#!/bin/bash
# claude-code-command-switch 一键安装脚本
# 使用方法: curl -sSL https://raw.githubusercontent.com/xkcyy/claude-code-switch/main/install.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/xkcyy/claude-code-switch/main"
INSTALL_DIR="$HOME/.claude-switch"
BIN_DIR="$HOME/.local/bin"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 检查依赖
check_dependencies() {
    info "检查依赖..."

    command -v claude >/dev/null 2>&1 || error "未找到 claude 命令，请先安装 Claude Code CLI"

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        info "检测到 Windows 系统"
        PLATFORM="windows"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        info "检测到 macOS 系统"
        PLATFORM="macos"
    else
        info "检测到 Linux 系统"
        PLATFORM="linux"
    fi
}

# 创建目录
setup_dirs() {
    info "创建安装目录..."
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$BIN_DIR"
    mkdir -p "$INSTALL_DIR/commands"
}

# 下载文件
download_files() {
    info "下载项目文件..."

    cd "$INSTALL_DIR"

    # 下载核心脚本
    curl -sSL "$REPO_URL/claude-switch" -o claude-switch || error "下载 claude-switch 失败"
    curl -sSL "$REPO_URL/command-template.sh" -o command-template.sh || error "下载 command-template.sh 失败"
    curl -sSL "$REPO_URL/models.conf" -o models.conf || error "下载 models.conf 失败"

    # 设置执行权限
    chmod +x claude-switch
    chmod +x command-template.sh

    info "文件下载完成"
}

# 安装到 PATH
install_to_path() {
    info "安装到系统 PATH..."

    # 创建符号链接
    ln -sf "$INSTALL_DIR/claude-switch" "$BIN_DIR/claude-switch"

    # 添加到 PATH（如果需要）
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        warn "$BIN_DIR 不在 PATH 中，正在添加..."

        # 检测 shell 配置文件
        if [ -n "$ZSH_VERSION" ]; then
            PROFILE="$HOME/.zshrc"
        elif [ -n "$BASH_VERSION" ]; then
            PROFILE="$HOME/.bashrc"
        else
            PROFILE="$HOME/.profile"
        fi

        echo "" >> "$PROFILE"
        echo "# claude-code-command-switch" >> "$PROFILE"
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$PROFILE"

        info "已添加到 $PROFILE，请运行 'source $PROFILE' 或重新打开终端"
    fi

    info "安装完成！"
}

# 初始化配置
init_config() {
    info "初始化配置..."

    if [ ! -f "$INSTALL_DIR/models.conf" ]; then
        cat > "$INSTALL_DIR/models.conf" << 'EOF'
# claude-code-command-switch 模型配置文件
# 格式: COMMAND_NAME|MODEL_ID|API_ENDPOINT|API_KEY_ENV_VAR|DESCRIPTION

# 示例配置（取消注释并填写您的 API Key）
# claude-glm|glm-4|https://open.bigmodel.cn/api/paas/v4|GLM_API_KEY|智谱 GLM-4
# claude-231|deepseek-chat|https://api.deepseek.com/v1|DEEPSEEK_API_KEY|DeepSeek V3
# claude-gpt|gpt-4-turbo|https://api.openai.com/v1|OPENAI_API_KEY|GPT-4 Turbo
EOF
    fi
}

# 显示使用说明
show_usage() {
    cat << EOF

${GREEN}✓ 安装完成！${NC}

${YELLOW}快速开始：${NC}
  1. 编辑配置文件: nano ~/.claude-switch/models.conf
  2. 添加模型命令: claude-switch add glm
  3. 使用新命令: claude-glm "你的问题"

${YELLOW}常用命令：${NC}
  claude-switch list              # 列出所有可用命令
  claude-switch add <name>        # 添加新模型命令
  claude-switch remove <name>     # 删除命令
  claude-switch edit              # 编辑配置文件
  claude-switch update            # 更新到最新版本

${YELLOW}配置文件位置：${NC} ~/.claude-switch/models.conf

${YELLOW}获取帮助：${NC} claude-switch help

EOF
}

# 主函数
main() {
    echo ""
    info "开始安装 claude-code-command-switch..."
    echo ""

    check_dependencies
    setup_dirs
    download_files
    install_to_path
    init_config
    show_usage
}

# 运行安装
main
