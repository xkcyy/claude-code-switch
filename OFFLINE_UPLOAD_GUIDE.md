# 离线上传到 GitHub 的解决方案

由于网络连接问题无法直接推送，请使用以下方案之一：

## 方案 1: 使用 VPN（推荐）

如果你有 VPN，请先连接 VPN，然后再推送：

```bash
# 1. 连接 VPN
# 2. 测试连接
curl -I https://github.com

# 3. 如果连接成功，推送代码
git push -u origin main
```

---

## 方案 2: 配置代理

如果你使用代理软件（如 Clash、V2Ray 等），配置 Git 使用代理：

```bash
# 假设代理端口是 7890（根据你的代理软件修改）
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 测试连接
curl -I https://github.com

# 推送
git push -u origin main

# 完成后可以取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

## 方案 3: 手动上传文件（最可靠）

### 步骤 1: 访问仓库

在浏览器中访问: https://github.com/xkcyy/claude-code-switch

### 步骤 2: 上传文件

1. 点击 "uploading an existing file" 链接
2. 将以下文件拖拽到浏览器窗口：

   **必需文件:**
   - `.gitignore`
   - `README.md`
   - `DESIGN.md`
   - `QUICKSTART.md`
   - `install.sh`
   - `install.ps1`
   - `claude-switch`
   - `claude-switch.ps1`
   - `command-template.sh`
   - `command-template.ps1`

3. 填写提交信息:
   ```
   feat: add claude-code-command-switch with cross-platform support

   - Add support for Windows, Linux, and macOS
   - Implement environment variable injection approach
   - Include 8+ pre-configured model providers
   - Add one-click installation scripts
   ```

4. 点击 "Commit changes"

### 文件位置

所有文件都在: `C:\Users\km189\Desktop\cc`

---

## 方案 4: 使用 GitHub Desktop（图形界面）

1. **下载 GitHub Desktop**
   访问: https://desktop.github.com/
   下载并安装

2. **登录 GitHub**
   打开 GitHub Desktop，使用你的 GitHub 账号登录

3. **添加本地仓库**
   - File → Add local repository
   - 选择路径: `C:\Users\km189\Desktop\cc`
   - 点击 Add repository

4. **发布仓库**
   - 点击 "Publish repository" 按钮
   - 选择 "Public"
   - 点击 "Publish repository"

GitHub Desktop 会自动处理网络问题并完成推送。

---

## 方案 5: 传输到其他网络环境

如果当前环境确实无法访问 GitHub：

1. **打包文件**
   ```powershell
   # 在项目目录
   Compress-Archive -Path * -DestinationPath ../claude-code-switch.zip -Force
   ```

2. **传输到可访问 GitHub 的环境**
   - 通过 U 盘、云盘等方式传输
   - 在其他电脑上解压并推送

3. **在其他环境推送**
   ```bash
   unzip claude-code-switch.zip
   cd claude-code-switch
   git push -u origin main
   ```

---

## 方案 6: 使用移动热点

1. **用手机开启移动热点**
2. **电脑连接手机热点**
3. **测试连接**
   ```bash
   curl -I https://github.com
   ```
4. **推送代码**
   ```bash
   git push -u origin main
   ```

---

## 推荐方案

根据你的情况，我推荐按以下顺序尝试：

1. **方案 4 (GitHub Desktop)** - 最简单，图形界面 ⭐⭐⭐⭐⭐
2. **方案 1 (VPN)** - 如果有 VPN，最快 ⭐⭐⭐⭐⭐
3. **方案 3 (手动上传)** - 最可靠，但繁琐 ⭐⭐⭐
4. **方案 6 (移动热点)** - 备用方案 ⭐⭐⭐
5. **方案 2 (代理)** - 如果你使用代理软件 ⭐⭐⭐⭐
6. **方案 5 (其他环境)** - 最后的选择 ⭐⭐

---

## 验证推送成功

无论使用哪种方案，推送成功后访问:
https://github.com/xkcyy/claude-code-switch

你应该能看到:
- ✓ README.md 在首页显示
- ✓ 11 个文件都已上传
- ✓ 代码内容完整

需要帮助？请告诉我你想尝试哪个方案。
