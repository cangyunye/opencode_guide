# 模型选择与成本控制

难度：进阶

在基础篇里，你用 Zen 的默认模型就能开始工作。但当使用深入后，你会遇到这些问题：不同模型的质量差异很大，价格也差很多，速度也不一样。选对模型，能省不少钱、省不少时间。

## 理解模型的三个维度

选模型就是在这三个维度之间做权衡：

**质量**：模型的理解能力和代码水平。质量越高，越不容易犯低级错误，处理复杂任务的能力越强。

**速度**：从你发送消息到 AI 开始回复的等待时间。越快越好，尤其在你需要反复交互的场景。

**成本**：模型按"tokens"（可以理解为字数）计费。你发的消息、AI 回复的内容、AI 读取的文件，都算 tokens。不同模型单价差异巨大。

没有"最好的模型"，只有"最适合你当前任务的模型"。

## 国产模型使用场景比对

DeepSeek、智谱（GLM）和通义千问（Qwen）是国内开发者最常用的三个模型供应商，下面通过具体场景对比它们的不同定位。

### DeepSeek V4 Flash vs DeepSeek V4 Pro vs GLM 5.2 vs Qwen 3.6 Plus vs Qwen 3.7 Max

| 维度 | DeepSeek V4 Flash | DeepSeek V4 Pro | GLM 5.2 | Qwen 3.6 Plus | Qwen 3.7 Max |
|------|-------------------|-----------------|---------|---------------|-------------|
| 定位 | 极致性价比 | 质量优先 | 均衡通用 | 低成本通用 | 编码旗舰 |
| 输入价格（每 1M tokens） | $0.14 | $1.10 | $0.50 | $0.40 | $2.50 |
| 输出价格（每 1M tokens） | $0.28 | $4.40 | $2.50 | $1.60 | $7.50 |
| 速度 | 极快 | 中等 | 中等偏快 | 快 | 中等 |
| 中文理解 | 优秀 | 优秀 | 优秀（中文原生） | 优秀（中文原生） | 优秀（中文原生） |
| 编码能力 | 中等偏上 | 强 | 中等偏上 | 中等偏上 | 强（编码优化） |
| 推理深度 | 浅 | 深 | 中等 | 中等偏浅 | 深 |
| 长文本处理 | 128K | 128K | 128K | 128K | 128K |

Qwen 系列的两个模型值得特别注意：**Qwen 3.6 Plus** 价格比 Flash 略高但远低于 Pro，是一个很有性价比的中间选择；**Qwen 3.7 Max** 定位编码旗舰，能力接近 DeepSeek V4 Pro，中文原生理解力更强，适合需要同时处理中文文档和代码的场景。

### 具体场景推荐

**场景一：日常问答、查资料、解释代码**

推荐：DeepSeek V4 Flash 或 Qwen 3.6 Plus

这类任务对推理深度要求不高，但对响应速度和成本敏感。Flash 极快的响应速度和极低的价格让它成为最佳选择。Qwen 3.6 Plus 中文原生能力在理解中文技术文档时有优势，且价格仍然很低。

```
@src/utils/parser.ts 这个解析函数的逻辑是什么？
```

**场景二：编写中等复杂度的功能代码**

推荐：DeepSeek V4 Pro 或 Qwen 3.7 Max

添加一个完整的 API 接口、实现一个业务逻辑模块这类任务，需要模型有较好的编码能力和一定的推理深度。Flash 可能会跳过一些边界情况处理，Pro 和 Qwen 3.7 Max 在这类任务上更可靠。如果你的项目文档和注释都是中文，Qwen 3.7 Max 的中文原生理解会带来一些额外优势。

```
帮我实现一个用户权限校验中间件，支持角色和功能级别的权限控制
```

**场景三：大型重构、架构设计、复杂 bug 定位**

推荐：Qwen 3.7 Max 或升级到 Claude Sonnet 5 / GPT 5.4

需要深入理解整个代码库、权衡多种方案、处理复杂的依赖关系。这个场景下 Flash 和 Qwen 3.6 Plus 明显不够用，Qwen 3.7 Max 可以应付大部分情况，但特别复杂的问题可能需要更强的国际模型。

```
这个项目的认证模块要从 JWT 迁移到 OAuth 2.0，帮我分析影响范围并制定迁移方案
```

**场景四：TDD 循环中的测试生成**

推荐：DeepSeek V4 Flash 或 Qwen 3.6 Plus

TDD 的 Red-Green-Refactor 循环中，写测试和写最小代码是高度重复的模式化任务。Flash 的速度优势在这里非常突出，Qwen 3.6 Plus 作为备选也可以。即使偶尔生成不完美的测试，TDD 循环本身会通过"测试失败 -> 修复"的自我纠错机制来弥补。

**场景五：brainstorming 需求问答**

推荐：DeepSeek V4 Pro 或 Qwen 3.7 Max

brainstorming 技能需要 AI 理解用户意图、提出有价值的方案选项。Flash 和 Qwen 3.6 Plus 在这个场景下可能给出过于简化的方案。Pro 和 Qwen 3.7 Max 的推理深度更适合这种需要"创意"的任务。

**场景六：writing-plans 步骤拆解**

推荐：DeepSeek V4 Pro 或 Qwen 3.7 Max

把复杂需求拆解为精确的实施步骤，需要较好的逻辑推理和上下文理解。两者在拆解的完整性和精确度上都优于 Flash 和 Qwen 3.6 Plus。

**场景七：中文项目文档生成与维护**

推荐：Qwen 3.7 Max

当任务涉及生成或整理中文技术文档、编写中文 API 说明、处理中文注释和 commit message 时，Qwen 系列的中文原生能力有明显优势。GLM 5.2 同样擅长，但 Qwen 3.7 Max 在编码场景的综合能力更强。

```
根据 @docs/architecture.md 的内容，帮我生成一份面向新成员的中文项目介绍文档
```

### Qwen 3.6 Plus vs DeepSeek V4 Flash：如何选择

这两个模型价格接近（Qwen 3.6 Plus 略贵），速度都很快。核心区别：

| 对比维度 | DeepSeek V4 Flash | Qwen 3.6 Plus |
|---------|-------------------|---------------|
| 极限速度 | 更快 | 快 |
| 中文长文本理解 | 好 | 更好（原生） |
| 编码准确性 | 中等偏上 | 中等偏上 |
| 上下文保持 | 一般 | 略好 |

简单来说：纯编码任务选 Flash，涉及大量中文理解的任务选 Qwen 3.6 Plus，差异不大，按个人体验选择即可。

### 选择策略总结

```
简单任务（问答、解释、测试生成）  → DeepSeek V4 Flash 或 Qwen 3.6 Plus
中等任务（功能开发、brainstorming）→ DeepSeek V4 Pro 或 Qwen 3.7 Max
复杂任务（架构、重构、疑难 bug）  → Qwen 3.7 Max 或 Claude Sonnet 5 / GPT 5.4
中文文档密集型任务                → Qwen 3.7 Max 或 GLM 5.2
```

## OpenCode 是否支持自动场景路由

**不支持。** OpenCode 不会根据任务复杂度自动切换模型。所有模型分配都是基于配置预先决定的。

但 OpenCode 提供了**按 Agent 分配不同模型**的能力，可以实现类似效果：

```json
{
  "model": "deepseek/deepseek-v4-pro",
  "small_model": "deepseek/deepseek-v4-flash",
  "agent": {
    "plan": {
      "model": "deepseek/deepseek-v4-flash"
    },
    "explore": {
      "model": "deepseek/deepseek-v4-flash"
    },
    "scout": {
      "model": "deepseek/deepseek-v4-flash"
    },
    "build": {
      "model": "deepseek/deepseek-v4-pro"
    }
  }
}
```

这段配置的效果是：

| Agent | 使用的模型 | 原因 |
|-------|-----------|------|
| build（主代理，动手改代码） | DeepSeek V4 Pro | 编码质量优先 |
| plan（规划分析） | DeepSeek V4 Flash | 只读分析，不需要最强模型 |
| explore（搜索代码） | DeepSeek V4 Flash | 简单的文件搜索 |
| scout（查外部文档） | DeepSeek V4 Flash | 文档查阅不需要深推理 |
| small_model（生成会话标题等） | DeepSeek V4 Flash | 轻量后台任务 |

这样，探索和规划用便宜快速的 Flash，真正改代码时用质量更好的 Pro。虽然不是自动判断，但效果接近"按场景分配模型"。

**模型分配规则**：
- 主代理如果不指定 model，使用全局 `model` 配置
- 子代理如果不指定 model，使用调用它的主代理的模型
- `small_model` 用于标题生成等轻量后台任务，自动回退到主模型

## 模型分类

### 旗舰级 -- 最强但最贵

适合极其复杂的架构设计、难以定位的 bug、大型重构。

| 模型 | 特点 |
|------|------|
| GPT 5.5 Pro | OpenAI 旗舰，质量极高，但价格昂贵 |
| Claude Opus 4.8 | Anthropic 旗舰，擅长复杂分析和长文理解 |
| GPT 5.5 | OpenAI 高端，质量与成本平衡 |

### 编码专用 -- 写代码的最佳选择

| 模型 | 特点 |
|------|------|
| GPT 5.3 Codex | OpenAI 编码优化模型，性价比不错 |
| Kimi K2.7 Code | 专注编码，价格合理 |
| Qwen 3.7 Max | 国产编码旗舰，中文理解好 |

### 性价比 -- 日常开发的主力

| 模型 | 特点 |
|------|------|
| Claude Sonnet 5 | Anthropic 中端，编码能力强 |
| GPT 5.4 Mini | OpenAI 轻量，速度和质量都不错 |
| MiniMax M3 | 国产模型，价格极低，质量接近旗舰 |
| **DeepSeek V4 Pro** | 编码质量好，价格中等 |
| **GLM 5.2** | 中文原生，均衡通用 |

### 轻量快速 -- 简单任务用

| 模型 | 特点 |
|------|------|
| **DeepSeek V4 Flash** | 极快极便宜 |
| GPT 5 Nano | OpenAI 最便宜的选择 |
| Claude Haiku 4.5 | Anthropic 轻量，速度很快 |

### 免费模型

Zen 目前提供几个限时免费的模型，适合零成本体验：

- DeepSeek V4 Flash Free
- Big Pickle（匿名模型）

免费模型可能存在隐私方面的差异（免费期间数据可能用于模型改进），不要用它们处理敏感代码。

## 如何切换模型

在 OpenCode 里按 `Ctrl+X M` 或输入 `/models`，会弹出模型列表。用上下箭头选择，回车切换。

你也可以在 `opencode.json` 中指定默认模型：

```json
{
  "model": "opencode/gpt-5.4-mini",
  "small_model": "opencode/gpt-5-nano"
}
```

## 供应商配置进阶

除了基础篇讲的 `/connect` 方式，你还可以通过以下方式配置供应商。

**环境变量**：在 `~/.bashrc` 或 `~/.zshrc` 中设置：

```bash
export ANTHROPIC_API_KEY="sk-ant-xxx"
export OPENAI_API_KEY="sk-xxx"
export DEEPSEEK_API_KEY="sk-xxx"
```

OpenCode 启动时会自动检测这些环境变量并启用对应供应商。

**配置文件 `opencode.json`**：在项目根目录或 `~/.opencode/opencode.json` 下创建：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "deepseek": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "DeepSeek",
      "options": {
        "baseURL": "https://api.deepseek.com/v1",
        "apiKey": "{env:DEEPSEEK_API_KEY}"
      },
      "models": {
        "deepseek-v4-pro": { "name": "DeepSeek V4 Pro" },
        "deepseek-v4-flash": { "name": "DeepSeek V4 Flash" }
      }
    },
    "glm": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "GLM",
      "options": {
        "baseURL": "https://open.bigmodel.cn/api/paas/v4",
        "apiKey": "{env:GLM_API_KEY}"
      },
      "models": {
        "glm-5.2": { "name": "GLM 5.2" }
      }
    }
  }
}
```

国内用户可以通过 `baseURL` 指向中转服务地址，实现国内直连。

**优先级**：环境变量 > auth.json（/connect 生成的）> opencode.json

## 上下文窗口与计费

每个模型有一个"上下文窗口"大小，决定了它能一次性处理多少内容。常见的有 128K、200K 等。

当对话或文件内容超出上下文窗口时，超出的部分会被截断或价格翻倍。所以：
- 不要让 AI 读取整个大型代码库，指定具体的文件
- 长时间对话后用 `/compact` 压缩上下文

## 新手升级路径

1. **起步**：用 Zen 免费模型体验，了解 OpenCode 的基本用法
2. **日常（国内）**：DeepSeek V4 Pro 做主力，Flash 处理轻量任务
3. **日常（国际）**：Claude Sonnet 5 或 GPT 5.4 Mini
4. **深入**：遇到难题时临时切换到 GPT 5.5 或 Claude Opus 4.8
5. **省钱**：按 Agent 分配模型，探索用 Flash，编码用 Pro

## 下一步

模型选择是性价比优化。接下来我们看 OpenCode 的两种核心工作模式：计划和构建。

[计划模式与构建模式 -->](08-plan-vs-build.md)
