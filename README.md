# film-factory · 电影工厂

一个「用代码做宣传片」的 Agent Skill：给一段产品介绍或一句话需求，它先写分镜表和文案，再生成一页 HTML + GSAP 时间轴，由 [HyperFrames](https://github.com/heygen-com/hyperframes) 逐帧渲染成片，最后用 Python 合成原创配乐。10–60 秒，16:9 / 9:16 都行。

它不是模板拼接：三道质量闸门（代码 / 浏览器摆位 / 渲染像素）全部 `0 failed` 才算交付。

```
pip install numpy pillow        # 配乐 + 审计脚本
bash scripts/env_check.sh       # 自检 node / Chrome / ffmpeg
```

安装与完整说明见 **[INSTALL.md](INSTALL.md)**。

## 装上之后第一件事

```bash
cp -r film-factory ~/.workbuddy/skills/
```

然后填 `references/profile.md`：署名、语言、画幅、要不要出现你自己的固定人物形象、文案语气、本机环境。填一次，之后每支片都按它执行；不填则技能会在开工前先问你。

## 目录

| 路径 | 内容 |
| --- | --- |
| `SKILL.md` | 工作流程、三道闸门、硬性规则 |
| `references/profile.md` | 身份底座：署名 / 语言 / 画幅 / 人物 IP / 语气 / 环境（**先填这个**） |
| `references/creative.md` | 视觉隐喻、五幕节奏、动效规则、配色、AI 感陷阱 |
| `references/layout.md` | 每一幕的分区图与硬性摆位规则 |
| `references/assets.md` | 去哪找真实 logo / 产品图，五点校验，`assets.md` 清单 |
| `references/quality-bar.md` | 数字门槛、机制清单、转场清单 |
| `references/footage-led.md` | 品牌自带产品视频时改走这条路 |
| `references/shot-list.md` | 先填的分镜表（含范例） |
| `references/recipes.md` | 27 种可复制的 GSAP 机制与转场 |
| `references/pipeline.md` | 工程管线、lint 警告、macOS 坑、缺陷清单 |
| `references/scoring.md` | 从画面推节拍、能量曲线、混音、无耳朵校验 |
| `scripts/` | 环境自检 + 三道闸门 + 素材抓取 + 字体子集 + 构建/审帧模板 + 乐器库 |
| `assets/ip/` | 放你自己的人物形象参考图（可选） |
| `examples/office-agent/` | 一条完整可渲染的参考片，附分镜表、文案出处表、联系表 |

## 依赖

Python 3.9+（numpy、Pillow）、Node.js 18+、Google Chrome（或 `npx puppeteer browsers install chrome`）、ffmpeg、puppeteer-core（在影片工程目录 `npm i puppeteer-core`）。渲染器按需 `npx --yes hyperframes@0.8.78` 拉起，首次需联网。

GSAP 3.14.2 已内置，**离线可渲染**。不要改回 CDN —— 断网时页面会白屏，摆位闸门会报 `no window.__timelines found`。

## 来源与改动

本项目由开源项目 **code-brand-film**（MIT，© nutllwhy）改造而来，保留原许可与第三方声明。相对上游的改动：

- 新增 `references/profile.md`：把署名、语言、画幅、人物形象、本机环境抽成可配置项，技能第一次使用会问用户，不再写死作者信息
- 新增 `scripts/env_check.sh`：一次自检 python 依赖 / node / Chrome / ffmpeg / npx
- 新增 `assets/ip/`：放使用者自己的人物形象参考图
- 修复 `scripts/layout_audit.mjs` 在本机必崩的问题（浏览器启动参数补 `--no-sandbox --disable-setuid-sandbox --disable-gpu --disable-dev-shm-usage` 等）
- 修复示例页的 CDN 依赖：GSAP 3.14.2 内置到本地，示例改为 `assets/gsap.min.js`，离线可用

## 许可证

代码与文档以 [MIT 协议](LICENSE) 开源。示例中的 Noto 字体（SIL OFL 1.1）、GSAP（GreenSock 标准许可）、HyperFrames 等第三方内容保留各自许可，见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。

用本技能收集的品牌 logo、产品图、官方视频归品牌方所有，商用前请确认授权；给客户做的片子，发布前请客户确认。
