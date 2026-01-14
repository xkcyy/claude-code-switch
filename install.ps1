# claude-code-command-switch Windows 安装脚本
# 使用方法: powershell -c "irm https://raw.githubusercontent.com/xkcyy/claude-code-switch/main/install.ps1 | iex"

$ErrorActionPreference = "Stop"

# 配置
$REPO_URL = "https://raw.githubusercontent.com/xkcyy/claude-code-switch/main"
$INSTALL_DIR = "$env:USERPROFILE\.claude-switch"
$BIN_DIR = "$env:USERPROFILE\.claude-switch\bin"

# 颜色函数
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Info-Message { Write-ColorOutput Green "[INFO] $args" }
function Warn-Message { Write-ColorOutput Yellow "[WARN] $args" }
function Error-Message { Write-ColorOutput Red "[ERROR] $args"; exit 1 }

# 检查管理员权限（可选）
function Check-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 检查依赖
function Check-Dependencies {
    Info-Message "检查依赖..."

    # 检查 claude 命令
    try {
        $null = Get-Command claude -ErrorAction Stop
        Info-Message "找到 claude 命令"
    }
    catch {
        Error-Message "未找到 claude 命令，请先安装 Claude Code CLI"
    }

    # 检查 PowerShell 版本
    $psVersion = $PSVersionTable.PSVersion.Major
    if ($psVersion -lt 5) {
        Error-Message "需要 PowerShell 5.0 或更高版本"
    }
    Info-Message "PowerShell 版本: $psVersion"
}

# 创建目录
function Setup-Dirs {
    Info-Message "创建安装目录..."

    if (!(Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }

    if (!(Test-Path $BIN_DIR)) {
        New-Item -ItemType Directory -Path $BIN_DIR -Force | Out-Null
    }

    if (!(Test-Path "$INSTALL_DIR\commands")) {
        New-Item -ItemType Directory -Path "$INSTALL_DIR\commands" -Force | Out-Null
    }
}

# 下载文件
function Download-Files {
    Info-Message "下载项目文件..."

    Push-Location $INSTALL_DIR

    try {
        # 下载核心脚本
        Invoke-RestMethod -Uri "$REPO_URL/claude-switch.ps1" -OutFile "claude-switch.ps1"
        Invoke-RestMethod -Uri "$REPO_URL/command-template.ps1" -OutFile "command-template.ps1"
        Invoke-RestMethod -Uri "$REPO_URL/models.conf" -OutFile "models.conf"

        Info-Message "文件下载完成"
    }
    catch {
        Error-Message "下载文件失败: $_"
    }
    finally {
        Pop-Location
    }
}

# 添加到 PATH
function Add-ToPath {
    Info-Message "添加到系统 PATH..."

    $pathEntry = $BIN_DIR

    # 获取当前 PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

    if ($currentPath -notlike "*$pathEntry*") {
        # 添加到用户 PATH
        $newPath = "$currentPath;$pathEntry"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

        Info-Message "已添加到用户 PATH"

        # 为当前会话更新 PATH
        $env:Path = "$env:Path;$pathEntry"

        Warn-Message "请重启终端使 PATH 生效"
    }
    else {
        Info-Message "PATH 已配置"
    }
}

# 创建快捷启动脚本
function Create-LauncherScripts {
    Info-Message "创建启动脚本..."

    # 创建 claude-switch.bat
    @"
@echo off
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-switch\claude-switch.ps1" %*
"@ | Out-File -FilePath "$BIN_DIR\claude-switch.bat" -Encoding ASCII

    Info-Message "启动脚本已创建"
}

# 初始化配置
function Initialize-Config {
    Info-Message "初始化配置..."

    if (!(Test-Path "$INSTALL_DIR\models.conf")) {
        @"
# claude-code-command-switch 模型配置文件
# 格式: COMMAND_NAME|MODEL_ID|API_ENDPOINT|API_KEY_ENV_VAR|DESCRIPTION

# 示例配置（取消注释并填写您的 API Key）
# claude-glm|glm-4|https://open.bigmodel.cn/api/paas/v4|GLM_API_KEY|智谱 GLM-4
# claude-231|deepseek-chat|https://api.deepseek.com/v1|DEEPSEEK_API_KEY|DeepSeek V3
# claude-gpt|gpt-4-turbo|https://api.openai.com/v1|OPENAI_API_KEY|GPT-4 Turbo
"@ | Out-File -FilePath "$INSTALL_DIR\models.conf" -Encoding UTF8
    }
}

# 显示使用说明
function Show-Usage {
    @"

========================================
  ✓ 安装完成！
========================================

快速开始：
  1. 设置环境变量: `$env:GLM_API_KEY="your-key"`
  2. 编辑配置文件: notepad ~/.claude-switch/models.conf
  3. 添加模型命令: claude-switch add glm
  4. 使用新命令: claude-glm "你的问题"

常用命令：
  claude-switch list              # 列出所有可用命令
  claude-switch add <name>        # 添加新模型命令
  claude-switch remove <name>     # 删除命令
  claude-switch edit              # 编辑配置文件

配置文件: ~/.claude-switch/models.conf

⚠ 重要提示：
  1. 请重启终端使 PATH 生效
  2. 或运行: `$env:Path += ";$env:USERPROFILE\.claude-switch\bin"

获取帮助：claude-switch help

"@
}

# 主函数
function Main {
    Clear-Host
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  claude-code-command-switch 安装程序" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    Check-Dependencies
    Setup-Dirs
    Download-Files
    Add-ToPath
    Create-LauncherScripts
    Initialize-Config
    Show-Usage
}

# 运行安装
Main
