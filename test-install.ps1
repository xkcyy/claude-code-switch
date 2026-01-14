$ErrorActionPreference = "Stop"

# 配置
$INSTALL_DIR = "$env:USERPROFILE\.claude-switch"
$BIN_DIR = "$env:USERPROFILE\.claude-switch\bin"
$SRC_DIR = "C:\Users\km189\Desktop\cc"

Write-Host "Testing installation..." -ForegroundColor Cyan

# 创建目录
Write-Host "Creating directories..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $BIN_DIR | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\commands" | Out-Null

# 复制文件
Write-Host "Copying files..." -ForegroundColor Green
Copy-Item "$SRC_DIR\claude-switch.ps1" -Destination "$INSTALL_DIR\claude-switch.ps1" -Force
Copy-Item "$SRC_DIR\command-template.ps1" -Destination "$INSTALL_DIR\command-template.ps1" -Force

# 创建配置文件
Write-Host "Creating config file..." -ForegroundColor Green
@"
# claude-code-command-switch 模型配置文件
# 格式: COMMAND_NAME|MODEL_ID|API_ENDPOINT|API_KEY_ENV_VAR|DESCRIPTION

# 示例配置（取消注释并填写您的 API Key）
# claude-glm|glm-4|https://open.bigmodel.cn/api/paas/v4|GLM_API_KEY|智谱 GLM-4
# claude-231|deepseek-chat|https://api.deepseek.com/v1|DEEPSEEK_API_KEY|DeepSeek V3
# claude-gpt|gpt-4-turbo|https://api.openai.com/v1|OPENAI_API_KEY|GPT-4 Turbo
"@ | Out-File -FilePath "$INSTALL_DIR\models.conf" -Encoding UTF8

# 创建启动脚本
Write-Host "Creating launcher script..." -ForegroundColor Green
@"
@echo off
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-switch\claude-switch.ps1" %*
"@ | Out-File -FilePath "$BIN_DIR\claude-switch.bat" -Encoding ASCII

# 验证安装
Write-Host "`nVerifying installation..." -ForegroundColor Cyan
Write-Host "Install directory: $INSTALL_DIR" -ForegroundColor Yellow
Get-ChildItem $INSTALL_DIR -Recurse | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Gray }

Write-Host "`nInstallation test complete!" -ForegroundColor Green
Write-Host "You can now run: claude-switch.bat help" -ForegroundColor Cyan
