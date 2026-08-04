# Loguru API 参考

> 基于 Loguru 官方文档，涵盖所有核心 API。技术术语保留英文。

## 目录

1. [logger.add() — 注册 sink](#1-loggeradd--注册-sink)
2. [logger.remove() — 移除 sink](#2-loggerremove--移除-sink)
3. [logger.configure() — 批量配置](#3-loggerconfigure--批量配置)
4. [logger.disable() / enable() — 库中使用](#4-loggerdisable--enable--库中使用)
5. [logger.catch() — 异常捕获](#5-loggercatch--异常捕获)
6. [logger.bind() — 绑定上下文](#6-loggerbind--绑定上下文)
7. [logger.contextualize() — 临时上下文](#7-loggercontextualize--临时上下文)
8. [logger.patch() — 动态附加](#8-loggerpatch--动态附加)
9. [logger.opt() — 延迟/按需控制](#9-loggeropt--延迟按需控制)
10. [logger.level() — 自定义级别](#10-loggerlevel--自定义级别)
11. [logger.complete() — 等待完成](#11-loggercomplete--等待完成)
12. [logger.parse() — 解析日志](#12-loggerparse--解析日志)
13. [日志级别参考](#13-日志级别参考)
14. [环境变量](#14-环境变量)

---

## 1. logger.add() — 注册 sink

```python
handler_id = logger.add(sink, **kwargs)
```

### sink 参数（接收器类型）

| sink 类型 | 示例 | 说明 |
|---|---|---|
| 字符串路径 | `"app.log"` | 文件路径，支持 `{time}` 模板 |
| 函数 | `my_func` | 自定义函数，接收 `message` 对象 |
| 类文件对象 | `sys.stderr`, `open("f", "w")` | 标准文件对象 |
| 协程函数 | `async def my_sink(m):` | 异步 sink，需 `complete()` 等待 |
| 标准 logging Handler | `logging.StreamHandler()` | 与标准库互操作 |

### 常用 kwargs 参数

| 参数 | 类型 | 说明 | 示例 |
|---|---|---|---|
| `level` | `str \| int` | 最低记录级别 | `"INFO"`, `"DEBUG"`, `30` |
| `format` | `str` | 输出格式模板 | `"{time} \| {level} \| {message}"` |
| `filter` | `str \| callable \| dict` | 过滤规则 | `"my_module"`, `lambda r: r["extra"].get("debug")` |
| `colorize` | `bool` | 是否启用颜色 | `True`（终端兼容时自动） |
| `serialize` | `bool` | 是否序列化为 JSON | `True` |
| `backtrace` | `bool` | 是否记录完整回溯 | `True` |
| `diagnose` | `bool` | 是否显示变量值 | `True`（**默认值！生产注意泄露**） |
| `enqueue` | `bool` | 是否异步入队 | `True`（多线程/多进程推荐） |
| `rotation` | `str \| int \| time \| callable` | 日志轮转 | 见下方 |
| `retention` | `str \| int \| timedelta \| callable` | 日志保留 | 见下方 |
| `compression` | `str \| callable` | 日志压缩 | `"zip"`, `"gz"`, `"tar.gz"` |
| `encoding` | `str` | 文件编码 | `"utf-8"` |
| `catch` | `bool` | 是否捕获 sink 内部异常 | `True`（默认） |

### rotation 取值

| 值 | 说明 |
|---|---|
| `"500 MB"` | 文件超过 500MB 轮转 |
| `"12:00"` | 每天中午 12:00 轮转 |
| `"1 week"` | 文件超过 1 周轮转 |
| `"1 day"` | 每天轮转 |
| `timedelta(hours=1)` | Python timedelta 对象 |
| `callable(message, file)` | 自定义函数，返回 True 则轮转 |

### retention 取值

| 值 | 说明 |
|---|---|
| `"10 days"` | 保留最近 10 天的日志 |
| `"1 week, 3 days"` | 保留 1 周 3 天 |
| `timedelta(days=30)` | Python timedelta 对象 |

### format 模板变量

| 变量 | 说明 |
|---|---|
| `{time}` | 时间（支持格式化：`{time:YYYY-MM-DD HH:mm:ss}`） |
| `{level}` | 日志级别 |
| `{message}` | 日志消息 |
| `{name}` | 模块名称 |
| `{function}` | 函数名 |
| `{line}` | 行号 |
| `{file}` | 文件路径 |
| `{thread}` | 线程信息 |
| `{process}` | 进程信息 |
| `{elapsed}` | 从程序启动的时间 |
| `{extra[key]}` | 自定义扩展字段 |

### 颜色标记

在 `format` 中使用 XML 风格标签：
```python
"<red>{message}</red>"
"<green>{time}</green>"
"<yellow><bold>{level}</bold></yellow>"
"<blue>{extra[user]}</blue>"
```

### 返回值

`add()` 返回一个 handler id（`int`），可用于 `remove()` 移除特定 sink。

---

## 2. logger.remove() — 移除 sink

```python
logger.remove()         # 移除所有 sink（清空）
logger.remove(handler_id)  # 移除指定 sink
```

**典型用法**：初始化日志系统时，先清空默认 stderr handler，再添加自定义 sink。

---

## 3. logger.configure() — 批量配置

```python
logger.configure(**config)

# 示例
config = {
    "handlers": [
        {"sink": sys.stdout, "format": "{time} - {message}"},
        {"sink": "file.log", "serialize": True},
    ],
    "extra": {"user": "admin"},
    "levels": [{"name": "METRICS", "no": 15, "color": "<blue>"}],
}
logger.configure(**config)
```

支持的顶层 key：`handlers`（同 `add()` 的 kwargs）、`extra`（同 `bind()`）、`levels`（同 `level()`）、`activation`、`patcher`。

---

## 4. logger.disable() / enable() — 库中使用

```python
# 在库中（例如 my_library/__init__.py）
logger.disable("my_library")   # 禁用此模块下的所有日志
logger.info("不会输出")         # 空操作

# 在应用端
logger.enable("my_library")    # 重新启用
logger.info("会输出")           # 正常输出
```

**关键规则**：库代码永远不要调用 `add()`，只能用 `disable(__name__)`。应用端通过 `enable()` 来决定是否看到库的日志。

---

## 5. logger.catch() — 异常捕获

### 装饰器模式

```python
@logger.catch
def my_function(x, y, z):
    return 1 / (x + y + z)
```

### 上下文管理器

```python
with logger.catch(message="任务失败"):
    risky_operation()
```

### 参数

| 参数 | 说明 |
|---|---|
| `exception` | 要捕获的异常类型（默认 `Exception`） |
| `level` | 记录级别（默认 `"ERROR"`） |
| `reraise` | 是否重新抛出（默认 `False`） |
| `message` | 异常发生时的消息前缀 |

---

## 6. logger.bind() — 绑定上下文

修改 `extra` 属性，为后续日志添加上下文：

```python
# 创建上下文 logger
ctx_logger = logger.bind(ip="192.168.1.1", user="admin")

# 所有通过 ctx_logger 发出的日志自动携带 extra
ctx_logger.info("登录成功")  # extra = {"ip": "192.168.1.1", "user": "admin"}

# 链式绑定（内联覆盖）
ctx_logger.bind(user="root").info("权限提升")

# 配合 format 使用
logger.add("app.log", format="{extra[ip]} {extra[user]} {message}")
```

---

## 7. logger.contextualize() — 临时上下文

`bind()` 的 `with` 版本，上下文管理器退出后自动恢复：

```python
# 基本用法
with logger.contextualize(task="数据同步"):
    logger.info("步骤 1")
    logger.info("步骤 2")
# 离开 with 块后，task 属性自动清除

# 手动控制（用于 __aenter__ 等场景）
token = logger.contextualize(task="异步任务")
token.__enter__()
try:
    logger.info("工作中...")
finally:
    token.__exit__(None, None, None)
```

---

## 8. logger.patch() — 动态附加

为每条新消息动态修改 record dict：

```python
# 每次记录前自动执行 callback
logger = logger.patch(lambda record: record["extra"].update(pid=os.getpid()))

# 之后所有日志自动携带 pid
logger.info("进程信息已附加")
```

---

## 9. logger.opt() — 延迟/按需控制

```python
logger.opt(lazy=True).debug("昂贵计算: {x}", x=lambda: heavy_computation())

logger.opt(exception=True).info("追加异常堆栈")         # 等价于 logger.exception()
logger.opt(colors=True).info("蓝色<blue>消息</blue>")    # 单条消息着色
logger.opt(record=True).info("线程: {record[thread]}")   # 访问完整 record
logger.opt(raw=True).info("绕过格式\n")                  # 不应用 format，直接输出
logger.opt(depth=1).info("向上回溯一层栈帧")             # 修正调用者信息
logger.opt(capture=False).info("不捕获 kwargs")          # kwargs 不被添加到 extra
```

### opt() 参数速查

| 参数 | 默认 | 说明 |
|---|---|---|
| `exception` | `None` | 设为 `True` 则异常堆栈附加到日志 |
| `lazy` | `False` | 设为 `True` 则格式化参数延迟求值 |
| `colors` | `False` | 设为 `True` 则启用单条消息着色 |
| `record` | `False` | 设为 `True` 则可在消息中访问 `{record[...]}` |
| `raw` | `False` | 设为 `True` 则绕过 sink 格式化 |
| `depth` | `0` | 增加栈帧回溯深度 |
| `capture` | `True` | 设为 `False` 则 kwargs 不被捕获到 extra |

---

## 10. logger.level() — 自定义级别

```python
# 创建自定义级别
new_level = logger.level("SNAKY", no=38, color="<yellow>", icon="🐍")

# 使用
logger.log("SNAKY", "自定义级别触发！")

# 或者直接调用（如果 level() 返回的名称与级别函数名一致）
logger.log(new_level.no, "用数值调用也可")
```

**loguru 内置级别**：`TRACE`(5)、`DEBUG`(10)、`INFO`(20)、`SUCCESS`(25)、`WARNING`(30)、`ERROR`(40)、`CRITICAL`(50)

---

## 11. logger.complete() — 等待完成

```python
logger.complete()  # 阻塞等待所有 enqueue=True 的异步消息写入完毕
```

**必须使用场景**：使用了 `enqueue=True` 的 sink 后，程序退出前必须调用 `complete()`，否则可能丢失最后的日志。

---

## 12. logger.parse() — 解析日志

将日志文件按正则表达式解析为结构化数据：

```python
import dateutil.parser

pattern = r"(?P<time>.*) - (?P<level>[0-9]+) - (?P<message>.*)"
caster_dict = dict(time=dateutil.parser.parse, level=int)

for groups in logger.parse("file.log", pattern, cast=caster_dict):
    print(groups)
    # {"level": 30, "message": "Log example", "time": datetime(2018, ...)}
```

---

## 13. 日志级别参考

| 级别名 | 数值 | 方法 | 说明 |
|---|---|---|---|
| TRACE | 5 | `logger.trace()` | 最低级别，超详细跟踪 |
| DEBUG | 10 | `logger.debug()` | 调试信息 |
| INFO | 20 | `logger.info()` | 普通信息 |
| SUCCESS | 25 | `logger.success()` | 成功信息（loguru 特有） |
| WARNING | 30 | `logger.warning()` | 警告 |
| ERROR | 40 | `logger.error()` | 错误 |
| CRITICAL | 50 | `logger.critical()` | 严重错误 |

---

## 14. 环境变量

| 变量 | 说明 |
|---|---|
| `LOGURU_FORMAT` | 覆盖默认格式化 |
| `LOGURU_LEVEL` | 覆盖默认日志级别 |
| `LOGURU_COLORIZE` | 覆盖颜色开关 |
| `LOGURU_DEBUG_COLOR` | 自定义 DEBUG 颜色 |
| `LOGURU_INFO_COLOR` | 自定义 INFO 颜色 |
| `LOGURU_WARNING_COLOR` | 自定义 WARNING 颜色 |
| `LOGURU_ERROR_COLOR` | 自定义 ERROR 颜色 |
| `LOGURU_CRITICAL_COLOR` | 自定义 CRITICAL 颜色 |
| `LOGURU_TRACE_COLOR` | 自定义 TRACE 颜色 |
| `LOGURU_SUCCESS_COLOR` | 自定义 SUCCESS 颜色 |
| `LOGURU_AUTOINIT` | 设为 `0` 禁止自动初始化（库中使用） |

```bash
# Linux / macOS
export LOGURU_FORMAT="{time} | <lvl>{message}</lvl>"

# Windows
setx LOGURU_DEBUG_COLOR "<green>"
```
