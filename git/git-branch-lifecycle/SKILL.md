---
name: git-branch-lifecycle
description: 长周期分支的管理策略——定期同步、冲突预防、合并策略选择。Use when a feature branch has been alive for more than 2 days, or when preparing to merge a long-lived branch.
---

# git-branch-lifecycle

管理超过 2 天的长周期功能分支。短命分支（≤2 天）不需要本 skill。

## Leading Words

| 术语 | 定义 |
|------|------|
| **定期同步** | 每隔一段时间将 main 的更新拉入功能分支，提前化解冲突 |
| **冲突窗口** | 分支从 main 分叉后，随着 main 提交增多，冲突概率递增的时间窗口 |
| **瘦分支** | 分支只包含与当前功能直接相关的改动 |

## 管理原则

| 原则 | 说明 |
|------|------|
| 保持分支短命 | 一个分支 ≤ 一周，超长的功能应拆为多个短分支 |
| 定期同步 main | 每 1-2 天执行 `git pull origin main`，在功能分支上提前解决冲突 |
| 分支要瘦 | 只包含与当前功能直接相关的改动，不"顺便"修其他东西 |
| 合并前自检 | lint + 测试通过后才能合并到 main |

## 合并策略

| 场景 | 命令 | 效果 |
|------|------|------|
| 日常功能合并 | `git merge --no-ff feature/xxx` | 保留分支轨迹，清晰功能边界 |
| 小改动/单 commit | `git merge feature/xxx` | 线性历史，简洁 |

## 生命周期收尾

功能开发完毕 → 合并到 main → 删除本地分支 `git branch -d feature/xxx` → 删除远程分支 `git push origin --delete feature/xxx`
