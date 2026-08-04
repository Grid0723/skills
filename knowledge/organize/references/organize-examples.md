# 归位与 MOC 创建示例

## 归位前后对比

### 归位前（收集箱中）

```yaml
---
Author: 张谦
tags: [交易/量化]
类型: 剪藏
来源: 知乎
状态: 待整理
---
```

### 归位后（领域目录中）

```yaml
---
Author: 张谦
tags: [交易/量化, 交易/ETF]
关键词: [ETF轮动, 动量策略, 行业ETF, 回测框架]
类型: 永久笔记
description: 知乎文章——ETF 行业轮动策略的 Python 实现与回测框架搭建
状态: 已消化
---
```

## MOC 创建模板

当子标签下笔记 ≥3 篇时，提示用户建 MOC：

```markdown
---
Alias: ETF交易
tags: [交易/ETF]
类型: 索引
---

# ETF 交易 MOC

> 子主题索引 · 标签 `#交易/ETF`

## 策略类

```dataview
TABLE description AS 摘要
FROM #交易/ETF
WHERE contains(关键词, "策略") OR contains(关键词, "轮动")
SORT file.mtime DESC
```

## 工具类

```dataview
TABLE description AS 摘要
FROM #交易/ETF
WHERE contains(关键词, "工具") OR contains(关键词, "数据")
SORT file.mtime DESC
```

## 关联笔记

- [[10_领域/交易投资/交易投资MOC]] — 上级 MOC
```

MOC 存放位置：`10_领域/<领域>/<子主题>MOC.md`

## 织网检测触发

```
organize 完成 → 查询当前笔记 tags 中各子标签的笔记数
  → "交易/ETF" 下有 3 篇 → 提示 "该子标签下已有 3 篇笔记，是否需要建立 ETF 交易 MOC？"
  → 用户确认 → 在 10_领域/交易投资/ 下创建 ETF交易MOC.md
  → 用户拒绝 → 不建，备注可稍后通过 connect 全量扫描触发
```
