# trading-assistant

交易助手项目专属技能——NestJS + Prisma + TypeScript 全栈。热插拔注册制。

- **[nest-generate](./nest-generate/SKILL.md)** — NestJS 代码生成：**NodeNext 模块系统 + DTO 验证栈**。金额字段以 string 传输，Swagger 装饰器标配。
- **[prisma-sync](./prisma-sync/SKILL.md)** — 双份 Prisma Schema 同步：**SSOT 设计稿（docs/）→ 实现稿（backend/）**。只同步 model/enum 定义，不碰 datasource/generator。
- **[finance-review](./finance-review/SKILL.md)** — 金融计算审查：**decimal.js 审计——禁止原生 `+ - * /` 运算**。扫描范围：Service 层、工具函数、格式化函数。输出 `文件:行号 | 违规 | 建议`。
- **[api-contract](./api-contract/SKILL.md)** — OpenAPI 3.0 契约校验：**契约基准——后端 Controller + 前端 API 调用双端独立检查**。路径/参数/响应/金额/分页五维度。
- **[doc-sync](./doc-sync/SKILL.md)** — 代码变更后同步文档：**文档驱动——变更类型映射到应同步的 docs 文件**。CHANGELOG + 实现日志 + ADR 覆盖。
- **[ta-test-spec](./ta-test-spec/SKILL.md)** — 测试规范：**lint门 + test门 + 类型守卫**。禁 any，Mock PrismaService，金额断言用 decimal.js。提交前 `pnpm lint && pnpm test`。
