# claude-code-command-switch Windows Installer
# Usage: irm https://raw.githubusercontent.com/xkcyy/claude-code-switch/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

# Configuration
$REPO_URL = "https://raw.githubusercontent.com/xkcyy/claude-code-switch/main"
$INSTALL_DIR = "$env:USERPROFILE\.claude-switch"
$BIN_DIR = "$env:USERPROFILE\.claude-switch\bin"

# Color functions
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

# Check dependencies
function Check-Dependencies {
    Info-Message "Checking dependencies..."

    try {
        $null = Get-Command claude -ErrorAction Stop
        Info-Message "Found claude command"
    }
    catch {
        Error-Message "claude command not found. Please install Claude Code CLI first."
    }

    $psVersion = $PSVersionTable.PSVersion.Major
    if ($psVersion -lt 5) {
        Error-Message "PowerShell 5.0 or higher required"
    }
    Info-Message "PowerShell version: $psVersion"
}

# Create directories
function Setup-Dirs {
    Info-Message "Creating installation directories..."

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

# Download files
function Download-Files {
    Info-Message "Downloading project files..."

    Push-Location $INSTALL_DIR

    try {
        # Download core scripts
        Invoke-WebRequest -Uri "$REPO_URL/claude-switch.ps1" -OutFile "claude-switch.ps1" -UseBasicParsing
        Invoke-WebRequest -Uri "$REPO_URL/command-template.ps1" -OutFile "command-template.ps1" -UseBasicParsing
        Invoke-WebRequest -Uri "$REPO_URL/models.conf" -OutFile "models.conf" -UseBasicParsing

        Info-Message "Files downloaded successfully"
    }
    catch {
        Error-Message "Failed to download files: $_"
    }
    finally {
        Pop-Location
    }
}

# Add to PATH
function Add-ToPath {
    Info-Message "Adding to system PATH..."

    $pathEntry = $BIN_DIR
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

    if ($currentPath -notlike "*$pathEntry*") {
        $newPath = "$currentPath;$pathEntry"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

        Info-Message "Added to user PATH"
        $env:Path = "$env:Path;$pathEntry"

        Warn-Message "Please restart your terminal for PATH to take effect"
    }
    else {
        Info-Message "PATH already configured"
    }
}

# Create launcher scripts
function Create-LauncherScripts {
    Info-Message "Creating launcher scripts..."

    $batchContent = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-switch\claude-switch.ps1" %*
"@
    $batchContent | Out-File -FilePath "$BIN_DIR\claude-switch.bat" -Encoding ASCII

    Info-Message "Launcher scripts created"
}

# Initialize configuration
function Initialize-Config {
    Info-Message "Initializing configuration..."

    if (!(Test-Path "$INSTALL_DIR\models.conf")) {
        $configContent = @"
# claude-code-command-switch Model Configuration
# Format: COMMAND_NAME|MODEL_ID|API_ENDPOINT|API_KEY_ENV_VAR|DESCRIPTION

# Example configurations (uncomment and fill in your API Key)
# claude-glm|glm-4|https://open.bigmodel.cn/api/paas/v4|GLM_API_KEY|Zhipu GLM-4
# claude-ds|deepseek-chat|https://api.deepseek.com/v1|DEEPSEEK_API_KEY|DeepSeek V3
# claude-gpt|gpt-4-turbo|https://api.openai.com/v1|OPENAI_API_KEY|GPT-4 Turbo
"@
        $configContent | Out-File -FilePath "$INSTALL_DIR\models.conf" -Encoding UTF8
    }
}

# Show usage instructions
function Show-Usage {
    @"

========================================
  Installation Complete!
========================================

Quick Start:
  1. Set environment variable: `$env:GLM_API_KEY="your-key"`
  2. Edit config file: notepad ~/.claude-switch/models.conf
  3. Add model command: claude-switch add glm
  4. Use new command: claude-glm "your question"

Common Commands:
  claude-switch list              # List all available commands
  claude-switch add <name>        # Add new model command
  claude-switch remove <name>     # Remove command
  claude-switch edit              # Edit configuration file

Config file: ~/.claude-switch/models.conf

IMPORTANT:
  1. Please restart terminal for PATH to take effect
  2. Or run: `$env:Path += ";$env:USERPROFILE\.claude-switch\bin"

Get help: claude-switch help

"@
}

# Main function
function Main {
    Clear-Host
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  claude-code-command-switch Installer" -ForegroundColor Cyan
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

# Run installation
Main
