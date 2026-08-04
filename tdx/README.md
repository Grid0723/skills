# tdx

TDX 数据采集项目专属技能——Python + PostgreSQL + TdxQuant。热插拔注册制。

- **[tdx-quant-docs](./tdx-quant-docs/SKILL.md)** — TdxQuant/tqcenter API 文档查阅：**60+ API 的返回值、约束、场景示例**。批量上限 99 只，日期 YYYYMMDD，代码格式 .SH/.SZ。
- **[loguru](./loguru/SKILL.md)** — Loguru 日志库：**全局单例 logger + sink 注册制**——轮转、诊断、结构化、`{}` 格式化。
- **[prisma-docs](./prisma-docs/SKILL.md)** — Prisma ORM 操作规范：**Schema-first + 安全红线**。金额 DECIMAL(36,18)，写走 `batch_upsert`，禁止自动迁移/重置。
- **[tdx-dev-guide](./tdx-dev-guide/SKILL.md)** — 新增数据获取器的 **10 步流程**：Cleaner→Fetcher→Schema→Field Maps→调度器→CLI→配置→文档→测试。每步有明确交付物和验证点。
- **[tdx-test-spec](./tdx-test-spec/SKILL.md)** — 集成测试规范：**CLI 验收 + dry_run 先行 + 全链路验证**。152 项验收子项见 `docs/08-Testing/测试手册.md`。
