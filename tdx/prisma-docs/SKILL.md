---
name: prisma-docs
description: TDX 项目 Prisma ORM 操作规范——Schema 设计、迁移、Python 查询与写入。Use when modifying the database schema, running Prisma migrations, or writing Python code that interacts with PostgreSQL via Prisma Client.
---

# prisma-docs

TDX 项目的 Prisma Client Python 操作规范。Prisma 是 Schema-first ORM——数据模型定义在 `prisma/schema.prisma` 中。

## Leading Words

| 术语 | 定义 |
|------|------|
| **Schema-first** | 数据模型先定义在 schema 文件中，再生成 Python 客户端 |
| **SSOT（单一事实源）** | schema.prisma 是数据结构的唯一定义源，不对其他处存副本 |
| **安全红线** | 不得自动执行的 Prisma 危险操作 |

## Schema 编写规范

- 金额字段：`DECIMAL(36,18)`
- 复合主键：`@@id([stock_code, date])` 模式
- 字段注释：全表统一 `///` 格式

## Python 使用

### 模型更新后

```bash
prisma generate  # 重新生成 Python 客户端类型
prisma db push   # 同步 schema 到数据库（开发环境）
```

### 查询

```python
from src.db.prisma import prisma

records = await prisma.stock_basic.find_many(
    where={"market": "SH"},
    take=100,
)
```

### 写入（upsert）

通过 Repository 层的 `batch_upsert()`——不直接调用 Prisma 写入：

```python
await batch_upsert(table_name, records, unique_keys=["stock_code", "date"])
```

## 安全红线

以下操作**必须在用户明确确认后**执行：

| 操作 | 风险 | 命令 |
|------|------|------|
| 迁移生效 | 直接修改生产数据库结构 | `prisma migrate deploy` |
| 重置数据库 | 删除所有数据 | `prisma migrate reset` |
| 修改生产 schema | 数据库结构变更 | 修改 `schema.prisma` |
| 手动 SQL | prisma.$executeRaw / $queryRaw | 绕过 ORM 约束 |

## 约束

- `backend/prisma/schema.prisma` 中的 datasource / generator / env 配置不修改
- 仅同步 model / enum 定义部分
- Prisma 7.x 使用 `prisma-client` provider，输出目录 `../generated/prisma`

## 外部参考

- `docs/03-Database/数据库设计.md` — ER 图 + 表结构 + 索引
- `docs/03-Database/数据字典.md` — 字段级详细说明
- `docs/06-DevOps/Prisma操作手册.md` — 完整操作指南
- `docs/05-ADR/001-prisma-orm选择.md` — 为什么选择 Prisma
