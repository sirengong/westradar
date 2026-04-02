#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# new_report.sh  —  发布新一期 TikTok 研究报告到 GitHub Pages
#
# 用法：
#   bash new_report.sh <日期> <报告HTML路径> <封面图文件夹路径>
#
# 示例：
#   bash new_report.sh 2026-04-08 ~/Desktop/report.html ~/Desktop/covers/
# ─────────────────────────────────────────────────────────────

set -e

DATE="$1"
REPORT_HTML="$2"
COVERS_DIR="$3"

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── 参数检查 ─────────────────────────────────────────────────
if [[ -z "$DATE" || -z "$REPORT_HTML" || -z "$COVERS_DIR" ]]; then
  echo "用法: bash new_report.sh <日期YYYY-MM-DD> <报告HTML> <封面图文件夹>"
  echo "示例: bash new_report.sh 2026-04-08 ~/Desktop/report.html ~/Desktop/covers/"
  exit 1
fi

if [[ ! -f "$REPORT_HTML" ]]; then
  echo "错误: 找不到报告文件 $REPORT_HTML"; exit 1
fi

if [[ ! -d "$COVERS_DIR" ]]; then
  echo "错误: 找不到封面图文件夹 $COVERS_DIR"; exit 1
fi

# ── 创建目标文件夹 ────────────────────────────────────────────
TARGET="$REPO_DIR/$DATE"
mkdir -p "$TARGET/index_files"

echo "📁  创建文件夹: $TARGET"

# ── 复制文件 ─────────────────────────────────────────────────
cp "$REPORT_HTML" "$TARGET/index.html"
cp "$COVERS_DIR"/*.jpg "$TARGET/index_files/" 2>/dev/null || \
cp "$COVERS_DIR"/*.png "$TARGET/index_files/" 2>/dev/null || true

echo "📄  已复制报告和封面图"

# ── 提示更新归档首页 ─────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────"
echo "⚠️  请手动更新归档首页 index.html："
echo "   1. 打开 $REPO_DIR/index.html"
echo "   2. 在 reports-list 里复制一个 report-card，填入日期 $DATE 和数据"
echo "   3. 把上一期的 'latest' class 去掉，给新卡片加上"
echo "────────────────────────────────────────────"
echo ""

# ── Git commit & push ─────────────────────────────────────────
cd "$REPO_DIR"
git add "$DATE/" index.html
git commit -m "feat: 新增 $DATE 期研究报告"
git push origin main

echo ""
echo "✅  发布成功！"
echo "🌐  新报告地址: https://sirengong.github.io/westradar/$DATE/hub.html"
echo "📋  归档首页:   https://sirengong.github.io/westradar/"
