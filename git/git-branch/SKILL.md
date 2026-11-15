---
name: git-branch
description: Git 分支生命周期——创建策略、命名规范、基线检查、长周期分支同步与合并收尾。Use when the user says "开分支"、"建分支"、"分支怎么命名"、"长分支怎么管"、"合并分支".
---

# git-branch

分支的**创建**与**存活管理**。短命分支（≤2 天）只用创建模式；超过 2 天进入生命周期模式。

## Leading Words

| 术语 | 定义 |
|------|------|
| **短命分支** | 一个分支只做一个具体功能，做完立即合并删除 |
| **从最新 main 拉出** | 始终从最新 main 创建，避免基于过时代码 |
| **短横线命名** | 小写短横线，描述具体功能（`feature/etf-data-fetcher`） |
| **冲突窗口** | 分支从 main 分叉后，冲突概率随 main 提交递增的时间窗口 |

## 入口判定

| 用户请求 | 模式 |
|---|---|
| 开分支 / 建分支 / 分支命名 | 创建模式 |
| 长分支怎么管 / 同步 main / 合并 / 收尾 | 生命周期模式 |

## 创建模式

### 1. 检查基线

确认当前 main 是最新的——提醒 `git pull origin main`。

- 完成标准：main 已同步

### 2. 确定类型与命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 新功能 | `feature/` | `feature/etf-data-fetcher` |
| Bug 修复 | `fix/` | `fix/kline-date-parse` |
| 重构 | `refactor/` | `refactor/cleaner-extract` |
| 紧急修复 | `hotfix/` | `hotfix/production-crash` |
| 文档 | `docs/` | `docs/api-guide-update` |

规则：

- 小写短横线，描述具体功能而非笼统词语
- 若用户提供名称，校验前缀与命名；已有同名前缀分支 → 提示冲突并建议新名
- 紧急 hotfix → 必须从 main 拉出，而非当前开发分支

- 完成标准：分支名已确定且合法

### 3. 建议命令并等待确认

展示建议命令（如 `git checkout -b feature/xxx`），**用户确认后**再执行。

- 完成标准：分支已创建

## 生命周期模式

适用：分支存活超过 2 天，或准备合并。

### 管理原则

| 原则 | 说明 |
|---|---|
| 保持短命 | 一个分支 ≤ 一周，超长功能拆为多个短分支 |
| 定期同步 main | 每 1–2 天 `git pull origin main`，提前解决冲突 |
| 分支要瘦 | 只含当前功能相关改动，不"顺便"修其他东西 |
| 合并前自检 | lint + 测试通过才能合并 |

### 合并策略

| 场景 | 命令 | 效果 |
|---|---|---|
| 日常功能合并 | `git merge --no-ff feature/xxx` | 保留分支轨迹 |
| 小改动/单 commit | `git merge feature/xxx` | 线性历史 |

### 收尾

功能开发完毕 → 合并到 main → 删除本地分支 `git branch -d feature/xxx` → 删除远程分支 `git push origin --delete feature/xxx`。

- 完成标准：分支已合并并清理

## 边界

- 禁止 `push --force` / `-f`（移交 `git-guardrails`）
- 合并冲突的解决流程见 `git-branch` 生命周期模式；跨多个 session 的分支同步用 `wayfinder` 的 ticket 记录进展
- 删除未合并分支前必须确认内容已备份

## Gotchas

- 在旧 main 上直接开分支 → 先 `git pull origin main`，否则后续冲突成倍增加
- hotfix 从功能分支拉出 → 必须从 main 拉出，否则会把未合并改动带进紧急修复
- 长分支只在合并前同步一次 main → 每 1–2 天同步，冲突才会小
