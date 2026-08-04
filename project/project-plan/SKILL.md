---
name: project-plan
description: 按功能模块分组创建项目任务清单。Use after project-init to lay out the feature modules and their tasks, or when updating the project scope.
---

# project-plan

创建按功能模块分组的任务清单，写入 `项目计划.md`。

## Leading Words

| 术语 | 定义 |
|------|------|
| **功能模块** | 任务按功能分组而非按时间线，每个模块独立可验证 |
| **#项目/<名> 标签归属** | 任务用 `#项目/<名>` 标签归属到具体项目 |

## 步骤

### 1. 确认项目范围

读取项目总览，与用户确认功能范围。

- 完成标准：功能模块列表已确认

### 2. 生成任务清单

在 `20_项目/<项目名>/` 下创建 `项目计划.md`：

```markdown
## 项目计划: <项目名>

### 模块 A
- [ ] 任务描述 #项目/<项目名>
- [ ] 任务描述 #项目/<项目名>

### 模块 B
- [ ] 任务描述 #项目/<项目名>
```

- 每个任务使用 `#项目/<项目名>` 标签归属
- 任务粒度：可在 1-2 个 session 内完成

- 完成标准：计划文档已创建

## 外部参考

- `references/plan-template.md` — 完整项目计划示例、任务粒度判断标准、模块分组原则
