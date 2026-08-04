---
name: tdx-dev-guide
description: TDX 项目新增数据获取器的完整开发流程。Use when implementing a new data fetcher in the TDX project——from defining the data model through registering CLI commands. 遵循 10 步流程。
---

# tdx-dev-guide

新增一个 TDX 数据获取器的端到端开发流程。每一步有明确的**交付物**和**验证点**。

## Leading Words

| 术语 | 定义 |
|------|------|
| **Cleaner → Fetcher 流水线** | 数据获取分两层：Cleaner（清洗+格式转换）→ Fetcher（调用 TQ API + 批量逻辑） |
| **field_maps 单一事实源** | 字段分组只存 `db/field_maps.py`，CLI 和 Fetcher 都从此获取 |
| **注册制** | 新功能通过 `@register_wizard` 装饰器注册，无需修改 dispatch 逻辑 |

## 步骤

### 1. 分析 API 返回值

查阅 `tdx-quant-docs` skill 中的对应 API 文档，确认：
- 参数格式（股票代码格式、日期格式）
- 返回值类型和数据结构
- 是否有批量上限（99 只）
- 完成标准：能列出 API 的完整输入输出契约

### 2. 设计数据表

在 `prisma/schema.prisma` 中定义 model。遵守：
- 金额字段用 `DECIMAL(36,18)`
- 日期字段用 `DateTime` 或 `Int`（按 TQ API 约定）
- 复合主键：`(stock_code, date)` 模式
- 完成标准：schema 通过 `prisma validate`
- 然后执行 `prisma migrate dev` 生成迁移

### 3. 编写 Cleaner

继承 `WideTableCleaner`（DataFrame 宽表路径）或独立 Cleaner：
- 定义字段映射（原始字段名 → 数据库列名）
- 实现数据清洗逻辑（类型转换、空值处理）
- 单值函数注册在 `cleaners/` 下
- 完成标准：能用示例数据运行并产出正确格式

### 4. 编写 Fetcher

继承 `BaseFetcher`：
- 实现 `fetch()` 方法——调用 TQ API
- 实现 `fetch_batch()`——处理 99 只分片
- 绑定 Cleaner 属性
- 设置 `task_type` 用于 CLI 调度
- 完成标准：`dry_run=True` 模式下能输出数据预览

### 5. 注册字段映射

在 `src/db/field_maps.py` 中注册新获取器的字段分组。CLI 层通过此获取可选的字段子集。

- 完成标准：字段分组可被 CLI 的 interactive 模块读取

### 6. 注册到调度器

在 `scheduler.py` 中添加新任务类型：
- 常驻模式（`tdx run`）：注册为定时任务
- 独立模式（`tdx fetch`）：添加任务分支
- 完成标准：CLI help 中出现新任务类型

### 7. 注册交互参数

在 `src/interactive/` 中注册参数采集向导：
- 添加 `@register_wizard(task_type="xxx")` 装饰器
- 定义参数步骤（股票范围、日期范围、字段筛选）
- 完成标准：`tdx init` 的交互菜单中出现新选项

### 8. 更新配置

若需要新的 `config.yaml` 节，在 `Config` dataclass 中添加字段。

- 完成标准：配置加载无报错

### 9. 文档

- 更新 `docs/04-API/内部接口契约.md`（新增 API 契约）
- 更新 `docs/03-Database/数据字典.md`（新增表字段说明）
- 更新 `docs/CHANGELOG.md`
- 完成标准：文档与实现一致

### 10. 测试

按 `tdx-test-spec` 规范执行集成验证：
- CLI 参数采集
- dry_run 数据预览
- 实际数据获取
- 数据库写入验证
- 完成标准：全部验收子项通过

## 约束

- TQ SDK 是同步 API，Prisma 是异步——用 `asyncio.to_thread()` 桥接
- 所有数据库写入走 `batch_upsert`
- 日志用 `loguru`，遵循 `loguru` skill 规范
