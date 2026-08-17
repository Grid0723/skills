---
name: changelog-guide
description: 校验 CHANGELOG 写入符合 Keep a Changelog + 语义化版本（SemVer）标准——变动类型、Unreleased 区块、版本号递增、ISO 8601 日期。Use always when creating or editing CHANGELOG files——runs as a background validator.
---

# changelog-guide

守卫 CHANGELOG 的格式边界。所有 CHANGELOG 写入（创建、追加、发布版本）在通过校验前不得落盘。

## Leading Words

| 术语 | 定义 |
|------|------|
| **变动类型** | Keep a Changelog 规定的六种变更分类——Added/Changed/Deprecated/Removed/Fixed/Security |
| **Unreleased 区块** | 文档最上方预留的待发布变更区——降低维护成本，发布时整体搬运 |
| **版本号递增** | SemVer 规则——不兼容→主版本、新功能→次版本、修复→修订号 |
| **YANKED 版本** | 因重大 bug 或安全问题被撤下的版本——必须醒目标注 |

## 标准 CHANGELOG 结构

```markdown
# CHANGELOG

本格式基于 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)，
并遵守[语义化版本控制](https://semver.org/spec/v2.0.0.html)。

## [Unreleased]

### Added
- xxx

## [1.1.0] - 2026-08-17

### Added
- xxx

### Fixed
- xxx

## [1.0.0] - 2026-06-01 [YANKED]
```

## 校验清单

创建或编辑 CHANGELOG 时，逐项检查：

- [ ] 文档头声明"格式基于 Keep a Changelog + 遵守 SemVer"？
- [ ] 最上方保留 `[Unreleased]` 区块（未发布变更先在此记录）？
- [ ] 每个版本标题格式为 `## [版本号] - YYYY-MM-DD`（ISO 8601）？
- [ ] 变动条目按六种类型分组，没有自创类型？
- [ ] 新版本在前、旧版本在后（倒序）？
- [ ] 版本号递增符合 SemVer（发布时 Unreleased 内容整体搬入新版本标题）？
- [ ] 被撤下的版本标注了 `[YANKED]`？

## 六种变动类型

| 类型 | 含义 |
|------|------|
| `Added` | 新添加的功能 |
| `Changed` | 对现有功能的变更 |
| `Deprecated` | 已经不建议使用、即将移除的功能 |
| `Removed` | 已经移除的功能 |
| `Fixed` | 对 bug 的修复 |
| `Security` | 对安全性的改进 |

## 版本号递增校验

与 `git-commit-guide` 的提交类型联动，判断下一个版本号：

| 提交类型 | SemVer 递增 |
|---------|-------------|
| `feat` / `feat!: ` | 次版本号 Y（`feat!` 或含 `BREAKING CHANGE` → 主版本号 X） |
| `fix` | 修订号 Z |
| `refactor` / `docs` / `chore` / `style` / `test` | 无版本递增（除非累计显著变更） |
| 不兼容 API 修改 | 主版本号 X（即使提交类型是 fix） |

递增示例：`1.9.1 → 1.10.0 → 2.0.0`（禁止前导零）。主版本号为 0 时处于开发期，API 不稳定，每次发行递增次版本号。

## 坏实践检查

写入时禁止以下做法：

- 用 git 日志堆砌当 CHANGELOG——CHANGELOG 是给人读的显著变更，git log 是源码演化记录
- 只记部分变更——不一致的 CHANGELOG 比没有更危险，用户会误信其为事实的唯一来源
- 忽略弃用/移除条目——升级者必须提前知道哪些将不再被支持
- 使用区域日期格式——统一 ISO 8601 的 `YYYY-MM-DD`

## 与相邻 skill 的关系

| skill | 边界 |
|-------|------|
| `doc-architecture` | 提供 CHANGELOG 空白**模板**（初始化时创建）；本 skill 校验**写入内容** |
| `git-commit-guide` | 决定提交类型与消息格式；本 skill 将类型映射为版本号递增 |
| `doc-sync` | 决定**何时**同步 CHANGELOG（代码变更后）；本 skill 校验同步的**内容** |