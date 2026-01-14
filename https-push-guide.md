# HTTPS 推送指南

## 使用 Personal Access Token 推送

由于 GitHub 已弃用密码认证，需要使用 Personal Access Token。

### 步骤 1: 创建 Token

1. 访问: https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置:
   - Note: claude-code-switch
   - Expiration: 90 days (或你选择的时间)
   - 勾选权限:
     - ☑ repo (Full control of private repositories)
     - ☑ workflow
4. 点击 "Generate token"
5. **复制生成的 token**（只显示一次！格式类似: ghp_xxxxxxxxxxxx）

### 步骤 2: 使用 Token 推送

#### 方法 A: 命令行输入（推荐）

```bash
# 在项目目录执行
cd C:\Users\km189\Desktop\cc

# 推送时会提示输入
git push -u origin main

# Username for 'https://github.com': xkcyy
# Password for 'https://xkcyy@github.com': [粘贴你的 token，不是 GitHub 密码！]
```

#### 方法 B: 使用 Git Credential Helper

```bash
# 配置凭证存储
git config --global credential.helper store

# 推送并输入凭证一次
git push -u origin main

# Username: xkcyy
# Password: [粘贴 token]

# 之后凭证会被保存，不需要再次输入
```

#### 方法 C: 将 Token 嵌入 URL（不推荐，仅用于测试）

```bash
# 将 token 嵌入到远程 URL 中
git remote set-url origin https://xkcyy:YOUR_TOKEN@github.com/xkcyy/claude-code-switch.git

# 推送
git push -u origin main

# 完成后建议移除 token
git remote set-url origin https://github.com/xkcyy/claude-code-switch.git
```

### 步骤 3: 验证

推送成功后，访问: https://github.com/xkcyy/claude-code-switch

你应该能看到所有文件和 README。

## 常见问题

### Q: 提示 "Authentication failed"
A: 检查 token 是否正确，确保勾选了 repo 权限

### Q: 提示 "Support for password authentication was removed"
A: 必须使用 Personal Access Token，不能使用 GitHub 密码

### Q: Token 安全吗？
A: Token 存储在本地 Git 凭据中，相对安全。建议定期更换。

## 清理凭证（如需要）

```bash
# Windows 清除 Git 凭据
cmdkey /list | findstr git
cmdkey /delete:git:https://github.com
```
