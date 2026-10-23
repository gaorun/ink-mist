#!/bin/sh
# Ink Mist 一键安装：主题/shader 装进 Ghostty 默认目录，并写入 theme = ink-mist
# 用法：git clone 后 ./install.sh，或 curl -fsSL https://raw.githubusercontent.com/gaorun/ink-mist/main/install.sh | sh
set -e

REPO_RAW="https://raw.githubusercontent.com/gaorun/ink-mist/main"
THEMES="$HOME/.config/ghostty/themes"
SHADERS="$HOME/.config/ghostty/shaders"

# 本地克隆运行时优先用仓库内文件；管道运行时从 GitHub raw 拉取
DIR="$(cd "$(dirname "$0")" && pwd)"
has_local() { [ -n "$DIR" ] && [ -f "$DIR/$1" ]; }

mkdir -p "$THEMES" "$SHADERS"

if has_local "theme/ink-mist"; then
  sed "s|/Users/YOUR_USERNAME|$HOME|" "$DIR/theme/ink-mist" > "$THEMES/ink-mist"
else
  curl -fsSL "$REPO_RAW/theme/ink-mist" | sed "s|/Users/YOUR_USERNAME|$HOME|" > "$THEMES/ink-mist"
fi
echo "已安装: $THEMES/ink-mist"

if has_local "shaders/ink-mist.glsl"; then
  cp "$DIR/shaders/ink-mist.glsl" "$SHADERS/ink-mist.glsl"
else
  curl -fsSL "$REPO_RAW/shaders/ink-mist.glsl" -o "$SHADERS/ink-mist.glsl"
fi
echo "已安装: $SHADERS/ink-mist.glsl"

# 写入 theme = ink-mist：优先 XDG 配置，macOS 回落到 Application Support
if [ -f "$HOME/.config/ghostty/config" ]; then
  CONFIG="$HOME/.config/ghostty/config"
elif [ "$(uname -s)" = "Darwin" ]; then
  CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
else
  CONFIG="$HOME/.config/ghostty/config"
fi
mkdir -p "$(dirname "$CONFIG")"
touch "$CONFIG"

if grep -q "theme = ink-mist" "$CONFIG"; then
  echo "配置已存在 theme = ink-mist，跳过"
else
  printf '\n# Ink Mist\ntheme = ink-mist\n' >> "$CONFIG"
  echo "已写入 $CONFIG: theme = ink-mist"
fi

echo "按 Cmd+Shift+, 重载 Ghostty 生效"
