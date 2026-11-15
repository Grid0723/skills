# knowledge

Fabric 脊椎内核——知识管理的 CODE 工作流原子步骤。

## 用户调用

知识操作有副作用（移动文件、写笔记），需要人类判断。

- **[fabric](./fabric/SKILL.md)** — **总编排器——捕获→分类→归位→提炼→输出→织网**。路由判断阶段、驱动 knowledge skill、嵌入织网检测、挂靠项目管理。
- **[capture](./capture/SKILL.md)** — 捕获到收集箱：**捕获不加判断、不求全**。URL/灵感 → `00_收集箱/`，`状态: 待整理`。剪藏加 `来源` 字段。
- **[classify](./classify/SKILL.md)** — 判断归属：**文件夹定位置，标签管主题**。对照 9 领域表，不确定标 `待归类/`。向用户确认后再进入归位。
- **[organize](./organize/SKILL.md)** — 归位：**物理移动+标签更新 `状态: 已归位`**。完成后嵌入织网检测——子标签 ≥3 篇时提示建子主题 MOC（`类型: 索引`）。
- **[distill](./distill/SKILL.md)** — 渐进式总结提炼：**四层递进——加粗→高亮→执行摘要**。10 秒测试：提炼后的笔记应在 10 秒内抓住核心价值。完成后检 ≥5 融合 hub。
- **[express](./express/SKILL.md)** — 输出阶段：**写作管道路由——fragments→beats→shape→edit-article**。按需跳过步骤。不承担开启新项目的职能。
- **[connect](./connect/SKILL.md)** — 全量知识库扫描：**L1 标签统一→L2 建 MOC→L3 补双链→L4 融合 hub**。与归位/提炼的嵌入检测互补。
- **[vault-lint](./vault-lint/SKILL.md)** — 笔记库体检：**frontmatter 完整性、状态机合规、标签格式、重复文件、时效**；只读报告 + dry-run 修复。
