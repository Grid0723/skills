---
name: setup-grid
description: Grid Skill 体系部署检查——比对源仓库与运行副本、版本号、skill 数量、AGENTS.md 注册表与权限配置，输出报告与修复建议。Use when the user says "检查部署"、"verify skills"、"装好了吗"、"为什么 skill 没生效".
---

# setup-grid

部署一致性检查。只读扫描，不修改任何文件。

## Leading Words

| 术语 | 定义 |
|---|---|
| **源仓库** | `Grid/skills`，GitHub 上的唯一真相 |
| **运行副本** | 全局 `~/.agents/skills/` 与项目 `.agents/skills/` |
| **漂移（Drift）** | 源仓库与运行副本内容不一致——手工修改、部署遗漏或版本滞后是主因 |

## 步骤

### 1. 定位路径

| 项 | 默认值 |
|---|---|
| 源仓库 | `10_领域/编程技术/Agent Skills/Grid/skills` |
| 全局副本 | `~/.agents/skills` |
| 项目副本 | `<vault>/.agents/skills` |

用户提供路径时以用户为准。

- 完成标准：三个路径已确认存在

### 2. 比对内容

对源仓库中每个 `SKILL.md`：

1. 在全局或项目副本中找到同名 skill
2. 用哈希或 `git diff --no-index` 比对
3. 记录三类结果：缺失 / 内容不一致 / 仅副本存在

注意：项目级 skill（fabric/learn/knowledge 域）不在全局层出现属于正常，不要报为缺失。

- 完成标准：差异清单已产出

### 3. 校验结构

- 每个 `SKILL.md` 有 `name` 与 `description`
- 编排器（fabric / grid / learn）无 `disable-model-invocation`
- skill 总数与 `README.md`、`skills.sh.json` 声明一致
- 有 `evals/` 时可先跑 `evals/check-structure.ps1`

- 完成标准：结构异常清单已产出

### 4. 核对注册表

- `AGENTS.md` 的 Skill 表是否列出新增/更名的 skill
- `opencode.json` 的 `permission.skill` 是否误拦编排器

- 完成标准：注册表差异已列出

### 5. 输出报告

```text
部署检查
- 源仓库: 49 个 skill
- 全局副本: 21 个（缺失 28，属项目级，正常）
- 项目副本: 21 个
- 内容不一致: 0
- 结构异常: 0
- 注册表缺失: 0
结论: 通过
```

- 完成标准：报告已展示，修复建议已给出

## 边界

- 不修改文件、不 commit、不 push
- 不自动执行 `npx skills add`，只提示命令
- 副本缺失但属于项目级 skill 时，标记为「正常」

## 外部参考

- `references/check-deploy.md` — 路径模板、diff 命令、常见漂移案例
