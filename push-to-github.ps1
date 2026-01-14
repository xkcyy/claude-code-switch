# PowerShell GitHub 推送助手
# 使用方法: .\push-to-github.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GitHub 推送助手" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 git 状态
Write-Host "[检查] Git 仓库状态..." -ForegroundColor Yellow
$gitStatus = git status 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "[错误] 不是 Git 仓库或 Git 未安装" -ForegroundColor Red
    exit 1
}

# 检查远程仓库
Write-Host "[检查] 远程仓库配置..." -ForegroundColor Yellow
$remotes = git remote -v

if ($remotes -match "xkcyy/claude-code-switch") {
    Write-Host "[成功] 远程仓库已配置" -ForegroundColor Green
    Write-Host $remotes
} else {
    Write-Host "[警告] 未找到正确的远程仓库" -ForegroundColor Yellow
    $response = Read-Host "是否添加远程仓库? (y/n)"
    if ($response -eq 'y') {
        git remote add origin https://github.com/xkcyy/claude-code-switch.git
        Write-Host "[成功] 远程仓库已添加" -ForegroundColor Green
    } else {
        exit 0
    }
}

Write-Host ""
Write-Host "选择推送方式:" -ForegroundColor Cyan
Write-Host "  1. HTTPS (需要 Personal Access Token)" -ForegroundColor White
Write-Host "  2. SSH (需要配置 SSH 密钥)" -ForegroundColor White
Write-Host "  3. 仅测试连接" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1-3)"

switch ($choice) {
    '1' {
        Write-Host ""
        Write-Host "[HTTPS 推送模式]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "请按以下步骤操作:" -ForegroundColor Yellow
        Write-Host "1. 访问: https://github.com/settings/tokens" -ForegroundColor White
        Write-Host "2. 生成新 Token (勾选 repo 权限)" -ForegroundColor White
        Write-Host "3. 推送时会提示输入用户名和密码" -ForegroundColor White
        Write-Host "   - 用户名: xkcyy" -ForegroundColor White
        Write-Host "   - 密码: [粘贴你的 Token]" -ForegroundColor White
        Write-Host ""

        $confirm = Read-Host "是否继续? (y/n)"
        if ($confirm -eq 'y') {
            git remote set-url origin https://github.com/xkcyy/claude-code-switch.git
            Write-Host "[推送] 正在推送..." -ForegroundColor Yellow
            git push -u origin main
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[成功] 推送成功!" -ForegroundColor Green
            } else {
                Write-Host "[失败] 推送失败，请检查网络和凭证" -ForegroundColor Red
            }
        }
    }

    '2' {
        Write-Host ""
        Write-Host "[SSH 推送模式]" -ForegroundColor Cyan
        Write-Host ""

        # 检查 SSH 密钥
        $sshKey = "$env:USERPROFILE\.ssh\id_ed25519.pub"
        if (Test-Path $sshKey) {
            Write-Host "[检查] 找到 SSH 公钥" -ForegroundColor Green
            Write-Host "公钥内容:"
            Get-Content $sshKey
            Write-Host ""
        } else {
            Write-Host "[警告] 未找到 SSH 密钥" -ForegroundColor Yellow
            $createKey = Read-Host "是否生成新 SSH 密钥? (y/n)"
            if ($createKey -eq 'y') {
                Write-Host "[生成] 正在生成 SSH 密钥..." -ForegroundColor Yellow
                ssh-keygen -t ed25519 -C "xkcyy@github.com"
                Write-Host "[完成] 密钥已生成" -ForegroundColor Green
                Write-Host "公钥内容:"
                Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
                Write-Host ""
                Write-Host "请将公钥添加到: https://github.com/settings/ssh/new" -ForegroundColor Yellow
                Read-Host "添加完成后按回车继续"
            }
        }

        Write-Host "[推送] 切换到 SSH 并推送..." -ForegroundColor Yellow
        git remote set-url origin git@github.com:xkcyy/claude-code-switch.git

        # 测试 SSH 连接
        Write-Host "[测试] 测试 SSH 连接..." -ForegroundColor Yellow
        $testResult = ssh -T git@github.com 2>&1
        if ($testResult -match "successfully authenticated") {
            Write-Host "[成功] SSH 认证成功" -ForegroundColor Green
        }

        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[成功] 推送成功!" -ForegroundColor Green
        } else {
            Write-Host "[失败] 推送失败" -ForegroundColor Red
        }
    }

    '3' {
        Write-Host ""
        Write-Host "[测试] 测试 GitHub 连接..." -ForegroundColor Yellow
        Write-Host ""

        # 测试 HTTPS 连接
        Write-Host "测试 HTTPS 连接..."
        try {
            $response = Invoke-WebRequest -Uri "https://github.com" -TimeoutSec 10 -UseBasicParsing
            Write-Host "[成功] HTTPS 连接正常 (状态码: $($response.StatusCode))" -ForegroundColor Green
        } catch {
            Write-Host "[失败] HTTPS 连接失败: $($_.Exception.Message)" -ForegroundColor Red
        }

        Write-Host ""

        # 测试 SSH 连接
        Write-Host "测试 SSH 连接..."
        try {
            $testResult = ssh -T git@github.com 2>&1
            if ($testResult -match "successfully authenticated") {
                Write-Host "[成功] SSH 连接正常" -ForegroundColor Green
            } else {
                Write-Host "[警告] SSH 未配置或认证失败" -ForegroundColor Yellow
                Write-Host $testResult
            }
        } catch {
            Write-Host "[失败] SSH 连接失败: $($_.Exception.Message)" -ForegroundColor Red
        }

        Write-Host ""
        Write-Host "[信息] 远程仓库配置:" -ForegroundColor Cyan
        git remote -v
    }

    default {
        Write-Host "[错误] 无效选择" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "访问仓库: https://github.com/xkcyy/claude-code-switch" -ForegroundColor Cyan
Write-Host ""
