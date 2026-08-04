---

title: "获取股票的单个财务数据getgpone\_data | 通达信量化平台"
source: "<https://help.tdx.com.cn/quant/docs/markdown/TdxQuant.md/mindoc-1h10pk3rsg044.html>"
---

## 获取股票的单个财务数据get\_gp\_one\_data

### 根据证券代码，获取股票的单个数据

```python
get_gp_one_data(stock_list: List[str] = [],
                field_list: List[str] = []) -> Dict:
```

### 输入参数

| 参数        | 是否必选 | 参数类型   | 参数说明                                                                                                                         |
| :---------- | :------- | :--------- | :------------------------------------------------------------------------------------------------------------------------------- |
| stock\_list | Y        | List\[str] | 证券代码列表                                                                                                                     |
| field\_list | Y        | List\[str] | 字段筛选，不能为空（如 `GO47` 表示是第47号个股数据最新业绩预告 本期扣非净利润预计同比增减幅上限%）这个值，GO为gp one的首字母大写 |

### 输出数据

| 名称 | 类型   | 数值   | 说明                                                                    |
| :--- | :----- | :----- | :---------------------------------------------------------------------- |
| GO1  | double | <br /> | 发行价(元)                                                              |
| GO2  | double | <br /> | 总发行数量(万股)                                                        |
| GO3  | double | <br /> | 一致预期目标价(元)\[注：一致预期值均为近半年内各家机构预测数值的平均值] |
| GO4  | double | <br /> | 一致预期T年度                                                           |
| GO5  | double | <br /> | 一致预期T年每股收益                                                     |
| GO6  | double | <br /> | 一致预期T+1年每股收益                                                   |
| GO7  | double | <br /> | 一致预期T+2年每股收益                                                   |
| GO8  | double | <br /> | 一致预期T年净利润(万元)                                                 |
| GO9  | double | <br /> | 一致预期T+1年净利润(万元)                                               |
| GO10 | double | <br /> | 一致预期T+2年净利润(万元)                                               |
| GO11 | double | <br /> | 一致预期T年营业收入(万元)                                               |
| GO12 | double | <br /> | 一致预期T+1年营业收入(万元)                                             |
| GO13 | double | <br /> | 一致预期T+2年营业收入(万元)                                             |
| GO14 | double | <br /> | 一致预期T年营业利润(万元)                                               |
| GO15 | double | <br /> | 一致预期T+1年营业利润(万元)                                             |
| GO16 | double | <br /> | 一致预期T+2年营业利润(万元)                                             |
| GO17 | double | <br /> | 一致预期T年每股净资产(元)                                               |
| GO18 | double | <br /> | 一致预期T+1年每股净资产(元)                                             |
| GO19 | double | <br /> | 一致预期T+2年每股净资产(元)                                             |
| GO20 | double | <br /> | 一致预期T年净资产收益率(%)                                              |
| GO21 | double | <br /> | 一致预期T+1年净资产收益率(%)                                            |
| GO22 | double | <br /> | 一致预期T+2年净资产收益率(%)                                            |
| GO23 | double | <br /> | 一致预期T年PE                                                           |
| GO24 | double | <br /> | 一致预期T+1年PE                                                         |
| GO25 | double | <br /> | 一致预期T+2年PE                                                         |
| GO26 | double | <br /> | 最新解禁日(YYMMDD格式)                                                  |
| GO27 | double | <br /> | 最新解禁数量（万股）                                                    |
| GO28 | double | <br /> | 下一报告期的预约披露时间                                                |
| GO29 | double | <br /> | 最新持股机构家数                                                        |
| GO30 | double | <br /> | 最新机构持股总量（万股）                                                |
| GO31 | double | <br /> | 最新持股基金家数                                                        |
| GO32 | double | <br /> | 最新基金持股量（万股）                                                  |
| GO33 | double | <br /> | 最新总股本（万股）                                                      |
| GO34 | double | <br /> | 最新实际流通A股（万股）                                                 |
| GO35 | double | <br /> | 最新业绩预告 报告期(YYMMDD格式)                                         |
| GO36 | double | <br /> | 最新业绩预告 本期归母净利润下限（万元）                                 |
| GO37 | double | <br /> | 最新业绩预告 本期归母净利润上限（万元）                                 |
| GO38 | double | <br /> | 最新业绩预告 本期归母净利润预计同比增减幅下限%                          |
| GO39 | double | <br /> | 最新业绩预告 本期归母净利润预计同比增减幅上限%                          |
| GO40 | double | <br /> | 最新业绩快报 报告期                                                     |
| GO41 | double | <br /> | 最新业绩快报 归母净利润（万元）                                         |
| GO42 | double | <br /> | 分红募资 派现总额（万元）                                               |
| GO43 | double | <br /> | 分红募资 募资总额（万元）                                               |
| GO44 | double | <br /> | 最新业绩预告 本期扣非净利润下限(万元)                                   |
| GO45 | double | <br /> | 最新业绩预告 本期扣非净利润上限(万元)                                   |
| GO46 | double | <br /> | 最新业绩预告 本期扣非净利润预计同比增减幅下限%                          |
| GO47 | double | <br /> | 最新业绩预告 本期扣非净利润预计同比增减幅上限%                          |

### 接口使用

```python
from tqcenter import tq

tq.initialize(__file__)

go = tq.get_gp_one_data(stock_list=['688318.SH'],field_list=['GO1','GO2','GO3','GO4','GO5'])
print(go)
```

### **数据样本**

```
{'688318.SH': {'GO1': '107.41', 'GO2': '1667.00', 'GO3': '0.00', 'GO4': '2025.00', 'GO5': '1.74'}}
```

