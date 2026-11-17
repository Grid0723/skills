# trading-assistant 项目文档实例化配置

> 基于 `doc-architecture` 通用模板的 trading-assistant 项目实例化。Agent 初始化同类全栈 Web 应用时，参考此配置。

## 文档骨架实例化状态

```
docs/
├── README.md                     ← ✅ 已生成（文档中心导航）
├── CHANGELOG.md                  ← ✅ 持续维护
│
├── 01-Requirements/
│   └── PRD.md                    ← ✅ 已生成（交易助手全功能需求定义）
│
├── 02-Architecture/
│   ├── 系统架构.md               ← ✅ 已生成（前后端分离六层架构）
│   ├── 开发指南.md               ← ✅ 已生成（NestJS/Prisma/Umi 开发流程）
│   └── 时序图.md                 ← ✅ 按需生成（核心业务流程）
│   └── 设计模式.md               ← 可选——项目采用 NestJS 标准模式
│
├── 03-Database/
│   ├── schema.prisma             ← ✅ SSOT 设计稿（Prisma 7.x 格式）
│   └── 数据字典.md               ← 可选——schema 字段注释即字典
│
├── 04-API/
│   └── openapi.yaml              ← ✅ OpenAPI 3.0 契约文件（非 .md）
│
├── 05-ADR/
│   ├── 001-decimal-precision.md  ← ✅ 金额精度决策
│   └── ...                       ← 后续决策按需追加
│
├── 06-DevOps/
│   ├── 部署指南.md               ← ✅（Docker + 环境变量）
│   └── 故障排查.md               ← ✅（pnpm/npm/Prisma 常见问题）
│
├── 07-MVP/
│   ├── 实施概览.md               ← ✅（MVP 目标+功能清单）
│   ├── 实现日志.md               ← ✅（持续记录）
│   └── 04-Implementation-Log.md  ← ✅ MVP 实现细节
│
└── 08-Testing/
    ├── 测试手册.md               ← ✅（Jest + Testing Module 用例）
    └── 测试记录.md               ← ✅（测试轮次记录）
```

## trading-assistant 特有差异

| 差异 | 与通用模板不同 |
|------|--------------|
| `04-API/openapi.yaml` | 接口契约用 YAML 而非 Markdown——这是 OpenAPI 3.0 标准，契约校验 skill 依赖它 |
| `03-Database/schema.prisma` | SSOT 设计稿用 Prisma Schema 格式而非 .md——Schema 同步 skill 依赖它 |
| `05-ADR/001-decimal-precision.md` | 金融系统有金额精度决策——非金融项目通常跳过此 ADR |
| `06-DevOps/配置参考.md` | 不生成——trading-assistant 通过 `.env` 配置，无 config.yaml |

## Agent 初始化同类项目时的推荐配置

- NestJS + Prisma 全栈项目 → 启用全部 8 个目录
- OpenAPI 项目 → `04-API/` 用 `.yaml` 而非 `.md`
- 金融/金额类项目 → 必须启用 `05-ADR/001-decimal-precision.md`
- 纯前端项目 → 跳过 `03-Database/`、`04-API/openapi.yaml` 改为接口类型定义文件
