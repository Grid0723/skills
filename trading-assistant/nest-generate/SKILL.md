---
name: nest-generate
description: 按 trading_assistant 项目规范生成 NestJS 模块/控制器/服务/ DTO。Use when the user wants to create a new API endpoint, module, controller, or service in the trading-assistant backend.
---

# nest-generate

在 trading_assistant 项目中按规范生成 NestJS 代码。遵循 NodeNext 模块系统和项目代码规范。

## Leading Words

| 术语 | 定义 |
|------|------|
| **NodeNext 模块系统** | 导入使用 `.js` 扩展名，对应 `tsconfig.json` 的 `moduleResolution: NodeNext` |
| **DTO 验证栈** | `class-validator` 装饰器 + Swagger 装饰器，分布在 Controller/DTO 两处 |
| **金额字符串传输** | 金额字段在 DTO 中为 `string` 类型，业务层转为 `Decimal` |

## 生成命令

```bash
cd backend
pnpm nest generate module <name>
pnpm nest generate controller <name>
pnpm nest generate service <name>
```

## 代码规范

### Controller

- 路由前缀与 `docs/04-API/openapi.yaml` 保持一致
- 使用 `@ApiTags`、`@ApiOperation`、`@ApiBearerAuth`（如需认证）
- 返回类型标注 DTO 类

### Service

- 依赖注入 `PrismaService`
- 金额计算使用 `decimal.js`
- CRUD 命名：`create`、`findAll`、`findOne`、`update`、`remove`

### DTO

- 校验装饰器：`@IsString`、`@IsOptional`、`@IsEnum` 等
- 金额字段类型为 `string`
- Create DTO 继承 `PartialType` 或独立定义

## 生成后检查

- [ ] 已更新 `app.module.ts` 导入新模块
- [ ] Controller 路由与 `openapi.yaml` 一致
- [ ] DTO 金额字段为 `string` 类型
- [ ] 运行 `cd backend && pnpm lint` 通过
