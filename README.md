# claude-code-command-switch

> 为 Claude Code CLI 提供多模型命令切换能力，一键切换不同的 AI 模型

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg)](https://github.com/your-username/claude-code-command-switch)

## 功能特性

- **跨平台支持** - 支持 Windows、Linux、macOS 三大操作系统
- **多模型支持** - 一个命令对应一个 AI 模型配置
- **简单易用** - 纯脚本实现，无需编译，一键安装
- **配置灵活** - 支持主流国产大模型（GLM、DeepSeek、通义千问等）
- **兼容性好** - 基于环境变量注入，完全兼容 Claude Code CLI

## 快速开始

### Windows

```powershell
# 方法 1: 使用 PowerShell 一键安装（推荐）
powershell -c "irm https://raw.githubusercontent.com/your-username/claude-code-command-switch/main/install.ps1 | iex"

# 方法 2: 手动安装
git clone https://github.com/your-username/claude-code-command-switch.git
cd claude-code-command-switch
.\install.ps1
```

安装后请**重启终端**使 PATH 生效，或运行：
```powershell
$env:Path += ";$env:USERPROFILE\.claude-switch\bin"
```

### Linux / macOS

```bash
# 方法 1: 使用 curl 一键安装（推荐）
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-command-switch/main/install.sh | bash

# 方法 2: 使用 wget
wget -qO- https://raw.githubusercontent.com/your-username/claude-code-command-switch/main/install.sh | bash

# 方法 3: 手动安装
git clone https://github.com/your-username/claude-code-command-switch.git
cd claude-code-command-switch
chmod +x install.sh
./install.sh
```

## 使用方法

### 1. 配置 API Key

**Linux / macOS:**
```bash
# 编辑配置文件
claude-switch edit

# 或直接设置环境变量
export GLM_API_KEY="your-glm-api-key"
export DEEPSEEK_API_KEY="your-deepseek-api-key"

# 永久保存（添加到 ~/.bashrc 或 ~/.zshrc）
echo 'export GLM_API_KEY="your-api-key"' >> ~/.bashrc
source ~/.bashrc
```

**Windows:**
```powershell
# 编辑配置文件
claude-switch edit

# 或设置环境变量（当前会话）
$env:GLM_API_KEY = "your-glm-api-key"

# 永久保存（用户级环境变量）
[Environment]::SetEnvironmentVariable("GLM_API_KEY", "your-api-key", "User")

# 或使用 setx 命令
setx GLM_API_KEY "your-api-key"
```

### 2. 安装模型命令

**所有平台通用:**
```bash
# 添加 claude-glm 命令（智谱 GLM）
claude-switch add glm

# 添加 claude-231 命令（DeepSeek）
claude-switch add 231

# 添加 claude-gpt 命令（OpenAI GPT-4）
claude-switch add gpt
```

### 3. 使用不同的模型

```bash
# 使用智谱 GLM-4
claude-glm "帮我写一个 Python 快速排序"

# 使用 DeepSeek V3
claude-231 "解释这段代码的作用"

# 使用 GPT-4 Turbo
claude-gpt "帮我优化这段代码"
```

### 4. 管理命令

```bash
# 列出所有可用命令
claude-switch list

# 删除某个命令
claude-switch remove glm

# 更新工具到最新版本
claude-switch update

# 查看帮助
claude-switch help
```

## 配置文件

配置文件位于: `~/.claude-switch/models.conf`

### 格式说明

```
COMMAND_NAME|MODEL_ID|API_ENDPOINT|API_KEY_ENV_VAR|DESCRIPTION
```

| 字段 | 说明 | 示例 |
|------|------|------|
| COMMAND_NAME | 命令名称（会自动添加 claude- 前缀） | glm |
| MODEL_ID | 模型 ID | glm-4 |
| API_ENDPOINT | API 接口地址 | https://open.bigmodel.cn/api/paas/v4 |
| API_KEY_ENV_VAR | API Key 环境变量名 | GLM_API_KEY |
| DESCRIPTION | 模型描述 | 智谱 GLM-4 模型 |

### 预置模型

工具已预置以下模型配置，取消注释并设置 API Key 即可使用：

| 模型 | 命令 | 获取 API Key |
|------|------|--------------|
| 智谱 GLM-4 | `claude-glm` | https://open.bigmodel.cn/ |
| DeepSeek V3 | `claude-231` | https://platform.deepseek.com/ |
| OpenAI GPT-4 | `claude-gpt` | https://platform.openai.com/ |
| 通义千问 | `claude-qwen` | https://dashscope.aliyun.com/ |
| Moonshot Kimi | `claude-kimi` | https://platform.moonshot.cn/ |
| 百川 Baichuan | `claude-baichuan` | https://platform.baichuan-ai.com/ |
| MiniMax | `claude-minimax` | https://www.minimaxi.com/ |
| 零一万物 Yi | `claude-yi` | https://platform.lingyiwanwu.com/ |

## 工作原理

```
用户执行: claude-glm "帮我写代码"
         ↓
读取 ~/.claude-switch/models.conf 配置
         ↓
临时设置环境变量:
  - ANTHROPIC_API_KEY=$GLM_API_KEY
  - ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/paas/v4
         ↓
调用原始 claude 命令
         ↓
API 请求被路由到 GLM 服务器
         ↓
返回 GLM-4 的响应结果
```

## 常见问题

### Q: Windows 安装后命令找不到？

```powershell
# 1. 检查 PATH
$env:Path -split ';' | Select-String "claude-switch"

# 2. 如果没有，重启终端使 PATH 生效
# 或手动添加到当前会话
$env:Path += ";$env:USERPROFILE\.claude-switch\bin"
```

### Q: Linux/macOS 安装后命令找不到？

```bash
# 1. 检查 PATH
echo $PATH | grep ".local/bin"

# 2. 如果没有，添加到配置文件
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Q: 提示 API Key 未设置？

**Windows:**
```powershell
# 临时设置
$env:GLM_API_KEY = "your-api-key"

# 永久设置
[Environment]::SetEnvironmentVariable("GLM_API_KEY", "your-api-key", "User")
```

**Linux/macOS:**
```bash
# 临时设置
export GLM_API_KEY="your-api-key"

# 永久设置
echo 'export GLM_API_KEY="your-api-key"' >> ~/.bashrc
source ~/.bashrc
```

### Q: 如何添加自定义模型？

**所有平台通用:**
```bash
# 1. 编辑配置文件
claude-switch edit

# 2. 添加一行配置
claude-mymodel|model-id|https://api.example.com/v1|MY_API_KEY|My Custom Model

# 3. 安装命令
claude-switch add mymodel
```

### Q: 如何卸载工具？

**Windows:**
```powershell
# 删除安装目录
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude-switch"

# 删除 PATH（需要手动从系统设置中移除）
```

**Linux/macOS:**
```bash
# 删除安装目录
rm -rf ~/.claude-switch

# 删除命令链接
rm -f ~/.local/bin/claude-switch
rm -f ~/.local/bin/claude-*
```

## 项目结构

```
claude-code-command-switch/
├── install.sh              # Linux/macOS 安装脚本
├── install.ps1             # Windows 安装脚本
├── claude-switch           # Linux/macOS 核心管理脚本
├── claude-switch.ps1       # Windows 核心管理脚本
├── command-template.sh     # Linux/macOS 命令模板
├── command-template.ps1    # Windows 命令模板
├── models.conf             # 模型配置文件
├── DESIGN.md               # 设计文档
├── QUICKSTART.md           # 快速开始指南
└── README.md               # 本文件
```

## 实现原理

本项目采用**环境变量注入方案**：

### Linux/macOS
1. 每个 `claude-xxx` 命令都是一个独立的 Bash 脚本
2. 脚本启动时临时设置 `ANTHROPIC_API_KEY` 和 `ANTHROPIC_BASE_URL` 环境变量
3. 然后调用原始的 `claude` 命令，将所有参数透传
4. Claude Code CLI 会读取环境变量，将请求路由到指定的 API 端点

### Windows
1. 每个 `claude-xxx.cmd` 命令是一个批处理文件
2. 同时生成 `.ps1` PowerShell 脚本版本
3. 两种脚本都会临时设置环境变量并调用原始 `claude` 命令
4. 支持在 CMD、PowerShell、Git Bash 等多种终端中使用

**优势：**
- 无需修改 Claude Code 源码
- 完全兼容所有 Claude Code 功能
- 实现简单，维护成本低
- 支持任意兼容 OpenAI API 的模型
- 跨平台支持，统一配置文件

## 系统要求

### Windows
- Windows 10/11 或 Windows Server 2016+
- PowerShell 5.1 或更高版本
- 已安装 Claude Code CLI
- curl 或 Invoke-RestMethod（用于安装）

### Linux / macOS
- Bash 4.0+
- 已安装 Claude Code CLI
- curl 或 wget（用于安装）

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 相关链接

- [Claude Code CLI](https://claude.ai/code)
- [Anthropic API 文档](https://docs.anthropic.com/)

---

**Star this repo if you find it helpful!** ⭐
