# Wayfinder Ticket 地图示例

## 案例：pandas → Polars 迁移

### 初始地图

```markdown
# Wayfinder 地图: pandas→Polars 迁移

状态: 进行中 | 创建: 2026-07-01

## Tickets

| ID | 类型 | 描述 | 状态 | 阻塞 |
|----|------|------|------|------|
| R1 | research | 验证 Polars 能否替代 pandas 的 DataFrame.groupby→agg | ✅ done | — |
| R2 | research | 确认 Polars 的 to_pandas() 无缝兼容现有 prisma batch_upsert | ✅ done | — |
| P1 | prototype | 用一个 Cleaner（kline_daily）用 Polars 重写，benchmark 对比 | ⏳ doing | R1, R2 |
| T1 | task | 迁移 kline_daily Cleaner | 🔒 blocked | P1 |
| T2 | task | 迁移 divid_factors Cleaner | 🔒 blocked | P1 |
| G1 | grilling | 决定 COPY 协议 vs Polars write_csv→COPY——哪个更快？ | 🔒 blocked | P1 |

## 依赖图
```
R1 ──┐
     ├── P1 ──┬── T1
R2 ──┘       ├── T2
              └── G1
```

## Frontier
P1（所有阻塞已解除，当前在执行）
```

### P1 完成后地图更新

```markdown
# Wayfinder 地图: pandas→Polars 迁移

状态: 进行中 | 更新: 2026-07-04

## Tickets

| ID | 类型 | 描述 | 状态 | 阻塞 |
|----|------|------|------|------|
| R1 | research | 验证 Polars groupby→agg | ✅ done | — |
| R2 | research | 确认 Polars to_pandas() 兼容性 | ✅ done | — |
| P1 | prototype | kline_daily 用 Polars 重写 | ✅ done | — |
| T1 | task | 迁移 kline_daily Cleaner | ⏳ doing | — |
| T2 | task | 迁移 divid_factors Cleaner | 🔒 blocked | T1 |
| G1 | grilling | COPY vs write_csv→COPY 性能差距 | ⏳ doing | — |
| G2 | grilling | **浮现！**——迁移后是否需要同时维护 pandas 版本？ | ⏳ doing | — |
| P2 | prototype | **浮现！**——分钟线 Cleaner 迁移前先 benchmark | 🔒 blocked | T1 |

## Frontier
T1, G1, G2（三个可并行执行）
```

## 关键概念速查

| 概念 | 操作 |
|------|------|
| 一个 ticket 解决后视野扩大 → 新 ticket 出现 | 追加到地图 |
| 阻塞解除 → 被阻塞的 ticket 进入 Frontier | 标记为可执行 |
| 每 session 只执行一个 ticket | 强约束 |
| wayfinder 不执行代码——只规划 | Plan, don't do |
| ticket 类型：research/prototype/grilling/task | 递进层次：先查再造再问再做 |
