---
name: git-push-guide
description: 通用 Git 推送原则——push 时机、推前检查、失败处理。Use when the user is about to push, asks about pushing code, or a push fails or is rejected.
---

# git-push-guide

定义推送的**推前检查**和**失败处理**。危险命令由 `git-guardrails` 拦截，提交时机由 `git-commit-guide` 管辖，本 skill 只覆盖推送动作本身。

## Leading Words

| 术语 | 定义 |
|------|------|
| **推前自检门** | push 前必须通过的检查——远程存在、工作区干净、分支状态明确 |
| **领先/落后检测** | 与 origin 对比：ahead 本地有未推 commit，behind 远程有新 commit |
| **干净推送** | 只推已提交的内容，不携带未提交改动 |

## 推前检查

### 1. 确认远程存在

`git remote -v` 为空 → 纯本地仓库，不 push，提示用户或建议添加远程。

- 完成标准：远程地址已确认

### 2. 确认工作区干净

`git status` 有未提交改动 → 先按 `git-commit-guide` 提交，或提示用户。

- 完成标准：无未提交改动

### 3. 确认分支状态

`git status -sb` 判断与 origin 的对比：

| 状态 | 动作 |
|------|------|
| ahead（仅领先） | `git log origin/<branch>..HEAD --oneline` 确认待推 commit |
| behind（仅落后） | 先 `git pull --rebase` 再推 |
| 分叉（ahead+behind） | `git pull --rebase`，解决冲突后再推 |

- 完成标准：分支状态明确，可安全推送

### 4. 推送

```bash
git push                              # 已有跟踪分支
git push -u origin <branch>           # 首次推送，建立跟踪
```

- 完成标准：推送成功，本地与远程同步

## 推送失败处理

| 失败 | 原因 | 处理 |
|------|------|------|
| `non-fast-forward` / rejected | 远程有新 commit | `git pull --rebase` 后重推 |
| `Permission denied` | SSH key 缺失 | `ssh -T git@github.com` 测试连通性 |
| 连接超时 | 网络/代理问题 | 检查代理；考虑走 `ssh.github.com:443` |

## 发布版本 tag 推送

版本发布时，SemVer 版本号本体不带 `v`（`1.2.0`），git 标签名带 `v` 前缀是惯例：

```bash
git tag v1.2.0 -m "Release version 1.2.0"   # 标签名 v1.2.0，版本号 1.2.0
git push origin v1.2.0                       # 只推该 tag
git push --tags                              # 推送全部本地 tag（慎用，确认无脏 tag）
```

- 发布流程：按 `git-commit-guide` 提交 → 按 `changelog-guide` 更新 CHANGELOG → 打 tag 推送
- tag 名与 CHANGELOG 版本号必须一致（`v1.2.0` ↔ `[1.2.0]`）

## 边界条件

- 用户要求 `--force` → 移交 `git-guardrails`，只走审批门
- submodule 有独立 `.git`：push 必须在 submodule 目录内执行，主仓库只提交 submodule 指针
- 无远程的仓库 → 不 push
