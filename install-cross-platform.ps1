# claude-code-command-switch Windows 安装入口
# 使用方法: powershell -c "irm https://raw.githubusercontent.com/your-repo/main/install.ps1 | iex"

$REPO_URL = "https://raw.githubusercontent.com/your-username/claude-code-command-switch/main"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  claude-code-command-switch 安装程序" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在 WSL 中
$wslCheck = bash -c "echo \$WSL_DISTRO_NAME" 2>$null

if ($wslCheck) {
    Write-Host "[INFO] 检测到 WSL 环境" -ForegroundColor Green
    Write-Host ""
    Write-Host "请在 WSL 终端中运行以下命令安装:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  bash -c \"\$(curl -sSL $REPO_URL/install.sh)\"" -ForegroundColor Cyan
    Write-Host ""
}
else {
    Write-Host "[INFO] 检测到 Windows 环境" -ForegroundColor Green
    Write-Host ""
    Write-Host "开始安装..." -ForegroundColor Cyan

    # 下载并执行安装脚本
    $installScript = "$env:TEMP\claude-switch-install.ps1"

    try {
        Invoke-RestMethod -Uri "$REPO_URL/install.ps1" -OutFile $installScript
        & $installScript
        Remove-Item $installScript -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "[ERROR] 安装失败: $_" -ForegroundColor Red
        exit 1
    }
}
