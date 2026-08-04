---
name: to-prd
description: 将当前对话综合为 PRD 文档——不采访用户，纯综合已有对话。Use when the user has finished discussing a feature and needs a PRD written, or when the grilling phase produces enough clarity.
---

# to-prd

综合对话内容生成 PRD 草案。**不采访用户**——只整合已讨论的内容。强调 **seam（测试接缝）** 优先。

## Leading Words

| 术语 | 定义 |
|------|------|
| **接缝优先** | PRD 中标注可独立测试的系统边界，每个 seam 对应一个可验证点 |
| **审批门** | 草案展示 → 用户确认 → 写入文件 |

## 步骤

### 1. 综合对话

回顾对话历史，提取：
- 用户的核心需求（问题描述 + 期望结果）
- 已确认的技术约束
- 已讨论的边界条件和例外
- 完成标准：整理出需求摘要

### 2. 生成 PRD 草案

按以下结构组织：

```bash
# PRD: <功能名>

## 目标
一句话描述要解决的问题。

## 范围
- 包含：...
- 不包含：...

## 接缝（可独立验证点）
- [ ] Seam 1: ...
- [ ] Seam 2: ...

## 约束
- 技术约束
- 时间约束（如有）

## 风险
```

- 完成标准：草案完备，每个 seam 可独立验证
- 极简：一个段落就够了，不写文件路径

### 3. 展示并等确认

在对话中展示草案。用户可能：
- 确认 → 写入 `docs/01-Requirements/PRD-xxx.md`
- 修改 → 根据反馈修正，重新展示
- 否决 → 返回拷问阶段
- 完成标准：用户确认内容无误

### 4. 写入文件

写入 `docs/01-Requirements/PRD-<功能名>.md`。

- 完成标准：文件已保存

## 外部参考

- `references/prd-template.md` — PRD 标准模板（含 ETF 示例）、Seam 标注指南、审批门流程、文件命名规范
