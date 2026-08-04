---
name: wayfinder
description: DevOps 类大型重构/迁移的战争迷雾渐进规划——每 session 一个 ticket，解决一个后视野扩大。Use when facing a large-scale refactoring or migration（如 pandas→Polars、PostgreSQL→TimescaleDB）that exceeds a single session's capacity.
---

# wayfinder

战争迷雾渐进规划。大型 DevOps 工作超出单 session 容量时，用 ticket 地图逐步推进。

## Leading Words

| 术语 | 定义 |
|------|------|
| **Fog of War（战争迷雾）** | 规划时看不到全貌，解决一个 ticket 后视野扩大，新 ticket 才浮现 |
| **Plan, don't do** | wayfinder 只解决"路在哪"，不负责走完全程 |
| **Frontier** | 所有开放、未被阻塞、无人认领的 ticket 中排最前面的 |

## Ticket 类型

| 类型 | 用途 | 示例 |
|------|------|------|
| **research** | 调研技术可行性 | "验证 Polars 能否替代 pandas 的 DataFrame 操作" |
| **prototype** | 最小可行原型 | "实现一个 Cleaner 用 Polars 重写，验证性能" |
| **grilling** | 拷问设计决策 | "Polars 写入 PostgreSQL 走什么路径？" |
| **task** | 执行一个迁移步骤 | "将 get_market_data Cleaner 迁移到 Polars" |

## 步骤

### 1. 创建共享地图

在 DevOps 目录下创建一张 issue/ticket 地图。标注初始已知的 ticket 和依赖关系。

- 完成标准：地图包含至少 2 个初始 ticket，标注依赖

### 2. 识别 Frontier

找出所有开放、未被阻塞、可立即开始的 ticket。

- 完成标准：锁定一个 Frontier ticket

### 3. 执行一个 Ticket（每 session 一个）

仅执行一个 ticket。完成后：
- 更新地图（新 ticket 浮现 → 添加到地图）
- 更新依赖关系（阻塞解除 → 开放新 Frontier）
- 标记当前 ticket 状态

- 完成标准：ticket 解决，地图更新

### 4. 循环或退出

回到步骤 2，识别下一个 Frontier。直到所有 ticket 完成或用户中止。

## 边界条件

- **每 session 一个 ticket**——强约束，避免 context 膨胀
- wayfinder 是 **plan, don't do** —— 它是地图，不是施工队
- 仅对 DevOps 类大型重构/迁移触发

## 外部参考

- `references/ticket-map-examples.md` — 完整案例：pandas→Polars 迁移的初始地图 + P1 完成后地图更新、Frontier 浮现规则、ticket 类型递进层次（research→prototype→grilling→task）
