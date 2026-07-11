# 持久规则与会话高级管理

难度：进阶

## 让 OpenCode 永远遵守一个规则

你在对话中告诉 AI "用中文回复"，它这个会话里确实会照做。但开一个新会话，它又忘了。怎么让规则持久化？

### 方式一：项目级 AGENTS.md

在项目根目录的 `AGENTS.md` 中添加规则。这个文件在每次对话开始时都会被 AI 读取。

```markdown
## 编码规范
- 所有代码注释用中文
- 变量命名用 camelCase
- 组件文件名用 PascalCase

## 工作习惯
- 每次修改文件前先说明要改什么、为什么改
- 完成后运行一次测试确认没有破坏现有功能
```

建议提交到 Git，团队成员共享。

### 方式二：全局级 AGENTS.md

在 `~/.config/opencode/AGENTS.md` 中写规则，对你所有项目都生效。

```markdown
## 个人偏好
- 用中文回复
- 代码示例使用 TypeScript
- 解释代码时从上到下逐段说明
```

适合写个人偏好，不提交到 Git。

### 方式三：配置文件 instructions 字段

在 `opencode.json` 中引用外部指令文件：

```json
{
  "instructions": [
    "docs/coding-standards.md",
    "docs/architecture.md",
    "https://your-company.com/opencode-rules.md"
  ]
}
```

支持文件路径（相对项目根目录）和远程 URL。适合从统一的地方管理多个项目的规则。

### 方式四：自定义代理配置

最精确的控制方式。在 `opencode.json` 中定义自定义代理，指定 prompt、model、permission 等：

```json
{
  "agent": {
    "my-coder": {
      "prompt": "你是一个严格遵循 TDD 的 TypeScript 开发者。所有回复用中文。",
      "model": "opencode/claude-sonnet-5",
      "temperature": 0.2
    }
  }
}
```

然后在 AGENTS.md 或对话中指定使用这个代理。

## AGENTS.md 编写指南

好的 AGENTS.md 不是越长越好，而是信息密度高、没有废话。

**建议包含的内容**：
- 项目一句话介绍
- 技术栈和框架版本
- 构建、测试、部署命令及执行顺序
- 目录结构说明
- 编码规范（命名、注释、错误处理风格）
- 已知的技术债务或需要注意的地方
- 不要动哪些文件或目录

**不建议包含的内容**：
- 整个 API 文档（太长，浪费上下文）
- 每个文件的详细说明（AI 可以自己读文件）
- 团队成员信息

## 会话高级管理

### Fork 分支会话

从当前会话的某个点"分叉"出一个新会话，尝试不同方向：

```
/sessions
# 选择当前会话，选择 Fork
```

新会话获得 `(fork #1)` 后缀。原始会话不受影响。

### 子会话树

当主 Agent 派生子代理执行任务时，会形成父子会话树。你可以用快捷键导航：

- 进入第一个子会话：`Leader+Down`
- 切换到下一个子会话：`Right`
- 返回父会话：`Up`

### 自动压缩机制

当上下文使用达到模型窗口的 95% 时，OpenCode 自动触发压缩：
1. AI 生成一份对话摘要（保留关键决策和文件变更）
2. 创建新会话承载摘要
3. 原始会话保留（可以回看）

在 `opencode.json` 中配置：

```json
{
  "compaction": {
    "auto": true,
    "reserved": 1000
  }
}
```

`reserved` 是为摘要保留的 token 数量。

### 导入导出

导出当前会话：

```
/export
```

从文件或分享链接导入会话：

```bash
opencode import path/to/session.json
opencode import https://opncd.ai/share/xxxxx
```

## 其他实用功能

### 自定义命令

在 `.opencode/commands/` 目录下创建 Markdown 文件，文件名就是命令名。比如创建 `.opencode/commands/deploy.md`，就可以在对话中用 `/deploy` 触发。

### MCP 服务器扩展

通过 MCP（Model Context Protocol）让 OpenCode 调用外部工具。比如连接 Sentry 查看错误、连接数据库执行查询。详细配置在[外部工具集成](18-external-tools-and-mcp.md)中介绍。

### /editor 使用外部编辑器

按 `Ctrl+X E`，会打开你系统的默认编辑器（或 $EDITOR 环境变量指定的编辑器）。适合撰写长消息或粘贴大量代码。

### /details 查看工具执行细节

按 `Ctrl+X D` 切换工具执行详情的显示。开启后你能看到 AI 每一步做了什么操作（读了哪些文件、改了什么内容、跑了什么命令）。

### /thinking 查看 AI 思考过程

部分模型（如 Claude）支持"思考"模式，会展示 AI 的推理过程。输入 `/thinking` 切换显示。

### 主题和快捷键

用 `/themes` 浏览和切换主题。在 `opencode.json` 的 `keybinds` 字段中自定义快捷键。

## 下一步

掌握了持久规则和会话管理，我们来看看如何通过 MCP 让 OpenCode 连接更多外部工具。

[外部工具集成与 MCP 扩展 -->](18-external-tools-and-mcp.md)
