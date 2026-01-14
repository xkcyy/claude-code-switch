$ErrorActionPreference = "Stop"

# Files to fix
$files = @(
    "C:\Users\km189\Desktop\cc\claude-switch.ps1",
    "C:\Users\km189\Desktop\cc\install.ps1",
    "C:\Users\km189\Desktop\cc\install-cross-platform.ps1",
    "C:\Users\km189\Desktop\cc\command-template.ps1"
)

$utf8Bom = New-Object System.Text.UTF8Encoding $true

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing: $file" -ForegroundColor Cyan

        # Read file with default encoding detection
        $content = Get-Content $file -Raw -Encoding UTF8

        # Write back with UTF-8 BOM
        [System.IO.File]::WriteAllText($file, $content, $utf8Bom)

        Write-Host "  -> Fixed with UTF-8 BOM" -ForegroundColor Green
    }
}

Write-Host "`nAll files fixed!" -ForegroundColor Green
