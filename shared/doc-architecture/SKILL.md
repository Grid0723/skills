---
name: doc-architecture
description: 项目文档的标准目录架构与撰写规范——项目初始化、Grid 阶段产出映射、Agent 上下文指针。Use when initializing a new project, setting up documentation, when Grid needs to know where to write its outputs, or when the user asks about documentation structure.
---

# doc-architecture

定义项目文档的标准 8 目录骨架、每目录的撰写规范和 Grid 阶段产出映射。不包含具体内容——内容由各阶段产出物和 Agent 按需生成。

## Leading Words

| 术语 | 定义 |
|------|------|
| **文档骨架（Doc Skeleton）** | 项目初始化时创建的 docs/ 目录结构——只含空白模板，不含具体内容 |
| **上下文指针（Context Pointer）** | Agent 通过 `docs/README.md` 快速导航到需要的文档——不重复写内容，只建查阅入口 |
| **阶段产出映射（Phase Output Mapping）** | Grid 的每个阶段有明确的 docs/ 写入目标 |

## 标准目录架构

```bash
docs/
├── README.md                     # 📖 文档导航索引——"我想了解 X，应该去看哪个文件"
├── CHANGELOG.md                  # 版本变更记录——按日期+版本号记录
│
├── 01-Requirements/              # 📋 需求文档
│   └── PRD-<功能名>.md           # 产品需求文档——Grid to-prd 产出
│
├── 02-Architecture/              # 🏗️ 架构文档
│   ├── 系统架构.md               # 系统架构总览——模块职责、技术栈、数据流
│   ├── 时序图.md                 # 关键流程的时序图/状态机——可选
│   ├── 开发指南.md               # 新增功能的开发流程——项目专属 dev-guide 的文档版
│   └── 设计模式.md               # 项目中使用的设计模式总结——可选
│
├── 03-Database/                  # 🗄️ 数据库设计
│   ├── 数据库设计.md             # ER 图 + 表结构 + 索引汇总
│   └── 数据字典.md               # 字段级详细说明
│
├── 04-API/                       # 🔌 API 契约
│   └── <接口契约>.md             # 内部接口契约或 OpenAPI 链接
│
├── 05-ADR/                       # 📝 架构决策记录
│   └── <序号>-<决策标题>.md      # 每条决策一个文件，Grid code-review 产出
│
├── 06-DevOps/                    # 🚀 运维部署
│   ├── CLI使用说明.md            # CLI 命令完整参考——如适用
│   ├── 部署指南.md               # 环境搭建、安装、启动
│   ├── 配置参考.md               # 配置文件全量参数说明——如适用
│   └── 故障排查.md               # FAQ / 常见问题
│
├── 07-MVP/                       # 🎯 开发实施
│   ├── 实施概览.md               # 项目目标 + 功能清单 + 技术选型回顾
│   ├── 实现日志.md               # 各里程碑实现记录
│   └── 开发计划-<功能名>.md      # Grid to-issues 产出
│
└── 08-Testing/                   # 🧪 测试文档
    ├── 测试手册.md               # 全量测试用例
    └── 测试记录.md               # 测试执行记录归档
```

## 每目录撰写规范

### README.md —— 文档导航索引

```markdown
# 📖 文档索引

## 快速导航

| 我想... | 去看... |
|---------|--------|
| 了解系统功能 | 01-Requirements/ |
| 理解架构 | 02-Architecture/系统架构.md |
| 搭建环境 | 06-DevOps/部署指南.md |
| 查数据库 | 03-Database/数据库设计.md |
...
```

### CHANGELOG.md —— 版本变更记录

格式遵守 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) + [语义化版本](https://semver.org/spec/v2.0.0.html)，写入校验见 `changelog-guide`。

```markdown
# CHANGELOG

本格式基于 Keep a Changelog，并遵守语义化版本控制（SemVer）。

## [Unreleased]

### Added
- xxx

## [0.1.0] - YYYY-MM-DD

### Added
- xxx

### Fixed
- xxx
```

要点：
- 版本标题格式 `## [版本号] - YYYY-MM-DD`（ISO 8601），`v` 前缀是 git 标签惯例、非版本号本体
- 最上方保留 `[Unreleased]` 区块——发布时整体搬入新版本标题
- 变动类型用六种标准：`Added` / `Changed` / `Deprecated` / `Removed` / `Fixed` / `Security`

### 01-Requirements —— 需求文档

每个功能一个 PRD 文件。Grid `to-prd` 阶段自动写入。格式见 `references/templates/01-Requirements/PRD.md`。

### 02-Architecture —— 架构文档

- **系统架构.md**：模块职责、技术栈、目录结构、核心数据流、关键设计原则
- **开发指南.md**：本地新增功能的步骤级流程——对应 `tdx-dev-guide` 或 `nest-generate` 的文档版
- **时序图.md / 设计模式.md**：按需产出，非必需

### 03-Database —— 数据库设计

- **数据库设计.md**：Mermaid ER 图、表结构总览、设计要点、索引汇总
- **数据字典.md**：字段级说明——每表的字段名、类型、含义、约束

### 05-ADR —— 架构决策记录

```markdown
# ADR: <决策标题>

- 状态: 通过 / 搁置 / 废弃
- 日期: YYYY-MM-DD
- 决策: 我们选择 X 而非 Y
- 理由: 因为...
- 代价: 但代价是...
- 替代方案: 考虑了 A、B、C，选择 X 的原因
```

Grid `code-review` 审查通过后自动写入。

### 06-DevOps —— 运维部署

**CLI使用说明.md**（如适用）：

```markdown
- 全局选项
- 命令组参考（每个命令：参数/返回值/示例）
- 典型操作场景
```

**故障排查.md**：

```markdown
## 分类 FAQ
### 安装与环境
| 问题 | 解决方案 |
### 运行时
| 问题 | 解决方案 |
```

### 07-MVP —— 开发实施

Grid `to-issues` 产出的开发计划写入此处。实施概览和实现日志由 `project-review` 更新。

### 08-Testing —— 测试文档

对应 `tdx-test-spec` / `ta-test-spec` 的文档版——具体的测试用例列表和执行记录。

## Grid 阶段 → 文档产出映射

| Grid 阶段 | 产出物 | 写入目标 | 触发条件 |
|-----------|--------|---------|---------|
| to-prd | PRD | `01-Requirements/PRD-<功能名>.md` | PRD 审批通过 |
| to-issues | 开发计划 | `07-MVP/开发计划-<功能名>.md` | 拆解完成 |
| 编码→code-review | 审查报告 → ADR | `05-ADR/<序号>-<标题>.md` | 审查通过 |
| wayfinder | ticket 地图 | `07-MVP/` 或 `06-DevOps/` | DevOps 任务 |
| doc-sync | 同步更新 | CHANGELOG + 受影响文档 | 代码变更后 |
| project-review | 里程碑总结 | `07-MVP/实现日志.md` | 功能完成/阶段切换 |

## 项目初始化——创建文档骨架

当 Grid 启动新项目时，执行以下步骤：

### 1. 创建 docs/ 骨架

从 `references/templates/` 复制初始文件到项目 `docs/` 下：
- `README.md` —— 空白导航索引
- `CHANGELOG.md` —— 空白变更记录
- 各子目录的占位 `.gitkeep`（不含具体内容的文档待后续阶段填充）

### 2. 填充已有信息

如果项目已有代码/数据库/配置：
- `02-Architecture/系统架构.md` ← 从代码目录结构生成初始版本
- `03-Database/数据库设计.md` ← 从 schema 文件生成 ER 图和字段表
- `06-DevOps/部署指南.md` ← 从 pyproject.toml / package.json / AGENTS.md 提取环境配置

### 3. 写入 README.md 快速导航

生成导航表，链接到实际存在的文档文件。

## Agent 查阅流程

当 Agent 在编码过程中遇到不确定时：
1. 先查 `docs/README.md` 快速导航——定位到相关文档
2. 读取该文档——获取架构约束、API 契约、数据库结构等上下文
3. 如果 docs 中无答案 → 查看项目 skill（`tdx-quant-docs` 等）的 reference 文件
4. 如果仍无答案 → 启动 `grilling` 拷问用户

## 外部参考

- `references/templates/` — 8 个子目录的空白模板文件——项目初始化时复制
- `references/instances/tdx.md` — TDX 项目实例化配置：实际文件状态 + 独有差异 + 初始化推荐
- `references/instances/trading-assistant.md` — trading-assistant 项目实例化配置
