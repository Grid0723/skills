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
        # [ \t] 而非 \s：.NET 的 \s 会跨行匹配，导致 tags: 空值吞掉下一行列表项
        $m = [regex]::Match($fm, "(?m)^$name[ \t]*:[ \t]*(.*?)[ \t]*$")
        if ($m.Success) {
            $v = $m.Groups[1].Value.Trim()
            if (($v.StartsWith('"') -and $v.EndsWith('"')) -or ($v.StartsWith("'") -and $v.EndsWith("'"))) {
                $v = $v.Substring(1, $v.Length - 2)
            }
            return $v
        }
        return $null
    }

    # 解析 tags：同时支持行内数组 tags: [a, b] 与块级列表 tags:\n  - a
    function Get-Tags {
        $result = New-Object System.Collections.Generic.List[string]
        $inline = [regex]::Match($fm, "(?m)^tags[ \t]*:[ \t]*(.*?)[ \t]*$").Groups[1].Value
        $inline = ($inline -split '\s+#', 2)[0].Trim()
        if ($inline -and $inline -ne "[]") {
            $q = [regex]::Match($inline, '^"(.*)"$')
            if ($q.Success) { $inline = $q.Groups[1].Value }
            if ($inline.StartsWith("[") -and $inline.EndsWith("]")) {
                $inline = $inline.Substring(1, $inline.Length - 2)
            }
            foreach ($t in $inline.Split(",")) {
                $v = $t.Trim().Trim("'", '"')
                if ($v) { $result.Add($v) }
            }
            return $result
        }
        # 块级列表：取 tags: 之后连续的缩进列表项
        $block = [regex]::Match($fm, "(?ms)^tags[ \t]*:[ \t]*\r?\n((?:[ \t]+-[^\r\n]*(?:\r?\n|$))+)")
        if ($block.Success) {
            foreach ($line in ($block.Groups[1].Value -split "\r?\n")) {
                $v = $line.Trim()
                if (-not $v.StartsWith("-")) { continue }
                $v = $v.Substring(1).Trim().Trim("'", '"')
                if ($v) { $result.Add($v) }
            }
        }
        return $result
    }

    $type = Get-Field "类型"
    $status = Get-Field "状态"
    $tags = Get-Tags

    # 必填字段
    if (-not (Get-Field "Author")) { $fail.Add("[frontmatter] $rel — 缺 Author") }
    if (-not [regex]::IsMatch($fm, "(?m)^tags[ \t]*:")) { $fail.Add("[frontmatter] $rel — 缺 tags") }
    foreach ($field in @("类型", "创建", "修改")) {
        if (-not (Get-Field $field)) { $fail.Add("[frontmatter] $rel — 缺 $field") }
    }

    # 类型与状态
    if ($type) {
        if ($type -notin $types) { $warn.Add("[类型] $rel — 非标准类型：$type") }
        if ($type -ne "想法" -and $type -ne "索引" -and $type -ne "项目" -and -not $status) {
            $fail.Add("[状态] $rel — 类型 $type 缺 状态")
        }
        # 项目类型状态由各项目规范自定义，不套四态状态机
        if ($type -ne "项目" -and $status -and $status -notin $states) {
            $fail.Add("[状态] $rel — 非法状态：$status")
        }
    }

    # 坏 frontmatter（用原始行判断，剥离引号前）
    # 先剥掉行内注释：模板里的 `状态: 待整理  # 待整理 | 已归位` 是合法写法
    $statusRaw = [regex]::Match($fm, "(?m)^状态:\s*(.*?)\s*$").Groups[1].Value
    if ($statusRaw) { $statusRaw = ($statusRaw -split '\s+#', 2)[0].Trim() }
    if ($statusRaw -and ($statusRaw -match '\|' -or $statusRaw -match '^"|"$')) {
        $fail.Add("[frontmatter] $rel — 状态字段格式异常：$statusRaw")
    }

    # 标签格式
    foreach ($t in $tags) {
        if ($t -match '\\|\[|\]' -or -not $t.Contains("/")) {
            $warn.Add("[标签] $rel — 非标准标签：$t")
        }
    }

    # 重复文件：仅当去掉编号后的同名原件确实存在时才报，避免「(2025)」「 1」这类合法命名误报
    $dupName = $null
    if ($file.BaseName -match '^(.*?)\s\d+$') { $dupName = $matches[1].Trim() }
    elseif ($file.BaseName -match '^(.*?)\(\d+\)$') { $dupName = $matches[1].Trim() }
    if ($dupName) {
        $hasBase = Get-ChildItem -Path $file.DirectoryName -Filter "*.md" -File |
            Where-Object { $_.BaseName -eq $dupName }
        if ($hasBase) {
            $warn.Add("[重复] $rel — 疑似副本（原件：$dupName.md）")
        }
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
