$ErrorActionPreference = "Stop"

$INSTALL_DIR = "$env:USERPROFILE\.claude-switch"
$SRC_DIR = "C:\Users\km189\Desktop\cc"

Write-Host "Re-installing..." -ForegroundColor Cyan

# 复制文件
Copy-Item "$SRC_DIR\claude-switch.ps1" -Destination "$INSTALL_DIR\claude-switch.ps1" -Force
Copy-Item "$SRC_DIR\command-template.ps1" -Destination "$INSTALL_DIR\command-template.ps1" -Force

Write-Host "Done!" -ForegroundColor Green
