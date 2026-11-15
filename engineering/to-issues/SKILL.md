---
name: to-issues
description: 将 PRD 拆解为 tracer bullet 垂直切片——每个切片贯穿所有层，可独立演示和验证。Use when the user has an approved PRD and needs it broken down into implementable tasks.
---

# to-issues

PRD → 可独立验证的任务清单，写入 `开发计划.md`。采用 **tracer bullet** 模式。

## Leading Words

| 术语 | 定义 |
|------|------|
| **Tracer bullet（垂直切片）** | 每个任务贯穿数据获取→清洗→存储→测试全层，可独立演示 |
| **一次一个** | 每个任务互不依赖，可独立认领和验证 |

## 步骤

### 1. 读取 PRD

读取 `docs/01-Requirements/PRD-xxx.md`，提取接缝列表。

- 完成标准：理解 PRD 中的所有 seam

### 2. 拆解为垂直切片

每个切片：
- 贯穿所有层（数据→业务→存储→测试）
- 可独立演示一个完整功能
- 无硬性依赖关系（A 不阻塞 B）
- 完成标准：所有 seam 已映射到独立任务

### 3. 生成开发计划

写入 `docs/07-MVP/开发计划.md`，按 S → F → T 组织：

```markdown
## S1 · <阶段名>

### F1 · <功能名>
- [ ] CF-S1-F1-T1 <描述> — Done when: <可验证判据>
- [ ] CF-S1-F1-T2 <描述> — Done when: <可验证判据>
```

编号规则（详见 `doc-architecture`）：

```text
<项目码>-S<阶段>-F<功能>-T<任务>
```

- 项目码 2–4 位大写，固定不变
- 阶段号整数、只增不减（禁止 `S1.5`、`R1`）
- 功能与 PRD 一一对应（`F2` ↔ `PRD-F02-*.md`）
- **一个 Task = 一个 commit**；Task 内不再拆子任务
- 拆解粒度：一个 Task 可在 1–2 小时内完成、可独立演示

- 完成标准：每个 Task 有编号与 `Done when`
- 极简：任务描述 30 秒可读完

### 4. 触发分支规划

拆解完成后，提示调用 `git-branch`：

> 建议创建分支 `feature/<项目码>-S<n>-F<n>`，是否执行？

一个功能一个分支；功能内多个 Task 依次提交，功能完成再合并。

- 完成标准：用户做出分支决策

## 外部参考

- `references/tracer-bullet-examples.md` — 完整拆解案例：ETF 获取器（5 个 task）、Bug 修复（3 个 task）、Tracer Bullet vs 水平分层对比、任务验收标准
