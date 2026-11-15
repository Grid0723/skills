# CHANGELOG

本格式基于 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)，并遵守[语义化版本控制](https://semver.org/spec/v2.0.0.html)。

本文件记录 Grid0723/skills 技能集的对外发布变更。内部部署与 Vault 文档同步细节见 Vault 内 `Grid/docs/CHANGELOG.md`。

## [Unreleased]

### Added

- **`knowledge/vault-lint`** — 笔记库体检：frontmatter 完整性、状态机合规、标签格式、重复文件、时效；只读报告 + dry-run 修复

## [2.2.1] - 2026-11-15

### Added

- **`engineering/diagnosing-bugs`** — 难 bug 与性能回归的诊断循环：红色反馈环 → mutation diff 验真 → 最小化 → 假设 → 埋点 → 修复 + 回归
- **`grid`** — Bug 修复路径接入该 skill：难 bug 先建红色反馈环，再交 `implement` 提交

### Changed

- **README / 使用手册 / engineering/README / skills.sh.json**：同步 46 个 skill、17 个全局、engineering 9 个

## [2.2.0] - 2026-11-15

### Added

- **`engineering/implement`** — 执行开发计划中的 Task：单任务模式（默认）或阶段批量模式（显式 `S<n>`）；读原文 → 确认 seam → tdd → code-review → 一个 Task 一个 commit；批量失败即停

### Changed

- **`doc-architecture` 重写为实际 8 目录模板**：固定入口文件（架构总览/实施概览/开发计划）、07-MVP 计划格式、ADR 统一编号、PRD 命名规则；移除与 Obsidian 混用的 frontmatter
- **任务编号体系统一**：`<项目码>-S<阶段>-F<功能>-T<任务>`，阶段号整数、功能与 PRD 一一对应、**一个 Task = 一个 commit**；ADR 独立为 `ADR-<3 位>`
- **`to-issues`**：按 S → F → T 生成 `07-MVP/开发计划.md`，每个 Task 带 `Done when`
- **`to-prd`**：文件名改为 `PRD-F<nn>-<功能名>.md`
- **`grid`**：拆 Issue 阶段写入 `docs/07-MVP/开发计划.md`，分支命名改为 `feature/<项目码>-S<n>-F<n>`
- **README / 使用手册 / skills.sh.json**：同步 45 个 skill、16 个全局
- **`evals/check-structure.ps1`**：references 检查放行 `templates` 与 `instances` 二级目录

## [2.1.0] - 2026-11-15

### Changed

- **git 域按工作单元合并（6 → 4）**：`git-commit-guide` + `changelog-guide` → `git-commit`；`git-branch-plan` + `git-branch-lifecycle` → `git-branch`；`git-push-guide` → `git-push`（重命名）；`git-guardrails` 保持独立
- **project 域按工作单元合并（5 → 2）**：`project-init` + `project-plan` + `project-archive` → `project-lifecycle`；`project-review` + `project-links` → `project-maintain`
- **合并后的 skill 自包含**：吸收原 OpenCode command 的入口步骤（提交/分支/推送/项目流程），用户无需自建命令
- **README / 使用手册 / skills.sh.json**：同步 44 个 skill、15 个全局、18 个知识库专属
- **升级注意**：本版移除 10 个旧 skill ID，虽按 2.1.0 发布，实质为不兼容变更——升级前须对照下方迁移映射更新引用

### Removed

- 移除 `git-commit-guide`、`changelog-guide`、`git-branch-plan`、`git-branch-lifecycle`、`git-push-guide`
- 移除 `project-init`、`project-plan`、`project-review`、`project-links`、`project-archive`

迁移映射（旧 → 新）：

| 旧名 | 新名 | 对应模式 |
|---|---|---|
| `git-commit-guide` | `git-commit` | 提交模式 |
| `changelog-guide` | `git-commit` | CHANGELOG 模式 |
| `git-branch-plan` | `git-branch` | 创建模式 |
| `git-branch-lifecycle` | `git-branch` | 生命周期模式 |
| `git-push-guide` | `git-push` | 推送模式 |
| `project-init` | `project-lifecycle` | 启动模式 |
| `project-plan` | `project-lifecycle` | 计划模式 |
| `project-archive` | `project-lifecycle` | 归档模式 |
| `project-review` | `project-maintain` | 回顾模式 |
| `project-links` | `project-maintain` | 链接模式 |

## [2.0.0] - 2026-11-15

### Added

- **`engineering/setup-grid`** — 部署一致性检查：源仓库 vs 运行副本 diff、版本号、skill 数量、AGENTS.md 注册表与权限配置；只读报告，不自动改
- **`engineering/retro`** — 会话后复盘：把失败模式写成对应 SKILL.md 的 `## Gotchas`，并建议 SemVer 递增；只改 Gotchas，不改正文
- **`evals/check-structure.ps1`** — Tier 1 结构检查：frontmatter、行数 ≤500、references 一层、Gotchas、编排器可见性
- **`evals/cases.md`** — 12 条 Tier 3 回归用例与记录模板

### Changed

- **编排器触发方式**：`fabric` / `grid` / `learn` 的 description 重写为「做什么 + 何时用 + 负向边界 + 触发词」，改由 description 触发词自动加载
- **fabric**：新增「入口判定」与「提交信息模板」；归位阶段状态改为 `已归位`，提炼完成标 `已提炼`
- **capture / organize / distill**：新增「前置与后继」声明；capture 补齐「想法分流」条目（此前仅存在于 Vault 运行副本）；organize 状态由 `已消化` 改为 `已归位`
- **`engineering/grid`**：路由表新增「轻量改动」类型——单文件、≤50 行、不改公共 API/数据模型/依赖且已有测试覆盖时直接 `tdd` → `code-review`；跳过 PRD 与拆 Issue 须说明判定依据
- **八个 skill 补 `## Gotchas`**：`grid` / `code-review` / `capture` / `connect` / `distill` / `fabric` / `organize` / `learn` 各补 4 条已知失败模式
- **README / Grid Skills 使用手册**：同步编排器可见性与排障说明（不再声称"模型不会自动调用"）；计数更新为 49 个 skill、17 个全局、34 个 reference

### Removed

- **编排器 `disable-model-invocation`**：`fabric` / `grid` / `learn` 移除该配置，改为对模型可见、由 description 触发词自动加载；原「仅由对话语义触发、模型不会自动调用」的行为不再适用

### Fixed

- **`engineering/grid` / `engineering/code-review`**：移除对不存在的 `karpathy-guidelines` 的引用——该 skill 从未安装，编排器全局约束与审查模板此前指向无法加载的 skill

## [1.0.8] - 2026-08-23

### Changed

- **`README.md`** — 叙事升级「双脊椎 → 三线编排器」：Grid/Fabric/Learn 三条工作流（含 Learn 与 Fabric 流水线接力说明）、功能域 8→9、加载层级全局 14→15/知识库 16→21、Learn 路由决策 mermaid 图、FAQ 与文档导航同步（42→47 个 skill）

## [1.0.7] - 2026-08-23

### Added

- **`learning/learn`** — Learn 编排器（第 43 个 skill，`disable-model-invocation: true`）：陌生领域学习总编排器——建图→深挖→验证→更新地图→收获，交接 Fabric。管理 Global→Local→Global 循环
- **`learning/map`** — 建图（Global）：采集→提取→聚合→标注语义关系（十类）生成领域地图→聚焦输出深挖队列
- **`learning/dig`** — 深挖（Local）：按队列逐个概念定向搜集学习，五问解答，形成关系命题
- **`learning/verify`** — 验证（质量控制）：六项交叉核查（权威来源/冲突检测/事实观点区分/定义一致性/证据检查/过度概括检查），不通过打回 dig 重挖
- **`learning/harvest`** — 收获（交接）：把领域地图与概念理解转为可沉淀笔记，写入 `00_收集箱` 交接 Fabric（第 47 个 skill）

### Changed

- **`README.md`** — 三层架构 mermaid 增加 Learn 编排器（知识库专属层 16→21 个）、功能域表/分类矩阵新增 learning 域、协作链路新增「陌生领域学习」链路（42→47 个 skill）
- **`skills.sh.json`** — 新增「Learn 脊椎」分组（learn/map/dig/verify/harvest）
- **`learning/learn`** — 入口判定加 `grilling` 分支：意图模糊（领域名/目标不明确）时先一问一答具体化领域名、学习深度、范围边界，再进入建图；边界条件同步补充

### 说明

- 方法论与设计文档：Vault `docs/领域地图式学习.md`、Vault `Grid/docs/Learn编排器设计.md`
- 部署待执行：`npx skills add Grid0723/skills` 后 learn 域进入知识库 `.agents/skills/`

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