---
name: project-review
description: 基于 CHANGELOG/commit log 更新项目的里程碑总结。Use after completing a key feature, when switching project phases, or when the user wants a progress review.
---

# project-review

里程碑回顾——基于外部 CHANGELOG/commit log，更新项目总览的「📝 里程碑总结」。

## Leading Words

| 术语 | 定义 |
|------|------|
| **里程碑总结** | 总览文档中的「📝 里程碑总结」区——记录核心变更、关键决策、所学经验 |
| **阶段切换触发** | 项目阶段变更（启动→进行中→收尾）时自动触发回顾 |

## 步骤

### 1. 读取变更记录

- 软件项目：读取 CHANGELOG.md 或 `git log`
- Obsidian 项目：读取项目目录下的笔记变更

- 完成标准：变更清单已提取

### 2. 撰写里程碑总结

提取三个维度：
- **核心变更**：本阶段完成了什么
- **关键决策**：做了什么重要选择及其原因
- **所学经验**：可复用的知识

- 完成标准：总结内容已产出

### 3. 更新总览文档

将总结写入项目总览的「📝 里程碑总结」区。追加时间戳。

- 完成标准：总览已更新

## 外部参考

- `references/review-template.md` — 从 CHANGELOG 提取里程碑总结的三步法（核心变更→关键决策→所学经验）、模板
