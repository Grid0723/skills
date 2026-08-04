---
name: git-commit-guide
description: 通用 Git 提交原则——提交时机、信息格式、提交前自检。Use when the user is about to commit code, asks about commit messages, or after completing a functional unit of work.
---

# git-commit-guide

定义提交的**时机**和**格式**。项目专属的前缀约定（如 `feat(backend):` / `feat(xxx):`）由各项目 AGENTS.md 声明。

## Leading Words

| 术语 | 定义 |
|------|------|
| **一个 commit 只做一件事** | 单次提交只包含一个逻辑变更，方便 review 和回退 |
| **小步快跑** | 完成一个小功能点立即提交，不攒着 |
| **自检门** | 提交前必须通过检查清单——lint、测试、变更范围 |

## 提交时机

| 时机 | 示例 |
|------|------|
| 完成一个小功能点 | "新增 ETF 数据获取器" |
| 修复一个 bug | "修复 K 线日期格式解析错误" |
| 重构一个模块 | "提取公共清洗逻辑为独立模块" |

## 信息格式（通用部分）

```bash
<type>: <简短描述>

- 变更点 1
- 变更点 2
```

| 类型 | 含义 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `refactor` | 重构（不改变功能） |
| `docs` | 文档 |
| `chore` | 构建/依赖/工具 |
| `test` | 测试 |
| `style` | 格式（不影响逻辑） |

## 项目专属前缀

**前缀格式由各项目 AGENTS.md 声明。** 例如：
- TDX 项目：`feat(xxx):` 单项目格式
- trading_assistant：`feat(backend):` / `feat(frontend):` 前后端区分

选择提交前缀时，优先匹配当前项目的 AGENTS.md 声明；无声明则使用通用类型（feat/fix/refactor 等）。

## 提交前自检

在 `git commit` 之前：
- [ ] 变更是否只属于一个逻辑主题？
- [ ] 提交信息是否描述了"做了什么"和"为什么"？
- [ ] 项目 lint 是否通过？
- [ ] 是否遵守了 `git-guardrails` 的安全约束？
