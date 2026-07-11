# 安装与基本配置

难度：基础

## 前置条件

你需要一台电脑（macOS、Linux 或 Windows）和一个终端。

如果你用 Windows，推荐通过 **WSL**（Windows Subsystem for Linux）来使用 OpenCode，体验更好。如果你还没装 WSL，可以参考微软的官方指南安装。

终端方面，macOS 自带的 Terminal 就够用，也可以用 iTerm2、Warp、Kitty 等第三方终端。Linux 上推荐 WezTerm 或 Alacritty。

另外，你需要在电脑上安装 [Git](https://git-scm.com/)，OpenCode 的撤销功能依赖 Git。

## 安装 OpenCode

### 方式一：一键安装脚本（推荐）

教材附带了两个一键安装脚本，自动检测系统并下载最新版：

**Linux / macOS（在终端中运行）**：

```bash
# 下载脚本
curl -fsSL https://raw.githubusercontent.com/your-repo/opencode-tutorial/main/docs/install-opencode.sh -o install-opencode.sh
# 运行
bash install-opencode.sh
```

**Windows**：

```powershell
# 在 PowerShell 中运行（右键 -> "使用 PowerShell 运行"）
# 下载脚本后运行
.\install-opencode.ps1
```

Windows 会自动下载 Desktop 桌面版安装包。Linux/macOS 会下载终端 CLI 版。

### 方式二：官方安装脚本

```bash
curl -fsSL https://opencode.ai/install | bash
```

### 方式三：包管理器

**macOS（Homebrew）**：

```bash
brew install anomalyco/tap/opencode
```

**npm / Bun / pnpm / Yarn**：

```bash
npm install -g opencode-ai
```

**Arch Linux**：

```bash
sudo pacman -S opencode
```

**Windows（Scoop）**：

```bash
scoop install opencode
```

安装完成后，在终端输入 `opencode --version` 确认安装成功。

## 配置供应商：一句话搞懂

OpenCode 本身不提供 AI 模型。它只是一个"遥控器"，你需要连接一个"信号源"（也就是供应商），才能让 AI 开始工作。

这个信号源可以是 OpenAI（GPT）、Anthropic（Claude）、Google（Gemini），也可以是国内的 DeepSeek、MiniMax 等。连接方式很简单。

## 最快上手：用 Zen 免费开始

对于第一次使用的开发者，推荐用 **OpenCode Zen**。这是 OpenCode 官方提供的一组精选模型，自带免费模型，注册后就能用。

步骤：

1. 在终端输入 `opencode`，启动 OpenCode
2. 在 OpenCode 里输入 `/connect`
3. 选择 `opencode`（也就是 Zen）
4. 浏览器会打开 opencode.ai/auth，注册账号、添加账单信息
5. 复制 API 密钥，粘贴回终端

就这样，配好了。你不需要信用卡也能用免费模型跑通整个流程。

## 配置文件方式：一次配好多个供应商

如果你已经有多个供应商的 API 密钥，可以通过配置文件一次性配好，不用每次都手动 `/connect`。

### 配置文件位置

| 系统 | 路径 | 说明 |
|------|------|------|
| Linux / macOS | `~/.opencode/opencode.json` | 全局配置，所有项目共享 |
| Windows | `%USERPROFILE%\.opencode\opencode.json` | 全局配置，所有项目共享 |
| 任意项目 | `项目根目录/opencode.json` | 仅当前项目生效 |

**项目级配置优先级高于全局配置**。你可以全局配好常用供应商，个别项目用特殊配置覆盖。

### 完整配置示例

以下配置文件包含了四个供应商和一个自定义中转。**复制即可使用**，只需把 `YOUR_API_KEY` 替换成你自己的密钥。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "opencode": {
      "name": "OpenCode Zen",
      "options": {}
    },
    "anthropic": {
      "options": {
        "apiKey": "{env:ANTHROPIC_API_KEY}"
      }
    },
    "openai": {
      "options": {
        "apiKey": "{env:OPENAI_API_KEY}"
      }
    },
    "deepseek": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "DeepSeek",
      "options": {
        "baseURL": "https://api.deepseek.com/v1",
        "apiKey": "{env:DEEPSEEK_API_KEY}"
      },
      "models": {
        "deepseek-v4-pro": { "name": "DeepSeek V4 Pro" },
        "deepseek-v4-flash": { "name": "DeepSeek V4 Flash" }
      }
    },
    "my-relay": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "我的中转服务",
      "options": {
        "baseURL": "https://your-relay-server.com/v1",
        "apiKey": "{env:OPENCODE_MY_API_KEY}"
      },
      "models": {
        "gpt-5.4-mini": { "name": "GPT 5.4 Mini (中转)" },
        "claude-sonnet-5": { "name": "Claude Sonnet 5 (中转)" },
        "qwen-3.7-plus": { "name": "Qwen 3.7 Plus (中转)" }
      }
    }
  }
}
```

### 配置文件逐段解读

**opencode（Zen）**：官方精选模型网关。通过 `/connect` 连接后会自动配置，也可以手动填入 apiKey。不需要在配置文件中写 apiKey -- 连接过一次就行。

**anthropic（Claude）**：通过环境变量 `ANTHROPIC_API_KEY` 读取密钥。如果你之前设过这个环境变量，直接可用。

**openai（GPT）**：通过环境变量 `OPENAI_API_KEY` 读取密钥。支持 GPT、Codex 等全系列模型。

**deepseek**：使用 OpenAI 兼容协议接入 DeepSeek。因为 DeepSeek 不是 OpenCode 内置的供应商，所以需要指定 `npm` 包（`@ai-sdk/openai-compatible`）和自定义 `baseURL`。模型列表也需要手动声明。

**my-relay（自定义中转）**：模板配置，展示如何接入任何 OpenAI 兼容的第三方服务。修改 `baseURL` 为你的中转地址，修改 `OPENCODE_MY_API_KEY` 环境变量为你的密钥，按需调整 `models` 列表。

### 变量替换语法

配置文件中的 `{env:VARIABLE_NAME}` 会在运行时替换为对应的环境变量值。这样你不需要把密钥写死在 JSON 里。

设置环境变量的方法：

**Linux / macOS**（写入 `~/.bashrc` 或 `~/.zshrc`）：

```bash
export ANTHROPIC_API_KEY="sk-ant-xxx"
export OPENAI_API_KEY="sk-xxx"
export DEEPSEEK_API_KEY="sk-xxx"
export OPENCODE_MY_API_KEY="sk-xxx"
```

**Windows**（PowerShell）：

```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-xxx"
$env:OPENAI_API_KEY = "sk-xxx"
$env:DEEPSEEK_API_KEY = "sk-xxx"
$env:OPENCODE_MY_API_KEY = "sk-xxx"
```

写入环境变量后，OpenCode 启动时会自动读取。

### 快速开始配置步骤

**Linux / macOS**：

```bash
# 1. 创建配置目录
mkdir -p ~/.opencode

# 2. 复制上面的 JSON 内容，写入配置文件
cat > ~/.opencode/opencode.json << 'EOF'
（粘贴上面的完整 JSON 内容）
EOF

# 3. 设置环境变量（只设你有的密钥）
export ANTHROPIC_API_KEY="sk-ant-xxx"
export OPENAI_API_KEY="sk-xxx"
export DEEPSEEK_API_KEY="sk-xxx"

# 4. 启动 OpenCode
opencode
```

**Windows**：

```powershell
# 1. 创建配置目录（如果不存在）
New-Item -ItemType Directory -Path "$env:USERPROFILE\.opencode" -Force

# 2. 将上面的 JSON 内容保存为文件
notepad "$env:USERPROFILE\.opencode\opencode.json"

# 3. 设置环境变量（只设你有的密钥）
$env:ANTHROPIC_API_KEY = "sk-ant-xxx"
$env:OPENAI_API_KEY = "sk-xxx"
$env:DEEPSEEK_API_KEY = "sk-xxx"

# 4. 启动 OpenCode
opencode
```

## 中国用户快速通道

如果你在国内，网络访问海外服务可能不稳定。有几个选择：

**选项一：用国内直连的供应商**

DeepSeek、MiniMax、智谱（GLM）、通义千问（Qwen）都可以从国内直接连接。按上面的配置文件示例，配置 deepseek 供应商即可。

**选项二：用 Zen 的免费模型试试**

如果网络通畅，Zen 是最方便的选择。

**选项三：用自定义中转服务**

把上面的 `my-relay` 配置中的 `baseURL` 改为你使用的第三方中转地址，通过 `OPENCODE_MY_API_KEY` 环境变量设置密钥。

具体配置方式在进阶篇的[模型选择](07-model-selection.md)中有详细说明。现在你只需要知道有这些选择就够了。

## 验证配置

配置好供应商后，在 OpenCode 里输入：

```
/models
```

如果能看到模型列表，说明配置成功。按 `Esc` 或 `q` 退出列表。

然后试着说一句简单的话：

```
你好，请介绍一下你自己
```

如果 AI 正常回复，恭喜你，OpenCode 已经可以正常工作了。

## 下一步

安装好、配好供应商，接下来我们在一个真实项目里第一次运行 OpenCode。

[第一次启动 -->](03-first-run.md)
