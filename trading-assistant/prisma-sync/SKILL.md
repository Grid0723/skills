---
name: prisma-sync
description: 同步双份 Prisma Schema——trading_assistant 项目 docs/ 设计稿 ↔ backend/ 实现稿。Use when adding or modifying data models, after schema changes, or before running prisma generate/migrate.
---

# prisma-sync

确保 `docs/03-Database/schema.prisma`（SSOT 设计稿）与 `backend/prisma/schema.prisma`（框架实现）同步。

## Leading Words

| 术语 | 定义 |
|------|------|
| **SSOT（单一事实源）** | `docs/03-Database/schema.prisma` 为设计基准，实现稿从它同步 |
| **双份隔离** | 设计稿只定义业务模型，实现稿额外包含 datasource/generator/env 配置 |

## 步骤

### 1. 读取设计稿

读取 `docs/03-Database/schema.prisma`——这是 SSOT。

- 完成标准：确认设计稿中的 model/enum 定义

### 2. 读取实现稿

读取 `backend/prisma/schema.prisma`——这是框架配置。

- 完成标准：确认实现稿中的差异

### 3. 比对并同步

将设计稿中的业务模型同步到实现稿。**不修改**实现稿中的：

- datasource（provider、url）
- generator（provider、output）
- env 配置引用

- 完成标准：model/enum 定义一致

### 4. 验证

```bash
cd backend && pnpm prisma validate && pnpm prisma format
```

- 完成标准：validate 通过，format 无变更

## 关键约束

- Prisma 7.x 使用 `prisma-client` provider
- 输出目录：`../generated/prisma`
- 金额字段：`DECIMAL(36,18)`
- 只同步 model/enum 定义部分
