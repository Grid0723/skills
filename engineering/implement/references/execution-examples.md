# 执行示例

## 单任务

```text
用户：执行 CF-S1-F2-T3

implement：
1. 读取 07-MVP/开发计划.md，确认原文：
   - [ ] CF-S1-F2-T3 编辑菜单表单接线 — Done when: 表单提交后列表刷新
2. 检查前置：CF-S1-F2-T1/T2 已完成 [x]
3. 检查分支：feature/CF-S1-F2 ✓
4. 确认 seam：菜单表单 → `MenuForm.onSubmit`
5. tdd：先写失败测试 → 实现 → 通过
6. code-review：Standards 轴
7. commit：feat(CF-S1-F2-T3): 编辑菜单表单接线
8. 标记 [x]，实现日志追加一行
```

## 批量（阶段）

```text
用户：跑完 S1

implement：
1. 读取 S1 下所有 F/T，展示执行顺序：
   F1: T1 → T2
   F2: T1 → T2 → T3
2. 依次执行，每个 Task 独立 commit
3. 某 Task 失败 → 停止，报告：
   - 失败 Task：CF-S1-F2-T2
   - 原因：测试红，断言与 PRD 冲突
   - 建议：回 PRD 确认或调整 seam
4. 阶段完成 → 整体 code-review + 更新实施概览
```

## 失败停止

```text
[✗] CF-S1-F2-T2 测试失败
     └─ 停止，不执行 T3
     └─ 已完成的 T1 保留 commit
     └─ 报告失败原因与建议
```

## 反例

| 写法 | 问题 |
|---|---|
| "继续" → 自动选下一个 Task | 没有编号，可能选错；必须先列清单确认 |
| 一个 Task 产生 3 个 commit | 回滚粒度失效；合并为一个 |
| 批量模式跳过失败 Task | 后续 Task 建立在坏基础上 |
| 不读计划原文凭记忆执行 | 编号、Done when、依赖都可能过时 |
