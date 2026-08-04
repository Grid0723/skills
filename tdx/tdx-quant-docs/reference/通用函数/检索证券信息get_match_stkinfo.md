---
title: "检索证券信息getmatchstkinfo | 通达信量化平台"
source: "https://help.tdx.com.cn/quant/docs/markdown/ctx.stock.md/mindoc-1hdguaia2v4bo.html#%E6%A3%80%E7%B4%A2%E8%AF%81%E5%88%B8%E4%BF%A1%E6%81%AF"
---

### 检索证券信息

```
def get_match_stkinfo(key_word:str = ''):
```

<br />

### [#](#输入参数) 输入参数

| 参数        | 是否必选 | 参数类型 | 参数说明 |
| --------- | ---- | ---- | ---- |
| key\_word | Y    | str  | 关键词  |

### [#](#输出数据) 输出数据

| 名称   | 类型 | 数值  | 说明   |
| ---- | -- | --- | ---- |
| Code | Y  | str | 证券代码 |
| Name | Y  | str | 证券名称 |

### [#](#接口使用) 接口使用

```
from tqcenter import tq
tq.initialize(__file__)
match_stkinfo = tq.get_match_stkinfo(key_word='通达信')
print(match_stkinfo)
```

<br />

### [#](#数据样本) 数据样本

```
[{'Code': '880515.SH', 'Name': '通达信88'},
{'Code': '880818.SH', 'Name': '通达信热股'},
{'Code': '688318.SH', 'Name': '财富趋势'}]
```

