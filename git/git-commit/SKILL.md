---
name: git-commit
description: Git 提交与 CHANGELOG 治理——提交时机、信息格式、提交前自检、破坏性标注，以及 Keep a Changelog + SemVer 格式校验。Use when the user says "提交"、"commit"、"提交信息"、"检查 CHANGELOG".
---

# git-commit

定义提交的**时机、格式与产物校验**。项目专属前缀由各项目 AGENTS.md 声明。

## Leading Words

| 术语 | 定义 |
|------|------|
| **一个 commit 只做一件事** | 单次提交只包含一个逻辑变更，方便 review 和回退 |
| **小步快跑** | 完成一个小功能点立即提交，不攒着 |
| **自检门** | 提交前必须通过检查清单——lint、测试、变更范围 |
| **产物联动** | 提交类型决定 CHANGELOG 版本号递增 |

## 入口判定

| 用户请求 | 模式 |
|---|---|
| 提交 / commit / 拟提交信息 | 提交模式 |
| 检查 CHANGELOG / 版本号 / 发版 | CHANGELOG 模式 |

## 提交模式

### 1. 采集上下文

运行并读取：

```bash
git status
git diff --stat
```

- 完成标准：变更范围已明确

### 2. 单一主题检查

变更是否只属于一个逻辑主题？范围过杂 → **停下，提示用户拆分**，不要强行提交。

- 完成标准：确认单一主题，或已给出拆分建议

### 3. 判断提交类型

| 类型 | 含义 | SemVer |
|------|------|--------|
| `feat` | 新功能 | 次版本号 Y |
| `fix` | Bug 修复 | 修订号 Z |
| `refactor` | 重构（不改功能） | 无 |
| `docs` | 文档 | 无 |
| `chore` | 构建/依赖/工具 | 无 |
| `test` | 测试 | 无 |
| `style` | 格式（不影响逻辑） | 无 |
| `feat!` / 含 `BREAKING CHANGE` | 不兼容修改 | 主版本号 X |

项目专属前缀优先匹配项目 AGENTS.md（如 `feat(backend):`）；无声明则用通用类型。

- 完成标准：类型与前缀已确定

### 4. 破坏性变更标注

含不兼容修改时，提交信息**必须**用 `!` 或 `BREAKING CHANGE:` 标注，并写清影响面。

- 完成标准：破坏性变更已标注或确认不存在

### 5. 拟提交信息并等待确认

格式：

```text
<type>: <简短描述>

- 变更点 1
- 变更点 2
```

展示完整信息（含类型前缀与变更点），**等用户确认**后再执行。

- 完成标准：用户确认

### 6. 执行提交

```bash
git add <精确路径>
git commit
```

功能级变更（feat/fix）需同步 CHANGELOG——切换到 CHANGELOG 模式校验后再提交。

- 完成标准：提交成功，工作区与预期一致

## CHANGELOG 模式

### 标准结构

```markdown
# CHANGELOG

本格式基于 Keep a Changelog，并遵守语义化版本控制。

## [Unreleased]

### Added
- xxx

## [1.1.0] - 2026-08-17

### Fixed
- xxx

## [1.0.0] - 2026-06-01 [YANKED]
```

### 校验清单

- [ ] 文档头声明 Keep a Changelog + SemVer？
- [ ] 最上方保留 `[Unreleased]`？
- [ ] 版本标题为 `## [版本号] - YYYY-MM-DD`（ISO 8601）？
- [ ] 条目按六类分组：Added / Changed / Deprecated / Removed / Fixed / Security？
- [ ] 新版本在前、旧版本在后？
- [ ] 版本号递增符合 SemVer？
- [ ] 被撤下的版本标注 `[YANKED]`？

### 版本号递增

| 提交类型 | 递增 |
|---|---|
| `feat` | 次版本号 Y |
| `fix` | 修订号 Z |
| `feat!` / `BREAKING CHANGE` | 主版本号 X |
| `refactor` / `docs` / `chore` / `style` / `test` | 无（除非累计显著变更） |

递增示例：`1.9.1 → 1.10.0 → 2.0.0`（禁止前导零）。主版本为 0 时属开发期，每次发行递增次版本号。

### 坏实践

- 用 git log 堆砌当 CHANGELOG
- 只记部分变更
- 忽略弃用/移除条目
- 使用区域日期格式

## 边界

- 禁止 `git commit --amend`
- 禁止 `git push`（移交 `git-push`）
- 不擅自修改 `.gitignore` 等配置
- 危险命令由 `git-guardrails` 拦截

## Gotchas

- 用户说"提交"时直接把所有改动 `git add -A` → 先按单一主题检查，范围过杂先拆分
- 破坏性变更没标 `!` → 版本号会错误递增，发布前必须回头改
- 功能级变更提交后才想起 CHANGELOG → 提交前先切 CHANGELOG 模式校验
