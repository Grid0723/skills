# Mock 策略与最佳实践

Mock 的核心原则：**mock 接缝（seam），不 mock 实现细节**。

## 何时 Mock

| 场景 | Mock 策略 | 原因 |
|------|----------|------|
| 外部服务（API/数据库/文件系统） | 必须 mock | 测试不应依赖外部服务可用性 |
| 第三方库的副作用操作 | 必须 mock | 测试不应真正发送邮件、写入云存储 |
| 耗时操作（网络请求、大计算） | 推荐 mock | 测试应快速运行 |
| 尚未实现的依赖模块 | 推荐 mock | 先定义接口契约，后实现 |

## 何时不 Mock

| 场景 | 不 Mock 的策略 | 原因 |
|------|--------------|------|
| 纯函数（无副作用、确定性输出） | 直接测试 | mock 纯函数是过度隔离 |
| 值对象/数据类 | 直接构造实例 | mock 数据对象增加噪音无价值 |
| 被测试模块内部的私有方法 | 不 mock | mock 内部实现让测试脆弱——重构即破裂 |
| 标准库函数 | 不 mock | 标准库的行为是可信的 |

## Mock 模式

### 经典：替换依赖

```python
# 在测试中替换外部依赖的实例
def test_fetch_stock_data(mocker):
    mock_api = mocker.patch("src.fetchers.tq_api")
    mock_api.get_market_data.return_value = {"000001.SZ": [...]}
    result = fetch_data("000001.SZ")
    assert result is not None
```

### 反模式：mock 内部实现

```python
# ❌ mock 了被测试模块自己的内部函数
def test_process(mocker):
    mocker.patch("src.module._internal_helper")  # 千万别
```

## 验证 Mock 调用

```python
# 验证 mock 被正确调用（而非仅验证返回值）
mock_api.get_market_data.assert_called_once_with(
    stock_list=["000001.SZ"],
    period="1d",
    start_date="20250101"
)
```

## TypeScript 端（trading_assistant）

```typescript
// Jest Mock
jest.mock("../prisma.service");
const mockPrisma = {
  tradeRecord: { findMany: jest.fn().mockResolvedValue([]) }
};

// NestJS Testing Module
const module = await Test.createTestingModule({
  providers: [
    TradeService,
    { provide: PrismaService, useValue: mockPrisma }
  ]
}).compile();
```

## 红线

- mock 接缝（模块边界），不 mock 内部实现
- 每个测试只 mock 必要的依赖——过度 mock 掩盖真实的依赖关系
- mock 的返回值应与真实 API 的返回值结构一致
- 测试不应验证 mock 的内部逻辑——只验证被测试模块对 mock 返回值的处理
