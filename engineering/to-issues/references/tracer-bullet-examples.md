---
Author: 张谦
tags: []
创建: 2026-07-15 11:50:50
修改: 2026-07-28 17:15:16
---

# Tracer Bullet 拆解案例

## 案例：ETF 数据获取器

### 原始 PRD Seam 列表

```bash
- [ ] Seam 1: 调用 tq.get_trackzs_etf_info() 返回 ETF 列表
- [ ] Seam 2: Cleaner 将原始字段映射为数据库列
- [ ] Seam 3: batch_upsert 写入 PostgreSQL
- [ ] Seam 4: CLI 可独立执行
```

### 拆解后的开发计划

```markdown
## 开发计划: etf-basic-fetcher

- [ ] Task-1: 定义 Schema——创建 etf_basic 表的 Prisma model
     验证: `prisma validate` 通过 + `prisma db push` 生效

- [ ] Task-2: 编写 Cleaner——ETF 字段映射 + 数据清洗
     验证: 用示例数据运行 dry_run，输出格式正确

- [ ] Task-3: 编写 Fetcher——调用 get_trackzs_etf_info + 批量分片
     验证: `tdx fetch --task etf-basic --dry-run -v` 输出数据预览

- [ ] Task-4: 注册到 CLI + 调度器
     验证: `tdx init` 菜单中出现 etf-basic，`tdx fetch --task etf-basic` 端到端执行

- [ ] Task-5: 集成测试 + 文档
     验证: 实际获取 ETF 数据 + 数据库确认 + CHANGELOG 更新
```

### 为何是 Tracer Bullet（垂直切片）？

```bash
传统（水平分层）：       Tracer Bullet（垂直切片）：
Task A: 设计所有表      Task 1: 一条 ETF 记录→表设计→Cleaner→Fetcher→CLI
Task B: 写所有 Cleaner  Task 2: 下一个数据类型→...
Task C: 写所有 Fetcher  ...
Task D: CLI 集成        ← 只有到 D 才能验证是否能跑

← 到 B 都无法验证    ← 每个 Task 后都可独立演示一个功能
```

每个 Task 贯穿 Schema→Cleaner→Fetcher→CLI 全层，做完就能跑。

## 另一个案例：Bug 修复

### Bug 描述

> 分钟 K 线查询返回的 volume 字段在 09:30 之前全是 0

### 拆解后的开发计划

```markdown
## 开发计划: fix-minute-kline-volume

- [ ] Task-1: 编写最小复现测试——查询 000001.SZ 某一日的分钟 K 线，断言 09:30-15:00 的 volume 不全为 0
     验证: 测试在修复前失败

- [ ] Task-2: 修复 Cleaner 中的 volume 字段映射
     验证: 上一步的测试通过

- [ ] Task-3: 回归测试——运行全部 kline 相关测试
     验证: 无新失败
```

## 任务验收标准

每个 Task 的验证项必须：

| 好 | 差 |
|---|----|
| "`tdx fetch --task xxx --dry-run` 输出完整预览数据" | "Fetcher 正常工作" |
| "测试在修复前失败、修复后通过" | "Bug 已修复" |
| "`prisma validate` 通过" | "Schema 正确" |

**验收标准必须可被 Agent 自动检查**，不依赖人类判断。
