# film-factory 使用说明（收到就能用）

这是一个「用代码做宣传片」的技能包：给一段产品介绍或一句话需求，它会先写分镜表和文案，
再生成一页 HTML + GSAP 时间轴，逐帧渲染成片，最后合成原创配乐。
15 秒、30 秒都行，横版竖版都行。成片不是模板拼接——三道质量闸门全部 `0 failed` 才算交付。

---

## 一、安装（1 分钟）

把 `film-factory/` 整个文件夹放进你的技能目录：

```bash
# macOS / Linux
cp -r film-factory ~/.workbuddy/skills/
```

Windows 放到 `%USERPROFILE%\.workbuddy\skills\film-factory\`。
放好后重开一个对话，说「用 film-factory 给我做个 15 秒宣传片」即可。

## 二、装完第一件事：自检 + 填配置

```bash
cd ~/.workbuddy/skills/film-factory
bash scripts/env_check.sh          # 看缺什么：python 依赖 / node / Chrome / ffmpeg
```

然后打开 `references/profile.md`，把里面 `<...>` 换成你自己的信息（5 分钟）：

1. 片尾署名 / 品牌名
2. 主要语言与画幅
3. 要不要出现你自己的固定人物形象（要的话把参考图放进 `assets/ip/`）
4. 文案语气与配色偏好
5. 本机环境（把自检结果抄进去）

填完一次，以后每支片都按它执行；不填的话，技能会先问你一遍再开工。

## 三、依赖

| 依赖 | 用途 | 装法 |
| --- | --- | --- |
| Python 3.9+ / numpy / Pillow | 配乐合成 + 三个审计脚本 | `python3 -m pip install numpy pillow` |
| Node.js 18+ | 渲染、摆位闸门 | 官网或 `brew install node` |
| Google Chrome | 摆位闸门 + 渲染内核 | 装 Chrome；或用 `npx puppeteer browsers install chrome` |
| ffmpeg | 抽帧、混音、校验 | `brew install ffmpeg` |
| puppeteer-core | 摆位闸门驱动浏览器 | 在影片工程目录 `npm i puppeteer-core` |
| hyperframes | 逐帧渲染器 | 自动 `npx --yes hyperframes@0.8.78`（首次联网下载） |

GSAP 3.14.2 已内置在 `assets/gsap.min.js` 和示例里，**不需要联网**，也不要改成 CDN（离线渲染会白屏）。

## 四、怎么用

一句话就够，例如：

> 用 film-factory 给「<产品名>」做一条 15 秒宣传片，横版，中文文案，走 <产品官网>

它会依次：搜官方 logo 和产品图 → 定一个视觉隐喻 → 写 `shot-list.md` + `copy.md` →
搭工程 → 写时间轴 → 跑三道闸门 → 渲染 → 配乐 → 交付。
找素材、查资料这几步需要联网。

## 五、常见问题

**摆位闸门报 `Chrome not found`**
`export CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"`（换成你的路径）。

**摆位闸门报 `puppeteer-core not found`**
在影片工程目录执行 `npm i puppeteer-core`。

**渲染卡住、不推进**
默认用 `PRODUCER_BROWSER_GPU_MODE=software`（最稳）。`hardware` 更快，但部分机器会挂起。

**中文显示成方块**
先跑 `scripts/fetch_cjk_fonts.sh src/chars.txt film/assets/fonts` 抓中文子集；`@font-face` 必须用本地文件，不能 `local()`。

**渲染日志看不到**
把日志写进文件再轮询，不要用管道（会被缓冲吞掉）。

## 六、许可与出处

- 本技能由开源项目 **code-brand-film**（MIT，© nutllwhy）改造而来，原许可与第三方声明完整保留：
  `LICENSE`、`THIRD_PARTY_NOTICES.md`。
- 示例里的 Noto 字体（SIL OFL 1.1）、GSAP（GreenSock 标准许可）各归其作者。
- 你做片时收集的品牌 logo、产品图、官方视频归品牌方所有，商用前确认授权；
  给客户做的片子，发布前请客户确认。

---

版本：film-factory v1.0（基于 code-brand-film，含本地 GSAP、环境自检、可直接填的 profile 模板）
