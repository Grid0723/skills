# skills

双脊椎 Agent Skill 体系——40 个原子技能 + 16 个 reference 文件，按 8 个功能域分组。未经部署——设计编制完成，待执行 [[部署手册]]。

## 全局共享 primitive

被两条脊椎和所有项目引用的底层技能。

- **[writing-great-skills](./shared/writing-great-skills/SKILL.md)** — 编写 Skill 的元规范：**从随机系统中拧出确定性**——四轴领域模型 + 本体系专属约定。写任何 Skill 之前必读。含 GLOSSARY.md 术语表。
- **[grilling](./shared/grilling/SKILL.md)** — 一对一接力式面试：**每次一个问题，把模糊想法具体化**。能探索不提问。含 references/examples.md（4 个完整交互场景）。
- **[tdd](./shared/tdd/SKILL.md)** — 红绿循环测试标准：**接缝驱动**——先写失败测试、最小实现、重构清理。含常见反模式定义 + references/mocking.md + references/tests.md。
- **[doc-architecture](./shared/doc-architecture/SKILL.md)** — 项目文档的**标准 8 目录骨架**——每目录撰写规范、Grid 阶段产出映射、含 10 个空白模板 + 2 个项目实例化配置。

## Git 工程工具

按 Grid 阶段分散的原子规范，项目前缀格式由各项目 AGENTS.md 声明。

- **[git-guardrails](./git/git-guardrails/SKILL.md)** — **拦截危险的 Git 命令**，防止不可逆破坏。危险操作走审批门——先展示影响范围，确认后执行。
- **[git-commit-guide](./git/git-commit-guide/SKILL.md)** — 通用提交原则：**一个 commit 只做一件事，小步快跑**。前缀格式（feat/fix/refactor）由各项目 AGENTS.md 声明。
- **[git-branch-plan](./git/git-branch-plan/SKILL.md)** — 拆解任务后规划分支：**短命分支、从最新 main 拉出**——命名策略和创建命令。
- **[git-branch-lifecycle](./git/git-branch-lifecycle/SKILL.md)** — 长周期分支管理：**定期同步、冲突预防**——合并策略选择和生命周期收尾。

## Grid 脊椎

软件开发生命周期编排器的内核——包含总编排器和被它引用的原子步骤。

- **[grid](./engineering/grid/SKILL.md)** — **总编排器**：路由→拷问→PRD→拆Issue→编码→超大任务规划。判断任务类型，推荐阶段序列和项目技能。
- **[to-prd](./engineering/to-prd/SKILL.md)** — 将对话综合为 PRD：**不采访用户，纯综合已有讨论**。接缝优先。审批后写入。含 references/prd-template.md。
- **[to-issues](./engineering/to-issues/SKILL.md)** — PRD 拆为垂直切片：**Tracer bullet——每个切片贯穿所有层，可独立演示**。含 references/tracer-bullet-examples.md。
- **[code-review](./engineering/code-review/SKILL.md)** — 双轴并行审查：**Standards + Spec，独立 sub-agent 上下文，报告不合并**。含 references/review-templates.md。
- **[wayfinder](./engineering/wayfinder/SKILL.md)** — DevOps 类大型重构的战争迷雾规划：**每 session 一个 ticket，解决后视野扩大**。含 references/ticket-map-examples.md。

## Fabric 脊椎

知识管理 CODE 工作流——包含总编排器和被它引用的原子步骤。

- **[fabric](./knowledge/fabric/SKILL.md)** — **总编排器**：捕获→分类→归位→提炼→输出→织网。路由判断阶段，嵌入织网检测，挂靠项目管理。
- **[capture](./knowledge/capture/SKILL.md)** — 捕获到收集箱：**捕获不加判断、不求全**。URL/灵感 → `00_收集箱/`，`状态: 待整理`。
- **[classify](./knowledge/classify/SKILL.md)** — 判断归属：**文件夹定位置，标签管主题**——对照 9 领域表决定物理目录，不确定的标待归类。
- **[organize](./knowledge/organize/SKILL.md)** — 归位：**物理移动+标签更新，完成后嵌入织网检测**——子标签 ≥3 篇时提示建 MOC。
- **[distill](./knowledge/distill/SKILL.md)** — 渐进式总结提炼：**四层递进——加粗→高亮→执行摘要**，让未来的自己在 10 秒内抓住核心价值。完成后检 ≥5 融合 hub。
- **[express](./knowledge/express/SKILL.md)** — Fabric 输出阶段——**写作管道路由**。按复杂度判断走 fragments→beats→shape→edit 的部分或全部。
- **[connect](./knowledge/connect/SKILL.md)** — 全量知识库扫描：**找出所有该建 MOC 或融合 hub 的地方**——L1 标签统一→L2 建 MOC→L3 补双链→L4 融合 hub。

## 写作体系

Matt Pocock 的 Explore/Exploit 写作心智模型。

- **[writing-fragments](./writing/writing-fragments/SKILL.md)** — Explore 阶段：**追问式访谈，碎片化采集原料**。最有价值的碎片是"承重"的命名隐喻。
- **[writing-beats](./writing/writing-beats/SKILL.md)** — Exploit 阶段：**节拍编排 + Grounding 机制**——每个概念在被使用前必须已接地，维护"已接地清单"。
- **[writing-shape](./writing/writing-shape/SKILL.md)** — Exploit 阶段：**逐段塑形——节拍→完整文章**。每个段落加衔接桥，继续 Grounding 验证。
- **[edit-article](./writing/edit-article/SKILL.md)** — Exploit 阶段：**DAG 依赖顺序逐段重写**——按 H2 拆分，先编辑依赖最少的段落。

## 项目管理

挂靠 Fabric 编排器的独立原子技能组。

- **[project-init](./project/project-init/SKILL.md)** — 创建新项目：**总览文档+外部链接，`项目阶段: 启动`**。阶段流转：启动→进行中→暂停→收尾→完成→归档。
- **[project-plan](./project/project-plan/SKILL.md)** — 按功能模块分组任务：**任务用 `#项目/<名>` 标签归属**，可在任意笔记中执行。
- **[project-review](./project/project-review/SKILL.md)** — 里程碑回顾：**基于 CHANGELOG/commit log 更新「📝 里程碑总结」**——核心变更、关键决策、所学经验。
- **[project-links](./project/project-links/SKILL.md)** — 维护外部链接：**`file:///` 本地路径和外部 URL**，统一聚合于 `20_项目/外部链接.md`。
- **[project-archive](./project/project-archive/SKILL.md)** — 项目收尾：**先反哺知识到 `10_领域`，再移入 `90_归档`**。先提炼再归档——归档后就很少再访问了。

## TDX 项目专属

TDX 数据采集项目的热插拔技能——Python + PostgreSQL + TdxQuant。

- **[tdx-quant-docs](./tdx/tdx-quant-docs/SKILL.md)** — TdxQuant API 文档查阅：**tqcenter 60+ API 的返回值、约束、场景示例**——批量上限 99 只、日期格式 YYYYMMDD。
- **[loguru](./tdx/loguru/SKILL.md)** — Loguru 日志库：**全局单例 logger + sink 注册**——轮转、格式化、异常捕获、结构化日志。
- **[prisma-docs](./tdx/prisma-docs/SKILL.md)** — Prisma ORM 操作规范：**Schema-first 设计 + 安全红线**——金额 DECIMAL(36,18)、安全红线禁止自动迁移。
- **[tdx-dev-guide](./tdx/tdx-dev-guide/SKILL.md)** — 新增获取器的 10 步流程：**Cleaner→Fetcher 流水线 + 注册制**——从 API 分析到 CLI 注册。
- **[tdx-test-spec](./tdx/tdx-test-spec/SKILL.md)** — 集成测试规范：**CLI 验收 + dry_run 先行 + 全链路验证**。

## trading-assistant 项目专属

交易助手项目的热插拔技能——NestJS + Prisma + TypeScript 全栈。

- **[nest-generate](./trading-assistant/nest-generate/SKILL.md)** — NestJS 代码生成：**NodeNext 模块系统 + DTO 验证栈**——金额字段以 string 传输。
- **[prisma-sync](./trading-assistant/prisma-sync/SKILL.md)** — 双份 Schema 同步：**SSOT 设计稿 → 实现稿**——只同步 model/enum，不碰 datasource/generator。
- **[finance-review](./trading-assistant/finance-review/SKILL.md)** — 金融计算审查：**decimal.js 审计——禁止原生浮点运算**。扫描 `+ - * /` 在变量运算上下文中的出现。
- **[api-contract](./trading-assistant/api-contract/SKILL.md)** — OpenAPI 契约校验：**契约基准——后端 Controller + 前端 API 调用双端独立检查**。
- **[doc-sync](./trading-assistant/doc-sync/SKILL.md)** — 文档同步：**代码变更 → 文档更新——文档驱动开发**。每类变更对应一组应同步的文档。
- **[ta-test-spec](./trading-assistant/ta-test-spec/SKILL.md)** — 测试规范：**lint 门 + test 门 + 类型守卫**——禁 any、Mock Prisma、decimal.js 断言。
