# TDX 项目文档实例化配置

> 基于 `doc-architecture` 通用模板的 TDX 项目实例化。Agent 初始化同类数据管道项目时，参考此配置。

## 文档骨架实例化状态

```
docs/
├── README.md                     ← ✅ 已生成（完整的文档导航索引）
├── CHANGELOG.md                  ← ✅ 持续维护（30+ 版本记录）
│
├── 01-Requirements/
│   └── PRD.md                    ← ✅ 已写入（v0.1.0 需求定义，154 行）
│
├── 02-Architecture/
│   ├── 系统架构.md               ← ✅ 已生成（六层架构，414 行）
│   ├── 时序图.md                 ← ✅ 已生成（4 张时序图+3 个状态机，262 行）
│   ├── 开发指南.md               ← ✅ 已生成（新增获取器 10 步流程，389 行）
│   └── 设计模式.md               ← ✅ 已生成（7 种设计模式总结，175 行）
│
├── 03-Database/
│   ├── 数据库设计.md             ← ✅ 已生成（Mermaid ER + 索引，513 行）
│   ├── 数据字典.md               ← ✅ 已生成（11 张表字段级说明，522 行）
│   └── add_comments.sql          ← TDX 特有——PostgreSQL 列注释批量脚本（704 行）
│
├── 04-API/
│   └── 内部接口契约.md           ← ✅ 已生成（971 行，11 章节）
│
├── 05-ADR/
│   ├── 001-prisma-orm选择.md     ← ✅
│   ├── 002-同步异步混合策略.md   ← ✅
│   ├── 003-批量分片99只限制.md   ← ✅
│   ├── 004-postgresql选择.md     ← ✅
│   ├── 005-polars迁移.md         ← ✅
│   ├── 005-timescaledb迁移.md    ← ✅
│   ├── 006-clickhouse-financial-data.md ← ✅（已搁置）
│   └── 007-rust-financial-data-ffi-实验.md ← ✅
│
├── 06-DevOps/
│   ├── CLI使用说明.md            ← ✅（667 行，全部 8 个命令组）
│   ├── 部署指南.md               ← ✅（167 行，含计划任务/nssm）
│   ├── 配置参考.md               ← ✅（317 行，config.yaml 全量参数）
│   ├── 日志系统设计.md           ← ✅（574 行，四通道+TQ劫持）
│   ├── 故障排查.md               ← ✅（275 行，5 类 FAQ）
│   └── Prisma操作手册.md         ← ✅（263 行，含安全红线+10 禁执操作）
│
├── 07-MVP/
│   ├── 实施概览.md               ← ✅（94 行，33 已完成+6 计划中）
│   ├── 实现日志.md               ← ✅（180 行，4 个里程碑）
│   └── 开发计划-TdxQuant_API覆盖.md ← ✅（549 行，P0-P6 六阶段）
│
└── 08-Testing/
    ├── 测试手册.md               ← ✅（729 行，46 项 × 152 验收子项）
    └── 测试记录.md               ← ✅（测试轮次记录表）
```

## TDX 特有文件

| 文件 | 原因 |
|------|------|
| `03-Database/add_comments.sql` | 财务表字段数极多（437 FN + 83 GP），注释批量执行更高效 |
| `05-ADR/006-clickhouse-financial-data.md` | 搁置状态——Wait until conditions are met |
| `05-ADR/007-rust-financial-data-ffi-实验.md` | 实验性质——结论为"不推荐"，但保留为参考 |
| `06-DevOps/日志系统设计.md` | 通用模板无此目录——TDX 的日志架构（四通道+TaskLogger+TQ劫持）设计决定单独成文 |

## Agent 初始化同类项目时的推荐配置

- Python 数据管道项目 → 启用全部 8 个目录
- 有数据库 → 启用 `03-Database/`
- 有 CLI → 启用 `06-DevOps/CLI使用说明.md`
- 无 API 端点 → 跳过 `04-API/`（或改为"内部模块接口"）
- 无 TimescaleDB/ClickHouse → 不生成 `03-Database/add_comments.sql`
