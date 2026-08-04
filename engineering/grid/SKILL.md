---
name: grid
description: 软件开发生命周期总编排器——从模糊想法到代码合并的全流程路由与调度。Use when the user has a software development task（新功能、bug修复、重构、配置变更），or says "帮我实现"、"写代码"、"改 bug"。
disable-model-invocation: true
---

# Grid

软件开发生命周期总编排器。接收任务描述 → 路由判断类型 → 按阶段驱动原子 skill → 编码内循环推进。

## Leading Words

| 术语                             | 定义                                 |
| ------------------------------ | ---------------------------------- |
| **路由（Routing）**                | 判断任务类型（新功能/bug修复/重构/配置变更），跳过不必要的阶段 |
| **管道（Pipeline）**               | Grid 的阶段序列——每一阶段有明确的产出物和退出条件       |
| **技能推荐（Skill Recommendation）** | 扫描项目 AGENTS.md 注册的技能列表，根据任务类型动态推荐  |
| **编码内循环（Inner Loop）**          | 开发计划中的任务逐项推进：写测试→写实现→审查→标记完成       |
| **审批门**                        | PRD、开发计划等正文必须先展示草案，用户确认后写入         |

## 阶段序列

```bash
路由 → 拷问 → PRD → 拆Issue → 编码(内循环) → 超大任务规划
```

## 步骤

### 1. 路由——判断任务类型

读取用户输入，判断类型，决定走哪些阶段：

| 类型 | 判断条件 | 跳过 |
|------|---------|------|
| 新功能 | 用户描述了一个尚不存在的功能 | 无 |
| Bug 修复 | 用户描述了异常行为或错误 | PRD（直接拷问→拆Issue→编码） |
| 重构 | 用户要求改结构不改功能 | PRD（拷问→拆Issue→编码→审查） |
| 配置变更 | 用户要求改配置/依赖/环境 | PRD、拆Issue（拷问→编码） |

**技能推荐**：扫描当前项目 AGENTS.md 中的 `skills:` 声明列表，根据任务类型推荐相关技能。

> 示例输出：
> 本次任务：新增 ETF 数据获取器（新功能）
> 阶段序列：拷问 → PRD → 拆 Issue → 编码 → 审查
> 建议加载：`tdx-quant-docs` + `tdx-dev-guide` + `loguru` + `tdx-test-spec`
> 是否确认？

- 完成标准：任务类型已判定，阶段序列已确认，技能推荐已展示

### 2. 拷问——引用 grilling

加载 `grilling` skill，执行一问一答式拷问。把模糊想法具体化到可写 PRD。

- 完成标准：用户表示"可以了"或"开始写 PRD 吧"
- 如果用户需求本已足够清晰 → 跳过，直接进入 PRD

### 3. PRD——引用 to-prd

加载 `to-prd` skill，综合对话生成 PRD 草案。接缝优先——每个 seam 对应可独立验证点。

- 完成标准：PRD 已写入 `docs/01-Requirements/PRD-xxx.md`

### 4. 拆 Issue——引用 to-issues

加载 `to-issues` skill，PRD → tracer bullet 垂直切片，写入 `开发计划.md`。每个 Task 可独立演示和验证。

拆解完成后自动提示调用 `git-branch-plan`：
> 建议创建分支 `feature/<功能名>`，是否执行？

- 完成标准：开发计划已写入，分支已创建（如适用）

### 5. 编码——内循环驱动

逐任务推进编码内循环。对开发计划中的每个 Task：

```bash
未完成 Task → 写测试(引用 tdd) → 写实现 → 测试通过 → 审查(引用 code-review) → 标记完成
```

- 每完成一个 Task：标记 `- [x]`
- 审查通过：写入 ADR
- 审查需修改：回到实现步骤
- 全部 Task 完成：编码阶段结束
- 完成标准：开发计划中全部 Task 标记完成

### 6. 超大任务规划——引用 wayfinder（条件触发）

仅当任务是 DevOps 类大型重构/迁移（如"pandas 迁移到 Polars"）时触发。加载 `wayfinder` skill。

- 完成标准：共享地图已建立，第一个 ticket 已规划

## 全局约束

编码阶段全程遵守：
- `karpathy-guidelines` —— LLM 编码行为规范
- `git-guardrails` —— 禁止自动 git add/commit/push
- `git-commit-guide` —— 完成一个小功能点立即提交

## 内部引用

| 阶段 | 引用的原子 skill |
|------|-----------------|
| 拷问 | `grilling` |
| PRD | `to-prd` |
| 拆 Issue | `to-issues` → `git-branch-plan` |
| 编码 | `tdd` → `code-review` → `git-commit-guide` |
| 超大任务规划 | `wayfinder` → `git-branch-lifecycle` |

## 项目技能扫描

编码阶段扫描项目仓库 AGENTS.md 中的 `skills:` 声明，动态加载对应技能。技能列表随项目不同而热插拔。
