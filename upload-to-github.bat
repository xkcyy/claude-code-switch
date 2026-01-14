@echo off
REM GitHub API 上传脚本
REM 使用前请设置你的 GitHub Personal Access Token

echo ========================================
echo   GitHub 文件上传脚本
echo ========================================
echo.

REM 检查是否设置了 Token
if "%GITHUB_TOKEN%"=="" (
    echo [错误] 未设置 GITHUB_TOKEN 环境变量
    echo.
    echo 请按以下步骤操作:
    echo 1. 访问: https://github.com/settings/tokens
    echo 2. 点击 "Generate new token" -^> "Generate new token (classic)"
    echo 3. 勾选 "repo" 权限
    echo 4. 生成 token 并复制
    echo 5. 设置环境变量:
    echo    setx GITHUB_TOKEN "your-token-here"
    echo.
    pause
    exit /b 1
)

echo [信息] Token 已设置
echo [信息] 开始上传文件...
echo.

REM 定义仓库信息
set OWNER=xkcyy
set REPO=claude-code-switch
set BASE_URL=https://api.github.com/repos/%OWNER%/%REPO%

REM 上传函数
:upload_file
set FILE_PATH=%1
set FILE_NAME=%~n1%~x1

echo [上传] %FILE_NAME%

curl -X PUT "%BASE_URL%/contents/%FILE_NAME%" ^
  -H "Authorization: token %GITHUB_TOKEN%" ^
  -H "Accept: application/vnd.github.v3+json" ^
  -d "{\"message\":\"Upload %FILE_NAME:\",\"content\":\"$(cat %FILE_PATH | base64 -w 0)\"}"

if %ERRORLEVEL% NEQ 0 (
    echo [错误] 上传失败: %FILE_NAME%
) else (
    echo [成功] %FILE_NAME%
)

goto :eof

echo.
echo [完成] 所有文件已上传
echo.
echo 访问仓库: https://github.com/%OWNER%/%REPO%
pause
