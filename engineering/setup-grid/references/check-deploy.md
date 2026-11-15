# 部署检查参考

## 路径模板

| 平台 | 全局副本 | 项目副本 |
|---|---|---|
| Windows | `C:\Users\<user>\.agents\skills` | `<vault>\.agents\skills` |
| macOS / Linux | `~/.agents/skills` | `<vault>/.agents/skills` |

源仓库固定为 Vault 内 `10_领域/编程技术/Agent Skills/Grid/skills`。

## 比对命令

```powershell
# 单目录比对（退出码 1 表示有差异）
git diff --no-index --stat "<全局副本>" "<源仓库>/<功能域>/<skill>"

# 批量列出差异
Get-ChildItem "<源仓库>" -Recurse -Filter SKILL.md |
    ForEach-Object { ... }
```

## 常见漂移

| 现象 | 原因 | 处理 |
|---|---|---|
| 副本多一条规则 | 只在 Vault 副本改过，未回写源仓库 | 先回写源仓库，再同步副本 |
| 副本少一个 skill | 新增后未部署 | `npx skills@latest add Grid0723/skills -a opencode` |
| 编排器从列表消失 | 误加 `disable-model-invocation` | 删除该字段 |
| 项目级 skill 报缺失 | 全局层本就不含 knowledge/learning 域 | 标记正常，不修复 |
| 版本号对不上 | README / CHANGELOG / tag 三处未同步 | 以 tag 为准，回填文档 |

## 判断规则

- **内容不一致**：必须修复，否则同一 skill 在不同会话表现不同。
- **副本缺失**：先判断层级，项目级缺失不算问题。
- **结构异常**：按 `evals/check-structure.ps1` 的输出处理，失败项必修，警告项按 `retro` 逐步回填。
