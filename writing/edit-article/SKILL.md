---
name: edit-article
description: 按 H2 标题拆分 → 构建 DAG 依赖图 → 逐段重写——先编辑依赖最少的段落。Use when polishing a finished article.
---

# edit-article

成品文章的编辑润色。DAG 依赖顺序逐段重写。

## Leading Words

| 术语 | 定义 |
|------|------|
| **DAG 依赖顺序** | 先编辑被其他段引用最少的段——改了 A 不会破坏 B |
| **逐段重写** | 每段独立编辑，确认后进入下一段 |

## 步骤

### 1. 按 H2 拆分 → 构建依赖图

段落 A 引用了 B 中的概念 → A 依赖 B。

### 2. 按依赖从少到多重写

每段：展示原稿 → 指出可改进处 → 用户确认 → 重写。

- 完成标准：全部段落重写完毕

### 3. 完整性检查

所有段间引用仍有效，风格一致。

## 外部参考

- `references/edit-examples.md` — DAG 构建示例、重写前后对比、常见编辑错误
