---
name: writing-beats
description: 写作 Exploit 阶段——将碎片原料组装为节拍旅程，使用 Grounding 机制确保概念无"跳读"。Use after collecting fragments——this step arranges raw material into a structured journey.
---

# writing-beats

写作 Exploit 阶段的节拍编排。将碎片原料组装为有序的"节拍旅程"。使用 **Grounding（接地）机制**。

## Leading Words

| 术语 | 定义 |
|------|------|
| **节拍（Beat）** | 旅程中的一个逻辑步骤——先讲 A，才能理解 B |
| **Grounding（接地）** | 每个概念在被使用前必须已建立——either 前置知识 or 由前面的 beat 引入 |

## Grounding 机制

维护一个**已接地清单**：
- 候选 beat 只有在它所依赖的概念全部"接地"后，才可入选
- 如果一个 beat 依赖的概念尚未接地 → 在其前面插入接地该概念的 beat
- 本质是对信息依赖关系的静态分析

## 步骤

### 1. 读取碎片堆

读取 `writing-fragments` 产出的碎片集合。

- 完成标准：全部碎片已录入

### 2. 提取概念依赖

从碎片中识别关键概念。对每个概念标注"读者需要什么前置知识才能理解它"。

- 完成标准：概念依赖图已形成

### 3. 编排节拍序列

按 Grounding 规则排列 beats：
1. 不需要前置知识的概念 → 最前列
2. 每个 beat 在所有依赖接地后才入选
3. 最终形成一条无需跳读的旅程

- 完成标准：beat 序列可执行，无跳读概念

### 4. 展示旅程轮廓

向用户展示 beats 序列和每个 beat 的核心内容。用户确认后进入写作塑形。

- 完成标准：用户确认旅程结构

## 外部参考

- `references/grounding-example.md` — Grounding 概念依赖推导全过程（布林带案例）、6 个 Beat 序列编排、"已接地清单"推进机制
