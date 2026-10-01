# 中文 AI 编程 CLI 工作流包 —— 一键安装脚本（Windows PowerShell 5.1 / 7+）
#
# 用法：
#   .\install.ps1            # 同时安装到 Claude Code 与 Codex CLI
#   .\install.ps1 -ClaudeOnly  # 只装 Claude Code
#   .\install.ps1 -CodexOnly    # 只装 Codex CLI
#
# 安装位置（实测结论，见 commands/测试记录-D2.md）：
#   Claude Code : $HOME\.claude\commands\<name>.md      （扁平文件，原样复制）
#   Codex CLI   : $HOME\.codex\skills\<name>\SKILL.md   （目录结构，frontmatter 只留 name+description）
#
# 可重复执行（幂等）。本文件请用 UTF-8 with BOM 保存（Windows PowerShell 5.1 中文显示需要）。

[CmdletBinding()]
param(
    [switch]$ClaudeOnly,
    [switch]$CodexOnly
)

$ErrorActionPreference = 'Stop'

$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommandsDir  = Join-Path (Split-Path -Parent $ScriptDir) 'commands'
# 安装根目录：默认用 $HOME（PowerShell 自动变量 = 用户主目录）。
# 若环境变量 HOME 被显式设置且指向已存在的目录（如 CI 用临时目录做隔离测试），则优先用它。
$HomeDir = $HOME
if ($env:HOME -and (Test-Path $env:HOME)) { $HomeDir = $env:HOME }
$ClaudeDir    = Join-Path $HomeDir '.claude\commands'
$CodexDir     = Join-Path $HomeDir '.codex\skills'

$InstallClaude = -not $CodexOnly
$InstallCodex  = -not $ClaudeOnly

# ---- 前置检查 ----
if (-not (Test-Path $CommandsDir)) {
    Write-Host "错误：找不到 commands 目录：$CommandsDir" -ForegroundColor Red
    Write-Host "请在解压后的完整包目录里运行本脚本。"
    exit 1
}

$SrcFiles = Get-ChildItem -Path $CommandsDir -Filter '*.md' |
    Where-Object { $_.Name -notlike '测试记录*' } | Sort-Object Name
if ($SrcFiles.Count -eq 0) {
    Write-Host "错误：commands 目录下没有 command 文件。" -ForegroundColor Red
    exit 1
}
Write-Host "找到 $($SrcFiles.Count) 个 command 文件。"

# ---- frontmatter 转换：Codex 用（去掉自定的 cli: 行，只留 name/description）----
# 只处理文件开头的第一个 --- ... --- 块，块外的正文原样保留。
function Convert-ForCodex {
    param([string[]]$Lines)
    $out = @()
    $seenOpen = $false
    $inFm = $false
    foreach ($line in $Lines) {
        $t = $line.Trim()
        if (-not $seenOpen -and $t -eq '---') { $seenOpen = $true; $inFm = $true; $out += $line; continue }
        if ($seenOpen -and $inFm -and $t -eq '---') { $inFm = $false; $out += $line; continue }
        if ($inFm -and $t -match '^cli:') { continue }
        $out += $line
    }
    return $out
}

# ---- 安装到 Claude Code ----
$nClaude = 0
if ($InstallClaude) {
    if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null }
    foreach ($f in $SrcFiles) {
        Copy-Item -Path $f.FullName -Destination (Join-Path $ClaudeDir $f.Name) -Force
        $nClaude++
    }
    Write-Host "Claude Code：已安装 $nClaude 个 → $ClaudeDir"
}

# ---- 安装到 Codex CLI ----
$nCodex = 0
if ($InstallCodex) {
    foreach ($f in $SrcFiles) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
        $destDir = Join-Path $CodexDir $name
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        $lines = [System.IO.File]::ReadAllLines($f.FullName)
        $converted = Convert-ForCodex -Lines $lines
        [System.IO.File]::WriteAllLines((Join-Path $destDir 'SKILL.md'), $converted)
        $nCodex++
    }
    Write-Host "Codex CLI：已安装 $nCodex 个 → $CodexDir\<name>\SKILL.md"
}

# ---- 验证 ----
Write-Host "---- 验证 ----"
$ok = $true

if ($InstallClaude) {
    $got = (Get-ChildItem -Path $ClaudeDir -Filter '*.md' | Measure-Object).Count
    Write-Host "Claude Code 目录文件数：$got（期望 $($SrcFiles.Count)）"
    if ($got -lt $SrcFiles.Count) { $ok = $false }
}

if ($InstallCodex) {
    $got = (Get-ChildItem -Path $CodexDir -Recurse -Filter 'SKILL.md' | Measure-Object).Count
    Write-Host "Codex skills 目录 SKILL.md 数：$got（期望 $($SrcFiles.Count)）"
    if ($got -lt $SrcFiles.Count) { $ok = $false }
    $sample = Join-Path $CodexDir 'review\SKILL.md'
    if (Test-Path $sample) {
        $hasCli = Select-String -Path $sample -Pattern '^cli:' -Quiet
        if ($hasCli) {
            Write-Host "警告：$sample 仍含有 cli: 行，转换可能未生效。" -ForegroundColor Yellow
            $ok = $false
        } else {
            Write-Host "抽查 $sample：frontmatter 已去掉 cli: 行 ✓"
        }
    }
}

# codex 版本检查（旧版 0.149.0 会静默失败，见测试记录-D2.md）
$codexCmd = Get-Command codex -ErrorAction SilentlyContinue
if ($codexCmd) {
    try {
        $ver = (& $codexCmd.Source --version 2>$null)
        Write-Host "检测到 codex：$($codexCmd.Source)（$ver）"
        if ($ver -match '0\.149') {
            Write-Host "警告：这是旧版 codex（0.149.x），已知会静默失败，请升级到 0.159+（官方最新版）。" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "提示：codex 命令存在但无法获取版本，可忽略。"
    }
} else {
    Write-Host "提示：未检测到 codex 命令。装好 Codex CLI 后文件即可生效（文件已就位，无需重装）。"
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "检测到 claude 命令。"
} else {
    Write-Host "提示：未检测到 claude 命令。装好 Claude Code 后文件即可生效（文件已就位，无需重装）。"
}

Write-Host "---- 完成 ----"
if ($ok) {
    Write-Host "安装成功。新开一个终端会话，输入 /review （或任意 command 名）即可调用。"
    Write-Host "快速验证：在 Claude Code / Codex 里说「/review 看看这个目录的代码」，看它是否按中文流程工作。"
} else {
    Write-Host "安装过程中有警告，请检查上面的输出。" -ForegroundColor Yellow
    exit 1
}
