---
name: project-links
description: 维护项目的外部链接文档。Use when adding a new external resource, updating links, or organizing project references.
---

# project-links

维护项目的外部资源链接。

## Leading Words

| 术语 | 定义 |
|------|------|
| **file:/// 路径** | 本地文件/文件夹的绝对路径链接 |

## 添加链接

在 `20_项目/<项目名>/外部链接.md` 中追加：

```markdown
- `[名称](file:///path)` — 描述
- `[名称](https://url)` — 描述
```

所有项目链接被 dataview 聚合于 `20_项目/外部链接.md`。
