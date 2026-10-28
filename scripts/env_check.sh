#!/usr/bin/env bash
# 环境自检：跑一次，看清缺什么、该装什么。
# 用法: bash scripts/env_check.sh   （在任何目录调用都可以，脚本会自己切到技能根目录）
set -u

# 初学者经常在别的目录里执行，先切到技能根目录，避免误报"找不到脚本"
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" || exit 1

ok()   { printf '  [OK]   %s\n' "$1"; }
warn() { printf '  [WARN] %s\n' "$1"; }
bad()  { printf '  [MISS] %s\n' "$1"; }

echo "== 1. Python（配乐 + 三个审计脚本）=="
PY=""
for c in python3 python; do
  if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done
if [ -n "$PY" ]; then
  ok "$PY $($PY --version 2>&1 | awk '{print $2}')  ($(command -v $PY))"
  if $PY - <<'EOF' >/dev/null 2>&1
import numpy, PIL
EOF
  then ok "numpy + Pillow 已装"; else
    warn "缺 numpy / Pillow：$PY -m pip install numpy pillow"
  fi
else
  bad "未找到 python3，装一个（>= 3.9）"
fi

echo "== 2. Node（渲染 / 摆位闸门）=="
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
  if [ "$NODE_MAJOR" -ge 18 ] 2>/dev/null; then
    ok "node $(node --version)"
  else
    warn "node $(node --version) 偏旧，建议 >= 18"
  fi
else
  bad "未找到 node，装 Node.js >= 18"
fi
if [ -d node_modules/puppeteer-core ] || [ -d "$(pwd)/node_modules/puppeteer-core" ]; then
  ok "puppeteer-core 在工程目录"
else
  warn "puppeteer-core 未安装在工程目录：npm i puppeteer-core（摆位闸门需要）"
fi

echo "== 3. Chrome（摆位闸门 / 渲染）=="
CHROME=""
for p in "${CHROME_PATH:-}" \
         "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Chromium.app/Contents/MacOS/Chromium" \
         "/usr/bin/google-chrome" "/usr/bin/chromium" "/usr/bin/chromium-browser" \
         "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"; do
  [ -n "$p" ] && [ -f "$p" ] && CHROME="$p" && break
done
for p in "$HOME"/.cache/puppeteer/chrome*/*/chrome-*/chrome-headless-shell \
         "$HOME"/.cache/hyperframes/chrome/*/*/*/chrome-headless-shell; do
  [ -n "$CHROME" ] && break
  [ -x "$p" ] && CHROME="$p"
done
for p in "$HOME"/.cache/puppeteer/chrome*/*/chrome-*/chrome; do
  [ -n "$CHROME" ] && break
  [ -x "$p" ] && CHROME="$p"
done
if [ -n "$CHROME" ]; then
  ok "$CHROME"
  echo "         （摆位闸门可直接用；如需固定，export CHROME_PATH=\"$CHROME\"）"
else
  bad "未找到 Chrome。装 Google Chrome，或：npx --yes puppeteer browsers install chrome"
  echo "         装好后 export CHROME_PATH=<chrome 可执行文件路径>"
fi

echo "== 4. ffmpeg（抽帧 / 混音 / 校验）=="
if command -v ffmpeg >/dev/null 2>&1; then
  ok "$(ffmpeg -hide_banner -version 2>/dev/null | head -1)"
else
  bad "未找到 ffmpeg：brew install ffmpeg（或系统包管理器）"
fi
if command -v ffprobe >/dev/null 2>&1; then ok "ffprobe 可用"; else warn "缺 ffprobe（同 ffmpeg 一起装）"; fi

echo "== 5. 渲染器 hyperframes =="
echo "  技能按需拉起：npx --yes hyperframes@0.8.78（首次会下载，需联网）"
if command -v npx >/dev/null 2>&1; then ok "npx 可用"; else bad "缺 npx，随 Node 一起装"; fi

echo "== 6. 字体（中文字幕）=="
if [ -f scripts/fetch_cjk_fonts.sh ]; then
  ok "fetch_cjk_fonts.sh 就位（会按用到的汉字抓 Noto 子集）"
else
  warn "找不到 scripts/fetch_cjk_fonts.sh，确认在技能根目录执行本脚本"
fi

echo
echo "自检结束。把结论抄进 references/profile.md 第 5 节，之后做片不用再试错。"
