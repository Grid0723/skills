# CHANGELOG

本格式基于 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)，并遵守[语义化版本控制](https://semver.org/spec/v2.0.0.html)。

本文件记录 Grid0723/skills 技能集的对外发布变更。内部部署与 Vault 文档同步细节见 Vault 内 `Grid/docs/CHANGELOG.md`。

## [Unreleased]

## [1.0.6] - 2026-08-18

### Added

- **`engineering/grid`** — 路由表新增「项目立项（已有项目计划）」类型：检测到 Fabric `project-init`/`project-plan` 产物（`项目计划.md`/`总览.md`）时，判定为完整管道（拷问→PRD→拆Issue→编码），**禁止跳过**拷问/PRD/拆Issue；拷问阶段注明已有计划时仍须完整 grilling（计划仅作输入素材）
- **`project/project-plan`** — 新增「进入开发衔接」说明：`项目计划.md` 是项目管理维度任务清单，≠ PRD/开发计划，正式编码须在代码仓库走 Grid 完整流程

### Changed

- **`docs/Grid Skills 使用手册.md`** — §二 路由决策 mermaid 图与阶段表补充「项目立项（已有项目计划）」分支与禁止跳过说明

## [1.0.5] - 2026-08-17

### Added

- **`git/changelog-guide`** — CHANGELOG 格式校验守卫：六种变动类型、Unreleased 区块、SemVer 版本递增、ISO 8601 日期，全程自动背景校验（第 42 个 skill）

### Changed

- **`git/git-commit-guide`** — 补「提交类型 → 版本号递增」映射（feat→次版本、fix→修订号、`!`/BREAKING CHANGE→主版本）；自检门加 BREAKING 标注与 CHANGELOG 同步检查
- **`shared/doc-architecture`** — CHANGELOG 模板与撰写规范对齐 Keep a Changelog 标准：六种变动类型、Unreleased 区块、SemVer 声明
- **`git/git-push-guide`** — 补发布版本 tag 推送指引（`git tag v1.2.0` ↔ CHANGELOG `[1.2.0]` 一致性）

## [1.0.4] - 2026-08-16

### Added

- **`git/git-push-guide`** — 推送原则：推前自检门、领先/落后检测、失败处理（non-fast-forward / SSH 认证 / 连接超时）（第 41 个 skill）

### Changed

- 登记同步：`git/README.md`、`skills.sh.json` "Git 工程"组、`README.md` 分类矩阵（40→41、git(4)→git(5)）、`docs/Grid Skills 使用手册.md` §4.2 条目

## [1.0.3] - 2026-08-15

### Changed

- **`docs/Grid Skills 使用手册.md`** — 使用手册副本收录进 skills 仓库（GitHub 零断链）；修正 tdx-quant-docs 参考目录数、to-issues 产出路径与任务格式、笔误
- **`README.md`** 二轮重写 — 方法论沉淀叙事（为什么做→从哪来→能做什么→如何正确使用），含三层架构 mermaid 图、8 域分类矩阵、路由决策图
- 文档导航仅列仓库内文档，修正 reference 文件数（16→22）等出入

## [1.0.1] - 2026-07-28

### Added

- `shared/doc-architecture/references/instances/tdx.md`、`trading-assistant.md` — 项目文档实例化配置
- `writing/writing-shape/references/shape-examples.md`、`edit-article/references/edit-examples.md` — 塑形示例与编辑错误
- `project/project-plan/references/plan-template.md`、`project-review/references/review-template.md`、`project-archive/references/archive-checklist.md`

### Changed

- **`shared/writing-great-skills`** — 三处理论补充：寻找折叠机会方法论、共置 vs 复制、No-Op 逐句测试
- 极简化 `project-links`（33→15 行）、`project-archive`（42→29 行）、`edit-article`（50→28 行）
- 14 个 SKILL.md 清理 frontmatter，统一为 `name` + `description`

## [1.0.0] - 2026-07-15

### Added

- **设计文档（7 份）** — 双脊椎体系设计、Grid/Fabric 编排器设计、物理布局设计、writing-great-skills 元规范与词汇表、Grid 与 Matt 对照表
- **全局共享 primitive（4 个）** — `writing-great-skills`、`grilling`、`tdd`、`doc-architecture`
- **Git 工程工具（4 个）** — `git-guardrails`、`git-commit-guide`、`git-branch-plan`、`git-branch-lifecycle`
- **Engineering — Grid 脊椎内核（5 个）** — `grid`、`to-prd`、`to-issues`、`code-review`、`wayfinder`
- **Knowledge — Fabric 脊椎内核（7 个）** — `fabric`、`capture`、`classify`、`organize`、`distill`、`express`、`connect`
- **Writing — 写作体系（4 个）** — `writing-fragments`、`writing-beats`、`writing-shape`、`edit-article`
- **Project — 项目管理（5 个）** — `project-init`、`project-plan`、`project-review`、`project-links`、`project-archive`
- **项目热插拔（11 个）** — TDX（5 个）+ trading-assistant（6 个）

### Changed

- 从旧 `note-workflow`（171 行单体）拆解为 Fabric 编排器 + 6 knowledge skill + 5 project skill
- 从两份 325 行 `git-operations` 副本拆解为 4 个原子 git skill
- 16 个新建 skill 扩充为含 references/ 参考文件的完整体
- 9 个 README.md 按 Matt Pocock 格式重写（加粗摘要 + 描述 + 链接）