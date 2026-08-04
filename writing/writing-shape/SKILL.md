---
name: writing-shape
description: 写作 Exploit 阶段——将节拍序列逐段塑形为完整文章，使用 Grounding 机制确保可读性。Use after beats are arranged——this step shapes each beat into polished prose.
---

# writing-shape

写作 Exploit 阶段的逐段塑形。将已编排的节拍序列逐一塑形为完整段落。继续使用 **Grounding（接地）机制**。

## Leading Words

| 术语 | 定义 |
|------|------|
| **逐段塑形** | 每次只处理一个 beat，塑形成完整段落后再进入下一个 |
| **衔接桥** | 段与段之间的过渡句——让读者顺畅地从 A 滑入 B |

## 步骤

### 1. 读节拍序列

读取 `writing-beats` 产出的 beats 序列。

- 完成标准：理解每个 beat 的内容和 Grounding 依赖

### 2. 逐段塑形循环

对每个 beat：
1. 展开碎片为完整段落——用自己的语言
2. 验证 Grounding——当前段依赖的概念在前面已接地
3. 写衔接桥——当前段与上一段之间加过渡句
4. 展示该段给用户确认

- 完成标准：全部 beats 已塑形为连贯文章

### 3. 全文通读

整合所有段落后通读全文，检查：
- Grounding 完整性——每个概念在出现时读者已能理解
- 衔接流畅性——段间过渡自然
- 节奏——有无过密或过疏的段落

- 完成标准：文章可发布

## 成品特征

- 每个段落服务于一个 beat
- 没有"跳读"概念——读者无需中途搜索定义
- 衔接桥让文章读起来是"一步到位的旅程"

## 外部参考

- `references/shape-examples.md` — 完整改造示例（beat→段落）、3 种衔接桥模式（转折/递进/举例）、4 种常见塑形错误
