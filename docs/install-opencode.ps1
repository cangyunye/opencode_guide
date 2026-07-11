# ============================================================
#  OpenCode 一键安装脚本 (Windows PowerShell)
#  自动下载 OpenCode Desktop 最新版并安装
#
#  使用方法：右键 -> "使用 PowerShell 运行"
#            或在 PowerShell 中: .\install-opencode.ps1
# ============================================================

$ErrorActionPreference = "Stop"
$REPO = "anomalyco/opencode"
$GITHUB_API = "https://api.github.com/repos/$REPO"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "       OpenCode 一键安装 (Windows Desktop)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 获取最新版本
Write-Host "[信息] 正在获取最新版本..." -ForegroundColor Green
try {
    $release = Invoke-RestMethod -Uri "$GITHUB_API/releases/latest"
    $version = $release.tag_name
    Write-Host "[信息] 最新版本: $version" -ForegroundColor Green
} catch {
    Write-Host "[错误] 无法获取最新版本，请检查网络连接。" -ForegroundColor Yellow
    Write-Host "       手动下载: https://github.com/$REPO/releases/latest" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""

# 获取 CPU 架构
$arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }

# 查找 Windows 安装包 (.exe)
$asset = $release.assets | Where-Object {
    $_.name -match "windows" -and $_.name -match $arch -and $_.name -match "\.exe$"
} | Select-Object -First 1

if (-not $asset) {
    # 回退：查找任何包含 windows 的 asset
    $asset = $release.assets | Where-Object {
        $_.name -match "windows" -and $_.name -match "\.exe$"
    } | Select-Object -First 1
}

if (-not $asset) {
    # 再回退：查找 .msi
    $asset = $release.assets | Where-Object {
        $_.name -match "windows" -and $_.name -match "\.msi$"
    } | Select-Object -First 1
}

if (-not $asset) {
    Write-Host "[回退] 未找到预编译安装包，使用 npm 安装..." -ForegroundColor Yellow
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install -g opencode-ai
        Write-Host ""
        Write-Host "[完成] 通过 npm 安装成功。运行 opencode 启动。" -ForegroundColor Green
    } else {
        Write-Host "[错误] 未找到适合的安装包，且未安装 npm。" -ForegroundColor Red
        Write-Host "       请手动下载: https://github.com/$REPO/releases/latest" -ForegroundColor Yellow
    }
    Read-Host "按回车键退出"
    exit 1
}

# 下载安装包
$downloadsFolder = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
$installerPath = [System.IO.Path]::Combine($downloadsFolder, $asset.name)

Write-Host "[下载] $($asset.name) ($([math]::Round($asset.size / 1MB, 1)) MB)" -ForegroundColor Green
Write-Host "       $($asset.browser_download_url)" -ForegroundColor DarkGray

try {
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installerPath -UseBasicParsing
    Write-Host "[完成] 安装包已下载到: $installerPath" -ForegroundColor Green
} catch {
    Write-Host "[错误] 下载失败: $_" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""

# 安装
if ($asset.name -match "\.msi$") {
    Write-Host "[安装] 正在启动 MSI 安装程序..." -ForegroundColor Green
    Start-Process msiexec.exe -ArgumentList "/i", "`"$installerPath`"", "/passive" -Wait
} else {
    Write-Host "[安装] 正在启动安装程序..." -ForegroundColor Green
    Start-Process -FilePath $installerPath
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  安装完成!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Cyan
Write-Host "  1. 打开 OpenCode Desktop"
Write-Host "  2. 输入 /connect 连接供应商"
Write-Host "  3. 复制 opencode.json 到 %USERPROFILE%\.opencode\opencode.json 配置多供应商"
Write-Host ""

# 自动创建配置目录
$configDir = [System.IO.Path]::Combine($env:USERPROFILE, ".opencode")
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    Write-Host "[提示] 已创建配置目录: $configDir" -ForegroundColor Green
}

Read-Host "按回车键退出"
