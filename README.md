# Ink Mist — Ghostty 单色印刷主题

炭墨底 + GPU 实时流动雾背景 + 露纸文字。雾效为着色器实时渲染，无图片资源。

## 效果截图

<!-- TODO: 补充截图到 assets/ 后取消注释
![Ink Mist 预览](assets/screenshot.png)
-->

> 截图占位 —— 待补充

## 内容

- `theme/ink-mist` — 主题文件（颜色、16 色调色板、custom-shader 引用；**无扩展名**，Ghostty 按文件名精确匹配）
- `shaders/ink-mist.glsl` — 背景着色器：三层不同尺度/速度缓缓流动的雾 + 印刷颗粒

## 安装

一键安装（主题、shader 装进 Ghostty 默认目录，并自动写入 `theme = ink-mist`）：

```sh
curl -fsSL https://raw.githubusercontent.com/gaorun/ink-mist/main/install.sh | sh
```

或者先克隆再运行：

```sh
git clone https://github.com/gaorun/ink-mist.git
cd ink-mist
./install.sh
```

按 `Cmd+Shift+,` 重载 Ghostty 生效。

## 调节

都在 `shaders/ink-mist.glsl` 里，改后重载即可：

- `iTime * 0.03` — 雾的流速（设 0 静止）
- `* 0.55` — 雾的最大浓度
- `vec3(0.42, 0.47, 0.53)` — 雾的颜色

## 备注

- 背景完全不透明；如需恢复桌面透视，自行加 `background-opacity`
- 已知实现细节：Ghostty(Metal) 下 custom-shader 的 `fragCoord`/`iChannel0` 原点在左上，着色器内已做 Y 翻转处理
- 文字区域通过 `iBackgroundColor` 距离检测保留，雾只渲染在背景空单元格上
