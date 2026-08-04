# 测试模式与断言规约

测试文件的结构、命名和断言标准。

## 测试文件命名

| 场景 | 命名 |
|------|------|
| Python 单元测试 | `test_<module>.py` |
| Python 集成测试 | `test_<fetcher>_integration.py` |
| TypeScript 单元测试 | `<name>.spec.ts` |
| TypeScript E2E | `<name>.e2e-spec.ts` |

## 测试结构（AAA 模式）

```
Arrange   —— 准备测试数据和 mock
Act       —— 执行被测代码
Assert    —— 验证结果
```

```python
def test_calculate_profit():
    # Arrange
    buy_price = Decimal("10.50")
    sell_price = Decimal("12.30")

    # Act
    profit = calculate_profit(buy_price, sell_price)

    # Assert
    assert profit == Decimal("1.80")
```

## 断言规约

### Python

```python
# 浮点/金额比较——不用 assertEqual 比较 float
assert profit == Decimal("1.80")       # 金额用 Decimal 精确比较
assert math.isclose(result, 0.333, rel_tol=1e-4)  # 科学计算用 isclose

# 异常验证
with pytest.raises(ValueError, match="股票代码不能为空"):
    fetch_data("")

# 集合验证
assert len(results) == 10
assert all(r.price > 0 for r in results)

# DataFrame 验证（TDX 项目）
assert not df.empty
assert list(df.columns) == ["date", "open", "high", "low", "close", "volume"]
assert df["date"].is_unique  # 无重复日期
```

### TypeScript（Jest）

```typescript
// 金额比较——不用 toBe 比较浮点
expect(new Decimal(result).equals(new Decimal("1.80"))).toBe(true);

// 异常验证
await expect(service.create(invalidDto)).rejects.toThrow(BadRequestException);

// 集合验证
expect(results).toHaveLength(10);
expect(results.every(r => r.price > 0)).toBe(true);

// 快照测试（DTO/响应结构稳定时）
expect(response).toMatchSnapshot();
```

## 反模式

```python
# ❌ 一个测试验证多个不相关的行为
def test_everything():
    assert fetch() is not None
    assert calculate() == 42
    assert format() == "ok"

# ❌ 测试逻辑中使用条件分支
def test_with_if():
    result = fetch()
    if result:
        assert len(result) > 0
    else:
        assert result is None

# ❌ 测试依赖执行顺序
# test_a 必须在 test_b 之前运行（test_b 依赖 test_a 的副作用）

# ❌ 测试中重复实现逻辑
def test_calculate():
    expected = a + b  # 这是"实现"——应该写死期望值
    assert calculate(a, b) == expected
```

## 测试描述规范

测试名描述**行为**和**预期结果**，而非实现细节：

```
✅ test_returns_empty_list_when_no_data
✅ test_raises_value_error_for_invalid_stock_code
✅ test_upsert_updates_existing_record

❌ test_fetch_calls_api
❌ test_handler_works
❌ test_case_1
```

## 一个测试一个断言？

**不是。** 一个测试一个**行为**。如果验证一个行为需要多个断言，就写多个。关键是每个测试只描述一个场景。

```python
def test_fetch_returns_correct_structure():  # 一个行为
    result = fetch("000001.SZ")
    assert "stock_code" in result         # 断言 1
    assert "date" in result               # 断言 2
    assert len(result["data"]) > 0        # 断言 3
    # 这三个断言都在验证同一个行为："返回结构正确"
```
