---
name: finance-review
description: 审查 trading_assistant 项目中金额/价格/数量的计算——确保使用 decimal.js，禁止原生浮点运算。Use when reviewing code that involves financial calculations, adding new transaction/asset/statistics code, or before merging financial logic.
---

# finance-review

确保所有金融计算使用 `decimal.js`——禁止 JavaScript 原生 `Number` 和 `+ - * /` 运算符。

## Leading Words

| 术语 | 定义 |
|------|------|
| **decimal.js 审计** | 扫描代码中所有 `+ - * /` 在变量运算上下文中的出现，逐一判断是否涉及金额 |
| **字符串传输** | 金额通过 API 时使用 `string` 类型，接收后在计算时转为 `Decimal` |

## 禁止模式

```typescript
const profit = sellPrice - buyPrice;       // ❌
const total = quantity * price;            // ❌
const avg = sum / count;                   // ❌
const fee = amount * 0.001;               // ❌
```

## 正确模式

```typescript
import Decimal from 'decimal.js';

const profit = new Decimal(sellPrice).minus(buyPrice);
const total = new Decimal(quantity).times(price);
const avg = new Decimal(sum).dividedBy(count);
const fee = new Decimal(amount).times(0.001);
```

## 检查范围

- **后端**：`backend/src/**/*.ts`（排除 `*.spec.ts`）
- **前端**：`frontend/src/**/*.{ts,tsx}`
- 搜索关键字：`+`、`-`、`*`、`/` 在变量运算上下文中
- 重点：Service 层、工具函数、格式化函数

## API 传输

- 金额字段 DTO 类型为 `string`
- 前端计算时先转为 `Decimal`

## 输出格式

```
| 文件:行号 | 违规代码 | 建议修复 |
```
