---

title: "获取每天的股本数据getgbinfo | 通达信量化平台"
source: "<https://help.tdx.com.cn/quant/docs/markdown/mindoc-1ctuhthaq5qmg/mindoc-1h3ru0b1tssrc.html>"
---

### [#](#获取指定股票的股本数据) 获取指定股票的股本数据

```
def get_gb_info(stock_code:str = '',
                date_list: List[str] = [],
                count: int = 1):
```

1\
2\
3

### [#](#输入参数) 输入参数

| 参数          | 是否必选 | 参数类型       | 参数说明   |
| :---------- | :--- | :--------- | :----- |
| stock\_code | Y    | str        | 股票代码   |
| date\_list  | Y    | List\[str] | 日期数组   |
| count       | Y    | int        | 日期有效个数 |

- date\_list传入的日期须从小到大排序
- date\_list有效数据个数须不小于count，且不能小于1

### [#](#输出数据) 输出数据

| 名称   | 类型     | 数值     | 说明   |
| :--- | :----- | :----- | :--- |
| Date | double | <br /> | 日期   |
| Zgb  | double | <br /> | 总股本  |
| Ltgb | double | <br /> | 流通股本 |

### [#](#接口使用) 接口使用

```
from tqcenter import tq
tq.initialize(__file__)
gb_info = tq.get_gb_info(stock_code = '688318.SH', date_list=['20250101','20250601'], count=2)
print(gb_info)
```

1\
2\
3\
4

### [#](#数据样本) 数据样本

```
[{'Date': 20250101, 'Zgb': 182942480.0, 'Ltgb': 182942480.0},
{'Date': 20250601,  'Zgb': 182942480.0, 'Ltgb': 182942480.0}]
```

1\
2
