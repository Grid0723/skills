---
name: tdx-quant-docs
description: 当用户询问 TdxQuant/tqcenter API 用法、通达信 Python 量化策略开发、或需要查阅 TdxQuant 文档时，务必使用此技能。即使用户未显式提及 TdxQuant，只要涉及通达信行情数据（K线/快照/分笔/Tick）、专业财务数据获取、选股公式指标计算、实时行情预警、交易下单撤单、自定义板块管理、回测模拟、股票列表获取/分类等量化场景，都应及时触发。核心函数触发词：tq.initialize、tq.get_market_data、tq.get_financial_data、tq.formula_process_mul_zb、tq.formula_xg、tq.get_stock_list、tq.order_stock、tq.refresh_kline、tq.get_stock_info、tq.get_more_info 等。
---

# TdxQuant 文档查阅技能

此技能提供 TdxQuant 框架文档的查阅能力。文档位于 `reference/` 目录（相对于本 SKILL.md），按功能模块分文件夹组织。

## 框架概述

TdxQuant 是一套基于**通达信金融终端**构建的 Python 量化策略运行框架，以 `tqcenter` 行情模块为核心，通过 API 接口提供：

- **行情数据**：实时与历史的快照、K 线、分笔（Tick）数据
- **基本面数据**：除权除息、基本财务、专业财务、股票交易数据、市场数据
- **新股和合约信息**：标的基础信息、可转债、新股申购等
- **分类数据**：市场类型、行业分类、自定义板块等

## 文档目录映射

当需要查找某个 API 函数的用法时，按以下映射定位对应文档文件：

### TdxQuant概述 (`reference/TdxQuant概述/`)
| 文档文件 | 内容 |
|---|---|
| `TdxQuant概述.md` | 框架总览 |
| `版本更新说明.md` | 版本更新日志 |
| `安装Python及开发环境.md` | Python 和开发环境安装指南 |
| `安装通达信终端并获取数据.md` | 通达信终端安装与数据获取 |
| `快速开始第一个策略.md` | 入门示例，编写第一个策略 |

### 通用函数 (`reference/通用函数/`)
| 文档文件 | API 函数 | 功能组 |
|---|---|---|---|
| `通用函数.md` | 模块总览 | — |
| `初始化initialize.md` | `tq.initialize(__file__)` | 生命周期 |
| `订阅行情subscribe_hq.md` | `tq.subscribe_hq()` | 行情订阅 |
| `取消订阅更新unsubscribe_hq.md` | `tq.unsubscribe_hq()` | 行情订阅 |
| `获得订阅列表get_subscribe_hq_stock_list.md` | `tq.get_subscribe_hq_stock_list()` | 行情订阅 |
| `刷新行情缓存refresh_cache.md` | `tq.refresh_cache()` | 缓存管理 |
| `缓存历史K线refresh_kline.md` | `tq.refresh_kline()` | 缓存管理 |
| `下载特定数据文件download_file.md` | `tq.download_file()` | 缓存管理 |
| `获取交易日列表get_trading_dates.md` | `tq.get_trading_dates()` | 日期检索 |
| `检索证券信息get_match_stkinfo.md` | `tq.get_match_stkinfo()` | 日期检索 |
| `发送消息到TQ策略界面send_message.md` | `tq.send_message()` | 客户端通信 |
| `发送预警信号到客户端send_warn.md` | `tq.send_warn()` | 客户端通信 |
| `发送文件到客户端send_file.md` | `tq.send_file()` | 客户端通信 |
| `发送回测数据send_bt_data.md` | `tq.send_bt_data()` | 客户端通信 |
| `打印数据到客户端print_to_tdx.md` | `tq.print_to_tdx()` | 客户端通信 |
| `调用客户端功能exec_to_tdx.md` | `tq.exec_to_tdx()` | 客户端通信 |

### 行情类信息 (`reference/行情类信息/`)
| 文档文件 | API 函数 |
|---|---|
| `行情类信息.md` | 模块总览 |
| `获取K线数据get_market_data.md` | `tq.get_market_data()` |
| `获取快照数据get_market_snapshot.md` | `tq.get_market_snapshot()` |
| `获取证券基本信息get_stock_info.md` | `tq.get_stock_info()` |
| `获取股票更多信息get_more_info.md` | `tq.get_more_info()` |
| `获取分红配送数据get_divid_factors.md` | `tq.get_divid_factors()` |
| `获取股票所属板块get_relation.md` | `tq.get_relation()` |
| `获取新股申购信息get_ipo_info.md` | `tq.get_ipo_info()` |
| `获取每天的股本数据get_gb_info.md` | `tq.get_gb_info()` |
| `根据时间段获取股本数据get_gb_info_by_date.md` | `tq.get_gb_info_by_date()` |
| `批量获取价格和成交量get_pricevol.md` | `tq.get_pricevol()` |

### 财务类数据 (`reference/财务类数据/`)
| 文档文件 | API 函数 |
|---|---|
| `获取专业财务数据get_financial_data.md` | `tq.get_financial_data()` |
| `获取指定日期财务数据get_financial_data_by_date.md` | `tq.get_financial_data_by_date()` |
| `获取股票交易数据get_gpjy_value.md` | `tq.get_gpjy_value()` |
| `获取指定日期股票交易数据get_gpjy_value_by_date.md` | `tq.get_gpjy_value_by_date()` |
| `获取板块交易数据get_bkjy_value.md` | `tq.get_bkjy_value()` |
| `获取指定日期板块交易数据get_bkjy_value_by_date.md` | `tq.get_bkjy_value_by_date()` |
| `获取市场交易数据get_scjy_value.md` | `tq.get_scjy_value()` |
| `获取指定日期市场交易数据get_scjy_value_by_date.md` | `tq.get_scjy_value_by_date()` |
| `获取股票的单个数据get_gp_one_data.md` | `tq.get_gp_one_data()` |

### 分类-板块成份股 (`reference/分类-板块成份股/`)
| 文档文件 | API 函数 |
|---|---|
| `获取系统分类成份股get_stock_list.md` | `tq.get_stock_list()` — 获取系统分类成份股 |
| `获取A股板块代码列表get_sector_list.md` | `tq.get_sector_list()` |
| `获取板块成份股get_stock_list_in_sector.md` | `tq.get_stock_list_in_sector()` |

### 自选股-自定义板块 (`reference/自选股-自定义板块/`)
| 文档文件 | API 函数 |
|---|---|
| `获取自定义板块列表get_user_sector.md` | `tq.get_user_sector()` |
| `添加自定义板块成份股send_user_block.md` | `tq.send_user_block()` |
| `清空自定义板块成份股clear_sector.md` | `tq.clear_sector()` |
| `创建自定义板块create_sector.md` | `tq.create_sector()` |
| `删除自定义板块delete_sector.md` | `tq.delete_sector()` |
| `重命名自定义板块rename_sector.md` | `tq.rename_sector()` |

### ETF-可转债-期货数据 (`reference/ETF-可转债-期货数据/`)
| 文档文件 | API 函数 |
|---|---|
| `跟踪指数的ETF信息get_trackzs_etf_info.md` | `tq.get_trackzs_etf_info()` |
| `可转债信息get_kzz_info.md` | `tq.get_kzz_info()` |

### 调用通达信公式 (`reference/调用通达信公式/`)
| 文档文件 | API 函数 |
|---|---|
| `格式化K线数据formula_format_data.md` | `tq.formula_format_data()` |
| `向通达信公式设置数据formula_set_data.md` | `tq.formula_set_data()` |
| `向通达信公式设置数据信息formula_set_data_info.md` | `tq.formula_set_data_info()` |
| `获取公式中的设置数据formula_get_data.md` | `tq.formula_get_data()` |
| `获取指定种类的公式列表formula_get_all.md` | `tq.formula_get_all()` |
| `获取指定公式信息formula_get_info.md` | `tq.formula_get_info()` |
| `调用通达信公式进行计算formula_zb-xg-exp.md` | `tq.formula_zb()` / `tq.formula_xg()` / `tq.formula_exp()` |
| `批量调用通达信公式formula_process_mul_xg-zb.md` | `tq.formula_process_mul_xg()` / `tq.formula_process_mul_zb()` |

### 交易函数 (`reference/交易函数/`)
| 文档文件 | API 函数 |
|---|---|
| `获取资金账户句柄stock_account.md` | `tq.stock_account()` |
| `查询账户资产query_stock_asset.md` | `tq.query_stock_asset()` |
| `查询账户委托信息query_stock_orders.md` | `tq.query_stock_orders()` |
| `查询账户持仓信息query_stock_positions.md` | `tq.query_stock_positions()` |
| `交易执行函数order_stock.md` | `tq.order_stock()` |
| `撤单cancel_order_stock.md` | `tq.cancel_order_stock()` |

### 常量枚举 (`reference/常量枚举/`)
| 文档文件 | 内容 |
|---|---|
| `常量枚举.md` | TdxQuant 框架中的常量定义和枚举值（如 `get_stock_list` 的类型码 `5`=所有A股、`50`=沪深A股、`51`=创业板、`52`=科创板、`53`=北交所等） |

### 回测及模拟交易 (`reference/回测及模拟交易/`)
| 文档文件 | 内容 |
|---|---|
| `什么是量化交易.md` | 量化交易概念介绍 |

### 场景化示例 (`reference/场景化示例/`)
| 文档文件 | 内容 |
|---|---|
| `执行选股入板块.md` | 选股结果存入自定义板块的完整示例 |
| `订阅行情涨幅突破实时预警.md` | 实时行情订阅与预警示例 |
| `计算调仓信号并快速买卖.md` | 调仓信号计算与交易执行示例 |
| `结合VBT回测示例.md` | 结合 VectorBT 进行策略回测的示例 |

### 公众号文章例子 (`reference/公众号文章例子/`)
| 文档文件 | 内容 |
|---|---|
| `20260122公众号文章.md` | 2026-01-22 公众号文章 |
| `20260302公众号文章.md` | 2026-03-02 公众号文章 |

### 常见问题 (`reference/常见问题/`)
| 文档文件 | 内容 |
|---|---|
| `常见问题.md` | TdxQuant 使用中的常见问题解答 |

### HTTP方式调用 (`reference/HTTP方式调用/`)
| 文档文件 | 内容 |
|---|---|
| `HTTP方式调用.md` | 不经 tqcenter，直接 POST `http://127.0.0.1:17709/` 调用 TQ 函数（`method`=函数名，`params`=参数，需先开启支持 TQ 的通达信客户端） |

### 综合参考（新增）
| 文档文件 | 内容 |
|---|---|
| `API返回值类型速查.md` | 全部 60+ 个 `tq.*` API 的 **Python 返回值类型**、数据结构示意图、错误处理约定。基于 `tqcenter.py` 源码逐一确认 |
| `内部机制与辅助工具.md` | 生命周期管理（初始化/重连/关闭）、错误码体系、分页机制（RPC级+股票级）、股票代码体系（29种后缀/市场映射）、辅助工具函数（`price_df`/`filter_dict_by_fields`/`formula_format_data` 等） |
| `tqcenter.py.md` | `tqcenter.py` 完整源码（Version 1.0.11, 2026-06-05），供深度查阅实现细节 |

## 查阅规则

1. **按 API 函数名定位**：当需要查阅某个 `tq.xxx()` 函数的用法时，根据上表找到对应的 `.md` 文件，使用 `Read` 工具读取文件内容。
2. **查阅返回值类型**：当需要了解某个 API 的具体 Python 返回类型和数据结构时，优先查阅 `API返回值类型速查.md`。
3. **查阅内部机制**：当需要理解框架初始化/重连/分页/辅助函数原理时，查阅 `内部机制与辅助工具.md`。
4. **按功能模块浏览**：当用户询问某类功能（如"怎么获取K线数据"）时，先定位对应的目录（如"行情类信息"），再读取其中的相关文档。
5. **查阅场景示例**：当用户询问"怎么做选股"、"怎么回测"等实操性问题时，优先查阅 `场景化示例/` 目录下的对应文档。
6. **查阅源码**：当需要确认底层实现细节（如返回数据的确切结构、字段处理逻辑）时，查阅 `tqcenter.py.md` 完整源码。
7. **交叉引用**：通用概念（初始化、数据格式约定）记录在 `通用函数/` 和 `TdxQuant概述/` 中，必要时同时查阅。
8. **HTTP 调用方式**：当用户希望不写 Python、用外部程序（如 curl / 其他语言）通过 HTTP 接口调用 TQ 时，查阅 `HTTP方式调用/HTTP方式调用.md`。

## TdxQuant 核心约定速查

以下是最常用的硬性规则，可在查阅文档前优先确认：

| 约束项 | 说明 |
|---|---|
| **初始化** | 每个脚本开头必须 `sys.path.append("C:/new_tdx64/PYPlugins/user")` + `tq.initialize(__file__)` |
| **结束清理** | 每个脚本末尾必须 `tq.close()` |
| **股票代码格式** | `605507.SH`、`000001.SZ`（后缀 `.SH` / `.SZ`） |
| **日期格式** | `YYYYMMDD`（无分隔符，如 `20260402`） |
| **批量上限** | 每次最多 **99 只**股票 |
| **返回值类型** | tqcenter.py v1.0.11 中**大部分数据获取 API** 内部已解析 JSON，直接返回 Python 对象（`get_market_data` → `Dict[str, pd.DataFrame]`、`get_stock_list` → `List` 等）；**部分操作类 API**（`subscribe_hq`、`refresh_kline`、`create_sector` 等）仍返回原始 JSON 字符串。具体每个 API 的返回类型见 `API返回值类型速查.md` |
| **L2 数据刷新** | L2 字段（`ZI`、`ZO`、`BI`、`ZB`）返回 null 时需调用 `tq.refresh_kline(stock_list=..., period="1d")` |
| **公式类型** | `formula_set_data_info` 单股历史数据+指标、`formula_process_mul_zb` 多股票批量指标、`formula_zb` 单股单一公式指标 |

### `get_stock_list()` 常用类型码

| 代码 | 含义 | 代码 | 含义 |
|---|---|---|---|
| `5` | 所有 A 股 | `50` | 沪深 A 股 |
| `7` | 上证主板 | `8` | 深证主板 |
| `51` | 创业板 | `52` | 科创板 |
| `53` | 北交所 | `23` | 沪深300 |
| `24` | 中证500 | `25` | 中证1000 |
| `0` | 自选股 | `1` | 持仓股 |
| `32` | 可转债 | `31` | ETF 基金 |
| `91` | 跟踪指数的 ETF | `101` | 国内期货 |
| `102` | 港股 | `103` | 美股 |
| `92` | 国内期货主力合约 | | |

## 项目代码示例（补充参考）

项目中的 `test/` 目录包含实际可运行的示例脚本，展示了常用 API 的调用模式：

| 文件 | 涉及 API |
|---|---|
| `test/test.py` | `get_more_info`, `get_market_data`, `formula_set_data_info`, `formula_get_data`, `formula_zb` |
| `test/test1.py` | `get_stock_list`, `formula_process_mul_zb`, `send_user_block`, L2 数据 null 判断 |
| `test/test2.py` | `formula_process_mul_zb`, `refresh_kline`, L2 数据刷新前后对比 |
| `test/test3.py` | `formula_process_mul_zb`（多股票批量公式计算） |
