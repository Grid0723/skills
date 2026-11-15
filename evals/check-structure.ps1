# evals/check-structure.ps1
# 结构检查（Tier 1）——只读扫描，不修改任何文件。
# 用法：pwsh -File evals/check-structure.ps1 [-Root <skills 仓库根>]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Root)) {
    Write-Host "路径不存在：$Root" -ForegroundColor Red
    exit 2
}

$fail = New-Object System.Collections.Generic.List[string]
$warn = New-Object System.Collections.Generic.List[string]
$skills = @()

# 收集所有 SKILL.md（排除 evals 目录自身）
Get-ChildItem -Path $Root -Recurse -Filter "SKILL.md" -File |
    Where-Object { $_.FullName -notmatch "[\\/]evals[\\/]" } |
    ForEach-Object { $skills += $_ }

foreach ($file in $skills) {
    $rel = $file.FullName.Substring($Root.Length).TrimStart('\', '/')
    $text = Get-Content -Raw -Encoding UTF8 $file.FullName
    $lineCount = ($text -split "`r?`n").Count

    # frontmatter 必备字段
    if ($text -notmatch "(?m)^name:\s*\S+") { $fail.Add("$rel 缺少 name") }
    if ($text -notmatch "(?m)^description:\s*\S+") { $fail.Add("$rel 缺少 description") }

    # 行数上限
    if ($lineCount -gt 500) { $fail.Add("$rel 行数 $lineCount 超过 500") }

    # 编排器不得隐藏
    $isOrchestrator = $file.DirectoryName -match "[\\/](fabric|grid|learn)$"
    if ($isOrchestrator -and $text -match "(?m)^disable-model-invocation:\s*true") {
        $fail.Add("$rel 是编排器，不应设置 disable-model-invocation")
    }

    # Gotchas 目前只告警，待 retro 逐步回填
    if ($text -notmatch "(?m)^##\s*Gotchas") { $warn.Add("$rel 缺少 Gotchas") }
}

# references 只允许一层（SKILL.md → references/*.md）
# 例外：references/templates/ 是模板集合，允许按目录分类
Get-ChildItem -Path $Root -Recurse -Directory -Filter "references" |
    Where-Object { $_.FullName -notmatch "[\\/]evals[\\/]" } |
    ForEach-Object {
        $subDirs = Get-ChildItem -Path $_.FullName -Directory
        $unexpected = $subDirs | Where-Object { $_.Name -notin @("templates", "instances") }
        if ($unexpected) {
            $rel = $_.FullName.Substring($Root.Length).TrimStart('\', '/')
            $warn.Add("$rel 存在非模板的二级目录")
        }
    }

Write-Host "结构检查：$($skills.Count) 个 SKILL.md"
Write-Host "失败：$($fail.Count)   警告：$($warn.Count)"

if ($fail.Count -gt 0) {
    Write-Host "`n失败项：" -ForegroundColor Red
    $fail | ForEach-Object { Write-Host "  - $_" }
}
if ($warn.Count -gt 0) {
    Write-Host "`n警告项：" -ForegroundColor Yellow
    $warn | ForEach-Object { Write-Host "  - $_" }
}

if ($fail.Count -gt 0) { exit 1 } else { exit 0 }
