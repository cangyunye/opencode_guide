# OpenCode 入门教材 -- 需求文档

## 项目概述

面向完全未接触过 AI 编码助手的初学者，编写一套系统性的 OpenCode 中文入门教材。
采用 MkDocs 部署的多 Markdown 文件结构，循序渐进地引导读者从零掌握 OpenCode。

**目标读者**：有基础编程经验、但从未使用过 AI 编码助手的开发者。
**教材风格**：口语化、场景化、少术语，像一位经验丰富的同事手把手教你。

---

## 章节分类

教材分为 **基础篇** 和 **进阶篇** 两大部分：

- **基础篇**：读完就能独立使用 OpenCode 完成日常开发任务。内容聚焦在"安装即用"，不讨论模型差异、技能编排、复杂权限等概念。
- **进阶篇**：读完能高效、安全、专业地使用 OpenCode。涉及模型选择、技能系统、计划模式、长时间操作、多维度开发、桌面版等深入话题。

---

## 文件结构

```
docs/
  index.md                          # 教材首页与导航

  # ===== 基础篇：快速上手 =====
  01-what-is-opencode.md            # OpenCode 是什么
  02-install-and-setup.md           # 安装与基本配置
  03-first-run.md                   # 第一次启动与 /init
  04-basic-usage.md                 # 基础使用场景
  05-permissions.md                 # 权限系统与安全操作
  06-sessions-and-commands.md       # 会话管理与常用命令

  # ===== 进阶篇：深入掌握 =====
  07-model-selection.md             # 模型选择与成本控制
  08-plan-vs-build.md               # 计划模式与构建模式
  09-skills-intro.md                # 技能系统入门（含触发机制）
  10-reading-skills.md              # 如何看懂技能
  11-skill-management.md            # 精简与修改技能
  12-key-skills.md                  # 核心技能详解
  13-skill-workflow.md              # 技能使用顺序与最佳实践
  14-long-tasks.md                  # 长时间操作（含中断原因与持续策略）
  15-multi-dimensional-dev.md       # 多维度开发（含多Agent准备）
  16-desktop-guide.md               # 桌面版操作指南
  17-persistent-rules.md            # 持久规则与会话高级管理
  18-external-tools-and-mcp.md      # 外部工具集成与 MCP 扩展（含浏览器/Office）
  19-custom-skills-design.md        # 自定义技能设计实战（含知识库搜索/运维）
  20-tips-and-tricks.md             # 实用技巧与常见问题

mkdocs.yml                          # MkDocs 配置文件
```

---

## 各章节详细规划

### 基础篇

---

#### `01-what-is-opencode.md` -- OpenCode 是什么

- OpenCode 的定位：一个住在你终端里的 AI 编程搭档
- 它与 ChatGPT/Copilot 的本质区别（Agent vs 补全工具）
- 核心特性一览：模型中立、多会话、技能系统、权限控制、开源
- 三种使用方式：终端界面、桌面应用、IDE 扩展
- 社区数据：70K+ GitHub Stars，65 万+ 月活开发者

#### `02-install-and-setup.md` -- 安装与基本配置

- 安装方式（安装脚本、npm、Homebrew 等），按平台分
- 供应商（Provider）概念一句话解释：OpenCode 不提供模型，只提供使用模型的界面
- **简化配置**：新手只用 /connect 命令连接默认供应商即可开始
- OpenCode Zen 一句话介绍：官方精选模型网关，自带免费模型
- 中国用户一句话指引：国内直连选 MiniMax/DeepSeek，网络通畅选 Zen
- **复杂配置内容移入第 7 章**：环境变量、配置文件 opencode.json、自定义 baseURL、75+ 供应商列表等

#### `03-first-run.md` -- 第一次启动与 /init

- 在项目目录中启动 OpenCode（opencode 命令）
- /init 命令的作用：扫描项目、创建 AGENTS.md
- AGENTS.md 是什么：项目的"说明书"，告诉 AI 你的项目结构和规范
- 项目级 vs 全局级 AGENTS.md
- 为什么建议把 AGENTS.md 提交到 Git
- CLAUDE.md 兼容说明
- **进阶内容移入第 17 章**：instructions 字段引用外部文件、自定义代理配置等

#### `04-basic-usage.md` -- 基础使用场景

- 场景一：让 OpenCode 解释代码（@文件 引用）
- 场景二：直接修改代码
- 场景三：撤销修改（/undo 和 /redo）
- 场景四：调试报错（粘贴错误信息）
- 场景五：添加新功能的简化流程（直接说需求）
- 常用快捷键速查表
- !命令执行 shell 命令
- **进阶内容移入第 8 章**：先 Plan 再 Build 的完整流程

#### `05-permissions.md` -- 权限系统与安全操作

- 权限系统的目的：让 AI 不能随意执行危险操作
- 三种权限级别：allow / ask / deny
- 新手默认设置已足够安全，无需手动配置
- 关键保护机制：.env 文件默认拒绝读取、doom_loop 自动暂停重复操作
- --auto 模式简介
- 看到权限提示时如何判断"允许"还是"拒绝"
- **进阶内容移入第 10 章**：精细控制规则（glob 模式、按代理覆盖）

#### `06-sessions-and-commands.md` -- 会话管理与常用命令

- /new 创建新会话、/sessions 切换会话
- /undo 撤销、/redo 重做
- /compact 手动压缩上下文
- /share 分享会话链接
- /export 导出对话
- /connect 连接供应商
- /models 查看和切换模型（基础用法，只教怎么换，不教怎么选）
- /help 查看帮助
- /exit 退出
- 快捷键速查
- **进阶内容移入第 17 章**：Fork、子会话树、自动压缩机制、导入等

---

### 进阶篇

---

#### `07-model-selection.md` -- 模型选择与成本控制（从基础移入进阶）

- 为什么需要了解模型：默认模型够用，但选对模型能省钱/提速/提质
- 模型的三个维度：成本、速度、质量
- 常见模型分类表：
  - 旗舰级：GPT 5.5、Claude Opus 4.8
  - 编码专用：GPT 5.3 Codex、Kimi K2.7 Code
  - 性价比：Claude Sonnet 5、GPT 5.4 Mini
  - 轻量快速：DeepSeek V4 Flash、GPT 5 Nano
- 免费模型一览：DeepSeek V4 Flash Free、Big Pickle 等
- Zen 定价参考（按每 1M tokens）
- 中国用户供应商选择：MiniMax、DeepSeek、智谱、中转服务
- 上下文窗口与计费关系
- 新手升级路径：免费模型 -> 低价模型 -> 按需升级
- **基础篇移入的内容**：环境变量配置、opencode.json 供应商配置、自定义 baseURL

#### `08-plan-vs-build.md` -- 计划模式与构建模式

- 两种模式的区别：Plan 只读不改，Build 直接动手
- Tab 键切换模式
- 推荐工作流：先 Plan 再 Build
- Plan 模式下的子代理：Explore（代码探索）、Scout（外部文档研究）
- Build 模式下的子代理：General（通用多步骤任务）
- 什么时候用 Plan、什么时候直接 Build
- 代理配置简介（.opencode/agents/）

#### `09-skills-intro.md` -- 技能系统入门

- 什么是技能（Skills）：可复用的行为指令，像给 AI 装备不同的"工具箱"
- 为什么需要技能：没有技能的 AI 是通用的，有技能的 AI 是专业的
- 技能的发现机制：AI 自动发现并根据需要加载
- 技能的来源：内置技能、社区技能、自定义技能
- 技能的文件结构：.opencode/skills/<name>/SKILL.md
- 技能权限控制：allow / ask / deny
- **技能触发机制**：
  - 自动触发：AI 根据你的请求内容与技能的 description 匹配，自动加载相关技能（无需手动操作）
  - 强制触发：在对话中明确说"使用 xxx 技能"或"按照 xxx 技能的方式来做"，AI 会主动加载
  - 如何确认技能已加载：观察 AI 的回复中是否出现该技能的特征用语（如 brainstorming 会一次只问一个问题）、或通过 /details 查看工具调用记录确认 skill 工具是否被调用
  - 触发失败的常见原因：技能被 deny、description 与请求不匹配、技能文件路径错误

#### `10-reading-skills.md` -- 如何看懂技能

- SKILL.md 的结构解析：YAML frontmatter + 正文
- frontmatter 字段说明：name、description
- 正文内容通常包含什么：工作原则、执行步骤、输出格式
- 以一个简单技能为例逐行解读
- 提示：不需要全部读完，关键是理解它的"触发条件"和"核心约束"
- 技能 description 写得好不好，直接影响 AI 能否正确自动触发

#### `11-skill-management.md` -- 精简与修改技能

- 什么时候需要精简技能：
  - 技能太多导致 AI 花大量 token 加载不相关技能
  - 技能之间内容冲突或重叠
  - 某些技能你永远用不到
- 精简方法：配置 permission 的 deny 规则、删除技能文件
- 什么时候需要修改技能：
  - 技能的默认行为不符合你的项目习惯
  - 技能的输出格式不符合你的需求
  - 技能遗漏了你项目中的特殊约束
- 修改方法：直接编辑 SKILL.md、创建覆盖版本
- 技能继承路径和优先级

#### `12-key-skills.md` -- 核心技能详解

逐一介绍 5 个核心技能：

- **brainstorming**（头脑风暴）
  - 用途：将粗略想法细化为完整设计
  - 工作方式：一次问一个问题、提出 2-3 种方案、分段验证
  - 输出：设计文档

- **writing-plans**（编写计划）
  - 用途：将需求拆解为可执行的实施步骤
  - 工作方式：每步精确到文件路径和代码内容
  - 输出：实施计划文档

- **grill-with-docs**（审问式文档化）
  - 用途：模糊设计时，通过问答达成共识并生成文档
  - 工作方式：一次一问、自动写入 CONTEXT.md 和 ADR
  - 来源：社区技能，安装方式

- **test-driven-development**（测试驱动开发）
  - 用途：Red-Green-Refactor 循环
  - 工作方式：先写失败测试、最小代码通过、重构改进
  - 与 writing-plans 的配合

- **code-review**（代码审查）
  - 用途：审查 AI 或人工编写的代码
  - 工作方式：检查风格、逻辑、安全性

#### `13-skill-workflow.md` -- 技能使用顺序与最佳实践

- 完整开发工作流中的技能编排：
  1. brainstorming -- 需求模糊时，先把想法想清楚
  2. writing-plans -- 需求明确后，制定实施计划
  3. test-driven-development -- 编码时，先写测试再写实现
  4. code-review -- 实现完成后，审查代码质量
- 每个技能的衔接点和交接方式
- 不是每次都需要全部技能，按需组合
- 什么时候不需要技能：简单改动、快速问答

#### `14-long-tasks.md` -- 让 OpenCode 长时间可靠操作

- 长任务面临的挑战：token 耗尽、上下文丢失、中途出错
- **导致任务停止/中断的常见原因**：
  - 上下文窗口耗尽（自动压缩未触发或失败）
  - 权限被拒绝（deny 规则或用户未批准）
  - doom_loop 触发（同一工具调用重复 3 次）
  - 模型 API 限流或超时（rate limit / timeout）
  - 子代理执行失败且主代理未处理错误
  - 用户手动中断（Ctrl+C）
  - bash 命令执行报错且 AI 未恢复
- 自动压缩（Auto-compact）：95% 上下文使用时自动触发
- 手动压缩：/compact 命令
- 会话 Fork：从某个点分叉出新会话，尝试不同方向
- 子代理（Task Sessions）：主代理分派子代理执行独立任务
- /undo 撤销失败的操作
- **让 Agent 持续干长时间活的策略**：
  - 使用 writing-plans 技能拆分任务为多个独立小步骤，每步完成后 AI 自动继续
  - 配置 `compaction.auto: true` 确保上下文自动压缩
  - 在 AGENTS.md 中写清楚"每完成一步后继续下一步，不要停下来等我确认"
  - 使用 --auto 模式自动批准权限（注意安全边界）
  - 设置代理的 `steps` 参数提高最大迭代次数
  - 合理使用子代理：独立任务分派给子代理，主代理不因单点失败而中断
- 分步执行策略：把大任务拆成小步骤
- AGENTS.md 中写好规则，避免 AI 偏离方向

#### `15-multi-dimensional-dev.md` -- 多维度开发

- 什么是多维度开发：前后端同时进行、多模块并行开发
- **多 Agent 运行前的准备工作**：
  - 确认项目已 /init 并维护好 AGENTS.md（所有 Agent 共享同一份规则）
  - 确认权限配置允许并发操作（edit/bash 等权限设为 allow）
  - 规划好文件边界：哪些文件/模块由哪个 Agent 负责，避免冲突
  - 如果使用 Git Worktree，提前创建好分支和工作目录
  - 配置好 MCP 服务器（如果多个 Agent 需要共享外部工具）
  - 确认模型 API 配额足够支撑多个 Agent 同时调用
- 多会话并行：为同一项目开多个会话
- 子代理并行：General 子代理处理独立任务
- Git Worktree 配合：在不同分支同时工作
- 分享会话：/share 让团队成员参考
- 与团队协作：统一 AGENTS.md、MCP 共享
- 注意事项：避免多会话同时修改同一文件

#### `16-desktop-guide.md` -- 桌面版操作指南（新增）

- 桌面版 vs 终端版的定位：同一个工具，不同的交互方式
- 安装桌面版（macOS、Windows、Linux）
- 桌面版界面介绍：侧边栏会话列表、主对话区、工具执行详情
- 桌面版专属功能：
  - 图形化会话管理（新建、切换、Fork）
  - 拖拽图片到终端（视觉参考）
  - 设置面板（图形化配置供应商、模型、主题）
  - 多项目侧边栏
  - 字体和主题可视化切换
- 桌面版与终端版的配置共享（共用 opencode.json 和 AGENTS.md）
- 什么时候用桌面版、什么时候用终端版

#### `17-persistent-rules.md` -- 持久规则与会话高级管理

- 如何让 OpenCode 永远遵守一个规则：
  - 写入 AGENTS.md（项目级持久）
  - 写入全局 AGENTS.md（跨项目持久）
  - 配置文件中的 instructions 字段（引用外部文件或 URL）
  - 自定义代理配置（最精确的控制）
- AGENTS.md 编写指南：项目结构、编码规范、构建命令、技术栈说明
- 会话高级管理：
  - Fork 分支会话
  - 子会话树导航
  - 自动压缩机制详解
  - 导入导出（/export、opencode import）
- 自定义命令（.opencode/commands/）
- MCP 服务器扩展简介
- /editor 使用外部编辑器撰写长消息
- /details 查看工具执行细节
- /thinking 查看 AI 思考过程
- 主题切换（/themes）与快捷键自定义（keybinds）

#### `18-external-tools-and-mcp.md` -- 外部工具集成与 MCP 扩展（新增）

- MCP（Model Context Protocol）是什么：让 OpenCode 调用外部工具的标准协议
- 内置 MCP 工具举例：Sentry 错误追踪、Context7 文档搜索、Grep GitHub 代码搜索
- 如何配置 MCP 服务器（本地和远程）
- **浏览器自动化操作**：
  - OpenCode 内置浏览器 MCP（integrated_browser）：支持导航、点击、输入、截图、DOM 操作
  - 前置准备：无额外依赖，内置即可使用；适用于 Web 开发测试、页面交互自动化
  - 常见场景：自动化表单填写、页面截图对比、前端调试
- **Excel / Word 文档操作**：
  - 通过内置技能（xlsx / docx）直接操作：创建、编辑、格式化、读取电子表格和文档
  - 前置准备：AI 侧无额外依赖，Agent 直接调用技能即可；生成 .xlsx / .docx 文件到工作区
  - 常见场景：批量数据处理、报告生成、模板填充
- **自定义 MCP 服务器的设计思路**：
  - 用 Node.js/Python 编写 MCP 服务器，暴露自定义工具
  - 通过 opencode.json 的 mcp 配置注册

#### `19-custom-skills-design.md` -- 自定义技能设计实战（新增）

- **本地知识库搜索技能设计**：
  - 目标：让 AI 快速搜索本地项目文档、笔记、代码注释等知识
  - 工具链：rg（ripgrep，内容搜索）、fd（文件查找）、fzf（模糊交互选择）
  - 技能设计思路：
    - SKILL.md 中定义搜索策略：先用 fd 定位文件类型，再用 rg 搜索关键词，最后用 fzf 交互筛选
    - 输出格式：返回匹配文件路径 + 相关上下文片段
    - 与内置 grep/glob 工具的关系：自定义技能作为补充，针对特定知识库结构优化
  - 示例 SKILL.md 框架
- **Linux 自动运维技能设计方向**：
  - 方向一：系统监控与告警（读取日志、检查磁盘/内存/CPU、生成报告）
  - 方向二：批量部署与配置管理（批量 SSH 执行命令、配置文件模板渲染）
  - 方向三：定时任务管理（crontab 读写、任务状态检查）
  - 方向四：故障排查辅助（分析 dmesg/journalctl、追踪网络连通性）
  - 方向五：安全巡检（检查开放端口、防火墙规则、SSL 证书过期）
  - 设计原则：每个技能聚焦一个方向，通过 bash 工具调用系统命令，输出结构化报告

#### `20-tips-and-tricks.md` -- 实用技巧与常见问题

- 实用技巧：
  - 给 AI 足够的上下文（引用文件、粘贴错误、提供示例）
  - 像和初级开发者沟通一样描述需求
  - 复杂任务先让 AI 做计划
  - 善用 @ 和 ! 快捷语法
  - 定期 /compact 避免上下文膨胀
  - 把 AGENTS.md 当项目文档维护
- 常见问题：
  - OpenCode 修改了不该改的文件怎么办（权限配置、/undo）
  - AI 输出不符合预期怎么办（调整描述、换模型）
  - 上下文不够用了怎么办（压缩、Fork、换子代理）
  - 国内网络连不上怎么办（国内供应商、中转、本地模型）
- 从其他工具迁移：Cursor / Copilot / Claude Code 用户快速上手
- 学习资源推荐：官方文档、learnopencode.com 中文教程、GitHub 仓库

---

## MkDocs 配置要点

```yaml
site_name: OpenCode 入门指南
site_description: 面向初学者的 OpenCode AI 编码助手中文教程
theme:
  name: material
  language: zh
  features:
    - navigation.instant
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.suggest
nav:
  - 首页: index.md

  - 基础篇:
    - OpenCode 是什么: 01-what-is-opencode.md
    - 安装与基本配置: 02-install-and-setup.md
    - 第一次启动: 03-first-run.md
    - 基础使用场景: 04-basic-usage.md
    - 权限系统与安全: 05-permissions.md
    - 会话管理与常用命令: 06-sessions-and-commands.md

  - 进阶篇:
    - 模型选择与成本控制: 07-model-selection.md
    - 计划模式与构建模式: 08-plan-vs-build.md
    - 技能系统入门: 09-skills-intro.md
    - 如何看懂技能: 10-reading-skills.md
    - 精简与修改技能: 11-skill-management.md
    - 核心技能详解: 12-key-skills.md
    - 技能使用顺序: 13-skill-workflow.md
    - 长时间操作: 14-long-tasks.md
    - 多维度开发: 15-multi-dimensional-dev.md
    - 桌面版操作指南: 16-desktop-guide.md
    - 持久规则与会话高级管理: 17-persistent-rules.md
    - 外部工具集成与 MCP 扩展: 18-external-tools-and-mcp.md
    - 自定义技能设计实战: 19-custom-skills-design.md
    - 实用技巧与常见问题: 20-tips-and-tricks.md

markdown_extensions:
  - admonition
  - codehilite
  - tables
  - toc
```

---

## 写作原则

1. 每章控制在 800-2000 字，避免信息过载
2. 使用场景驱动，先展示"为什么"再解释"怎么做"
3. 代码示例使用终端风格（带 $ 提示符）
4. 重要概念首次出现时给出通俗比喻
5. 每章结尾给出"下一步"引导
6. 避免 AI 行话（如 "LLM"、"RAG"、"tokenize"），用"模型"、"上下文"等通俗说法替代
7. 基础篇只讲"怎么做"，进阶篇才讲"为什么"和"怎么做得更好"
8. 每篇开头标注"难度：基础 / 进阶"，让读者有心理准备
