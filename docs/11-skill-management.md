# 精简与修改技能

难度：进阶

## 什么时候需要精简技能

技能不是越多越好。每个技能在被加载时都会消耗上下文空间（相当于占用了 AI 的"记忆容量"）。技能太多、太杂，反而会让 AI 的表现变差。

需要精简的信号：

**AI 经常加载不相关的技能**：你让它改个 CSS 样式，它却加载了 TDD 技能，说明技能的描述让 AI 产生了误判。

**技能之间内容冲突**：两个技能对同一件事给出了矛盾的规则，AI 不知道该听谁的。比如一个技能说"所有代码必须写测试"，另一个说"原型代码不需要写测试"。

**你从来不用某些技能**：安装了很多社区技能，但实际工作中从未触发过。这些技能白白占用空间。

**上下文明显不够用**：AI 频繁"忘记"之前聊过什么，或者 `/compact` 之后效果很差。可能是因为技能占用了太多上下文空间。

## 精简方法

### 方法一：在权限中 deny

最简单的方式，不改文件，只加规则：

```json
{
  "permission": {
    "skill": {
      "unused-skill-name": "deny",
      "experimental-*": "deny"
    }
  }
}
```

支持通配符，可以一键禁用一类技能。

### 方法二：删除技能文件

直接删掉不需要的技能目录：

```bash
rm -rf .opencode/skills/unused-skill-name
```

彻底移除，不占任何空间。

### 方法三：缩小 description 的匹配范围

如果技能经常被误触发，可以修改 description，让它更精确：

```yaml
# 之前（太宽泛）
description: "Use for code quality review"

# 之后（更精确）
description: "Use only when explicitly asked to review existing code changes. Do not auto-trigger for new feature development."
```

## 什么时候需要修改技能

需要修改的信号：

**技能的默认行为不符合你的项目习惯**：比如 writing-plans 技能默认把计划保存到 `docs/plans/` 目录，但你的项目习惯把设计文档放在 `design/` 下。

**技能的输出格式不符合你的需求**：比如 brainstorming 技能输出纯文本设计文档，但你希望输出包含图表的 Markdown。

**技能遗漏了你项目的特殊约束**：比如 TDD 技能没有提到"我们项目用 Jest 而不是 Vitest"，导致 AI 用错了测试框架。

**技能的语言不适合**：社区技能可能是英文的，但你希望 AI 用中文和你沟通。

## 修改方法

### 方法一：直接编辑 SKILL.md

找到技能文件并修改：

```bash
# 查看技能位置
ls .opencode/skills/

# 编辑
vim .opencode/skills/writing-plans/SKILL.md
```

注意：修改内置技能时，建议先复制一份到项目级目录，再修改副本。这样不影响其他项目。

### 方法二：创建覆盖版本

在项目目录下创建同名技能，项目级的优先级更高：

```bash
# 把内置技能复制到项目目录
cp -r ~/.config/opencode/skills/writing-plans .opencode/skills/

# 修改项目级副本
vim .opencode/skills/writing-plans/SKILL.md
```

这样你有了自己的版本，不会影响其他项目，也不会在升级 OpenCode 时被覆盖。

## 技能优先级

当多个位置存在同名技能时：

**项目级 > 全局级 > 内置**

```
.opencode/skills/tdd/SKILL.md         # 项目级，优先级最高
~/.config/opencode/skills/tdd/SKILL.md  # 全局级
（内置 TDD 技能）                        # 最低，被以上覆盖
```

你也可以在 `~/.claude/skills/` 或 `.claude/skills/` 下放技能（兼容 Claude Code 格式），但优先级低于 `.opencode/skills/`。

## 下一步

了解技能管理后，我们来深入看几个最实用的核心技能。

[核心技能详解 -->](12-key-skills.md)
