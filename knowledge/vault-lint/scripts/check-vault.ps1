# vault-lint 检查脚本（只读）
# 用法：pwsh -File scripts/check-vault.ps1 [-Vault <vault 根>] [-Limit 50]
param(
    [string]$Vault = (Get-Location).Path,
    [int]$Limit = 50
)

$ErrorActionPreference = "Stop"

$targets = @("00_收集箱", "01_孵化", "10_领域", "20_项目")
$exclude = @("Grid\\skills", "90_归档", "\\.git\\", "\\.trash\\")

$states = @("待整理", "已归位", "已提炼", "可输出")
$types = @("剪藏", "永久笔记", "项目", "速记", "想法", "索引")

$fail = New-Object System.Collections.Generic.List[string]
$warn = New-Object System.Collections.Generic.List[string]
$files = @()

foreach ($dir in $targets) {
    $path = Join-Path $Vault $dir
    if (-not (Test-Path $path)) { continue }
    Get-ChildItem -Path $path -Recurse -Filter "*.md" -File | ForEach-Object {
        $skip = $false
        foreach ($pattern in $exclude) {
            if ($_.FullName -match $pattern) { $skip = $true }
        }
        if ($_.FullName -match "[\\/]20_项目[\\/]" -and $_.Name -notin @("总览.md", "项目计划.md", "外部链接.md")) {
            $skip = $true
        }
        if (-not $skip) { $files += $_ }
    }
}

foreach ($file in $files) {
    $rel = $file.FullName.Substring($Vault.Length).TrimStart('\', '/')
    $text = Get-Content -Raw -Encoding UTF8 $file.FullName
    if ($null -eq $text) { $text = "" }

    # 20_项目 只检查管理文档
    if ($rel -like "20_项目*") {
        $name = $file.Name
        if ($name -notin @("总览.md", "项目计划.md", "外部链接.md")) { continue }
    }

    $match = [regex]::Match($text, "(?s)^---\r?\n(.*?)\r?\n---")
    if (-not $match.Success) {
        $fail.Add("[frontmatter] $rel — 缺少 frontmatter")
        continue
    }
    $fm = $match.Groups[1].Value

    function Get-Field([string]$name) {
        $m = [regex]::Match($fm, "(?m)^$name`:\s*(.*?)\s*$")
        if ($m.Success) {
            $v = $m.Groups[1].Value.Trim()
            if (($v.StartsWith('"') -and $v.EndsWith('"')) -or ($v.StartsWith("'") -and $v.EndsWith("'"))) {
                $v = $v.Substring(1, $v.Length - 2)
            }
            return $v
        }
        return $null
    }

    $type = Get-Field "类型"
    $status = Get-Field "状态"

    # 必填字段
    foreach ($field in @("Author", "tags", "类型", "创建", "修改")) {
        if (-not (Get-Field $field)) { $fail.Add("[frontmatter] $rel — 缺 $field") }
    }

    # 类型与状态
    if ($type) {
        if ($type -notin $types) { $warn.Add("[类型] $rel — 非标准类型：$type") }
        if ($type -ne "想法" -and $type -ne "索引" -and -not $status) {
            $fail.Add("[状态] $rel — 类型 $type 缺 状态")
        }
        if ($type -eq "项目" -and $status -and $status -notin $states) {
            # 项目类型状态由项目规范定义，只提示
            $warn.Add("[状态] $rel — 项目类型使用自定义状态：$status")
        }
        if ($type -ne "项目" -and $status -and $status -notin $states) {
            $fail.Add("[状态] $rel — 非法状态：$status")
        }
    }

    # 坏 frontmatter（用原始行判断，剥离引号前）
    $statusRaw = [regex]::Match($fm, "(?m)^状态:\s*(.*?)\s*$").Groups[1].Value
    if ($statusRaw -and ($statusRaw -match '\|' -or $statusRaw -match '^"|"$')) {
        $fail.Add("[frontmatter] $rel — 状态字段格式异常：$statusRaw")
    }

    # 标签格式
    $tagLine = Get-Field "tags"
    if ($tagLine -and $tagLine -ne "[]") {
        $inner = $tagLine.Trim()
        if ($inner.StartsWith("[")) { $inner = $inner.Substring(1, $inner.Length - 2) }
        foreach ($tag in $inner.Split(",")) {
            $t = $tag.Trim().Trim("'", '"')
            if (-not $t) { continue }
            if ($t.StartsWith("-") -or $t.Contains("[") -or $t.Contains("\") -or -not $t.Contains("/")) {
                $warn.Add("[标签] $rel — 非标准标签：$t")
            }
        }
    }

    # 重复文件
    if ($file.Name -match "\s\d+\.md$" -or $file.Name -match "\(\d+\)\.md$") {
        $warn.Add("[重复] $rel — 疑似副本")
    }
}

$failCount = $fail.Count
$warnCount = $warn.Count

Write-Host "Vault 体检"
Write-Host "- 扫描：$($files.Count) 篇"
Write-Host "- 失败：$failCount"
Write-Host "- 警告：$warnCount"

if ($failCount -gt 0) {
    Write-Host "`n## 失败" -ForegroundColor Red
    $fail | Select-Object -First $Limit | ForEach-Object { Write-Host "  - $_" }
}
if ($warnCount -gt 0) {
    Write-Host "`n## 警告" -ForegroundColor Yellow
    $warn | Select-Object -First $Limit | ForEach-Object { Write-Host "  - $_" }
}

if ($failCount -gt 0) { exit 1 } else { exit 0 }
