# 实用技巧与常见问题

难度：进阶

## 实用技巧

### 给 AI 足够的上下文

AI 不能读心。你的描述越具体，它的输出越准确。

**不好**："修一下那个 bug"

**好**："运行 `npm run test` 后，`UserService.test.ts` 的第 42 个测试失败了。错误信息是 `Expected 200 but received 500`。请看一下 @src/services/UserService.ts 的 `getUserById` 方法，修复这个问题。"

具体到：什么命令报的错、哪个文件、什么方法、错误信息是什么。

### 像和初级开发者沟通一样描述需求

你不需要把所有细节都说出来（AI 会自己读代码），但需要说清楚"要做什么"和"期望的结果是什么"。把 AI 想象成一个聪明的初级开发者：他懂技术，但不了解你的项目。

### 复杂任务先让 AI 做计划

涉及 3 个以上文件的任务，先用 Plan 模式（Tab 键）让 AI 分析方案。确认方案合理后，再切换到 Build 模式实施。比直接让它动手然后反复 /undo 高效得多。

### 善用 @ 和 ! 语法

- `@文件路径`：引用项目中的文件到对话上下文
- `!命令`：执行终端命令并把输出纳入上下文

这两个语法让你不需要切换工具就能完成大部分操作。

### 定期 /compact

对话超过 20 轮交互后，手动执行一次 `/compact`。这会让 AI 生成对话摘要，释放上下文空间。之后 AI 的回复质量会更好。

### 把 AGENTS.md 当活文档维护

项目结构变了、加了新框架、改了构建命令，都更新到 AGENTS.md 里。这个文件越准确，AI 的表现就越好。

## 常见问题

### AI 修改了不该改的文件

**即时处理**：`/undo` 撤销，然后调整描述，指明正确的文件。

**预防措施**：在权限中精细化控制：

```json
{
  "permission": {
    "edit": {
      "*": "deny",
      "src/**/*.ts": "allow",
      "src/**/*.tsx": "allow",
      "tests/**/*.ts": "allow"
    }
  }
}
```

### AI 输出不符合预期

**原因一：描述不够清楚**。换一种方式描述，提供更多上下文和示例。

**原因二：模型能力不够**。换一个更高质量的模型（Claude Sonnet 5、GPT 5.4 Mini），复杂任务用旗舰模型。

**原因三：缺少技能约束**。安装或创建合适的技能，让 AI 有明确的行为规范。

### 上下文不够用了

**即时处理**：`/compact` 压缩上下文。

**预防措施**：
- 不要让 AI 读取整个大型文件，指定行范围或具体函数
- 启用自动压缩（`compaction.auto: true`）
- 用 Fork 开新会话处理后续任务
- 把大任务拆成多个小会话

### 国内网络连不上

**方案一**：用国内直连的供应商。MiniMax、DeepSeek、智谱、通义千问都可以直接用。

**方案二**：用第三方中转服务。在 `opencode.json` 中配置 `baseURL` 指向中转地址。

**方案三**：用本地模型。通过 Ollama 或其他本地推理工具运行模型，通过 OpenAI 兼容 API 接入 OpenCode。

### 技能没有自动触发

**检查清单**：
1. 技能文件是否在正确路径（`.opencode/skills/<name>/SKILL.md`）
2. 技能的 description 是否清晰描述了使用场景
3. 技能是否被 deny 了
4. 尝试强制触发："请使用 xxx 技能"

### 从其他工具迁移

如果你之前用 Cursor、GitHub Copilot 或 Claude Code，迁移到 OpenCode 很简单：

**规则文件**：OpenCode 能识别 `CLAUDE.md`（Claude Code）和 Cursor 的 rules 文件。不需要重新编写规则。

**操作习惯**：
- Cursor 的 Cmd+K 对话 -> OpenCode 的底部输入框
- Cursor 的 Agent 模式 -> OpenCode 的 Build 模式
- Claude Code 的 slash 命令 -> 大部分在 OpenCode 中有对应命令

**配置**：把 API 密钥从旧工具的配置中复制过来，通过 `/connect` 或环境变量配置到 OpenCode。

## 学习资源

- **OpenCode 官方文档**：[opencode.ai/docs](https://opencode.ai/docs)
- **OpenCode 中文实战课**：[learnopencode.com](https://learnopencode.com) -- 免费的中文教程，包含 49.7 万字内容和 83 个学霸笔记
- **GitHub 仓库**：[github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)
- **中文社区**：[opencodeai.cn](https://opencodeai.cn) -- 中文官网，提供下载、文档和镜像导航

## 到这里

恭喜你读完了整本教材。从安装配置到技能设计，你现在应该已经具备了独立使用和定制 OpenCode 的能力。

最好的学习方式是实践。打开你的项目，启动 OpenCode，开始你的第一次 AI 辅助开发吧。
