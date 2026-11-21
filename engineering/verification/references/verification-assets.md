# 验证资产模板与脚本骨架

## 一、功能地图

固定路径：`docs/08-Testing/功能地图.md`

```markdown
# 功能地图

> 用途：让 agent 用一条命令证明改动有效。冒烟项 ≤10 条。
> 驱动脚本：`scripts/verify.ps1`（按项目技术栈替换）

## 核心路径（冒烟）

| 功能 | 触达方式 | 前置数据 | 期望结果 |
|---|---|---|---|
| 应用启动 | `pnpm dev` → 访问 `http://localhost:3000` | 无 | 返回 200，首页含「登录」 |
| 用户登录 | `curl -X POST /api/login -d '{"u":"demo","p":"demo"}'` | seed 用户 demo | 200 + token 字段 |
| 创建订单 | `curl -X POST /api/orders -H "Authorization: Bearer $TOKEN" -d '{...}'` | 已登录 | 201 + orderId，库中可查 |
| 订单列表 | `curl /api/orders -H "Authorization: Bearer $TOKEN"` | 已有 1 条订单 | 200 + 数组长度 ≥1 |

## 按需路径

| 功能 | 触达方式 | 说明 |
|---|---|---|
| 导出 CSV | `curl /api/orders/export` | 数据量大时手动验证 |

## 环境前提

- 端口、数据库、种子数据的准备命令
- 不可用依赖的降级方式（见下）
```

规则：

- 「触达方式」必须可复制执行，不写「打开页面点一下」
- 「前置数据」写清如何准备（seed 命令 / fixture 路径）
- 失败项要能对应到功能名，驱动脚本的输出必须带功能名

## 二、一键驱动脚本

默认路径 `scripts/verify.<ext>`，与项目技术栈一致；不要引入新运行时。

### Node / TypeScript（`scripts/verify.mjs`）

```js
// 一键验证：按功能地图顺序跑冒烟项，任一失败即非零退出。
// 用法：node scripts/verify.mjs [--offline]
import { spawnSync } from "node:child_process";

const offline = process.argv.includes("--offline");
const results = [];

// 每个冒烟项：name + 执行函数；失败时记录功能名，不中断后续收集
async function check(name, fn) {
  try {
    await fn();
    results.push({ name, ok: true });
    console.log(`[PASS] ${name}`);
  } catch (err) {
    results.push({ name, ok: false, error: err.message });
    console.error(`[FAIL] ${name}: ${err.message}`);
  }
}

await check("应用启动", async () => {
  const res = await fetch("http://localhost:3000");
  if (res.status !== 200) throw new Error(`HTTP ${res.status}`);
});

await check("用户登录", async () => {
  if (offline) {
    console.log("[SKIP] 用户登录：--offline");
    return;
  }
  const res = await fetch("http://localhost:3000/api/login", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ u: "demo", p: "demo" }),
  });
  if (res.status !== 200) throw new Error(`HTTP ${res.status}`);
});

const failed = results.filter((r) => !r.ok);
console.log(`\n${results.length - failed.length}/${results.length} 通过`);
// 任一失败即非零退出，CI 与 agent 都靠这个判定
process.exit(failed.length === 0 ? 0 : 1);
```

### Python（`scripts/verify.py`）

```python
"""一键验证：按功能地图顺序跑冒烟项，任一失败即非零退出。"""
import os
import sys

import httpx

RESULTS = []


def check(name):
    """装饰器：记录单个冒烟项的结果，失败不中断后续项。"""
    def wrap(fn):
        try:
            fn()
            RESULTS.append((name, True))
            print(f"[PASS] {name}")
        except Exception as exc:  # noqa: BLE001 - 验证脚本需要收集所有失败
            RESULTS.append((name, False))
            print(f"[FAIL] {name}: {exc}")
        return fn
    return wrap


@check("应用启动")
def app_up():
    res = httpx.get("http://localhost:3000", timeout=5)
    assert res.status_code == 200, f"HTTP {res.status_code}"


@check("用户登录")
def login():
    if "--offline" in sys.argv:
        print("[SKIP] 用户登录：--offline")
        return
    res = httpx.post(
        "http://localhost:3000/api/login",
        json={"u": "demo", "p": "demo"},
        timeout=5,
    )
    assert res.status_code == 200, f"HTTP {res.status_code}"


failed = [name for name, ok in RESULTS if not ok]
print(f"\n{len(RESULTS) - len(failed)}/{len(RESULTS)} 通过")
sys.exit(0 if not failed else 1)
```

### PowerShell（`scripts/verify.ps1`）

```powershell
# 一键验证：按功能地图顺序跑冒烟项，任一失败即非零退出。
# 用法：pwsh -File scripts/verify.ps1 [-Offline]
param([switch]$Offline)

$ErrorActionPreference = "Stop"
$results = @()

function Test-Step {
    param([string]$Name, [scriptblock]$Action)
    try {
        & $Action
        $script:results += @{ Name = $Name; Ok = $true }
        Write-Host "[PASS] $Name"
    } catch {
        $script:results += @{ Name = $Name; Ok = $false }
        Write-Host "[FAIL] $Name : $($_.Exception.Message)"
    }
}

Test-Step "应用启动" {
    $res = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing
    if ($res.StatusCode -ne 200) { throw "HTTP $($res.StatusCode)" }
}

Test-Step "用户登录" {
    if ($Offline) { Write-Host "[SKIP] 用户登录：-Offline"; return }
    $body = @{ u = "demo"; p = "demo" } | ConvertTo-Json
    $res = Invoke-RestMethod -Uri "http://localhost:3000/api/login" -Method Post -Body $body -ContentType "application/json"
    if (-not $res.token) { throw "响应缺少 token" }
}

$failed = @($results | Where-Object { -not $_.Ok })
Write-Host "`n$($results.Count - $failed.Count)/$($results.Count) 通过"
exit ([int]($failed.Count -gt 0))
```

## 三、退出码与输出约定

| 约定 | 要求 |
|---|---|
| 成功 | 退出码 0，打印 `N/N 通过` |
| 失败 | 退出码非 0，每个失败项打印 `[FAIL] <功能名>: <原因>` |
| 跳过 | 打印 `[SKIP] <功能名>: <原因>`；全部跳过时仍返回非 0，避免"静默绿" |
| 日志 | 输出到 stdout/stderr，便于 agent 截取证据片段 |

## 四、CI 接入

```yaml
# .github/workflows/verify.yml（示例）
- run: |
    <启动依赖：数据库/容器>
    <准备种子数据>
    <启动应用并等待端口就绪>
    <运行 scripts/verify.*>
```

CI 与本地共用同一个脚本，不写第二套冒烟逻辑。

## 五、降级与纯库项目

**外部依赖不可用**：

- 支持 `--offline`：跳过依赖外网的项，逐条打印 `[SKIP]` 与原因
- 不允许把失败改写为跳过；跳过必须显式声明

**纯库项目（无服务入口）**：

```python
# scripts/verify.py —— 通过公共 API 跑一个最小端到端示例
from mylib import Client

def check_roundtrip():
    client = Client()
    client.put("k", "v")
    assert client.get("k") == "v"

check_roundtrip()
```

功能地图的「触达方式」写示例命令（如 `python examples/roundtrip.py`），期望结果写可判断的输出。

## 六、与 implement 的接入

```text
implement 单任务：
  tdd 绿 → 检查 docs/08-Testing/功能地图.md 是否存在
    → 存在：运行 scripts/verify.*，输出作为「已复现」证据
    → 不存在：记录「未建立验证资产」，提示可运行 verification
  → code-review → commit
```

证据示例（写进 Task 收尾或实现日志）：

```text
验证：node scripts/verify.mjs
结果：4/4 通过（exit 0）
失败项：无
```
