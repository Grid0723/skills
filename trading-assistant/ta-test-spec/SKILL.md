---
name: ta-test-spec
description: trading_assistant 项目的测试规范——后端/前端 lint、单元测试、类型检查。Use when writing or running tests, before committing, or during code review.
---

# ta-test-spec

trading_assistant 项目专属测试规范。本项目测试性质是**单元测试 + lint + 类型检查**。

## Leading Words

| 术语 | 定义 |
|------|------|
| **lint 门** | 代码必须通过 `pnpm lint` 才能提交 |
| **test 门** | 修改的模块必须通过对应单元测试 |
| **类型守卫** | TypeScript 严格模式，禁止 `any`（或标注 TODO/FIXME） |

## 提交前检查

```bash
cd backend && pnpm lint && pnpm test    # 后端
cd frontend && pnpm lint && pnpm test   # 前端
```

- 完成标准：lint 零告警，test 全通过

## 测试规范

| 规范 | 说明 |
|------|------|
| 新功能带测试 | 每个新 Controller/Service 必须有对应的 `.spec.ts` |
| 测试独立于数据库 | Service 层 mock PrismaService |
| Controller 测试 | 用 `@nestjs/testing` 的 `Test.createTestingModule` |
| 金融计算测试 | 金额断言用 `decimal.js` 比较，不直接用 `toBe` 比较浮点 |

## 代码质量检查

- [ ] TypeScript 严格模式无新增 `any`
- [ ] ESLint 零告警
- [ ] Prettier 格式化一致
- [ ] 导入使用 `NodeNext` 模块系统（`.js` 扩展名）
- [ ] 金额字段 DTO 为 `string` 类型

## 参考

- `backend/jest.config.ts`
- `frontend/jest.config.ts`
- `backend/.eslintrc.js`
- `frontend/.eslintrc.js`
