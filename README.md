# skills

[![skills.sh](https://skills.sh/b/Grid0723/skills)](https://skills.sh/Grid0723/skills)

> 三线 Agent Skill 体系——36 个原子技能。不是一份技能清单，而是一套方法论的沉淀：让 AI 助手在软件工程、知识管理、陌生领域学习三条工作流上，每次都以相同的过程工作。

```text
$ grid
╭──────────────────────────────╮
│  welcome to the grid         │
│  > _                         │
╰──────────────────────────────╯
```

用系统对抗随机。用实践校验认知。用制度约束风险。用密度对抗稀释。用长期对抗波动。

## 是什么

**Agent Skill** 是写给 AI Agent 的指令包：一段触发描述 + 有序步骤 + 按需展开的参考。

本仓库把它系统化为 **36 个 skill**，按 7 个功能域组织，部署在三个层次（全局 / 知识库 / 项目）。演化自 Matt Pocock 的公开体系，但按个人工作流重构：有状态编排器、中文语境、知识管理脊椎、项目热插拔。

每条 skill 的设计目标只有一个：**让同类任务每次走相同的过程**。定义见 [writing-great-skills](./shared/writing-great-skills/SKILL.md)。

## 三条脊椎

| 脊椎 | 管什么 | 典型入口 | 详细章节 |
|---|---|---|---|
| **Grid** | 把事做出来：需求 → 方案 → 任务 → 实现 → 审查 | "帮我实现…"、"继续 CF-S1-F2-T3"、"跑完 S1" | [手册 §二](./docs/Grid%20Skills%20使用手册.md) |
| **Fabric** | 把认知留下来：捕获 → 归位 → 提炼 → 织网 | "保存这个"、"消化这篇"、"整理知识库" | [手册 §三](./docs/Grid%20Skills%20使用手册.md) |
| **Learn** | 把未知变成地图：建图 → 深挖 → 验证 → 收获 | "我要学 X"、"从零学 X" | [手册 §四](./docs/Grid%20Skills%20使用手册.md) |

Grid 管产出，Fabric 管沉淀，Learn 管输入前的地图。三者是一条流水线：Learn 的收获交给 Fabric，Fabric 的认知支撑 Grid 的决策。

## 功能域索引

| 功能域 | 数量 | 部署层 | 职责 | 入口 |
|---|---:|---|---|---|
| [shared](./shared/README.md) — 全局共享 primitive | 4 | 全局 | Skill 元规范、拷问、TDD、文档骨架 | [README](./shared/README.md) |
| [git](./git/README.md) — Git 工程 | 4 | 全局 | 安全护栏、提交与 CHANGELOG、分支生命周期、推送 | [README](./git/README.md) |
| [engineering](./engineering/README.md) — Grid 脊椎 | 9 | 全局 | 编排、PRD、任务、执行、审查、诊断、重构、治理 | [README](./engineering/README.md) |
| [knowledge](./knowledge/README.md) — Fabric 脊椎 | 8 | 知识库 | 捕获 → 分类 → 归位 → 提炼 → 输出 → 织网 + 体检 | [README](./knowledge/README.md) |
| [learning](./learning/README.md) — Learn 脊椎 | 5 | 知识库 | 建图 → 深挖 → 验证 → 收获 | [README](./learning/README.md) |
| [writing](./writing/README.md) — 写作体系 | 4 | 知识库 | 碎片 → 节拍 → 塑形 → 编辑（面向对外发表） | [README](./writing/README.md) |
| [project](./project/README.md) — 项目管理 | 2 | 知识库 | 生命周期（立项/计划/归档）、维护（回顾/链接） | [README](./project/README.md) |

每个域 README 含该域全部 skill 的一句话职责；完整触发条件、输入输出、协作关系见[使用手册](./docs/Grid%20Skills%20使用手册.md)。

## 三步上手

**1. 安装**

```bash
# 不指定 agent；统一装到 .agents/skills/

# 全局（所有项目可用）：shared + git + engineering，17 个
npx skills@latest add Grid0723/skills

# 项目级（只在该目录生效）：知识库专属（knowledge / writing / project / learning）
cd <项目目录>
npx skills@latest add Grid0723/skills
```

**2. 配置 AGENTS.md**

| 位置 | 写什么 |
|---|---|
| 全局 `~/.config/opencode/AGENTS.md` | 三条脊椎路由 + 守门规则（先确认再执行、Git 危险命令、提交自检） |
| Vault 根 `AGENTS.md` | 六目录架构、四态状态机、Fabric 阈值、Learn 交接规则 |
| 代码仓库根 `AGENTS.md` | skill 路由、项目专属 skill 声明、编号与 docs 结构（不写项目命令） |

原则：AGENTS.md 只放索引与路由，不放操作步骤。完整可复制片段（全局 / 知识库 / 代码仓库）见[使用手册 §一](./docs/Grid%20Skills%20使用手册.md)的「AGENTS.md 配置」。

**3. 开始**

直接说「保存这个」「帮我实现一个功能」「我要学 X」——编排器路由到原子 skill；加载后先确认再执行。

**更新**

```bash
npx skills@latest update
```

更新后跑 `setup-grid`（源/副本一致性）与 `evals/check-structure.ps1`（结构检查），重启会话确认列表。

完整安装路径、AGENTS.md 模板与更新流程见[使用手册 §一](./docs/Grid%20Skills%20使用手册.md)。

## 文档地图

| 文档 | 用途 | 详略 |
|---|---|---|
| [使用手册](./docs/Grid%20Skills%20使用手册.md) | 路由决策、阶段详解、36 个 skill 速查、协作链路、故障排查 | **详实**：操作级 |
| 各域 README | 单域 skill 一句话职责 | 索引级 |
| 双脊椎Agent Skill体系设计 | 架构总纲与设计原则（Vault `Grid/docs/`） | 设计级 |
| 部署手册 | 运行时位置、安装步骤、验证清单（Vault `Grid/docs/`） | 操作级 |
| [CHANGELOG](./CHANGELOG.md) | 版本变更与演化线 | 记录级 |

> 本 README 只做纲领与索引；具体怎么做、什么时候用哪个 skill、出错怎么查，统一看使用手册。

## 版本

**v2.2.7** · 36 个 skill · 2026-11-19
