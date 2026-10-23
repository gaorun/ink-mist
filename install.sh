#!/bin/sh
# 安装 Ink Mist 到 Ghostty 默认目录，并把 $HOME 注入主题的 custom-shader 路径
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES="$HOME/.config/ghostty/themes"
SHADERS="$HOME/.config/ghostty/shaders"

mkdir -p "$THEMES" "$SHADERS"
sed "s|/Users/YOUR_USERNAME|$HOME|" "$DIR/theme/ink-mist" > "$THEMES/ink-mist"
cp "$DIR/shaders/ink-mist.glsl" "$SHADERS/"

echo "已安装: $THEMES/ink-mist"
echo "已安装: $SHADERS/ink-mist.glsl"
echo "在 Ghostty 配置中加入 theme = ink-mist，然后按 Cmd+Shift+, 重载"
