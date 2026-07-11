# 如何看懂技能

难度：进阶

你不需要读完每个技能的全部内容才能使用它。但了解技能文件的结构，能帮你更好地判断"这个技能适不适合我的场景"，以及"为什么 AI 没有按我期望的方式工作"。

## SKILL.md 的结构

每个技能就是一个 Markdown 文件，名叫 `SKILL.md`。它的结构分两部分：

### 1. YAML 头部（frontmatter）

文件最开头，用 `---` 包裹的一段 YAML 配置：

```yaml
---
name: test-driven-development
description: >
  Use when implementing any feature or bugfix,
  before writing implementation code.
---
```

两个关键字段：

- **name**：技能的唯一标识名。AI 调用技能时用这个名字
- **description**：技能的描述。这是 AI 判断"是否需要加载这个技能"的唯一依据。描述写得好不好，直接决定了自动触发的准确率

description 应该写清楚：
- 这个技能解决什么类型的问题
- 在什么时机使用
- 和其他技能的区别

不好的描述："A testing skill"（太模糊，AI 不知道什么时候该用）
好的描述："Use when implementing any feature or bugfix, before writing implementation code. Follows red-green-refactor loop."（具体指明了使用时机和工作方式）

### 2. 正文内容

YAML 头部之后是技能的具体规则。常见的内容类型：

**工作原则**：技能必须遵守的约束。比如 TDD 技能会规定"不为没有失败测试的生产代码编写代码"。

**执行步骤**：按什么顺序做什么事。比如 brainstorming 技能会规定"一次只问一个问题，等回答后再问下一个"。

**输出格式**：结果要输出成什么样。比如 writing-plans 技能会规定"计划保存为 Markdown 文件，路径为 docs/plans/YYYY-MM-DD-<name>.md"。

**触发规则**：什么时候该用这个技能，什么时候不该用。

**示例**：展示一些好的输入输出示例，帮助 AI 理解期望的行为。

## 逐行解读示例

以一个简化版的 brainstorming 技能为例：

```yaml
---
name: brainstorming
description: >
  Use before any creative work: building features, creating
  components, modifying behavior. Refines rough ideas into
  complete designs through collaborative questioning.
---
```

- name 是 `brainstorming`，以后你强制触发时说"使用 brainstorming 技能"
- description 说得很清楚：在"创建功能、构建组件、修改行为"之前使用，通过"协作式提问"把粗略想法细化为完整设计

正文可能包含这样的规则：

```
## Process
1. Understand the project context first
2. Ask one question at a time, wait for the answer
3. Offer 2-3 approaches for each design decision
4. Present the design in 200-300 word segments
5. Validate each segment before moving on

## Principles
- Prefer choice questions over open-ended ones
- Follow YAGNI strictly
- Never assume technology choices -- ask the user

## Output
Save the design document to: docs/plans/YYYY-MM-DD-<topic>-design.md
```

从这个简化版你能看出技能的核心逻辑：不是直接动手做事，而是通过问答帮你把想法理清楚，然后输出一份设计文档。

## 实际操作建议

1. **安装新技能后，先看一下它的 description**：打开 `.opencode/skills/<技能名>/SKILL.md`，读一下 YAML 头部，理解这个技能是做什么的
2. **不需要读完整个正文**：你只需要知道"这个技能大概按什么思路工作"就够了。细节交给 AI，它会严格按规则执行
3. **如果 AI 的行为不符合预期**：检查一下技能的正文规则，可能是某个约束导致了你不想要的行为
4. **description 不理想可以改**：如果发现自动触发不准，尝试优化 description 的措辞

## 下一步

能看懂技能了，接下来我们看什么时候需要精简或修改技能。

[精简与修改技能 -->](11-skill-management.md)
