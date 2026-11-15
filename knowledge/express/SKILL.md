---
name: express
description: Fabric 输出阶段——路由到写作体系（fragments→beats→shape→edit-article）。Use when the user wants to write an article or produce finished output from distilled notes.
---

# express

Fabric 输出阶段——纯写作管道路由。不承担开启新项目的职能。

## Leading Words

| 术语 | 定义 |
|------|------|
| **写作管道路由** | 根据复杂度判断走部分还是完整写作管道 |
| **按需跳过** | 用户可跳过 fragments 直接从 beats 开始，或直接要求"写一篇文章"走全管道 |

## 入口判定

| 用户意图 | 路由 |
|---|---|
| 沉淀经验 / 技术笔记（给自己） | 不走写作管道 → `distill` |
| 碎片 / 灵感，面向发表 | `writing-fragments` |
| 有原料缺结构 | `fragments` → `beats` |
| 完整文章（给别人看） | 全管道 |
| 精炼已有文章 | `edit-article` |

边界不清时先问一句：**"这篇是给自己还是给别人看？"**

- 给自己 → `distill`，产出永久笔记
- 给别人 → 写作管道

## 步骤

### 1. 判断复杂度

根据用户输入判断：
- 碎片/灵感记录 → 推荐 `writing-fragments`
- 有原料但缺结构 → 推荐 `writing-fragments` → `writing-beats`
- 需要完整文章 → 推荐全管道：`fragments` → `beats` → `shape` → `edit-article`

- 完成标准：明确写作管道的起点

### 2. 推荐并确认

向用户展示推荐路径，用户可选择跳过某些步骤。

- 完成标准：用户确认管道顺序

### 3. 加载并路由

依次加载并触发对应写作 skill。每个 skill 完成后询问是否进入下一步。

- 完成标准：管道完成或用户中止

## 写作体系 Skill 链

```
writing-fragments → writing-beats → writing-shape → edit-article
     (碎片采集)      (节拍编排)      (逐段塑形)      (逐段重写)
```

## 外部参考

- `references/pipeline-routing.md` — 复杂度→管道映射表（5 个场景）、管道跳步协议
