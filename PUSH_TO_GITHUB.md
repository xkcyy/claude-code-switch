# 推送到 GitHub 的详细步骤

由于网络连接问题，请使用以下方法之一将代码推送到 GitHub。

## 方法 1: 使用 SSH 密钥（推荐）

### 步骤 1: 生成 SSH 密钥

```bash
# 在 PowerShell 中运行
ssh-keygen -t ed25519 -C "your_email@example.com"
# 按回车使用默认路径
# 按回车不设置密码（或设置一个密码）
```

### 步骤 2: 查看并复制公钥

```bash
# 查看公钥内容
cat ~/.ssh/id_ed25519.pub
# 或在 PowerShell 中
type $env:USERPROFILE\.ssh\id_ed25519.pub
```

### 步骤 3: 添加 SSH 密钥到 GitHub

1. 访问: https://github.com/settings/ssh/new
2. 粘贴公钥内容
3. 点击 "Add SSH key"
4. 输入 GitHub 密码确认

### 步骤 4: 切换到 SSH 并推送

```bash
# 在项目目录中
cd C:\Users\km189\Desktop\cc

# 切换远程地址为 SSH
git remote set-url origin git@github.com:xkcyy/claude-code-switch.git

# 首次连接需要确认
yes | git push -u origin main
```

---

## 方法 2: 使用 Personal Access Token

### 步骤 1: 创建 Token

1. 访问: https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 勾选权限:
   - ☑ repo
   - ☑ workflow
4. 设置过期时间并点击 "Generate token"
5. **复制 token**（只显示一次，请妥善保存）

### 步骤 2: 使用 Token 推送

```bash
# 在项目目录中
cd C:\Users\km189\Desktop\cc

# 切换回 HTTPS
git remote set-url origin https://github.com/xkcyy/claude-code-switch.git

# 推送（会提示输入用户名和密码）
git push -u origin main

# 用户名: xkcyy
# 密码: [粘贴你的 token]
```

---

## 方法 3: 手动上传文件（最简单但繁琐）

### 访问仓库
https://github.com/xkcyy/claude-code-switch

### 上传步骤

1. **点击 "uploading an existing file"**
2. **拖拽或选择以下文件**:

   ```
   .gitignore
   DESIGN.md
   QUICKSTART.md
   README.md
   claude-switch
   claude-switch.ps1
   command-template.ps1
   command-template.sh
   install.ps1
   install.sh
   ```

3. **填写提交信息**:
   - Commit message: `feat: add claude-code-command-switch with cross-platform support`
   - Extended description: 可选

4. **点击 "Commit changes"**

---

## 方法 4: 使用 GitHub Desktop（图形界面）

### 安装 GitHub Desktop

1. 下载: https://desktop.github.com/
2. 安装并运行
3. 使用 GitHub 账号登录

### 发布仓库

1. 点击 "File" → "Add local repository"
2. 选择路径: `C:\Users\km189\Desktop\cc`
3. 点击 "Add repository"
4. 点击 "Publish repository" 按钮
5. 选择 "Public" 或 "Private"
6. 点击 "Publish repository"

---

## 方法 5: 检查网络和代理设置

### 如果使用了代理

```bash
# 设置 HTTP 代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 然后推送
git push -u origin main
```

### 如果需要取消代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

## 验证推送成功

推送成功后，访问以下地址验证:
https://github.com/xkcyy/claude-code-switch

你应该能看到:
- ✓ README.md 在首页显示
- ✓ 所有 11 个文件
- ✓ 提交记录

---

## 推荐方案排序

1. **方法 1 (SSH)** - 最安全，配置一次后永久使用 ⭐⭐⭐⭐⭐
2. **方法 4 (GitHub Desktop)** - 最简单，图形界面 ⭐⭐⭐⭐⭐
3. **方法 2 (Token)** - 适合临时使用 ⭐⭐⭐
4. **方法 3 (手动上传)** - 备用方案 ⭐⭐
5. **方法 5 (代理)** - 需要代理网络 ⭐⭐⭐⭐

选择一个适合你的方法即可！
