---
name: doc-sync
description: trading_assistant 项目代码变更后同步更新 docs/ 文档和 CHANGELOG。Use after completing code changes, before committing, or when the user asks to sync documentation.
---

# doc-sync

代码变更后检查并提示需同步更新的文档，确保文档驱动开发的一致性。

## Leading Words

| 术语 | 定义 |
|------|------|
| **文档驱动** | 代码是实现，`docs/` 是设计基准——变更应以文档为起点 |
| **变更跟踪** | 每类代码变更对应一组应同步的文档 |

## 同步规则

| 变更类型 | 需更新文档 |
|----------|-----------|
| 新增/修改数据模型 | `docs/03-Database/schema.prisma` + `backend/prisma/schema.prisma` |
| 新增/修改 API | `docs/04-API/openapi.yaml` |
| 业务逻辑变更 | `docs/02-Architecture/` 下的 Mermaid 图 |
| 环境/部署变更 | `docs/06-DevOps/` 相关文档 |
| 架构决策 | `docs/05-ADR/` 新增决策记录 |
| 任何功能变更 | `docs/CHANGELOG.md` |
| MVP 阶段变更 | `docs/07-MVP/04-Implementation-Log.md` |

## 步骤

1. **分析变更**：执行 `git diff` 查看代码改动范围
2. **确定范围**：根据变更类型确定需更新的文档列表
3. **更新文档**：先读现有内容，在原文基础上追加/修改
4. **更新日志**：CHANGELOG 按版本号记录，实现日志记录细节和决策

## 文档规范

- 简体中文 + Mermaid 架构图
- 与现有文档 Markdown 风格一致
- 语义化版本号，同步 `docs/README.md` 版本徽章
