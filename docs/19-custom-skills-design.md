# 自定义技能设计实战

难度：进阶

除了使用内置和社区技能，你完全可以自己编写技能来满足项目的特殊需求。这一章先介绍"打工人四件套"（文档/表格/演示/测试），再通过具体案例演示技能设计的方法。

## 打工人四件套：办公文档技能安装指南

日常工作中最常见的需求就是处理 Office 文档和 Web 测试。以下四个技能来自 Anthropic 官方维护的技能仓库，质量很高，OpenCode 可以直接使用。

### 安装方式

OpenCode 使用 SKILL.md 格式，和 Claude Code 兼容。安装方式如下：

```bash
# 1. 克隆仓库到本地
git clone https://github.com/anthropics/skills.git /tmp/anthropic-skills

# 2. 复制需要的技能到项目目录
cp -r /tmp/anthropic-skills/skills/docx .opencode/skills/docx
cp -r /tmp/anthropic-skills/skills/xlsx .opencode/skills/xlsx
cp -r /tmp/anthropic-skills/skills/pptx .opencode/skills/pptx
cp -r /tmp/anthropic-skills/skills/pdf  .opencode/skills/pdf
cp -r /tmp/anthropic-skills/skills/webapp-testing .opencode/skills/webapp-testing

# 3. 清理临时文件
rm -rf /tmp/anthropic-skills
```

如果你想在所有项目中都能用，复制到全局目录：

```bash
cp -r /tmp/anthropic-skills/skills/docx ~/.config/opencode/skills/docx
# 以此类推
```

> 注意：这些技能的 SKILL.md 可能引用了 `scripts/` 目录下的辅助脚本。如果技能运行时报找不到脚本，把整个 skills 仓库克隆到固定位置，在 AGENTS.md 中说明路径。

### docx（Word 文档操作）

**用途**：创建、读取、编辑 Word 文档（.docx）

**前置依赖**：

| 依赖 | 安装命令 | 用途 |
|------|---------|------|
| docx (npm) | `npm install -g docx` | 创建新文档 |
| pandoc | `brew install pandoc` 或 `apt install pandoc` | 读取和提取内容 |
| python 3 | 系统自带 | 运行辅助脚本 |
| LibreOffice（可选） | `brew install --cask libreoffice` | .doc 转换、修订接受、PDF 转换 |

**能做什么**：
- 创建带样式的 Word 文档（标题、列表、表格、图片、页眉页脚、目录）
- 编辑现有文档（解包 .docx 的 XML，修改后重新打包）
- 读取文档内容提取文本
- 接受/拒绝修订跟踪
- 批量修改合同模板

**典型用法**：

```
根据 docs/plans/payment-design.md 的内容，创建一个正式的技术设计文档，保存为 /workspace/payment-design.docx
```

### pdf（PDF 操作）

**用途**：读取、创建、合并、拆分 PDF，提取文本和表格，OCR 扫描件等

**前置依赖**：

| 依赖 | 安装命令 | 用途 |
|------|---------|------|
| pypdf | `pip install pypdf` | 合并、拆分、旋转、加密、水印 |
| pdfplumber | `pip install pdfplumber` | 文本和表格提取（保留布局） |
| reportlab | `pip install reportlab` | 创建新 PDF |
| pytesseract + pdf2image | `pip install pytesseract pdf2image` | OCR 扫描件（需安装 Tesseract） |
| poppler-utils | `apt install poppler-utils` | pdftotext、pdfimages 等命令行工具 |

**能做什么**：
- 从 PDF 提取文本和表格（保留原始布局）
- 合并多个 PDF 为一个文件
- 按页拆分 PDF
- 添加水印、旋转页面
- 创建新 PDF（支持多页、上下标）
- 填写 PDF 表单
- 密码加密/解密
- OCR 扫描件转可搜索文本
- 提取 PDF 中的图片

**典型用法**：

```
读取 /workspace/report.pdf，提取其中的所有表格数据，整理成 CSV 格式保存到 /workspace/tables.csv
```

### pptx（PPT 演示文稿）

**用途**：创建、读取、编辑 PowerPoint 演示文稿

**前置依赖**：

| 依赖 | 安装命令 | 用途 |
|------|---------|------|
| pptxgenjs | `npm install -g pptxgenjs` | 从零创建演示文稿 |
| markitdown | `pip install "markitdown[pptx]"` | 读取和提取内容 |
| Pillow | `pip install Pillow` | 缩略图网格预览 |
| LibreOffice | `brew install --cask libreoffice` | 转换为图片做视觉检查 |
| Poppler | `apt install poppler-utils` | PDF 转图片 |

**能做什么**：
- 从零创建演示文稿（支持配色方案、字体、布局、间距）
- 读取现有 PPT 的内容
- 基于模板编辑现有演示文稿
- 视觉质量检查（转换为图片后检查重叠、溢出、对比度）
- 多页幻灯片批量生成

**典型用法**：

```
根据 docs/quarterly-report.md 的内容，创建一份 10 页的季度汇报 PPT，使用商务风格配色
```

### xlsx（Excel 操作）

**用途**：创建、读取、编辑 Excel 电子表格

**前置依赖**：

| 依赖 | 安装命令 | 用途 |
|------|---------|------|
| openpyxl | `pip install openpyxl` | 复杂格式、公式、多工作表 |
| pandas | `pip install pandas` | 数据分析、批量操作 |
| LibreOffice（可选） | `brew install --cask libreoffice` | 公式重算验证 |

**能做什么**：
- 创建带格式和公式的 Excel 文件
- 编辑现有 Excel（保留公式和格式）
- 数据分析和批量处理
- 公式重算和错误扫描（消除 #REF!、#DIV/0! 等）
- 图表生成
- CSV/TSV 文件读写

**典型用法**：

```
读取 /data/sales_2024.xlsx，汇总每个季度的总销售额，生成一个新的汇总表保存到 /workspace/summary.xlsx
```

### webapp-testing（Web 应用测试）

**用途**：使用 Playwright 自动化测试本地 Web 应用

**前置依赖**：

| 依赖 | 安装命令 | 用途 |
|------|---------|------|
| playwright | `pip install playwright` | Python Playwright 自动化 |
| Chromium | `playwright install chromium` | 测试用浏览器 |

**能做什么**：
- 自动化 UI 测试（点击、输入、断言）
- 浏览器截图用于视觉检查
- 捕获浏览器控制台日志
- 自动启动前后端服务器再测试
- 元素发现（找到页面上的按钮、链接、输入框）

**典型用法**：

```
启动我的 Next.js 项目（npm run dev），然后打开 http://localhost:3000/login，
测试登录流程：输入 test@example.com 和 password123，点击登录，
验证是否跳转到了首页，截图保存到 /workspace/tests/login-test.png
```

### 四件套速查

| 技能 | 什么场景触发 | 最小依赖 | 安装命令 |
|------|------------|---------|---------|
| docx | "Word 文档"、".docx"、报告、合同 | Node.js + npm | `npm install -g docx` |
| pdf | "PDF"、提取、合并、OCR | Python 3 | `pip install pypdf pdfplumber` |
| pptx | "PPT"、"幻灯片"、"演示文稿" | Node.js + npm | `npm install -g pptxgenjs` |
| xlsx | "Excel"、".xlsx"、表格、报表 | Python 3 | `pip install openpyxl pandas` |
| webapp-testing | "测试页面"、"UI 测试"、"截图" | Python 3 | `pip install playwright` |

### 安装四件套的一键脚本

```bash
# 安装全部前置依赖
pip install openpyxl pandas pypdf pdfplumber reportlab Pillow "markitdown[pptx]" playwright --break-system-packages
npm install -g docx pptxgenjs
playwright install chromium

# 克隆并安装技能
git clone https://github.com/anthropics/skills.git /tmp/anthropic-skills
for skill in docx pdf pptx xlsx webapp-testing; do
  cp -r /tmp/anthropic-skills/skills/$skill ~/.config/opencode/skills/$skill 2>/dev/null
done
rm -rf /tmp/anthropic-skills
```

## 本地知识库搜索技能

### 需求

你的项目有大量的文档、笔记、设计稿散落在各个目录中。你想让 AI 能快速搜索这些知识，而不是靠猜测文件路径。

### 思路

利用系统命令行工具构建搜索管道：
- **fd**：快速查找文件（按名称、类型、路径）
- **rg**（ripgrep）：快速搜索文件内容

这两个工具速度极快，适合 AI 通过 bash 调用来搜索项目知识库。

### SKILL.md 设计

在 `.opencode/skills/local-search/SKILL.md` 创建技能文件：

```yaml
---
name: local-search
description: >
  Use when the user asks to search project documentation,
  notes, design docs, or any local knowledge base.
  Searches through docs/, notes/, design/, and wiki/ directories.
---
```

正文规则：

```markdown
## Search Strategy

When searching for local knowledge:

1. **Locate files by type**: Use fd to find files matching the query pattern
   - Documentation: `fd .md docs/`
   - Notes: `fd .md notes/`
   - Design docs: `fd .md design/`

2. **Search content**: Use rg to search within files for specific keywords
   - `rg "keyword" --type md docs/ notes/ design/`
   - Always include line numbers and context (`-C 3`)

3. **Summarize findings**: After finding relevant content:
   - List matching file paths
   - Extract relevant passages (3-5 lines around each match)
   - If multiple files match, rank by relevance

## Constraints

- Never search binary files or node_modules
- Limit results to 20 most relevant matches
- If search returns no results, suggest alternative keywords
- Prefer specific file paths over broad directory searches

## Output Format

For each match, report:
- File path (relative to project root)
- Line numbers
- Relevant content excerpt
- Brief relevance explanation
```

### 使用方式

```text
搜索项目中关于"支付回调"相关的文档
```

AI 会自动加载 local-search 技能，用 fd 和 rg 搜索相关文档，整理结果给你。

### 和内置工具的关系

OpenCode 内置了 `glob`（文件查找）和 `grep`（内容搜索）工具，能完成类似的工作。自定义技能的价值在于：

- 针对特定的知识库目录结构优化搜索策略
- 定义固定的输出格式，让结果更规范
- 可以结合项目特定的分类规则（文档 vs 代码 vs 笔记）

## Linux 自动运维技能设计

### 设计方向

Linux 系统运维有很多重复性工作，适合用 AI + 技能来自动化。以下是几个可以独立设计的技能方向：

### 方向一：系统监控与告警

```yaml
name: sys-monitor
description: >
  Use when checking system health: disk usage, memory, CPU,
  process status, or service availability.
```

核心能力：
- 读取 `/proc` 或使用 `df`、`free`、`top` 等命令检查系统状态
- 与预设阈值对比，判断是否异常
- 生成结构化的健康报告
- 如果发现异常，给出具体的修复建议

### 方向二：批量部署与配置管理

```yaml
name: deploy-manager
description: >
  Use when deploying services to multiple servers or managing
  configuration files across environments.
```

核心能力：
- 读取配置模板，渲染为目标环境的配置文件
- 批量执行 SSH 命令（需要配置 SSH 密钥）
- 验证部署结果（检查服务状态、端口监听）
- 回滚方案（保留上一版本的配置备份）

### 方向三：定时任务管理

```yaml
name: cron-manager
description: >
  Use when creating, modifying, or troubleshooting crontab
  entries and scheduled tasks.
```

核心能力：
- 读取和解析现有的 crontab
- 添加、修改、删除定时任务
- 验证 cron 表达式的正确性
- 检查任务执行日志和失败记录

### 方向四：故障排查

```yaml
name: troubleshoot
description: >
  Use when diagnosing system issues: network problems, service
  crashes, high resource usage, or unexpected behavior.
```

核心能力：
- 分析 `dmesg`、`journalctl` 日志
- 检查网络连通性（ping、traceroute、curl）
- 检查端口监听和服务状态
- 追踪问题链路，给出排查步骤

### 方向五：安全巡检

```yaml
name: security-audit
description: >
  Use when performing security checks: open ports, firewall rules,
  SSL certificates, user permissions, or access logs.
```

核心能力：
- 检查开放端口（`ss`、`netstat`）
- 审查防火墙规则（`iptables`、`ufw`）
- 检查 SSL 证书有效期
- 审查用户权限和 sudo 配置
- 检查 SSH 配置安全性

### 设计原则

1. **每个技能聚焦一个方向**：不要试图把所有运维能力塞进一个技能。技能越聚焦，触发越准确，行为越可靠。
2. **通过 bash 工具调用系统命令**：技能本身不直接执行命令，而是告诉 AI 应该调用什么命令、怎么解读输出。
3. **输出结构化报告**：运维任务的结果应该是可读的报告，而不是零散的命令输出。用表格、列表、状态标识（OK / WARNING / CRITICAL）来组织信息。
4. **安全第一**：涉及系统操作的技能，应该在 AGENTS.md 或技能正文中明确限制（比如"不要修改系统配置，只做检查"）。

## 其他推荐技能

除了四件套，Anthropic 的技能仓库中还有几个值得关注的技能：

| 技能 | 用途 | 是否需要额外依赖 |
|------|------|----------------|
| skill-creator | 帮你创建和测试新的 SKILL.md | Python（用于评估） |
| mcp-builder | 指导构建 MCP 服务器 | TypeScript SDK 或 Python FastMCP |
| frontend-design | 前端视觉设计指导 | 无 |
| doc-coauthoring | 结构化文档协作工作流 | 无 |
| theme-factory | 为制品应用专业主题配色 | 无 |

安装方式和四件套相同，从 `https://github.com/anthropics/skills` 克隆后复制到 `.opencode/skills/` 目录。

## 下一步

技能设计是 OpenCode 的高级玩法。最后一章整理了一些实用技巧和常见问题，帮你避开使用中的坑。

[实用技巧与常见问题 -->](20-tips-and-tricks.md)
