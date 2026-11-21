# Engineering

Grid 脊椎内核——软件开发生命周期编排器的原子步骤。

## 用户调用

仅手动输入名称触发——编排性质，有副作用。

- **[grid](./grid/SKILL.md)** — **总编排器——路由→拷问→PRD→拆Issue→编码→超大任务规划**。判断任务类型、推荐阶段序列和项目技能、驱动编码内循环。
- **[to-prd](./to-prd/SKILL.md)** — 将对话综合为 PRD：**不采访用户，纯综合已有讨论**。接缝优先——每个 seam 对应一个可独立验证点。审批门：草案展示→确认→写入 `docs/01-Requirements/`。
- **[to-issues](./to-issues/SKILL.md)** — PRD 拆为垂直切片：**Tracer bullet——每个切片贯穿所有层，可独立演示**。写入 `07-MVP/开发计划.md`，编号 `<项目码>-S<阶段>-F<功能>-T<任务>`，一个 Task 一个 commit。
- **[implement](./implement/SKILL.md)** — 执行 Task：**默认单任务，显式 `S<n>` 进入批量**。读原文 → 确认 seam → tdd → 端到端验证（有资产时）→ code-review → 一个 Task 一个 commit。
- **[verification](./verification/SKILL.md)** — 端到端验证：**功能地图 + 一键驱动，让 agent 自己证明改动有效**。核心路径 ≤10 条，退出码判定；输出作为 code-review 的 `已复现` 证据。
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** — 难 bug 诊断：**先建红色反馈环 → mutation diff 验真 → 最小化 → 假设 → 埋点 → 修复 + 回归**。
- **[code-review](./code-review/SKILL.md)** — 双轴并行审查：**Standards（加载项目审查 skill）+ Spec（独立上下文），报告不合并**。两个 sub-agent 各自有独立上下文，审查互不污染。审查报告写入 `docs/05-ADR/`。
- **[wayfinder](./wayfinder/SKILL.md)** — DevOps 类大型重构的战争迷雾规划：**每 session 一个 ticket，解决后视野扩大**。4 种 ticket 类型：research/prototype/grilling/task。Plan, don't do——只规划路在哪。
- **[setup-grid](./setup-grid/SKILL.md)** — 部署一致性检查：**源仓库 vs 运行副本 diff、版本、数量、注册表**。只读报告，不自动改。
- **[retro](./retro/SKILL.md)** — 会话后复盘：**把失败模式写成 Gotchas**，并建议版本号。只改 Gotchas，不改正文逻辑。
