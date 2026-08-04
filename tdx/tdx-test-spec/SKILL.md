---
name: tdx-test-spec
description: TDX 数据采集项目的集成测试规范——CLI 验收测试、数据获取验证、数据库写入验证。Use when writing or running tests for the TDX project, after implementing a new fetcher, or before merging to main.
---

# tdx-test-spec

TDX 项目专属测试规范。本项目的测试性质是**集成验证**——验证 CLI 命令输出、TQ API 返回数据格式、数据库 upsert 正确性。

## Leading Words

| 术语 | 定义 |
|------|------|
| **CLI 验收** | 用实际 CLI 命令验证功能——`uv run tdx fetch --task xxx` |
| **dry_run 先行** | 先 dry_run 预览数据格式，确认无误后再实际写入 |
| **全链路验证** | 从 CLI 输入→TQ API 调用→Cleaner→数据库写入，逐段检查 |

## 测试范围

| 层级 | 测试方式 | 覆盖 |
|------|---------|------|
| CLI 参数采集 | `uv run tdx init --task xxx` | 交互式参数是否正确采集 |
| 数据预览 | `uv run tdx fetch --task xxx --dry-run` | 返回数据格式、字段完整性 |
| 实际获取 | `uv run tdx fetch --task xxx --stock 000001.SZ` | 单只股票端到端验证 |
| 数据库写入 | 查询 PostgreSQL 确认 upsert 正确 | 主键、类型、NULL 处理 |
| 增量更新 | 两次 fetch 对比 | 第二次不应产生重复行 |

## 测试流程

### 1. dry_run 预览

```bash
uv run tdx fetch --task <task_type> --stock 000001.SZ --dry-run -v
```

- 完成标准：输出数据格式与 `tdx-quant-docs` 文档一致
- 字段名、类型、空值处理均符合预期

### 2. 实际获取 + 写入

```bash
uv run tdx fetch --task <task_type> --stock 000001.SZ
```

- 完成标准：PostgreSQL 中新增对应数据行
- 主键正确、无 NULL 越界

### 3. 增量验证

重复执行步骤 2：
- 完成标准：无重复行、无报错、日志显示 upsert 路径正确

## 每日运维验证

```bash
uv run tdx daily-update  # 全量日常更新
uv run tdx status        # 检查各任务状态
```

- 完成标准：所有任务日志显示成功，数据库各表最新日期正确

## 测试文档

详细测试用例见 `docs/08-Testing/测试手册.md`（7 模块 × 46 项 = 152 验收子项）。
