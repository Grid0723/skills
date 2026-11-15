---
name: implement
description: 执行开发计划中的 Task——单任务模式（默认）或阶段批量模式（显式指定 S<n>），驱动 tdd → code-review → commit。Use when the user says "执行 Task"、"开始编码"、"实现 CF-S1-F2-T3"、"跑完 S1".
---

# implement

把 `docs/07-MVP/开发计划.md` 里的 Task 变成代码。**默认单任务**；批量模式必须显式给出阶段号。

## Leading Words

| 术语 | 定义 |
|------|------|
| **Task 原文** | 开发计划中带编号与 `Done when` 的那一行；执行前必须读取，不凭记忆 |
| **Seam** | 可独立测试的系统接缝；写测试前先对齐 |
| **一个 Task 一个 commit** | Task 是提交的最小单位，不攒、不拆 |
| **Ready frontier** | 依赖已满足、可以立即执行的 Task 集合 |

## 入口判定

| 用户输入 | 模式 |
|---|---|
| `CF-S1-F2-T3` 或"执行这个 Task" | 单任务模式 |
| `S1` / "跑完 S1" / "批量执行阶段 S1" | 批量模式（必须显式阶段号） |
| "开始编码" / "继续"（无编号） | 先读计划，列出下一步 Task，等确认后按单任务执行 |

> 批量模式不接受"继续""往下做"这类推断，必须明确 `S<n>`。

## 前置读取

1. `docs/07-MVP/开发计划.md` — 定位 Task 原文、依赖、`Done when`
2. `docs/01-Requirements/PRD-F<nn>-*.md` — 对应功能的接缝与范围
3. `docs/05-ADR/` — 与当前功能相关的决策
4. 当前分支与工作区状态（`git status -sb`）

- 完成标准：Task 原文、依赖、Done when 已确认

## 单任务模式

### 1. 定位与校验

- 找到 Task 编号对应的原文
- 检查前置 Task 是否已完成（`[x]`）
- 检查分支：应为 `feature/<项目码>-S<n>-F<n>`
- 不满足 → 停下说明，不强行执行

- 完成标准：前置条件全部满足

### 2. 确认 seam

与用户对齐本次改动的测试接缝（哪个接口/函数/模块）。不确定 → 先 `grilling`。

- 完成标准：seam 已明确

### 3. 执行 TDD

引用 `tdd`：

1. 写失败测试 → 运行确认红
2. 写最小实现 → 运行确认绿
3. 重构（如需要）

- 完成标准：测试通过，行为符合 `Done when`

### 4. 审查

引用 `code-review`。小改动可只做 Standards 轴，但必须说明省略 Spec 轴的理由。

- 完成标准：审查通过，或问题已修复

### 5. 提交

引用 `git-commit`，一个 Task 一个 commit：

```text
<type>(<Task ID>): <描述>

- 变更点 1
- 变更点 2
```

- 完成标准：commit 已创建，工作区干净

### 6. 回填

- 开发计划中标记 `- [x]`
- 需要时在 `docs/07-MVP/实现日志.md` 追加一行
- 产生决策 → 写 `docs/05-ADR/ADR-<nnn>-<名>.md`

- 完成标准：计划与日志已更新

## 批量模式

### 1. 读取阶段

读取 `S<n>` 下的所有 F 与 T，建立依赖图：

- F 内 Task 默认顺序执行
- F 间有依赖时按依赖排序
- 无依赖的 Task 进入 ready frontier

- 完成标准：执行顺序已列出并展示给用户

### 2. 逐个执行

对 frontier 中的每个 Task：

1. 走单任务模式的 1–6 步
2. 每个 Task 独立 commit
3. 失败 → **立即停止**，报告失败 Task 与原因，不继续后面的 Task

- 完成标准：阶段内所有 Task 完成，或已停止并报告

### 3. 阶段收尾

- 整体跑一次 `code-review`
- 更新 `docs/07-MVP/实施概览.md` 的当前阶段与进度
- 更新 `docs/CHANGELOG.md`（如对外可见）

- 完成标准：阶段状态已更新

## 边界

- 不跳过 `Done when`
- 不把两个 Task 合并成一个 commit
- 不把一 Task 拆成多个 commit（除非用户明确要求）
- 批量模式必须显式 `S<n>`
- 项目文件默认只读约束仍生效：必须有用户明确任务指令才能执行

## 外部参考

- `references/execution-examples.md` — 单任务与批量执行示例、失败停止示例

## Gotchas

- 凭记忆执行 Task → 必须先读开发计划原文，编号与 Done when 以文件为准
- 批量模式跳过失败 Task 继续跑 → 失败即停，否则后续 Task 建立在坏基础上
- 一个 Task 攒了多个 commit → 合并为一个，否则回滚粒度失效
- 未确认 seam 就写测试 → 测试写在错误层级，返工成本更高
