# 权限系统详解

难度：进阶

> 本文档是对[权限与安全基础](05-permissions.md)的完整展开。

## 三种权限级别

OpenCode 对 AI 的每一类操作都有三种控制级别：

- **allow**：直接执行，不需要你确认
- **ask**：执行前弹出提示，等你批准
- **deny**：直接拒绝，AI 无法执行

## 所有操作的默认权限值

| 操作 | 默认权限 | 说明 |
|------|---------|------|
| read | allow | 读取文件 |
| edit | allow | 修改文件 |
| bash | allow | 运行终端命令 |
| glob | allow | 搜索文件名 |
| grep | allow | 搜索文件内容 |
| task | allow | 启动子代理 |
| skill | allow | 加载技能 |
| webfetch | allow | 访问网页 |
| websearch | allow | 搜索互联网 |
| lsp | allow | LSP 查询 |
| **doom_loop** | **ask** | 同一操作重复 3 次时 |
| **external_directory** | **ask** | 访问项目目录外的文件 |

绝大多数默认 allow，只有 doom_loop 和 external_directory 默认 ask。

## .env 文件保护

虽然 read 默认 allow，但 `.env` 文件被特殊对待：

| 文件模式 | 权限 |
|---------|------|
| `.env` | deny |
| `.env.local`、`.env.production` 等 | deny |
| `.env.example` | allow |

## 权限配置位置

在 `opencode.json` 的 `permission` 字段中配置。

| 配置位置 | 生效范围 |
|---------|---------|
| `~/.opencode/opencode.json` | 全局，所有项目共享 |
| 项目根目录 `opencode.json` | 仅当前项目 |

项目级优先于全局级。

## 配置写法

### 简写：整个操作设为同一级别

```json
{
  "permission": {
    "bash": "ask"
  }
}
```

AI 每次要运行终端命令时都会先问你。

### 精细写法：用 glob 模式匹配

```json
{
  "permission": {
    "bash": {
      "*": "allow",
      "git *": "allow",
      "npm *": "allow",
      "rm *": "deny",
      "sudo *": "deny"
    },
    "edit": {
      "*": "allow",
      "*.env": "deny"
    }
  }
}
```

规则按顺序匹配，**最后一条匹配的规则生效**。`rm -rf something` 先匹配 `*`（allow），再匹配 `rm *`（deny），最终 deny。

### 按代理覆盖

每个 Agent 可以有自己的权限配置，与全局合并，Agent 规则优先：

```json
{
  "permission": {
    "bash": {
      "git push *": "deny"
    }
  },
  "agent": {
    "build": {
      "permission": {
        "bash": {
          "git push *": "ask",
          "npm publish *": "deny"
        }
      }
    }
  }
}
```

也可以在 `.opencode/agents/` 目录下用 Markdown 文件配置：

```markdown
---
description: Code review without edits
mode: subagent
permission:
  edit: deny
  bash: ask
---
Only analyze code and suggest changes.
```

## --auto 模式的精确行为

```bash
opencode --auto
```

- 所有原本需要 ask 的操作 -> 自动批准为 allow
- 所有显式设置为 deny 的规则 -> 仍然生效，不绕过

--auto 只取消"等待确认"，不取消"禁止执行"。

## task 权限与子代理

通过 `permission.task` 可以控制某个 Agent 能调用哪些子代理，支持 glob 模式：

```json
{
  "permission": {
    "task": {
      "*": "allow",
      "explore": "deny"
    }
  }
}
```

设为 deny 时，该子代理会从 Task 工具描述中完全移除，模型不会尝试调用它。

## 回到权限基础

理解了精细配置后，回到[权限与安全基础](05-permissions.md)查看面向初学者的简化说明。
