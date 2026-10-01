#!/usr/bin/env bash
# 中文 AI 编程 CLI 工作流包 —— 一键安装脚本（Linux / macOS）
#
# 用法：
#   ./install.sh                 # 同时安装到 Claude Code 与 Codex CLI
#   ./install.sh --claude-only   # 只装 Claude Code
#   ./install.sh --codex-only    # 只装 Codex CLI
#
# 安装位置（实测结论，见 commands/测试记录-D2.md）：
#   Claude Code : ~/.claude/commands/<name>.md        （扁平文件，原样复制）
#   Codex CLI   : ~/.codex/skills/<name>/SKILL.md     （目录结构，frontmatter 只留 name+description）
#
# 可重复执行（幂等）：重复安装会覆盖旧文件，不会产生重复。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/../commands"

CLAUDE_DIR="$HOME/.claude/commands"
CODEX_DIR="$HOME/.codex/skills"

INSTALL_CLAUDE=1
INSTALL_CODEX=1

for arg in "$@"; do
  case "$arg" in
    --claude-only) INSTALL_CODEX=0 ;;
    --codex-only)  INSTALL_CLAUDE=0 ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *) echo "未知参数: ${arg}（用 --help 查看用法）" >&2; exit 1 ;;
  esac
done

# ---- 前置检查 ----
if [ ! -d "$COMMANDS_DIR" ]; then
  echo "错误：找不到 commands 目录：$COMMANDS_DIR" >&2
  echo "请在解压后的完整包目录里运行本脚本。" >&2
  exit 1
fi

SRC_FILES=()
while IFS= read -r f; do
  SRC_FILES+=("$f")
done < <(find "$COMMANDS_DIR" -maxdepth 1 -name '*.md' ! -name '测试记录*' | sort)
if [ "${#SRC_FILES[@]}" -eq 0 ]; then
  echo "错误：commands 目录下没有 command 文件。" >&2
  exit 1
fi
echo "找到 ${#SRC_FILES[@]} 个 command 文件。"

# ---- frontmatter 转换：Codex 用（去掉自定的 cli: 行，只留 name/description）----
# 只处理文件开头的第一个 --- ... --- 块，块外的正文原样保留。
convert_for_codex() {
  awk '
    BEGIN { in_fm = 0; seen_open = 0 }
    !seen_open && /^---$/ { seen_open = 1; in_fm = 1; print; next }
    seen_open && in_fm && /^---$/ { in_fm = 0; print; next }
    in_fm && /^cli:/ { next }
    { print }
  ' "$1"
}

# ---- 安装到 Claude Code ----
n_claude=0
if [ "$INSTALL_CLAUDE" -eq 1 ]; then
  mkdir -p "$CLAUDE_DIR"
  for f in "${SRC_FILES[@]}"; do
    cp "$f" "$CLAUDE_DIR/$(basename "$f")"
    n_claude=$((n_claude + 1))
  done
  echo "Claude Code：已安装 $n_claude 个 → $CLAUDE_DIR"
fi

# ---- 安装到 Codex CLI ----
n_codex=0
if [ "$INSTALL_CODEX" -eq 1 ]; then
  for f in "${SRC_FILES[@]}"; do
    name="$(basename "$f" .md)"
    dest_dir="$CODEX_DIR/$name"
    mkdir -p "$dest_dir"
    convert_for_codex "$f" > "$dest_dir/SKILL.md"
    n_codex=$((n_codex + 1))
  done
  echo "Codex CLI：已安装 $n_codex 个 → $CODEX_DIR/<name>/SKILL.md"
fi

# ---- 验证 ----
echo "---- 验证 ----"
ok=1
got=0  # 防御性初始化（配合 set -u）

if [ "$INSTALL_CLAUDE" -eq 1 ]; then
  got=$(find "$CLAUDE_DIR" -maxdepth 1 -name '*.md' | wc -l)
  echo "Claude Code 目录文件数：${got}（期望 ${#SRC_FILES[@]}）"
  [ "$got" -ge "${#SRC_FILES[@]}" ] || ok=0
fi

if [ "$INSTALL_CODEX" -eq 1 ]; then
  got=$(find "$CODEX_DIR" -maxdepth 2 -name 'SKILL.md' | wc -l)
  echo "Codex skills 目录 SKILL.md 数：${got}（期望 ${#SRC_FILES[@]}）"
  [ "$got" -ge "${#SRC_FILES[@]}" ] || ok=0
  # 抽查一个转换结果：frontmatter 不应再有 cli: 行
  sample="$CODEX_DIR/review/SKILL.md"
  if [ -f "$sample" ]; then
    if grep -q '^cli:' "$sample"; then
      echo "警告：$sample 仍含有 cli: 行，转换可能未生效。" >&2
      ok=0
    else
      echo "抽查 ${sample}：frontmatter 已去掉 cli: 行 ✓"
    fi
  fi
fi

# codex 版本检查（旧版 0.149.0 会静默失败，见测试记录-D2.md）
CODEX_BIN=""
for cand in "$HOME/.local/bin/codex" "$(command -v codex 2>/dev/null || true)"; do
  [ -n "$cand" ] && [ -x "$cand" ] && { CODEX_BIN="$cand"; break; }
done
if [ -n "$CODEX_BIN" ]; then
  ver="$("$CODEX_BIN" --version 2>/dev/null || echo "未知")"
  echo "检测到 codex：${CODEX_BIN}（${ver}）"
  case "$ver" in
    *"0.149"*) echo "警告：这是旧版 codex（0.149.x），已知会静默失败，请升级到 0.159+（官方最新版）。" >&2 ;;
  esac
else
  echo "提示：未检测到 codex 命令。装好 Codex CLI 后文件即可生效（文件已就位，无需重装）。"
fi

if command -v claude >/dev/null 2>&1; then
  echo "检测到 claude 命令：$(command -v claude)"
else
  echo "提示：未检测到 claude 命令。装好 Claude Code 后文件即可生效（文件已就位，无需重装）。"
fi

echo "---- 完成 ----"
if [ "$ok" -eq 1 ]; then
  echo "安装成功。新开一个终端会话，输入 /review （或任意 command 名）即可调用。"
  echo "快速验证：在 Claude Code / Codex 里说「/review 看看这个目录的代码」，看它是否按中文流程工作。"
else
  echo "安装过程中有警告，请检查上面的输出。" >&2
  exit 1
fi
