---
Author: 张谦
tags: []
创建: 2026-07-15 14:59:18
修改: 2026-07-28 15:29:29
---

# 项目文档索引

`docs/` 目录为本项目的设计基准，按"文档驱动开发"原则组织。

## 文档结构

```bash
docs/
├── README.md                     # 📖 本文档
├── CHANGELOG.md                  # 版本变更记录
│
├── 01-Requirements/              # 📋 需求文档
│   └── PRD-<功能名>.md           # 产品需求文档
│
├── 02-Architecture/              # 🏗️ 架构文档
│   ├── 系统架构.md               # 系统架构总览
│   └── 开发指南.md               # 开发流程与规范
│
├── 03-Database/                  # 🗄️ 数据库设计
│   ├── 数据库设计.md             # ER 图 + 表结构
│   └── 数据字典.md               # 字段级说明
│
├── 04-API/                       # 🔌 API 契约
│   └── 接口契约.md               # 接口定义
│
├── 05-ADR/                       # 📝 架构决策记录
│   └── <序号>-<标题>.md          # 决策记录
│
├── 06-DevOps/                    # 🚀 运维部署
│   ├── 部署指南.md               # 环境搭建
│   └── 故障排查.md               # FAQ
│
├── 07-MVP/                       # 🎯 实施
│   ├── 实施概览.md               # 目标 + 功能清单
│   ├── 实现日志.md               # 里程碑记录
│   └── 开发计划-<功能名>.md      # 功能开发计划
│
└── 08-Testing/                   # 🧪 测试
    ├── 测试手册.md               # 测试用例
    └── 测试记录.md               # 执行记录
```

## 快速导航

| 我想… | 去看… |
|---|---|
| 了解系统功能 | [01-Requirements/](./01-Requirements/) |
| 理解架构 | [02-Architecture/系统架构.md](./02-Architecture/系统架构.md) |
| 搭建环境 | [06-DevOps/部署指南.md](./06-DevOps/部署指南.md) |
| 查数据库 | [03-Database/数据库设计.md](./03-Database/数据库设计.md) |
| 看 API 定义 | [04-API/](./04-API/) |
| 了解设计决策 | [05-ADR/](./05-ADR/) |
| 排查问题 | [06-DevOps/故障排查.md](./06-DevOps/故障排查.md) |
| 开发新功能 | [02-Architecture/开发指南.md](./02-Architecture/开发指南.md) |
| 查看进度 | [07-MVP/实施概览.md](./07-MVP/实施概览.md) |
| 查看版本变化 | [CHANGELOG.md](./CHANGELOG.md) |

## 相关资源

- **代码仓库**: `../`
- **配置文件**: `../config.yaml` / `../pyproject.toml` / `../package.json`
- **智能体规范**: `../AGENTS.md`
