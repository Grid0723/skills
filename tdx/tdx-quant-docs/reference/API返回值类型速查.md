---
title: "API 返回值类型速查 | 通达信量化平台"
source: "基于 tqcenter.py 源码分析（Version 1.0.11, 2026-06-05）"
---

# API 返回值类型速查

本文档基于 `tqcenter.py` 源码，列出所有 `tq.*` 公开 API 的**实际 Python 返回值类型**与**数据结构示意**。

> **重要提示**：DLL 层返回的是 JSON 字符串，`tqcenter.py`（v1.0.11）内部**大部分数据获取 API** 已通过 `json.loads()` 自动解析为 Python 对象（dict / list / DataFrame）。
> 使用者无需再手动调用 `json.loads()`。
> **例外**：部分操作类 API（`subscribe_hq`、`refresh_kline`、`refresh_cache`、`create_sector` 等）未解析，返回原始 `str`（JSON 字符串）。详见各接口条目标注。

---

## 行情类信息

### `get_market_data()` → Dict[str, pd.DataFrame]

> 获取 K 线 / Tick 历史数据。

**K 线模式**（period 为 `1d`/`5m`/`1h` 等）：
```
{
  'Close':  pd.DataFrame,   # 行索引=DatetimeIndex, 列名=stock_list
  'Open':   pd.DataFrame,   # 同上维度
  'High':   pd.DataFrame,
  'Low':    pd.DataFrame,
  'Volume': pd.DataFrame,
  'Amount': pd.DataFrame,
  'ForwardFactor': pd.DataFrame,  # 仅 dividend_type='none' 时返回有效值
  'VolInStock': pd.DataFrame,     # 仅期货返回有效值
  ...
}
```

- DataFrame **行索引（Index）**：统一的时间戳 `pd.DatetimeIndex`
- DataFrame **列名（Columns）**：传入的 `stock_list`
- 各字段的 DataFrame 维度完全相同
- 默认 `fill_data=True`，空值会向前填充

**Tick 模式**（period=`'tick'`）：
```
{
  '000001.SZ': np.structured_array,   # dtype 含 datetime + 数值字段
  '600519.SH': np.structured_array,
}
```
每只股票返回一个 `numpy` 结构化数组，字段名从原始数据中提取。

---

### `get_market_snapshot()` → Dict[str, str]

> 获取单只股票实时快照。

```
{
  'Open': '128.01',       # 开盘价
  'High': '131.87',       # 最高价
  'Low': '128.00',        # 最低价
  'Close': '131.58',      # 收盘价/最新价
  'Volume': '2257325',    # 成交量
  'Amount': '29394.81',   # 成交额
  'ErrorId': '0',
  ...
}
```
所有字段值均为**字符串**类型。可通过 `field_list` 筛选返回字段。

---

### `get_stock_info()` → Dict[str, str]

> 获取单只股票的基本面信息。

```
{
  'Name': '财富趋势',
  'Unit': '100',
  'MinPrice': '0.01',
  'XsFlag': '2',
  'Fz': ['570', '690', '780', '900', ...],   # 开收市时间（4段），List[str]
  'BelongHS300': '0',
  'IsSTGP': '0',
  'HSStockKind': '4',
  'ActiveCapital': '25611.94',
  'J_zgb': '25611.94',         # 总股本(万股)
  'J_mgsy': '0.96',            # 每股收益
  'J_mgjzc': '14.46',          # 每股净资产
  'blockzscode': '881355',
  'rs_hyname': '软件服务',
  'ErrorId': '0',
  ...
}
```
字段值均为**字符串**（包括数字）。`Fz` 字段为 `List[str]`。可通过 `field_list` 筛选返回字段。

---

### `get_more_info()` → Dict[str, Any]

> 获取单只股票的"更多信息"（87 个字段的扁平字典）。

```
{
  'Name': '财富趋势',
  'TotalShares': 256119400.0,     # 总股本
  'FloatShares': 256119400.0,     # 流通股本
  'PE': 45.67,                    # 市盈率
  'PB': 8.92,                     # 市净率
  'EPS': 0.96,                    # 每股收益
  'NAV': 14.46,                   # 每股净资产
  'TotalMV': 3876543210.0,        # 总市值
  'FloatMV': 3876543210.0,        # 流通市值
  ...
}
```
- 返回 `json_res["Value"]`，是一个**扁平字典**（非嵌套）
- 字段类型混合：String / Int / Float / Date
- 支持通过 `field_list` 筛选

---

### `get_divid_factors()` → pd.DataFrame

> 获取单只股票的除权除息数据。

```
                Type  Bonus  AllotPrice  ShareBonus  Allotment
Date
2020-09-29        1    6.0         0.0         0.0        0.0
2021-05-27        1   10.0         0.0         0.0        0.0
2022-06-20        1   14.0         0.0         4.0        0.0
```

返回 `pd.DataFrame`：
- **行索引（Index）**：除权除息日期 `DatetimeIndex`
- **列**：`Type`（1=除权除息, 11=扩缩股, 15=重新调整）、`Bonus`（红利）、`AllotPrice`（配股价）、`ShareBonus`（送股/扩缩股比例）、`Allotment`（配股）

> 注意：源码注释提到 `start_time` / `end_time` 参数仅用于客户端切片，**后端实际返回所有权息数据**。

---

### `get_relation()` → List[Dict]

> 获取股票所属板块信息。

```
[
  {'Code': '881355', 'Name': '软件服务', 'Type': '1'},
  {'Code': '18', 'Name': '深圳板块', 'Type': '2'},
  ...
]
```

返回 `List[Dict]`，每个元素含 `Code`、`Name`、`Type` 字段。

---

### `get_ipo_info()` → List[Dict]

> 获取新股申购信息。

```
[
  {'Code': '688xxx.SH', 'Name': '某某科技', 'Price': 'xx.xx', ...},
  ...
]
```

返回 `json_res["Value"]`，类型为 `List[Dict]`。

---

### `get_gb_info()` → List[Dict]

> 获取指定日期的股本数据（按 `date_list` 列表查询）。

```
[
  {'Date': '20250601', 'TotalShares': ..., 'FloatShares': ..., ...},
  ...
]
```

返回 `json_res["Value"]`，类型为 `List[Dict]`。`count` 参数控制返回数量（前 count 条）。

---

### `get_gb_info_by_date()` → List[Dict]

> 获取指定时间段的股本数据（按 `start_date` ~ `end_date` 区间查询）。

```
[
  {'Date': '20250601', 'TotalShares': ..., 'FloatShares': ..., ...},
  ...
]
```

返回 `json_res["Value"]`，类型为 `List[Dict]`。

---

### `get_pricevol()` → Dict

> 批量获取股票价格和成交量数据。

```
{
  '000001.SZ': {'Price': ..., 'Volume': ..., ...},
  '600519.SH': {'Price': ..., 'Volume': ..., ...},
}
```

返回 `json_res["Value"]`，类型为 `Dict[str, Dict]`，按股票代码索引。

---

## 财务类数据

### `get_financial_data()` → Dict[str, pd.DataFrame | dict]

> 获取专业财务数据（需先在客户端下载专业财务数据包）。

```
{
  '600519.SH': pd.DataFrame,   # 当各字段列表长度一致时返回 DataFrame
  '000001.SZ': pd.DataFrame,
  '600036.SH': dict,           # 当各字段列表长度不一致时返回原始 dict
}
```

- 返回 `Dict[str, pd.DataFrame]`（常规情况）或 `Dict[str, dict]`（异常情况）
- 每只股票可能有不同数量的报告期
- DataFrame 中每行对应一个报告期，列对应财务字段（`FN1`~`FN236`）
- 字段名需用 `field_list` 指定（格式如 `['FN193', 'FN1']`）

---

### `get_financial_data_by_date()` → Dict[str, dict]

> 按年份和月日获取财务数据。

```
{
  '600519.SH': {'FN1': [0.96, 0.98, ...], 'FN193': [...], ...},
  '000001.SZ': {...},
}
```

返回 `data_dict.get("Value", {})`，`Dict[str, dict]`，按股票代码索引。每个 stock 的 value 是 Dict，字段名→数值列表。

---

### `get_gpjy_value()` → Dict[str, dict]

> 获取股票交易数据（需先在客户端下载对应数据包）。

```
{
  '600519.SH': {'GP1': [...], 'GP2': [...], ...},
  '000001.SZ': {...},
}
```

返回 `data_dict.get("Value", {})`，`Dict[str, dict]`，按股票代码索引。每个 stock 的 value 是 Dict（字段名→数值列表）。

---

### `get_gpjy_value_by_date()` → Dict[str, dict]

> 按年份和月日获取股票交易数据。

```
{
  '600519.SH': {'GP1': [...], 'GP2': [...], ...},
}
```

返回 `data_dict.get("Value", {})`，`Dict[str, dict]`。

---

### `get_bkjy_value()` → Dict[str, dict]

> 获取板块交易数据。

```python
# 返回 data_dict.get("Value", {})
# Dict[str, dict]，按板块代码索引
```

---

### `get_bkjy_value_by_date()` → Dict[str, dict]

> 按年份和月日获取板块交易数据。返回值同 `get_bkjy_value()`。

---

### `get_scjy_value()` → Dict

> 获取市场交易数据。

返回 `data_dict["Value"]`（正常情况），`Dict` 结构。
若 JSON 解析失败则可能返回原始 `bytes`/`bytearray`。

---

### `get_scjy_value_by_date()` → Dict

> 按年份和月日获取市场交易数据。返回值同 `get_scjy_value()`。

---

### `get_gp_one_data()` → Dict[str, dict]

> 获取股票的单个数据（一次性查询）。

```
{
  '600519.SH': {'Field1': 'Value1', 'Field2': 'Value2', ...},
  '000001.SZ': {...},
}
```

返回 `data_dict.get("Value", {})`，`Dict[str, dict]`。

---

## 分类-板块成份股

### `get_stock_list()` → List[str] | List[Dict]

> 获取系统分类成份股列表。

```
# list_type=0（默认）：仅返回代码列表
['000001.SZ', '000002.SZ', '600519.SH', ...]

# list_type=1：返回代码+名称列表
[
  {'Code': '000001.SZ', 'Name': '平安银行'},
  {'Code': '000002.SZ', 'Name': '万科A'},
  ...
]
```

返回 `json_res["Value"]`，默认 `market='5'`（所有 A 股）。参数 `market` 接受**字符串**类型。

---

### `get_sector_list()` → List[Dict]

> 获取板块代码列表。

```
[
  {'Code': '881001', 'Name': '煤炭'},
  {'Code': '881006', 'Name': '石油'},
  ...
]
```

返回 `json_res["Value"]`，类型为 `List[Dict]`。

---

### `get_stock_list_in_sector()` → List[str] | List[Dict]

> 获取板块成份股列表。

```
# list_type=0（默认）：代码列表
['000983.SZ', '600188.SH', ...]

# list_type=1：代码+名称列表
[{'Code': '000983.SZ', 'Name': '山西焦煤'}, ...]
```

返回 `json_res["Value"]`，类型为 `List`。`block_type` 参数控制板块类型（0=系统板块, 1=自定义板块, 2=期货板块）。

---

## 自选股-自定义板块

### `get_user_sector()` → List[Dict]

> 获取用户自选股板块列表。

```
[
  {'Code': 'Z1', 'Name': '我的自选'},
  {'Code': 'Z2', 'Name': '重点关注'},
  ...
]
```

返回 `json_res["Value"]`。

---

### `send_user_block()` → Dict

> 添加自选股到客户端自定义板块。

```
{'ErrorId': '0', 'Msg': '发送成功', ...}
```

返回值类型 `Dict`，含 `ErrorId` 状态字段。

---

## ETF-可转债-期货数据

### `get_trackzs_etf_info()` → List[Dict]

> 获取跟踪指数的 ETF 信息。

```
[
  {'Code': '510050.SH', 'Name': '上证50ETF', ...},
  ...
]
```

返回 `json_res["Value"]`，`List[Dict]`。

---

### `get_kzz_info()` → Dict

> 获取可转债基础信息。

```
{
  'Code': '123xxx.SZ',
  'Name': 'XX转债',
  'ConvertPrice': 'xx.xx',  # 转股价
  'MaturityDate': '2028xxxx',  # 到期日
  ...
}
```

返回 `json_res["Value"][0]`（取第一条），`Dict`。支持通过 `field_list` 筛选字段。

---

## 调用通达信公式

### `formula_format_data()` → Dict[str, List[Dict]]

> 格式化 K 线数据为公式可用格式。

```
{
  '688318.SH': [
    {'Date': '2024-01-02 00:00:00', 'Amount': 29394.81, 'Volume': 2257325.0,
     'Close': 131.58, 'Open': 128.01, 'High': 131.87, 'Low': 128.0},
    ...
  ],
  '600519.SH': [...],
}
```

返回 `Dict[str, List[Dict]]`，按股票代码索引。每条记录含 `Date`、`Amount`、`Volume`、`Close`、`Open`、`High`、`Low`。

---

### `formula_set_data()` → Dict

> 向公式设置自定义 K 线数据。

```
{'ErrorId': '0', ...}
```

### `formula_set_data_info()` → Dict

> 设置公式股票参数（按时间范围/K 线数量加载历史数据）。

```
{'ErrorId': '0', ...}
```

`count=-1` 获取全部数据，`count=-2` 使用无序列数据，`count=0` 使用 `start_time`/`end_time`。

### `formula_get_data()` → Dict

> 获取之前通过 `formula_set_data_info` 设置的数据。

```
{'Values': [...], 'ErrorId': '0', ...}
```

### `formula_zb()` → Dict

> 单股调用指标公式（需先用 `formula_set_data_info` 设置数据）。

```
{'NOTEXT1': [{'Date': '20260203', 'Value': '11.06'}, ...], 'ErrorId': '0'}
```

### `formula_xg()` → Dict

> 单股调用选股公式。

```
{'XG1': [{'Date': '20260203', 'Value': '0'}, ...], 'ErrorId': '0'}
```

### `formula_exp()` → Dict

> 单股调用专家系统公式。返回结构同 `formula_zb()`。

---

### `formula_process_mul_zb()` → Dict

> 批量执行指标公式（无需提前设置数据）。

```
{
  '000001.SZ': {
    'NOTEXT1': [{'Date': '20260203', 'Value': '11.06'}, ...],
    'NOTEXT2': [{'Date': '20260203', 'Value': '10.85'}, ...],
    'OUTPUT1': ['全国性银行 深圳板块 ...'],   # 文字输出（可能为 List[str]）
  },
  '600519.SH': {...},
  'ErrorId': '0'
}
```

- 返回 `Dict[str, dict]`，按股票代码索引
- 每个股票 value 是 `Dict[str, List[Dict|str]]`：指标输出名 → 数据列表
- Date/Value 结构：`{'Date': 'YYYYMMDD', 'Value': '...'}`（Value 为字符串）
- 当 `ErrorId='19'` 时表示返回数据过大，部分数据被截断

### `formula_process_mul_xg()` → Dict

> 批量执行选股公式。返回结构同 `formula_process_mul_zb()`。

```
{
  '000001.SZ': {'XG1': [{'Date': '20260203', 'Value': '0'}, ...]},
  '600519.SH': {'XG1': [{'Date': '20260203', 'Value': '1'}, ...]},
  'ErrorId': '0'
}
```

### `formula_process_mul_exp()` → Dict

> 批量执行专家系统公式。返回结构同 `formula_process_mul_zb()`。

---

### `formula_get_all()` → List[Dict]

> 获取指定种类的公式列表。

```
[
  {'Name': 'MA', 'Code': 'MA', 'Type': 0, ...},
  {'Name': 'MACD', 'Code': 'MACD', 'Type': 0, ...},
  ...
]
```

返回 `json_res["Value"]`，`List[Dict]`。`formula_type` 可取值：0=指标公式, 1=选股公式, 2=专家系统公式。

### `formula_get_info()` → Dict

> 获取指定公式的详细信息。

```
{
  'Name': 'MACD',
  'Code': 'MACD',
  'Description': '指数平滑异同移动平均线',
  'Params': [...],
  ...
}
```

返回 `json_res["Value"]`，`Dict`。

---

## 交易函数

### `stock_account()` → int

> 获取资金账户句柄。

```
1190008847   # 成功返回正整数（account_id）
-1           # 失败返回 -1
```

返回 `json_res["Value"]`，类型 `int`。失败时返回 `-1`。

---

### `query_stock_asset()` → Dict

> 查询股票账户资产信息。

```
{
  'ErrorId': '0',
  'Assets': {...},    # 资产详情
  'Positions': [...], # 持仓列表
  ...
}
```

返回 `Dict`。

---

### `query_stock_orders()` → List[Dict]

> 查询股票账户委托信息。

```
[
  {'OrderId': 'xxx', 'StockCode': '688318.SH', 'OrderType': 0,
   'OrderVolume': 200, 'Price': 160.0, 'Status': 1, ...},
  ...
]
```

返回 `json_res["Value"]`，`List[Dict]`。

---

### `query_stock_positions()` → List[Dict]

> 查询股票账户持仓信息。

```
[
  {'StockCode': '688318.SH', 'Volume': 500, 'CostPrice': 130.5, ...},
  ...
]
```

返回 `json_res["Value"]`，`List[Dict]`。

---

### `order_stock()` → Dict | int

> 执行买卖下单。

```
# 成功时返回 Dict：
{'ErrorId': '0', 'Msg': '已发送信号至客户端，待用户确认！', 'Value': 1, 'Wtbh': 'xxx'}

# 失败时返回 -1（int）
```

- 成功返回 `Dict`，含 `Value`（0=失败, 1=待确认, 2=成功）、`Wtbh`（委托编号）、`Msg`（提示信息）
- 失败返回 `-1`

---

### `cancel_order_stock()` → Dict | int

> 撤销委托订单。

```
{'ErrorId': '0', ...}   # 成功
-1                       # 失败
```

---

## 通用函数

### `subscribe_quote()` → str

> 订阅单股行情数据回调。

**注意：源码标注"暂无实际功能"。** 返回原始 JSON 字符串（`str`），未内部解析。

---

### `subscribe_hq()` → str | None

> 订阅实时行情更新回调。

返回原始 JSON 字符串（`str`，未内部解析）或打印错误信息。**最多订阅 100 只股票，**超出会回退旧列表并抛异常。

---

### `unsubscribe_hq()` → str | None

> 取消实时行情订阅。返回字符串或 None。

---

### `get_subscribe_hq_stock_list()` → List[str]

> 获取当前已订阅行情的股票列表。

```
['000001.SZ', '600519.SH']
```

---

### `refresh_cache()` → str

> 刷新行情缓存。

返回原始 JSON 字符串（`str`，未内部解析）。

---

### `refresh_kline()` → str | None

> 刷新 K 线缓存（仅支持 `1m`/`5m`/`1d` 周期）。

返回原始 JSON 字符串（`str`，未内部解析），失败打印错误信息。**注意：此函数支持的周期比 `get_market_data` 更受限。**

---

### `download_file()` → str | None

> 下载文件（10大股东、ETF 申赎数据等）。

`down_type` 控制下载类型。返回原始 JSON 字符串（`str`，未内部解析）。

---

### `get_trading_dates()` → List[str]

> 获取交易日列表。

```
['20251211', '20251212', '20251215', '20251216', ...]
```

返回 `json_res.get("Date", [])`，`List[str]`（日期字符串，格式 `YYYYMMDD`）。

---

### `get_trading_calendar()` → List[str]

> 获取交易日历（与 `get_trading_dates` 实现相同）。

---

### `get_match_stkinfo()` → List[Dict]

> 证券代码/名称模糊检索。

```
[
  {'Code': '000001.SZ', 'Name': '平安银行', 'PY': 'payh', ...},
  {'Code': '000002.SZ', 'Name': '万科A', 'PY': 'wka', ...},
  ...
]
```

返回 `json_res["Value"]`，`List[Dict]`。

---

### `send_message()` → Dict

> 发送消息到 TDX 客户端策略界面。

```
{'ErrorId': '0', ...}
```

### `send_warn()` → Dict

> 发送预警信号到客户端。

### `send_file()` → Dict

> 发送文件路径到客户端。

### `send_bt_data()` → Dict

> 发送回测数据到客户端。

---

### `print_to_tdx()` → None

> 将 DataFrame 打印为通达信客户端面板（XML + JSON + SP 文件）。

无返回值（副作用：生成文件并移动到通达信目录）。详见 `内部机制与辅助工具.md`。

---

### `exec_to_tdx()` → Dict

> 在客户端调用功能或 URL。

```
{'ErrorId': '0', ...}
```

---

## 板块管理

### `create_sector()` → str | None

> 创建自定义板块。返回原始 JSON 字符串（`str`，未内部解析）。

### `delete_sector()` → str | None

> 删除自定义板块。返回原始 JSON 字符串（`str`，未内部解析）。

### `rename_sector()` → str | None

> 重命名自定义板块。返回原始 JSON 字符串（`str`，未内部解析）。

### `clear_sector()` → str | None

> 清空自定义板块成份股。返回原始 JSON 字符串（`str`，未内部解析）。

---

## 辅助工具（静态方法）

### `price_df()` → pd.DataFrame

> 从 K 线返回的 Dict 中提取某个价格字段的 DataFrame。

```python
close = tq.price_df(result, 'Close', column_names=['mystock'])
# 返回 pd.DataFrame，已排序索引、填充空值、可选重命名列
```

### `filter_dict_by_fields()` → Dict

> 按字段名筛选字典（大小写不敏感）。

```python
filtered = tq.filter_dict_by_fields(data, field_list=['name', 'close'])
# 返回含原始键名的新 Dict
```

---

## 返回值错误处理约定

所有 API 返回的 Dict 中均包含 `ErrorId` 字段：

| ErrorId | 含义 | 内部行为 |
|---------|------|---------|
| `'0'` | 成功 | 正常返回数据 |
| `'6'` / `'7'` | 连接异常 | `_reInitialize()` 自动重连 |
| `'12'` | 同名策略已运行 | 打印提示，仍可继续 |
| `'19'` | 返回数据过大 | 仅公式批量调用出现，部分数据截断 |
| `'20'` | 致命错误 | `raise SystemExit` 终止程序 |

失败时 API 通常返回空 `{}`、`[]` 或 `-1`（交易类函数）。
