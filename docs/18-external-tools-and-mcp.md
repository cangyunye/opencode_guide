# 外部工具集成与 MCP 扩展

难度：进阶

## MCP 是什么

MCP（Model Context Protocol）是一个标准协议，让 OpenCode 能调用外部工具。通过 MCP，你可以让 AI 操作数据库、查询监控、发送通知、搜索代码仓库 -- 任何你能通过编程接口访问的东西。

## 内置 MCP 工具示例

OpenCode 社区已经有不少现成的 MCP 服务器可以直接使用：

| 服务 | 用途 |
|------|------|
| Sentry | 查看项目的错误追踪数据 |
| Context7 | 搜索第三方库的最新文档 |
| Grep (Vercel) | 在 GitHub 上搜索代码 |
| 数据库 | 直接查询和管理数据库 |

这些都不需要你自己搭建，配置好地址就能用。

## 配置 MCP 服务器

### 本地 MCP 服务器

本地运行的 MCP 服务器，通常是 npm 包：

```json
{
  "mcp": {
    "my-database": {
      "type": "local",
      "command": ["npx", "-y", "@my-org/mcp-postgres"],
      "environment": {
        "DATABASE_URL": "postgresql://localhost:5432/mydb"
      },
      "enabled": true
    }
  }
}
```

### 远程 MCP 服务器

通过 URL 访问的 MCP 服务器：

```json
{
  "mcp": {
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.dev/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_TOKEN"
      },
      "enabled": true
    }
  }
}
```

配置好后，MCP 提供的工具会和 OpenCode 的内置工具一起展示给 AI。AI 会根据你的请求自动选择合适的工具。

## 浏览器自动化操作

OpenCode 内置了浏览器 MCP（integrated_browser），可以让 AI 操控浏览器。

### 前置准备

无需额外安装任何依赖。OpenCode 自带的浏览器 MCP 支持导航、点击、输入、截图、读取 DOM 等操作。

### 能做什么

- 打开网页并导航
- 点击按钮和链接
- 在输入框中填写内容
- 读取页面结构和元素属性
- 截取页面截图
- 执行 JavaScript
- 处理弹窗（alert、confirm、prompt）

### 常见场景

**Web 开发测试**：AI 修改代码后，自动打开浏览器验证页面是否正常渲染。

```text
请打开 http://localhost:3000/login，检查登录表单是否正常显示，然后尝试用测试账号 test@example.com / password123 登录，告诉我结果。
```

**页面截图对比**：AI 修改 UI 后，截图前后对比。

**自动化表单**：让 AI 在页面上填写复杂的表单并提交。

**前端调试**：AI 在页面上执行 JavaScript 检查状态。

### 注意事项

- 浏览器操作会消耗较多 tokens（页面内容可能很大）
- iframe 内容无法访问
- 建议先 `browser_snapshot` 查看页面结构，再操作具体元素

## Excel 和 Word 文档操作

OpenCode 本身不内置 Excel 和 Word 的处理能力。但通过社区技能 + 运行时库的组合，可以让 AI 操控 Office 文档。

### 工作原理

AI 操作 xlsx/docx 文件的真实过程是：

1. 你安装对应的社区技能（SKILL.md 文件）
2. SKILL.md 告诉 AI 应该用什么库、什么命令来处理文件
3. AI 根据指引，**实时编写 Python 或 JavaScript 脚本**，通过 bash 工具执行
4. 脚本调用第三方库完成实际的文件读写

所以你需要的不是 OpenCode 的"内置功能"，而是：**技能文件 + 运行时环境 + 第三方库**。

### xlsx（Excel）操作

常见场景：
- 从数据生成 Excel 报表
- 批量处理电子表格（清洗数据、计算公式、格式化）
- 读取 Excel 中的数据并写入代码或配置

```text
请读取 /data/sales_2024.xlsx，汇总每个季度的总销售额，生成一个新的汇总表保存到 /workspace/summary.xlsx
```

**前置准备（三选一）**：

| 方案 | 需要安装 | 优缺点 |
|------|---------|--------|
| Python + openpyxl | `pip install openpyxl pandas` | 功能全面，支持复杂操作和数据分析 |
| Python + xlsx CLI 二进制 | 下载 Go 编写的单文件二进制 | 零 Python 依赖，适合简单读写 |
| Node.js + exceljs | `npm install -g exceljs` | JavaScript 生态，适合 JS 项目 |

**技能安装**：从社区获取 xlsx 技能的 SKILL.md，放入 `.opencode/skills/xlsx/SKILL.md`。技能文件会指导 AI 使用你安装的库来编写处理脚本。

### docx（Word）操作

常见场景：
- 根据数据自动生成报告文档
- 批量修改合同模板
- 创建带格式的技术文档

```text
根据 docs/plans/payment-design.md 的内容，创建一个正式的技术设计文档，保存为 /workspace/payment-design.docx
```

**前置准备（二选一）**：

| 方案 | 需要安装 | 优缺点 |
|------|---------|--------|
| Node.js + docx | `npm install -g docx` | 创建 Word 文档，支持格式、表格、图片 |
| Python + python-docx | `pip install python-docx` | 读写 Word 文档，Python 生态 |

**技能安装**：从社区获取 docx 技能的 SKILL.md，放入 `.opencode/skills/docx/SKILL.md`。

### 通用建议

- 如果你主要用 Python 开发，优先选 Python 方案（openpyxl + python-docx），一个环境搞定两种文件
- 如果你主要用 Node.js 开发，优先选 Node.js 方案（docx + exceljs）
- 如果是全新环境、什么都不想装，用 xlsx 的 Go 二进制方案处理 Excel 最简单
- 无论哪种方案，技能文件只是"操作指南"，真正的处理能力来自第三方库

## 自定义 MCP 服务器

如果你有特定需求，可以自己编写 MCP 服务器。支持 Node.js 和 Python：

1. 创建一个 MCP 服务器项目
2. 定义暴露的工具（名称、参数、功能）
3. 在 `opencode.json` 中注册

这是一个更高级的话题，需要一定的开发能力。

## 下一步

知道了如何扩展 OpenCode 的能力，下一章我们看看如何设计自己的技能。

[自定义技能设计实战 -->](19-custom-skills-design.md)
