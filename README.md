# OpenCode 入门指南

面向初学者的 OpenCode AI 编码助手中文教程。基于 MkDocs 构建，可直接部署到 GitHub Pages、Vercel 或 Netlify。

## 简介

OpenCode 是一个开源的 AI 编码助手，住在你的终端里，能读代码、改文件、跑命令。这本教材从零开始，教你怎么装、怎么配、怎么用、怎么用好。

**目标读者**：有编程基础、会用终端、但没用过 AI 编码助手的开发者。

**教材结构**：
- **基础篇**（6 章）：安装、配置、基本使用、权限、会话管理
- **进阶篇**（15 章）：模型选择、技能系统、长时间任务、多维度开发、桌面版、MCP 扩展、自定义技能设计

共 22 个 Markdown 文件，配套安装脚本和 MkDocs 配置。

## 内容预览

在本地预览：

```bash
# 安装依赖
pip install mkdocs mkdocs-material pymdown-extensions

# 启动本地预览服务器
mkdocs serve
```

浏览器访问 `http://127.0.0.1:8000`。

## 部署方案

### 方案一：GitHub Pages

适合免费托管。MkDocs 直接支持。

1. 将此仓库推送到 GitHub
2. 在仓库根目录创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy MkDocs
on:
  push:
    branches: [main]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "24"
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install mkdocs-material pymdown-extensions
      - run: mkdocs build
      - uses: actions/upload-pages-artifact@v4
        with:
          path: site
      - uses: actions/deploy-pages@v4
```

3. 在 GitHub 仓库 Settings > Pages 中，Source 选 "GitHub Actions"

### 方案二：Vercel

适合自定义域名。

1. 安装 MkDocs 部署插件：

```bash
pip install mkdocs-material pymdown-extensions mkdocs-vercel-deploy
```

2. 在 `mkdocs.yml` 中添加：

```yaml
plugins:
  - search
  - vercel-deploy:
      id: opencode-tutorial
```

3. 推送到 Vercel 关联的 Git 仓库，自动构建部署

### 方案三：Netlify

1. 在 Netlify 中创建新站点，关联 Git 仓库
2. Build command：`mkdocs build`
3. Publish directory：`site`

### 方案四：静态文件托管

手动构建后上传 `site/` 目录到任何静态文件托管服务：

```bash
mkdocs build
# 将 site/ 目录上传到服务器或 OSS/S3
```

## 项目结构

```
opencode-tutorial/
  mkdocs.yml                          # MkDocs 配置
  README.md                            # 本文件
  REQUIREMENTS.md                      # 需求文档
  docs/
    index.md                          # 教材首页
    install-opencode.sh               # Linux/macOS 一键安装脚本
    install-opencode.ps1              # Windows PowerShell 安装脚本
    01-what-is-opencode.md            # 基础：OpenCode 是什么
    02-install-and-setup.md           # 基础：安装与配置
    03-first-run.md                   # 基础：第一次启动
    04-basic-usage.md                 # 基础：使用场景
    05-permissions.md                 # 基础：权限基础
    05a-permissions-advanced.md       # 进阶：权限详解
    06-sessions-and-commands.md       # 基础：会话与命令
    07-model-selection.md             # 进阶：模型选择
    08-plan-vs-build.md               # 进阶：计划与构建
    09-skills-intro.md                # 进阶：技能入门
    09a-why-skills-matter.md          # 进阶：技能深度分析
    10-reading-skills.md              # 进阶：看懂技能
    11-skill-management.md            # 进阶：技能管理
    12-key-skills.md                  # 进阶：核心技能
    13-skill-workflow.md              # 进阶：技能顺序
    14-long-tasks.md                  # 进阶：长时间操作
    15-multi-dimensional-dev.md       # 进阶：多维度开发
    16-desktop-guide.md              # 进阶：桌面版
    17-persistent-rules.md           # 进阶：持久规则
    18-external-tools-and-mcp.md     # 进阶：MCP 扩展
    19-custom-skills-design.md        # 进阶：自定义技能
    20-tips-and-tricks.md             # 进阶：技巧与问题
```

## 定制

修改 `mkdocs.yml` 中的 `palette.primary` 和 `palette.accent` 可更换主题色。Material 主题支持 `red`、`pink`、`purple`、`deep purple`、`indigo`、`blue`、`teal`、`green` 等配色。
