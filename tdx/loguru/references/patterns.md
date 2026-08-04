# Loguru 常用配方

> 可直接复制粘贴的常见场景代码片段。所有示例均遵循 Loguru 最佳实践。

## 目录

1. [最小化快速启动](#1-最小化快速启动)
2. [文件日志 + 轮转 + 保留](#2-文件日志--轮转--保留)
3. [多通道日志（文件 + 终端 + 数据库）](#3-多通道日志文件--终端--数据库)
4. [结构化 JSON 日志](#4-结构化-json-日志)
5. [带上下文的日志](#5-带上下文的日志)
6. [异常捕获与诊断](#6-异常捕获与诊断)
7. [与标准 logging 互操作](#7-与标准-logging-互操作)
8. [在库中安全使用](#8-在库中安全使用)
9. [自定义日志级别](#9-自定义日志级别)
10. [从配置文件加载](#10-从配置文件加载)
11. [解析历史日志文件](#11-解析历史日志文件)
12. [生产环境安全配置](#12-生产环境安全配置)

---

## 1. 最小化快速启动

```python
from loguru import logger

# 默认输出到 stderr，开箱即用
logger.debug("调试信息")
logger.info("普通信息")
logger.warning("警告信息")
logger.error("错误信息")
```

---

## 2. 文件日志 + 轮转 + 保留

```python
from loguru import logger

logger.remove()  # 先清空默认 handler

# 按大小轮转
logger.add("app.log", rotation="50 MB")

# 按时间轮转（每天中午）
logger.add("daily.log", rotation="12:00")

# 按时间轮转 + 保留 7 天 + 压缩
logger.add(
    "app_{time:YYYY-MM-DD}.log",
    rotation="1 day",
    retention="7 days",
    compression="zip",
    encoding="utf-8",
)

# 自定义格式化
logger.add(
    "formatted.log",
    format="{time:YYYY-MM-DD HH:mm:ss.SSS} | {level: <8} | {name}:{function}:{line} | {message}",
    level="DEBUG",
)
```

---

## 3. 多通道日志（文件 + 终端 + 数据库）

```python
import sys
from loguru import logger

logger.remove()

# 通道 1：文件 — 详细 JSON（DEBUG 以上全量）
logger.add(
    "logs/app_{time:YYYY-MM-DD}.log",
    format="{message}",
    serialize=True,
    rotation="10 MB",
    retention=30,
    level="DEBUG",
    encoding="utf-8",
    enqueue=True,
)

# 通道 2：文件 — 仅错误（ERROR 以上）
logger.add(
    "logs/error_{time:YYYY-MM-DD}.log",
    format="{message}",
    serialize=True,
    rotation="10 MB",
    level="ERROR",
    encoding="utf-8",
    enqueue=True,
)

# 通道 3：终端 — 带颜色，INFO 以上
logger.add(
    sys.stderr,
    format="<green>{time:HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan> - <level>{message}</level>",
    level="INFO",
    colorize=True,
    enqueue=True,
)

# 通道 4：自定义 sink 函数（例如写入数据库）
def db_sink(message):
    record = message.record
    save_to_db(
        time=record["time"],
        level=record["level"].name,
        message=record["message"],
        module=record["name"],
    )

logger.add(db_sink, level="WARNING", enqueue=True)

# 程序退出前
logger.complete()
```

---

## 4. 结构化 JSON 日志

```python
from loguru import logger

logger.remove()

# sink 函数：每条消息自动转 JSON
def json_sink(message):
    import json
    record = message.record
    serialized = json.dumps({
        "timestamp": record["time"].isoformat(),
        "level": record["level"].name,
        "message": record["message"],
        "module": record["name"],
        "function": record["function"],
        "line": record["line"],
        "thread": record["thread"].name,
        "extra": record["extra"],
        "exception": record["exception"],
    })
    print(serialized)  # 或写入文件、发送到 ELK 等

logger.add(json_sink, level="DEBUG", enqueue=True)

# 带上下文的日志
with logger.contextualize(request_id="abc-123"):
    logger.info("处理请求")

# 输出：
# {"timestamp": "2026-06-04T10:30:00", "level": "INFO", "message": "处理请求", "extra": {"request_id": "abc-123"}, ...}
```

---

## 5. 带上下文的日志

### 5a. 绑定固定上下文

```python
from loguru import logger

# 为特定模块创建带上下文的 logger
user_logger = logger.bind(user_id=42, ip="192.168.1.1")

# 配合 format 使用
logger.add("user.log", format="{extra[user_id]} | {extra[ip]} | {message}")

user_logger.info("用户登录")
user_logger.info("用户购买")
# 输出: 42 | 192.168.1.1 | 用户登录
```

### 5b. 临时上下文（with 块）

```python
def process_order(order_id):
    with logger.contextualize(order_id=order_id):
        logger.info("订单处理开始")
        validate()
        logger.info("校验通过")
        charge()
        logger.info("扣款成功")
    # 离开 with 块后，order_id 自动清除
```

### 5c. 动态 patch

```python
import os
from loguru import logger

# 每次日志自动附加进程 ID
logger = logger.patch(lambda r: r["extra"].update(pid=os.getpid(), host="server-01"))

logger.info("服务启动")  # extra 包含 pid 和 host
```

### 5d. filter 过滤

```python
# 只记录 admin 角色到特定文件
logger.add("admin.log", filter=lambda r: r["extra"].get("role") == "admin")

logger.bind(role="admin").info("管理员操作")  # ✅ 写入 admin.log
logger.bind(role="user").info("用户操作")     # ❌ 不写入
```

---

## 6. 异常捕获与诊断

### 6a. 装饰器自动捕获

```python
@logger.catch
def fetch_data(url):
    response = requests.get(url, timeout=5)
    return response.json()

# 异常自动记录到所有已配置的 sink
```

### 6b. exception() 方法（推荐用于 try/except）

```python
try:
    process_data()
except Exception:
    logger.exception("数据处理失败")  # 自动附加完整堆栈 + 变量值
```

### 6c. 启用完整诊断（开发环境）

```python
# ⚠️ diagnose=True 是默认值，生产环境会泄露变量值！
logger.add("debug.log", backtrace=True, diagnose=True)

def divide(a, b):
    return a / b

try:
    divide(5, 0)
except ZeroDivisionError:
    logger.exception("除零错误")
```

输出：
```
2026-06-04 10:30:00 | ERROR | __main__:divide:4 - 除零错误
Traceback (most recent call last):
  File "app.py", line 7, in <module>
    divide(5, 0)
    │        └ 0
    └ <function divide at 0x7f...>
> File "app.py", line 4, in divide
    return a / b
           │   └ 0
           └ 5
ZeroDivisionError: division by zero
```

---

## 7. 与标准 logging 互操作

### 7a. 将标准 logging 消息拦截到 Loguru

```python
import logging
import inspect
from loguru import logger

class InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        # 获取对应 Loguru 级别
        level: str | int
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        # 查找原始调用者（跳过 logging 框架自身）
        frame, depth = inspect.currentframe(), 0
        while frame and (depth == 0 or frame.f_code.co_filename == logging.__file__):
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())

# 一次性替换所有标准 logging
logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)
```

### 7b. 将标准 logging Handler 作为 Loguru sink

```python
import logging.handlers
from loguru import logger

handler = logging.handlers.SysLogHandler(address=('localhost', 514))
logger.add(handler)
```

---

## 8. 在库中安全使用

```python
# 在库的 __init__.py 中
from loguru import logger

logger.disable(__name__)  # 库的日志默认不输出

# 在库代码中正常使用 logger
def library_function():
    logger.debug("库内部调试信息")  # 默认不输出
    logger.info("库内部信息")       # 默认不输出

# 应用端决定是否启用
# 在应用入口：
# from loguru import logger
# logger.enable("my_library")
```

---

## 9. 自定义日志级别

```python
from loguru import logger

# 创建自定义级别
logger.level("METRICS", no=15, color="<blue>", icon="📊")

# 使用
logger.log("METRICS", "QPS=1200, P99=45ms")
```

---

## 10. 从配置文件加载

### YAML 配置

```yaml
# log_config.yaml
logging:
  handlers:
    - sink: "app.log"
      format: "{time} - {message}"
      level: "INFO"
    - sink: "error.log"
      format: "{time} - {level} - {message}"
      level: "ERROR"
  extra:
    service: "my-service"
```

### 加载代码

```python
import yaml
from loguru import logger

with open("log_config.yaml") as f:
    config = yaml.safe_load(f)

logger.configure(**config["logging"])
```

---

## 11. 解析历史日志文件

```python
import dateutil.parser
from loguru import logger

pattern = r"(?P<time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \| (?P<level>\w+)\s+\| (?P<message>.*)"
caster_dict = dict(time=dateutil.parser.parse)

for groups in logger.parse("app.log", pattern, cast=caster_dict):
    # groups = {"time": datetime(...), "level": "INFO", "message": "..."}
    if groups["level"] == "ERROR":
        print(f"错误发生时间: {groups['time']}, 消息: {groups['message']}")
```

---

## 12. 生产环境安全配置

```python
import sys
from loguru import logger

logger.remove()

# ⚠️ 生产环境一定要关闭 diagnose（默认是 True）
logger.add(
    "prod_{time:YYYY-MM-DD}.log",
    rotation="50 MB",
    retention="30 days",
    compression="zip",
    level="INFO",
    diagnose=False,     # 不输出变量值，防止泄露
    backtrace=False,    # 不输出完整回溯
    enqueue=True,
)

# 终端只显示 WARNING 以上
logger.add(
    sys.stderr,
    format="<level>{level: <8}</level> | {message}",
    level="WARNING",
    colorize=True,
    enqueue=True,
)

# 敏感数据过滤（自定义 sink 中实现）
def safe_sink(message):
    record = message.record
    msg = record["message"]
    # 移除 token、密码等敏感信息
    msg = msg.replace(os.getenv("API_KEY", ""), "***")
    save_securely(msg)

# 退出前确保刷盘
import atexit
atexit.register(logger.complete)
```
