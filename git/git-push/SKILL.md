---
name: git-push
description: Git 推送——推前检查、领先/落后判定、失败处理与版本 tag 推送。Use when the user says "推送"、"push"、"推送失败"、"打 tag".
---

# git-push

定义推送的**推前检查**与**失败处理**。危险命令由 `git-guardrails` 拦截；提交由 `git-commit` 管辖。

## Leading Words

| 术语 | 定义 |
|------|------|
| **推前自检门** | 远程存在、工作区干净、分支状态明确 |
| **领先/落后检测** | ahead 有未推 commit；behind 远程有新 commit |
| **干净推送** | 只推已提交内容，不携带未提交改动 |

## 推前检查

### 1. 确认远程存在

`git remote -v` 为空 → 纯本地仓库，不 push，提示用户或建议添加远程。

### 2. 确认工作区干净

`git status` 有未提交改动 → 先按 `git-commit` 提交，或提示用户处理。

### 3. 确认分支状态

`git status -sb` 判断与 origin 的对比：

| 状态 | 动作 |
|------|------|
| ahead | `git log origin/<branch>..HEAD --oneline` 确认待推 commit |
| behind | 先 `git pull --rebase` 再推 |
| 分叉 | `git pull --rebase`，解决冲突后再推 |

### 4. 展示并确认后推送

展示将执行的命令与影响范围（推送内容、目标分支），**用户确认后**执行：

```bash
git push                    # 已有跟踪分支
git push -u origin <branch> # 首次推送，建立跟踪
```

- 完成标准：推送成功，本地与远程同步

## 推送失败处理

| 失败 | 原因 | 处理 |
|---|---|---|
| `non-fast-forward` / rejected | 远程有新 commit | `git pull --rebase` 后重推 |
| `Permission denied` | SSH key 缺失 | `ssh -T git@github.com` 测试 |
| 连接超时 | 网络/代理 | 检查代理；考虑 `ssh.github.com:443` |

## 发布 tag 推送

版本号本体不带 `v`（`1.2.0`），tag 名带 `v` 是惯例：

```bash
git tag v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
git push --tags   # 慎用，确认无脏 tag
```

发布流程：`git-commit` 提交 → `git-commit` 的 CHANGELOG 模式更新 → 打 tag 推送。tag 名与 CHANGELOG 版本号必须一致（`v1.2.0` ↔ `[1.2.0]`）。

## 边界

- 用户要求 `--force` → 移交 `git-guardrails`，只走审批门
- submodule 有独立 `.git`：push 必须在 submodule 目录内执行，主仓库只提交 submodule 指针
- 无远程 → 不 push

## Gotchas

- 工作区有未提交改动就 push → 先提交或明确告知用户"不会推这些内容"
- behind 状态直接 push → 必然 rejected，先 `pull --rebase`
- 打了 tag 却没推 → `git push` 不会自动推 tag，必须显式 `push origin vX.Y.Z`
