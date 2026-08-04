---
name: git-guardrails
description: 拦截危险的 Git 命令，防止对仓库造成不可逆破坏。Use always when working in a Git repository——runs as a background guard.
---

# git-guardrails

守卫 Git 仓库的安全边界。所有操作在确认安全前不得执行。

## Leading Words

| 术语 | 定义 |
|------|------|
| **不可逆操作** | 执行后无法通过 git reflog 恢复的命令 |
| **审批门** | 危险操作必须先展示影响范围，用户确认后才能执行 |
| **安全方案优先** | 遇到危险命令时，先提供安全的替代方案，而非直接拒绝 |

## 危险命令清单

以下命令在用户明确确认前**禁止执行**：

| 命令 | 风险 | 替代方案 |
|------|------|---------|
| `git push --force` / `-f` | 覆盖远程历史 | `git push --force-with-lease` |
| `git reset --hard` | 永久丢失未提交改动 | `git stash` |
| `git clean -fd` | 删除所有未跟踪文件 | 先 `git clean -n` 预览 |
| `git rebase`（含 force push） | 改写已推送到远程的提交 | 仅在个人分支上使用 |
| `git commit --amend`（已推送后） | 改写远程历史 | 仅在未推送时使用 |
| `git branch -D` | 强制删除未合并分支 | `git branch -d` 先检查 |
| `rm -rf .git` | 销毁整个仓库历史 | 永远不要 |

## 执行规则

1. 遇到上表中的命令 → **暂停**，展示该命令的影响范围
2. 提供替代的**安全方案**
3. 用户确认 → 执行；用户拒绝 → 放弃
4. 对于不在表中但感觉有风险的操作 → 先解释影响再执行

## 全域自动执行禁令

以下操作**在任何情况下都必须等待用户指令**——不因`危险命令清单`中的"确认"通道而豁免：

- `git add`、`git commit`、`git push`、`git merge`、`git rebase`
- 修改 `.gitignore` 或 `.gitconfig`

> 与上节的关系：上节的命令是"确认后可执行"；本节是"确认也不够，必须用户主动提出"。
