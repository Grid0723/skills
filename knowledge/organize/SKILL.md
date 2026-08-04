---
name: organize
description: 将已分类笔记物理移动到领域/项目目录，更新标签和状态。完成后自动检测子标签下笔记数 ≥3 则提示建 MOC。Use after classify confirms the note's destination——this is the physical move+tag step.
---

# organize

已分类笔记 → 物理移动 + 标签更新。完成后嵌入织网检测。

## Leading Words

| 术语 | 定义 |
|------|------|
| **物理移动** | 用 Obsidian 移动功能（自动更新链接），不直接用文件系统 |
| **即时状态流转** | 移动完成即刻 `状态: 已消化` |

## 步骤

### 1. 物理移动

将笔记从 `00_收集箱/` 移到归属目录：
- `10_领域/<领域>/` 或 `20_项目/<项目>/`

- 完成标准：文件已在新位置，原路径已空

### 2. 更新 frontmatter

更新字段：
- `类型` → `永久笔记` 或 `项目`
- `状态` → `已消化`
- 补 `description`（一句话核心）
- 补 `关键词`（检索词列表）
- 修正 `tags`（确保层级标签对齐 9 领域）

- 完成标准：frontmatter 字段齐全

### 3. 嵌入织网检测

查询该笔记关联的子标签下笔记数：
- ≥3 篇 → 提示 "该子标签下已有 N 篇笔记，是否需要建立子主题 MOC？"
- 用户确认 → 在 `10_领域/<领域>/` 下创建 `<子主题>MOC.md`（`类型: 索引`）

- 完成标准：织网检测完成，MOC 按需创建

## 外部参考

- `references/organize-examples.md` — 归位前后 frontmatter 对比、MOC 创建模板、织网检测触发流程
