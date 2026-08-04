---
name: git-branch-plan
description: 拆解任务后规划分支命名和创建策略。Use when the user has completed breaking down a feature into tasks (after PRD or issue breakdown), and is ready to start coding.
---

# git-branch-plan

在开始编码前规划分支——从哪个基线创建、命名规范、何时合并。

## Leading Words

| 术语 | 定义 |
|------|------|
| **短命分支** | 一个分支只做一个具体功能，做完立即合并删除 |
| **从最新 main 拉出** | 始终从最新的 main 分支创建，避免基于过时代码 |
| **短横线命名** | 分支名用小写短横线，描述具体功能（feature/etf-data-fetcher） |

## 步骤

### 1. 检查基线

确认当前 main 是最新的——提醒用户 `git pull origin main`。

- 完成标准：main 已同步到远程最新

### 2. 确定分支类型与命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 新功能 | `feature/` | `feature/etf-data-fetcher` |
| Bug 修复 | `fix/` | `fix/kline-date-parse` |
| 重构 | `refactor/` | `refactor/cleaner-extract` |
| 紧急修复 | `hotfix/` | `hotfix/production-crash` |
| 文档 | `docs/` | `docs/api-guide-update` |

分支名使用**小写短横线**，描述具体功能而非笼统词语。

- 完成标准：分支名已确定

### 3. 建议创建命令

向用户展示：

> 建议创建分支：`git checkout -b feature/xxx`
> 确认后执行。

- 完成标准：用户确认分支创建

## 边界条件

- 如果是紧急 hotfix → 提示"从 main 拉出而非当前开发分支"
- 如果已有同名前缀分支 → 提示冲突，建议新命名
