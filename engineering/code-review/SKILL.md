---
name: code-review
description: 双轴并行代码审查——Standards 审查 + Spec 审查，独立 sub-agent 上下文，报告不合并。Use when a task from the development plan is completed, before merging, or during PR review.
---

# code-review

双轴并行审查。**Standards 审查 agent**（加载项目审查 skill）+ **Spec 审查 agent**（独立上下文）。两份报告不合并、不重排。

## Leading Words

| 术语 | 定义 |
|------|------|
| **双轴并行** | 两个 sub-agent 各自有独立上下文，审查互不污染 |
| **报告不合并** | 两份审查报告独立输出，防止一轴掩盖另一轴的问题 |

## 步骤

### 1. 确定审查范围

确认本次审查的任务范围：
- 读取 `开发计划.md` 中对应的 Task
- 读取对应的 PRD seam 描述
- 完成标准：明确审查的边界

### 2. 启动双轴审查

并行启动两个 sub-agent：

**Standards 审查 agent**（加载项目专属审查 skill）：
- 根据任务类型动态筛选应加载的审查 skill（如 `finance-review`、`api-contract`）
- 检查：代码规范、命名、类型安全、金额计算合规
- 向用户提示建议加载的 skill 列表并等确认

**Spec 审查 agent**（独立上下文）：
- 检查：代码是否实现了 PRD 中定义的 seam
- 检查：是否有遗漏的功能点
- 完成标准：两份报告已产出

### 3. 汇总审查结果

展示两份报告——不合并、不重排。用户看到两份独立结论。

- 通过 → 标记 Task 完成，写入 ADR
- 需修改 → 列出需修改项，回到编码阶段

### 4. 写入 ADR

```markdown
# ADR: <功能名> 审查
- 审查日期: ...
- Standards: 通过/需修改
- Spec: 通过/需修改
- 关键发现: ...
```

- 完成标准：ADR 已写入 `docs/05-ADR/`

## 外部参考

- `references/review-templates.md` — Standards 审查模板（项目审查 skill 加载示例）、Spec 审查模板（seam 逐项验证）、Sub-Agent 分派实现方案、ADR 写入格式
