# claude-code-command-switch 设计方案

## 项目概述

**项目名称**: claude-code-command-switch
**目标**: 为 Claude Code CLI 提供多模型命令切换能力

### 核心功能
- 允许创建多个 `claude-xxx` 命令（如 `claude-glm`, `claude-231`）
- 每个命令映射到独立的模型配置（API Key、Endpoint、Model ID）
- 支持动态添加/删除/更新模型命令
- 保持与原 `claude` 命令的兼容性

---

## 架构设计

### 1. 技术栈选择

```
语言: TypeScript
运行时: Node.js >= 18
包管理: npm
配置管理: YAML + JSON
命令包装: Node.js child process
```

### 2. 项目结构

```
claude-code-command-switch/
├── src/
│   ├── core/
│   │   ├── CommandManager.ts      # 命令生成和管理
│   │   ├── ConfigManager.ts       # 配置文件管理
│   │   └── ProcessWrapper.ts      # Claude 进程包装器
│   ├── cli/
│   │   ├── index.ts               # 主 CLI 入口
│   │   ├── commands/
│   │   │   ├── add.ts             # 添加新模型命令
│   │   │   ├── remove.ts          # 删除模型命令
│   │   │   ├── list.ts            # 列出所有命令
│   │   │   └── switch.ts          # 切换默认模型
│   │   └── utils/
│   │       ├── logger.ts          # 日志工具
│   │       └── validator.ts       # 配置验证
│   ├── templates/
│   │   └── command-template.sh    # 命令脚本模板
│   └── types/
│       └── index.ts               # TypeScript 类型定义
├── config/
│   ├── models.yaml                # 模型配置文件
│   └── schema.json                # 配置验证 schema
├── bin/
│   ├── claude-switch              # 主 CLI 入口
│   └── setup.sh                   # 初始化安装脚本
├── package.json
├── tsconfig.json
└── README.md
```

---

## 3. 核心模块设计

### 3.1 配置文件结构 (models.yaml)

```yaml
# models.yaml - 模型配置中心
version: "1.0"
default: claude-glm  # 默认使用的命令

models:
  claude-glm:
    name: "GLM Model"
    apiKey: "${GLM_API_KEY}"      # 支持环境变量
    apiEndpoint: "https://open.bigmodel.cn/api/paas/v4/chat/completions"
    modelId: "glm-4"
    maxTokens: 8192
    temperature: 0.7
    description: "智谱 GLM-4 模型"

  claude-231:
    name: "DeepSeek Model"
    apiKey: "${DEEPSEEK_API_KEY}"
    apiEndpoint: "https://api.deepseek.com/v1/chat/completions"
    modelId: "deepseek-chat"
    maxTokens: 4096
    temperature: 0.5
    description: "DeepSeek V3 模型"

  claude-gpt:
    name: "OpenAI GPT-4"
    apiKey: "${OPENAI_API_KEY}"
    apiEndpoint: "https://api.openai.com/v1/chat/completions"
    modelId: "gpt-4-turbo"
    maxTokens: 4096
    temperature: 0.7
    description: "OpenAI GPT-4 Turbo"

metadata:
  created: "2026-01-14"
  lastModified: "2026-01-14"
```

### 3.2 命令生成模块 (CommandManager.ts)

```typescript
export interface ModelConfig {
  name: string;
  apiKey: string;
  apiEndpoint: string;
  modelId: string;
  maxTokens: number;
  temperature: number;
  description: string;
}

export class CommandManager {
  /**
   * 生成 claude-xxx 命令脚本
   * @param commandName 命令名称（如 claude-glm）
   * @param config 模型配置
   */
  async generateCommand(
    commandName: string,
    config: ModelConfig
  ): Promise<string> {
    // 生成 shell 脚本或批处理文件
  }

  /**
   * 注册命令到系统
   * @param commandName 命令名称
   * @param scriptPath 脚本路径
   */
  async registerCommand(
    commandName: string,
    scriptPath: string
  ): Promise<void> {
    // Windows: 添加到 PATH 或创建 .bat 文件
    // Unix: 创建符号链接或复制到 /usr/local/bin
  }

  /**
   * 列出所有已注册的命令
   */
  async listCommands(): Promise<string[]> {
    // 扫描配置文件中的所有命令
  }

  /**
   * 删除指定命令
   */
  async removeCommand(commandName: string): Promise<void> {
    // 删除命令脚本和配置
  }
}
```

### 3.3 进程包装器 (ProcessWrapper.ts)

```typescript
export class ProcessWrapper {
  /**
   * 执行 claude 命令，注入自定义配置
   * @param commandName 命令名称
   * @param args 命令参数
   */
  async execute(
    commandName: string,
    args: string[]
  ): Promise<void> {
    // 1. 读取模型配置
    // 2. 临时设置环境变量
    // 3. 调用原始 claude 命令
    // 4. 清理环境变量
  }

  /**
   * 注入模型配置到环境变量
   */
  private injectConfig(config: ModelConfig): void {
    // 设置 ANTHROPIC_API_KEY, ANTHROPIC_BASE_URL 等
  }
}
```

---

## 4. 实现方案

### 方案 A: 环境变量注入 (推荐)

**原理**: 临时修改环境变量，调用原始 `claude` 命令

```bash
#!/bin/bash
# claude-glm 命令脚本

export ANTHROPIC_API_KEY="your-glm-api-key"
export ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/paas/v4"

exec claude "$@"
```

**优点**:
- 实现简单，兼容性好
- 不需要修改 Claude Code 源码
- 自动继承原命令的所有功能

**缺点**:
- 依赖环境变量优先级
- 需确保 Claude Code 支持这些环境变量

---

### 方案 B: 配置文件切换

**原理**: 切换 Claude Code 配置文件

```typescript
// 1. 备份当前配置
// 2. 写入新模型配置
// 3. 执行 claude 命令
// 4. 恢复原配置
```

**优点**:
- 更精确的控制
- 不依赖环境变量

**缺点**:
- 实现复杂
- 并发调用可能冲突
- 需要处理配置文件锁定

---

### 方案 C: 代理服务器 (最灵活)

**原理**: 启动本地代理服务器，转发 API 请求

```
claude-glm → local proxy (127.0.0.1:8080) → GLM API
claude-231 → local proxy (127.0.0.1:8081) → DeepSeek API
```

**优点**:
- 完全控制请求和响应
- 支持请求/响应转换
- 可以添加中间件逻辑

**缺点**:
- 架构复杂
- 需要管理多个服务器进程
- 资源开销较大

---

## 5. CLI 命令设计

### 5.1 安装和初始化

```bash
# 全局安装
npm install -g claude-code-command-switch

# 初始化配置
claude-switch init

# 添加第一个模型
claude-switch add glm \
  --name "claude-glm" \
  --api-key "$GLM_API_KEY" \
  --endpoint "https://open.bigmodel.cn/api/paas/v4" \
  --model "glm-4"
```

### 5.2 日常使用

```bash
# 使用指定模型
claude-glm "帮我写一个 Python 脚本"
claude-231 "解释这段代码"

# 列出所有可用命令
claude-switch list

# 切换默认模型
claude-switch default claude-glm

# 删除某个命令
claude-switch remove claude-231

# 更新配置
claude-switch update claude-glm --model "glm-4-turbo"
```

---

## 6. 工作流程

```
用户执行 claude-glm "hello"
         ↓
    检查命令是否存在
         ↓
    读取 models.yaml 配置
         ↓
    注入环境变量/配置
         ↓
    调用原始 claude 命令
         ↓
    API 请求被路由到 GLM
         ↓
    返回结果给用户
```

---

## 7. 安装部署

### 7.1 自动安装脚本 (setup.sh)

```bash
#!/bin/bash
# setup.sh

# 1. 检查 Node.js 版本
# 2. 安装依赖
# 3. 创建配置目录
# 4. 生成默认配置文件
# 5. 注册到 PATH
```

### 7.2 手动安装步骤

```bash
# 克隆项目
git clone https://github.com/user/claude-code-command-switch.git
cd claude-code-command-switch

# 安装依赖
npm install

# 构建
npm run build

# 链接到全局
npm link

# 初始化
claude-switch init
```

---

## 8. 配置验证

### schema.json (JSON Schema)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["version", "models"],
  "properties": {
    "version": { "type": "string" },
    "default": { "type": "string" },
    "models": {
      "type": "object",
      "patternProperties": {
        "^claude-[a-z0-9-]+$": {
          "type": "object",
          "required": ["name", "apiKey", "apiEndpoint", "modelId"],
          "properties": {
            "name": { "type": "string" },
            "apiKey": { "type": "string" },
            "apiEndpoint": { "type": "string", "format": "uri" },
            "modelId": { "type": "string" },
            "maxTokens": { "type": "number", "minimum": 1 },
            "temperature": { "type": "number", "minimum": 0, "maximum": 2 }
          }
        }
      }
    }
  }
}
```

---

## 9. 安全考虑

1. **API Key 保护**
   - 支持环境变量引用
   - 配置文件权限设置为 600
   - 不在日志中输出完整 key

2. **命令注入防护**
   - 验证命令名称格式
   - 转义特殊字符

3. **并发控制**
   - 配置文件读写加锁
   - 避免竞态条件

---

## 10. 扩展性

### 10.1 插件系统

```typescript
// 支持自定义中间件
interface Plugin {
  name: string;
  beforeRequest?: (config: ModelConfig) => ModelConfig;
  afterResponse?: (response: any) => any;
}
```

### 10.2 配置热重载

```bash
# 监听配置文件变化
claude-switch watch --auto-reload
```

### 10.3 团队共享配置

```yaml
# 支持从远程 URL 加载配置
remote:
  url: "https://raw.githubusercontent.com/team/config/models.yaml"
  sync: true
```

---

## 11. 开发计划

### Phase 1: MVP
- [ ] 基础项目结构
- [ ] 配置文件管理
- [ ] 命令生成（方案 A: 环境变量注入）
- [ ] 基本 CLI 命令（add, list, remove）

### Phase 2: 增强
- [ ] 配置验证
- [ ] 自动安装脚本
- [ ] 命令补全支持
- [ ] 日志和调试模式

### Phase 3: 高级特性
- [ ] 代理服务器模式（方案 C）
- [ ] 插件系统
- [ ] 配置热重载
- [ ] Web UI 配置界面

---

## 12. 示例配置

### 智谱 GLM-4
```yaml
claude-glm:
  name: "GLM-4"
  apiKey: "${GLM_API_KEY}"
  apiEndpoint: "https://open.bigmodel.cn/api/paas/v4/chat/completions"
  modelId: "glm-4"
```

### DeepSeek V3
```yaml
claude-231:
  name: "DeepSeek V3"
  apiKey: "${DEEPSEEK_API_KEY}"
  apiEndpoint: "https://api.deepseek.com/v1/chat/completions"
  modelId: "deepseek-chat"
```

### OpenAI GPT-4
```yaml
claude-gpt:
  name: "GPT-4 Turbo"
  apiKey: "${OPENAI_API_KEY}"
  apiEndpoint: "https://api.openai.com/v1/chat/completions"
  modelId: "gpt-4-turbo"
```

---

## 总结

**推荐方案**: 方案 A (环境变量注入) + YAML 配置文件

**理由**:
1. 实现简单可靠
2. 完全兼容 Claude Code
3. 易于维护和扩展
4. 用户学习成本低

**下一步**: 创建项目基础结构和 MVP 实现
