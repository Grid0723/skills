# PRD 模板与 Seam 标注示例

## PRD 标准模板

```markdown
# PRD: <功能名>

## 目标
一句话描述要解决的问题。去掉技术实现细节。

例: 让 TDX 系统自动从通达信终端获取 ETF 基本信息并存入 PostgreSQL。

## 范围

### 包含
- 获取 ETF 基本信息（代码、名称、跟踪指数、费率、规模）
- 存入 stock_basic 表扩展或新表
- CLI 交互模式支持选择 ETF 类别

### 不包含
- ETF 成分股实时计算（P1 考虑）
- ETF 估值分析
- 前端展示页面

## 接缝（可独立验证点）

- [ ] Seam 1: 调用 `tq.get_trackzs_etf_info()` 返回 ETF 列表，字段完整
- [ ] Seam 2: Cleaner 将原始字段映射为数据库列
- [ ] Seam 3: batch_upsert 写入 PostgreSQL，upsert 正确
- [ ] Seam 4: CLI `tdx fetch --task etf-basic` 可独立执行

## 约束
- 批量上限：TQ API 每次 ≤99 只，≥99 需分片
- 日期格式：YYYYMMDD
- 数据库：金额字段 DECIMAL(36,18)

## 风险
- TQ API 返回的 ETF 规模字段可能为 0（新 ETF），需空值处理
- 部分 ETF 无跟踪指数信息，字段可为 NULL
```

## Seam 标注指南

Seam 是"用户（或测试）可以独立感知系统工作的点"——不需要理解内部实现就能验证。

| 好的 Seam | 差的 Seam |
|-----------|----------|
| "调用 API 返回完整字段列表" | "实现 fetch_etf_basic 方法" |
| "CLI 命令可独立执行并输出结果" | "在 scheduler.py 中注册任务" |
| "数据库 upsert 不产生重复行" | "batch_upsert 内部路径正确" |

**原则：Seam 描述结果，不描述过程。** 每个 Seam 对应开发计划中的一个 Task。

## 审批门流程

```
GRID 展示草案
  ├── 用户确认 → 写入 docs/01-Requirements/PRD-xxx.md
  ├── 用户修改 → 根据反馈修正，重新展示
  └── 用户否决 → 返回 grilling 拷问阶段
```

## 文件命名

```
docs/01-Requirements/PRD-<英文功能名>.md
```
