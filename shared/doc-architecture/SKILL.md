---
name: doc-architecture
description: 项目文档的标准目录架构与撰写规范——8 目录骨架、07-MVP 计划格式、ADR 编号、S-F-T 任务编号与 Grid 阶段产出映射。Use when initializing a new project, setting up documentation, or when the user asks about documentation structure.
---

# doc-architecture

定义 `docs/` 的标准结构与固定文件格式。内容由各阶段产出，本 skill 只管**骨架与格式**。

## Leading Words

| 术语 | 定义 |
|------|------|
| **文档骨架** | 初始化时创建的目录与固定入口文件，只含模板，不含具体内容 |
| **固定入口** | 每个目录有一个约定文件（如 `系统架构.md`），Agent 先读它再按需展开 |
| **阶段产出映射** | Grid 每个阶段有明确的 docs 写入目标 |
| **编号体系** | `<项目码>-S<阶段>-F<功能>-T<任务>`；ADR 独立编号 |

## 标准目录

```text
docs/
├── README.md                 # 文档导航（我想了解 X → 看哪个文件）
├── CHANGELOG.md              # Keep a Changelog + SemVer
│
├── 01-Requirements/          # 必选
│   └── PRD-F<nn>-<功能名>.md
├── 02-Architecture/          # 必选
│   ├── 系统架构.md            # 固定入口
│   └── design/               # 按需：专题设计
├── 03-Database/              # 数据类项目
│   ├── 数据库设计.md
│   └── 数据字典.md            # 按需
├── 04-API/                   # 有 API 的项目
│   └── 接口契约.md
├── 05-ADR/                   # 必选
│   ├── 0000-ADR模板.md
│   └── ADR-<nnn>-<中文短名>.md
├── 06-DevOps/                # 必选
│   ├── 部署指南.md
│   ├── 环境.md               # 按需
│   └── CI.md                 # 按需
├── 07-MVP/                   # 必选
│   ├── 实施概览.md            # 固定入口：当前阶段、进度、下一步
│   ├── 开发计划.md            # 唯一任务源：S → F → T
│   ├── 实现日志.md            # 可选：按日期记录完成项与偏差
│   └── 计划/                 # 可选：单阶段任务 >10 个时拆
│       └── S<n>-<阶段名>.md
├── 08-Testing/               # 按需
│   ├── 测试手册.md
│   ├── 测试记录.md
│   └── S<n>-验收清单.md
└── 09-参考资料/               # 可选：外部资料、社区、竞品
```

## 编号体系

```text
<项目码>-S<阶段>-F<功能>-T<任务>

项目码：2–4 位大写（CF / IOT / TDX / TA / AR），固定不变
阶段：  S1、S2、S3…（整数，只增不减；禁止 S1.5 / R1）
功能：  F1、F2、F3…（阶段内递增，与 PRD 一一对应）
任务：  T1、T2、T3…（功能内递增；一个 Task = 一个 commit）
ADR：   ADR-001…（项目内递增，3 位，不复用，与 Task 解耦）
```

示例：

| 产物 | 编号 |
|---|---|
| 任务 | `CF-S1-F2-T3` |
| PRD | `PRD-F02-编辑菜单.md` |
| 分支 | `feature/CF-S1-F2` |
| commit | `feat(CF-S1-F2-T3): 编辑菜单表单接线` |
| 决策 | `ADR-049` |

## 固定文件格式

### 01-Requirements / PRD

```markdown
# PRD: <功能名>

## 目标
一句话描述要解决的问题。

## 功能域（可选 · 功能域 ≥3 时填）
目标 → 功能域 → 功能项 三层，叶子标 `F<nn>`，与开发计划对应。

## 范围
- 包含：…
- 不包含：…

## 接缝（可独立验证点）
- [ ] Seam 1: …
- [ ] Seam 2: …

## 约束
## 风险
```

命名：`PRD-F<nn>-<功能名>.md`；小项目可省略 F 号，但同一仓库内必须一致。

### 05-ADR

```markdown
# ADR-<nnn>: <决策标题>

- 状态: 通过 / 搁置 / 废弃
- 日期: YYYY-MM-DD
- 决策: 我们选择 X 而非 Y
- 理由: 因为…
- 代价: 但代价是…
- 替代方案: 考虑过 A、B、C
```

命名：`ADR-<3 位>-<中文短名>.md`；模板固定为 `0000-ADR模板.md`。编号不复用。

### 07-MVP / 实施概览

只回答三个问题，不堆任务：

```markdown
# 实施概览

## 当前阶段
S<n> · <阶段名>（进度 x/y）

## 正在做什么
一句话。

## 下一步
下一件要执行的事。
```

### 07-MVP / 开发计划

唯一任务源：

```markdown
## S1 · <阶段名>

### F1 · <功能名>
- [ ] CF-S1-F1-T1 <任务描述> — Done when: <可验证判据>
- [ ] CF-S1-F1-T2 <任务描述> — Done when: <可验证判据> — 依赖: CF-S1-F1-T1

### F2 · <功能名>
- [ ] CF-S1-F2-T1 <任务描述> — Done when: <可验证判据> — 依赖: CF-S1-F1-T2
```

规则：

- 一个 Task = 一个 commit
- 每个 Task 必须有 `Done when`
- `依赖:` 只在存在真实阻塞时写，值为 Task ID，多个用英文逗号分隔；省略该字段视为无依赖
- 依赖不得成环；跨功能、跨阶段的阻塞一律用完整 Task ID 表达
- 一个功能一个分支（`feature/<项目码>-S<n>-F<n>`）
- `计划/` 只是本文件的阶段拆分，不允许出现第二份任务清单

### 02-Architecture / 系统架构

模块职责、技术栈、目录结构、核心数据流、关键设计原则；专题设计放 `design/`。架构图怎么画见下文「架构视图」。

### 03-Database

`数据库设计.md`：Mermaid ER 图 + 表结构 + 索引；`数据字典.md`：字段级说明。

### 04-API

内部契约或 OpenAPI 链接；与项目自建的 API 契约校验 skill 对齐。

### 06-DevOps

`部署指南.md`（环境搭建、启动）、`环境.md`（依赖与变量）、`CI.md`（流水线）。

### 08-Testing

`测试手册.md`（用例）、`测试记录.md`（执行归档）、`S<n>-验收清单.md`（阶段验收）。

### CHANGELOG

Keep a Changelog + SemVer；写入校验见 `git-commit` 的 CHANGELOG 模式。

## 架构视图

六类架构图各自回答一个不同的问题。**默认只画系统架构的进程拓扑与核心数据流两张**，其余按条件触发——不是初始化时铺满。

| 视图 | 触发条件 | 落地位置 |
|---|---|---|
| 系统架构 | 需部署运行的项目（必选） | `02-Architecture/系统架构.md` |
| 技术架构 | 分层 ≥2 且团队 ≥2 人 | `02-Architecture/design/技术架构.md` |
| 功能架构 | 功能域 ≥3 | PRD 的「功能域」小节 |
| 产品架构 | 有外部真实用户的产品 | `09-参考资料/产品架构.md` |
| 信息架构 | 页面 ≥5 或导航 ≥3 级 | `02-Architecture/design/信息架构.md` |
| ER | 有持久化数据库 | `03-Database/数据库设计.md` |

生成指令（剪枝规则、可复制 Prompt、反例、自检清单）见 `references/架构视图指南.md`。

三条硬规则：

- **一图一问**：标题写成问句或断言（「请求如何从 UI 到数据库」），不写「架构图」
- **显式剪枝**：必须带数值上限（节点数 / 层数 / 深度），不接受"适量""精简"
- **不跨图重复**：需要引用时写「详见 `系统架构.md`」，不复制节点

## Grid 阶段 → 文档产出

| 阶段 | 产出 | 写入目标 |
|---|---|---|
| to-prd | PRD | `01-Requirements/PRD-F<nn>-<名>.md` |
| to-issues | 开发计划 | `07-MVP/开发计划.md` |
| 编码 → code-review | ADR | `05-ADR/ADR-<nnn>-<名>.md` |
| implement | 实现日志 | `07-MVP/实现日志.md` |
| project-maintain | 里程碑总结 | `07-MVP/实施概览.md` |

## 新项目初始化

1. 创建目录与固定入口文件（从 `references/templates/` 复制）。
2. 若已有代码：从目录结构生成 `系统架构.md`，从 schema 生成 `数据库设计.md`，从包配置生成 `部署指南.md`。
3. 画架构图前先读 `references/架构视图指南.md`，只画已触发条件的视图（默认系统架构 + 数据流两张）。
4. 生成 `README.md` 导航表，只链接实际存在的文件。
5. 确定项目码并写入 `07-MVP/实施概览.md`。

## Agent 查阅顺序

1. `docs/README.md` → 定位
2. 对应固定入口文件 → 读约束
3. 项目 skill 的 references
4. 仍无答案 → `grilling`

## 边界

- 不替代代码仓库的 README；docs 面向开发过程，README 面向使用者
- 不在 docs 里复制代码；只写约束、决策与契约
- 旧项目迁移按需进行，不强制一次改完

## 外部参考

- `references/templates/` — 各目录空白模板（按本 SKILL.md 格式维护）
- `references/架构视图指南.md` — 六类架构图的取舍表与通用规则
- `references/views/` — 六类架构图的生成指令（Prompt + 剪枝 + 反例 + 自检）
- `references/instances/` — 数据管道类 / 全栈 Web 类的项目实例化配置
