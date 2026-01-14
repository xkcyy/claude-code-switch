# 快速开始指南

## 5 分钟上手 claude-code-command-switch

### 步骤 1: 一键安装 (30 秒)

**Windows:**
```powershell
powershell -c "irm https://raw.githubusercontent.com/your-username/claude-code-command-switch/main/install.ps1 | iex"
```

**Linux / macOS:**
```bash
curl -sSL https://raw.githubusercontent.com/your-username/claude-code-command-switch/main/install.sh | bash
```

---

### 步骤 2: 设置 API Key (1 分钟)

**Windows:**
```powershell
# 以智谱 GLM 为例
[Environment]::SetEnvironmentVariable("GLM_API_KEY", "your-api-key-here", "User")

# 或临时设置（当前会话）
$env:GLM_API_KEY = "your-api-key-here"
```

**Linux / macOS:**
```bash
# 以智谱 GLM 为例
export GLM_API_KEY="your-api-key-here"

# 永久保存到配置文件
echo 'export GLM_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

---

### 步骤 3: 安装模型命令 (30 秒)

**所有平台通用:**
```bash
claude-switch add glm
```

---

### 步骤 4: 开始使用 (立即)

```bash
# 使用智谱 GLM-4
claude-glm "帮我写一个 Python 快速排序算法"
```

---

## 支持的模型

| 提供商 | 模型 | 安装命令 | 获取 Key |
|--------|------|----------|----------|
| 智谱 | GLM-4 | `claude-switch add glm` | https://open.bigmodel.cn/ |
| DeepSeek | V3 | `claude-switch add 231` | https://platform.deepseek.com/ |
| OpenAI | GPT-4 | `claude-switch add gpt` | https://platform.openai.com/ |
| 阿里云 | 通义千问 | `claude-switch add qwen` | https://dashscope.aliyun.com/ |
| Moonshot | Kimi | `claude-switch add kimi` | https://platform.moonshot.cn/ |
| 百川 | Baichuan4 | `claude-switch add baichuan` | https://platform.baichuan-ai.com/ |
| MiniMax | ABAB6.5s | `claude-switch add minimax` | https://www.minimaxi.com/ |
| 零一万物 | Yi-Large | `claude-switch add yi` | https://platform.lingyiwanwu.com/ |

## 常用命令

```bash
claude-switch list          # 查看所有可用命令
claude-switch add <name>    # 安装模型命令
claude-switch remove <name> # 删除命令
claude-switch edit          # 编辑配置
claude-switch help          # 查看帮助
```

## 配置文件位置

```bash
# Linux / macOS
~/.claude-switch/models.conf

# Windows
%USERPROFILE%\.claude-switch\models.conf
```

## 平台特定说明

### Windows
- 安装后需要**重启终端**使 PATH 生效
- 或手动运行: `$env:Path += ";$env:USERPROFILE\.claude-switch\bin"`
- 支持 CMD、PowerShell、Git Bash 等多种终端

### Linux / macOS
- 如果命令找不到，运行: `export PATH="$HOME/.local/bin:$PATH"`
- 添加到 `~/.bashrc` 或 `~/.zshrc` 使其永久生效

---

需要帮助？运行 `claude-switch help`
