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

写入 `开发计划.md`：

```markdown
## 开发计划: <功能名>

- [ ] Task-1: <描述> — 验证: <如何确认完成>
- [ ] Task-2: <描述> — 验证: <如何确认完成>
- [ ] Task-3: <描述> — 验证: <如何确认完成>
```

- 完成标准：每个 Task 有明确的验证点
- 极简：任务描述 30 秒可读完

### 4. 触发分支规划

拆解完成后，提示调用 `git-branch`：
> 建议创建分支 `feature/<功能名>`，是否执行？

- 完成标准：用户做出分支决策

## 外部参考

- `references/tracer-bullet-examples.md` — 完整拆解案例：ETF 获取器（5 个 task）、Bug 修复（3 个 task）、Tracer Bullet vs 水平分层对比、任务验收标准
