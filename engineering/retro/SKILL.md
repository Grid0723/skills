---
name: retro
description: 会话后复盘——把失败模式与绕路写成对应 SKILL.md 的 Gotchas 条目，并建议是否升版本。Use when the user says "复盘一下"、"这个 skill 哪里不好用"、"为什么又走错了".
---

# retro

把一次会话的失败经验沉淀为 skill 的 Gotchas。只改 Gotchas，不改正文逻辑。

## Leading Words

| 术语 | 定义 |
|---|---|
| **Gotcha** | 一个具体的失败模式：什么现象 → 正确做法 |
| **可回填** | 能在对应 skill 的步骤里找到落点的经验；找不到落点的不强行塞入 |
| **最小改动** | 一次只追加 1–3 条 Gotchas，不重构 skill |

## 步骤

### 1. 收集失败点

来源：用户指出 / agent 自查 / 回归测试未通过项。

每条写成：`现象 → 原因 → 正确做法`。

- 完成标准：失败点清单已列出

### 2. 定位 skill

| 失败点 | 落点 |
|---|---|
| 路由错、跳过阶段 | 对应编排器（fabric / grid / learn） |
| 前置条件未检查 | 对应原子 skill |
| 输出格式错 | 对应规范类 skill |
| 找不到落点 | 记入会话结论，不进 skill |

- 完成标准：每条失败点都有落点或明确放弃

### 3. 写入 Gotchas

在目标 `SKILL.md` 末尾追加：

```markdown
## Gotchas

- <现象> → <正确做法>
```

规则：

- 一条一行，不写长篇
- 只写「会再犯」的错，不复述正常流程
- 已有相同条目则合并，不重复

- 完成标准：diff 已展示，用户确认

### 4. 建议版本

| 改动 | SemVer |
|---|---|
| 1–2 条 Gotchas | patch（x.y.Z+1） |
| 改变触发词或流程 | minor |
| 删除 / 重命名 skill | major |

- 完成标准：版本建议已给出

## 边界

- 只改 `## Gotchas` 节，不改正文逻辑
- 不 commit / push
- 找不到落点的经验不强行塞进 skill

## 外部参考

- `references/gotcha-examples.md` — 好 / 坏 Gotcha 对比
