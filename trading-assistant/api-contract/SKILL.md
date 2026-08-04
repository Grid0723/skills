---
name: api-contract
description: 校验 trading_assistant 前后端实现是否符合 OpenAPI 3.0 契约。Use when implementing or modifying API endpoints, connecting frontend to backend, or during PR review.
---

# api-contract

确保前后端实现与 `docs/04-API/openapi.yaml` 契约一致。

## Leading Words

| 术语 | 定义 |
|------|------|
| **契约基准** | `openapi.yaml` 是 API 的唯一权威定义 |
| **双端校验** | 后端 Controller + 前端 API 调用，两端独立检查 |

## 检查维度

| 维度 | 后端检查点 | 前端检查点 |
|------|-----------|-----------|
| **路径** | `@Controller` + `@Get/@Post` 装饰器 | `fetch`/`axios` URL |
| **参数** | `@Param`、`@Query`、`@Body` 装饰器 | 请求参数结构 |
| **响应** | `@ApiResponse` 和返回 DTO | 响应类型定义 |
| **金额** | 返回 string 类型 | 用 string 接收 |
| **分页** | 实现分页参数 | 处理分页响应 |

## 步骤

1. 阅读契约：`docs/04-API/openapi.yaml`
2. 检查后端：Controller 路由、DTO 字段、响应结构、HTTP 状态码
3. 检查前端：API 调用路径、请求/响应类型、错误处理覆盖

## 输出格式

```
| 维度 | 契约定义 | 实际实现 | 文件:行号 |
```
