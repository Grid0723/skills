---
name: loguru
description: 当用户需要配置日志系统、添加文件日志、设置日志轮转/保留、格式化日志输出、捕获异常堆栈、结构化日志、自定义日志级别、或任何与 loguru 日志库相关的操作时使用。涵盖从简单脚本到生产系统的全场景。触发关键词：loguru、日志、logging、log、日志轮转、rotation、日志格式、sink、异常捕获、logger.catch、结构化日志、JSON日志、log setup、日志配置。只要涉及 Python 日志记录的配置或问题排查，都应当优先加载此技能。
---

# Loguru 日志库技能

提供 Loguru 的通用使用指南，适用于任何 Python 项目（从单文件脚本到大型系统）。

## 核心理念

Loguru 的设计哲学：**有且仅有一个全局 `logger`**，通过 `logger.add()` 注册 sink（接收器）来管理日志输出。无需 Handler、Formatter、Filter 等概念，一个函数掌控一切。

```python
from loguru import logger

logger.debug("开箱即用，无需样板代码！")
```

## 文件组织

| 文件 | 内容 | 何时查阅 |
|---|---|---|
| `references/api.md` | 完整 API 参考（14 个核心 API，含参数表格） | 需要查看具体函数签名、参数说明时 |
| `references/patterns.md` | 12 种场景配方（文件轮转、异常诊断、多通道等） | 需要直接复制代码时 |

## 核心 API 速查

### 添加 sink（日志输出目标）

```python
logger.remove()  # 先清空默认 handler（推荐在项目初始化时调用）
handler_id = logger.add(sink, **kwargs)
```

`sink` 可以是：文件路径字符串、`sys.stderr`、自定义函数（接收 `message` 对象）、协程函数、标准 `logging.Handler`。

### 最常用配置

```python
# 文件日志 + 自动轮转
logger.add("app_{time}.log", rotation="10 MB", retention="30 days", compression="zip")

# 终端输出（带颜色）
logger.add(sys.stderr, colorize=True, format="<green>{time:HH:mm:ss}</green> <level>{message}</level>")

# JSON 日志（方便 ELK 等工具解析）
logger.add("app.log", serialize=True, enqueue=True)

# 条件过滤：只记录特定模块或特定上下文的日志
logger.add("admin.log", filter=lambda r: r["extra"].get("role") == "admin")
```

### 日志记录

```python
logger.trace("超详细")          # 级别 5
logger.debug("调试")            # 10
logger.info("信息")             # 20
logger.success("成功")          # 25（loguru 内置）
logger.warning("警告")          # 30
logger.error("错误")            # 40
logger.critical("严重错误")     # 50

# {} 格式化（等价于 str.format()），拒绝 % 格式
logger.info("股票 {} 收盘价 {:.2f}", code, price)
```

### 异常处理

```python
# 装饰器：自动捕获并记录异常，不中断程序
@logger.catch
def risky():
    return 1 / 0

# exception()：在 except 块中，自动附带完整堆栈 + 变量值
try:
    ...
except Exception:
    logger.exception("操作失败")

# ⚠️ diagnose=True 是默认值，生产环境应关闭（防泄露敏感变量值）
logger.add("prod.log", diagnose=False, backtrace=False)
```

### 结构化日志（上下文绑定）

```python
# bind() — 创建携带固定上下文的子 logger
ctx = logger.bind(user_id=42, request_id="req-123")
ctx.info("请求处理中")  # extra = {user_id: 42, request_id: "req-123"}

# contextualize() — with 块内临时上下文（退出后自动清除）
with logger.contextualize(task="数据同步"):
    logger.info("步骤 1 完成")
    logger.info("步骤 2 完成")

# patch() — 每次日志前动态注入信息
logger = logger.patch(lambda r: r["extra"].update(pid=os.getpid()))
```

### 其他关键 API

```python
# 自定义日志级别
logger.level("METRICS", no=15, color="<blue>", icon="📊")
logger.log("METRICS", "自定义消息")

# 延迟求值（生产环境避免昂贵计算）
logger.opt(lazy=True).debug("结果: {x}", x=lambda: heavy_calc())

# 修正调用栈（在包装函数内使用）
logger.opt(depth=1).info("调用者信息指向包装函数外部")

# 程序退出前：确保所有 enqueue=True 的异步日志刷盘
logger.complete()
```

### 在库中安全使用

```python
# 库代码：只 disable，不 add
logger.disable(__name__)

# 应用代码：按需启用
logger.enable("my_library")
```

## 使用规则

1. **初始化时先 `logger.remove()`**：清空默认 stderr handler，再按需添加自己的 sink。
2. **多线程/多进程环境用 `enqueue=True`**：避免阻塞和竞态条件。
3. **退出前调用 `logger.complete()`**：确保异步日志全部刷盘，不丢失。
4. **生产环境关闭 `diagnose=True`**（默认值）：防止泄露变量值到日志中。
5. **格式化用 `{}` 风格**：与 `str.format()` 一致，别用 `%`。
6. **库中不调用 `add()`**：用 `disable(__name__)` 让日志变空操作，由应用端 `enable()` 控制。

## 进一步查阅

- 需要具体 API 签名和参数 → `references/api.md`
- 需要直接可用的代码配方 → `references/patterns.md`
