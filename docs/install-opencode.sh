#!/bin/bash
# ============================================================
#  OpenCode 一键安装脚本
#  用途：自动检测操作系统，下载最新版 OpenCode
#  Windows 会直接下载 Desktop 桌面版
#  Linux/macOS 会下载终端 CLI 版
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO="anomalyco/opencode"
GITHUB_API="https://api.github.com/repos/${REPO}"

# 获取系统信息
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/arch-release ]]; then
            echo "arch"
        elif command -v apt-get &>/dev/null; then
            echo "debian"
        elif command -v dnf &>/dev/null; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 获取 CPU 架构
detect_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64) echo "x86_64" ;;
        aarch64|arm64) echo "aarch64" ;;
        *) echo "$arch" ;;
    esac
}

# 获取最新版本号
get_latest_version() {
    curl -fsSL "${GITHUB_API}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/'
}

# 获取下载链接
get_download_url() {
    local version="$1"
    local os="$2"
    local arch="$3"
    local url=""

    if [[ "$os" == "windows" ]]; then
        # Windows 下载 desktop 版
        case "$arch" in
            x86_64) url="https://github.com/${REPO}/releases/download/${version}/OpenCode_${version}_windows_amd64.exe" ;;
            aarch64) url="https://github.com/${REPO}/releases/download/${version}/OpenCode_${version}_windows_arm64.exe" ;;
        esac
    else
        # Linux/macOS 下载 CLI 版
        case "$os" in
            macos)
                case "$arch" in
                    x86_64) url="https://github.com/${REPO}/releases/download/${version}/opencode-macos-x64" ;;
                    aarch64) url="https://github.com/${REPO}/releases/download/${version}/opencode-macos-arm64" ;;
                esac
                ;;
            *)
                case "$arch" in
                    x86_64) url="https://github.com/${REPO}/releases/download/${version}/opencode-linux-x64" ;;
                    aarch64) url="https://github.com/${REPO}/releases/download/${version}/opencode-linux-arm64" ;;
                esac
                ;;
        esac
    fi

    echo "$url"
}

# 主流程
main() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       OpenCode 一键安装脚本                ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""

    OS=$(detect_os)
    ARCH=$(detect_arch)

    echo -e "${GREEN}[信息]${NC} 操作系统: ${OS}"
    echo -e "${GREEN}[信息]${NC} CPU 架构: ${ARCH}"
    echo ""

    # Windows 直接打开下载页面（因为没有 curl + bash 环境）
    if [[ "$OS" == "windows" ]]; then
        VERSION=$(get_latest_version)
        echo -e "${GREEN}[信息]${NC} 最新版本: ${VERSION}"
        echo ""
        echo -e "${YELLOW}检测到 Windows 系统，将下载 Desktop 桌面版...${NC}"
        echo ""

        # 尝试在 Git Bash / MSYS2 / WSL 中下载
        DOWNLOAD_URL=$(get_download_url "$VERSION" "$OS" "$ARCH")
        if [[ -n "$DOWNLOAD_URL" ]]; then
            FILENAME="OpenCode-${VERSION}-installer.exe"
            echo -e "${GREEN}[下载]${NC} ${DOWNLOAD_URL}"
            curl -fsSL -o "$HOME/Downloads/$FILENAME" "$DOWNLOAD_URL"
            echo ""
            echo -e "${GREEN}[完成]${NC} 安装包已下载到: ~/Downloads/${FILENAME}"
            echo -e "${YELLOW}       请双击运行安装。${NC}"
        else
            echo -e "${YELLOW}自动下载失败，请手动访问以下地址下载 Desktop 版：${NC}"
            echo ""
            echo "  https://github.com/${REPO}/releases/latest"
            echo ""
        fi
        echo ""
        echo -e "${CYAN}安装完成后，打开 OpenCode Desktop，输入 /connect 连接供应商即可。${NC}"
        return 0
    fi

    # Linux/macOS: 检查是否已安装
    if command -v opencode &>/dev/null; then
        CURRENT_VER=$(opencode --version 2>/dev/null || echo "unknown")
        echo -e "${YELLOW}[提示]${NC} 检测到已安装 OpenCode (${CURRENT_VER})"
        read -p "是否重新安装？[y/N] " ANSWER
        if [[ "$ANSWER" != "y" && "$ANSWER" != "Y" ]]; then
            echo -e "${GREEN}[跳过]${NC} 保持现有版本。"
            echo -e "${CYAN}运行 opencode upgrade 可升级到最新版。${NC}"
            return 0
        fi
    fi

    # 获取最新版本
    VERSION=$(get_latest_version)
    if [[ -z "$VERSION" ]]; then
        echo -e "${YELLOW}[错误]${NC} 无法获取最新版本号，请检查网络连接。"
        echo -e "${YELLOW}       可以手动访问: https://github.com/${REPO}/releases/latest${NC}"
        return 1
    fi

    echo -e "${GREEN}[信息]${NC} 最新版本: ${VERSION}"
    echo ""

    # 尝试包管理器安装
    INSTALLED=false

    if [[ "$OS" == "macos" ]] && command -v brew &>/dev/null; then
        echo -e "${GREEN}[安装]${NC} 通过 Homebrew 安装..."
        brew install anomalyco/tap/opencode
        INSTALLED=true
    elif [[ "$OS" == "arch" ]] && command -v pacman &>/dev/null; then
        echo -e "${GREEN}[安装]${NC} 通过 pacman 安装..."
        sudo pacman -S --noconfirm opencode
        INSTALLED=true
    elif [[ "$OS" == "debian" ]] && command -v snap &>/dev/null; then
        echo -e "${GREEN}[安装]${NC} 通过 snap 安装（可选）..."
        echo -e "${YELLOW}       推荐使用安装脚本或 npm。${NC}"
    fi

    # 回退到直接下载二进制
    if [[ "$INSTALLED" == "false" ]]; then
        echo -e "${YELLOW}       尝试直接下载二进制...${NC}"
        DOWNLOAD_URL=$(get_download_url "$VERSION" "$OS" "$ARCH")

        if [[ -n "$DOWNLOAD_URL" ]]; then
            # 创建临时目录
            TMPDIR=$(mktemp -d)
            TRAP_FILE="$TMPDIR/opencode"
            trap "rm -f \"$TRAP_FILE\"; rmdir \"$TMPDIR\" 2>/dev/null" EXIT

            echo -e "${GREEN}[下载]${NC} ${DOWNLOAD_URL}"
            curl -fsSL -o "$TRAP_FILE" "$DOWNLOAD_URL"
            chmod +x "$TRAP_FILE"

            # 安装到用户目录
            INSTALL_DIR="$HOME/.local/bin"
            mkdir -p "$INSTALL_DIR"
            mv "$TRAP_FILE" "$INSTALL_DIR/opencode"
            trap - EXIT

            echo ""
            echo -e "${GREEN}[完成]${NC} 已安装到: ${INSTALL_DIR}/opencode"

            # 检查 PATH
            if ! echo ":$PATH:" | grep -q ":${INSTALL_DIR}:"; then
                echo ""
                echo -e "${YELLOW}[注意]${NC} 请将以下行添加到你的 shell 配置文件中："
                echo ""
                if [[ "$SHELL" == *"zsh"* ]]; then
                    echo '  echo '\''export PATH="$HOME/.local/bin:$PATH"'\'' >> ~/.zshrc'
                    echo '  source ~/.zshrc'
                else
                    echo '  echo '\''export PATH="$HOME/.local/bin:$PATH"'\'' >> ~/.bashrc'
                    echo '  source ~/.bashrc'
                fi
                echo ""
            fi
        else
            echo -e "${YELLOW}[回退]${NC} 未找到适合你系统的预编译二进制。"
            echo ""
            echo "请使用以下方式之一安装："
            echo ""
            echo "  # 安装脚本（通用）"
            echo "  curl -fsSL https://opencode.ai/install | bash"
            echo ""
            echo "  # npm（需要 Node.js）"
            echo "  npm install -g opencode-ai"
            echo ""
            echo "  # 手动下载"
            echo "  https://github.com/${REPO}/releases/latest"
            echo ""
            return 1
        fi
    fi

    # 验证安装
    echo ""
    if command -v opencode &>/dev/null; then
        INSTALLED_VER=$(opencode --version 2>/dev/null || echo "${VERSION}")
        echo -e "${GREEN}[验证]${NC} OpenCode ${INSTALLED_VER} 安装成功"
        echo ""
        echo -e "${CYAN}下一步：${NC}"
        echo "  1. 运行 opencode 启动"
        echo "  2. 在 OpenCode 中输入 /connect 连接供应商"
        echo "  3. 复制 docs/opencode.json 到 ~/.opencode/opencode.json 配置供应商"
    else
        echo -e "${YELLOW}[注意]${NC} 安装完成，但 opencode 命令不在 PATH 中。"
        echo "  请重新打开终端窗口，或运行: source ~/.bashrc（或 ~/.zshrc）"
    fi
}

main "$@"
