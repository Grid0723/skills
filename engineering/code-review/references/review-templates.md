# 双轴审查模板与 Sub-Agent 分派示例

## Standards 审查模板

```markdown
# Standards 审查报告

审查范围: Task-2: 编写 Cleaner（ETF 字段映射 + 数据清洗）
审查日期: 2026-07-15

## 加载的审查 Skill
- 项目自建审查 skill（如涉金融计算、API 契约）

## 检查项

### 代码规范
| 文件 | 行号 | 问题 | 严重度 |
|------|------|------|--------|
| cleaners/etf_cleaner.py | 23 | 变量名 `x` 无意义 | minor |
| cleaners/etf_cleaner.py | 45 | 重复的类型转换逻辑未提取 | medium |

### 命名
| 文件 | 行号 | 问题 |
|------|------|------|
| fetchers/etf_fetcher.py | 12 | `get_data()` 过于笼统，建议 `fetch_etf_basic()` |

### 类型安全
| 文件 | 行号 | 问题 |
|------|------|------|
| cleaners/etf_cleaner.py | 31 | 函数缺少返回类型标注 |

### 安全/金额（如适用）
未发现违规。

## 总体评估
- 可合并 ✔
- 3 个问题：2 minor + 1 medium，不阻塞合并
```

## Spec 审查模板

```markdown
# Spec 审查报告

审查范围: Task-2: 编写 Cleaner（ETF 字段映射 + 数据清洗）
对照 PRD: PRD-etf-basic-fetcher.md Seam 2

## Seam 逐项验证

| Seam | 验证结果 | 证据 |
|------|---------|------|
| Cleaner 将原始字段映射为数据库列 | ✅ 通过 | `field_maps.py` 中注册了 `etf_basic` 字段分组，13 个字段均已映射 |
| 空值处理符合约定 | ✅ 通过 | 规模字段 NULL → Decimal("0.00") |
| 输出结构与 schema 一致 | ⚠️ 待确认 | schema 中多了 `management_fee` 列但 Cleaner 未映射——需补充或去掉 schema 列 |

## 遗漏检查

- 原始 PRD 中提到"跟踪指数信息"，但 Cleaner 未处理 `track_index_code` 字段映射
- Task-1 的 Schema 中有 `management_fee` 列但 Task-2 未处理

## 总体评估
- ⚠️ 需修改：1 个遗漏（`management_fee`）+ 1 个缺失（`track_index_code`）
```

## Sub-Agent 分派

### 在 OpenCode 中的实现

```
Grid 编码阶段 → 任务完成 → 启动 code-review

并行启动两个 sub-agent：

Sub-agent 1（Standards 审查）:
  上下文: 当前任务涉及的全部文件 + 项目审查 skill（若项目声明了）
  指令: 按 Standards 审查模板产出报告

Sub-agent 2（Spec 审查）:
  上下文: 当前任务涉及的全部文件 + 对应 PRD 的 seam 描述
  指令: 按 Spec 审查模板逐一验证每个 seam

→ 两份报告产出 → 展示给用户（不合并、不重排）→ 用户决策
```

## 审查产出物

审查通过后写入 ADR：

```markdown
# ADR: Task-2 etf-cleaner 审查

- 审查日期: 2026-07-15
- Standards: 通过（3 个 minor，不阻塞）
- Spec: 需修改（management_fee 映射缺失）
- 决议: 补全 management_fee 映射后合并
```
