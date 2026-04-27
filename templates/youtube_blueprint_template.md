# YouTube Shorts 板块 · 写作蓝图模板（Template v1）

> **版本说明**：v1 综合 Vol.002（C:/Users/gongjue/tiktok-reports/2026-04-09/hub.html L:2157-2876）
> 与 Vol.003（C:/Users/gongjue/tiktok-reports/2026-04-16/hub.html L:1512-2198）双版本沉淀。
> Vol.003 引入互动分排名 / eng-badge / yt-grid / sec-divider 等结构性改进**全部保留**；
> Vol.002 的「封面 yt-views-chip 下角 chip」「内联 `<style>` 安全网」**保留**。
> tags 全部保留 `#` 前缀（两版一致）。
> 适用于 Vol.004+ 所有 YouTube 板块生成。
>
> **🔗 卡 id 命名规范（Vol.005+ 强制）**：每个 `<div class="yt-card …">` 必须加 `id="yt-N"`（N = 该卡 rank，1-10）。Overview 板块 v2 的关键词跳转依赖此 id。

> 本文件是 YouTube Shorts 板块的「字段清单 + 写作约束」。每期分析阶段须按此模板填出 `youtube.md`，
> 写作 subagent 严格按填好的 `youtube.md` + 上一期对应板块的 HTML 格式写出最终 hub.html。

---

## ⚠️ 数据来源与排名口径（重要）

YouTube 板块数据通过 `youtube-research` skill 调用 YouTube Data API v3 抓取（见 `yt_top10.json`），
**排名口径 = engagementScore（互动分 = 综合播放/点赞/评论的加权分）**，
不是纯播放量；Top 10 不一定 = 播放最高的 10 条。

`yt_top10.json → top_shorts[]` 的关键字段映射：

| JSON 字段 | 模板字段 | 用途 |
|---|---|---|
| `rank` | `video_N.rank` | 1-10 |
| `id` | `video_N.video_id` | 拼 embedUrl 与 webVideoUrl |
| `title` | `video_N.title_raw` | 原始英文标题（写作时可加中文副标题） |
| `channelTitle` | `video_N.channel_name` | 频道名 |
| `viewCount` | `video_N.metrics.views` | 转 "M / 万" 显示 |
| `likeCount` | `video_N.metrics.likes` | 转 "M / K / 万" 显示；隐藏点赞填 "—" |
| `commentCount` | `video_N.metrics.comments` | 转 "K / 万" 显示 |
| `durationSeconds` | `video_N.metrics.duration` | 显示 "Ns" 或 "~N秒" |
| `engagementScore` | `video_N.eng_badge_value` | 显示在右上 `eng-badge`，格式 "互动分 96M" |
| `embedUrl` | `video_N.embed_url` | vbox-btn `openVbox(url+?autoplay=1, 'iframe')` |
| `webVideoUrl` | `video_N.web_url` | 频道点击跳转 |
| `publishedAt` | `video_N.published_date` | 取 `YYYY-MM-DD` |

---

## 0. CSS Class 完整审计（必须 100% 复用，禁止改名/自创）

> 写作 subagent **第一步**：Read 上期 hub.html 中 youtube 板块行号区间，输出此清单作为审计痕迹。
> 下表是 v1 模板锁定的全部 class（两版联合，已自动决策保留版本）。

### 0.1 板块顶层
- `section-panel`（外层容器，含 `id="s-youtube"`）
- `sec-inner`
- `sec-kicker`
- `sec-title`
- `sec-desc`

### 0.2 stats-row
- `stats-row`
- `stat-pill`

### 0.3 conclusion-box（顶部三栏结论）
- `conclusion-box`
- `cb-header`
- `cb-icon`
- `cb-title`
- `cb-tag`
- `cb-grid`
- `cb-col`
- `cb-col-title`
- `dot`（内嵌 span）
- `cb-col-body`
- `cb-highlight`（关键词高亮 span）

### 0.4 tk-section-title（"视频详情分析" / "数据总览" 分隔标题）
- `tk-section-title`
- `num`（右侧副标识，如 "按互动分排名 · Top 10" 或 "互动分排行"）

### 0.5 yt-grid（10 张 yt-card 容器 · Vol.003 风格保留）
- `yt-grid`

### 0.6 yt-card（10 张视频卡）
- `yt-card`（卡根，**不**再用 Vol.002 的 `.top` 修饰；冠军靠 `eng-badge` + `yt-rank.gold` 表达）
- `yt-cover`（封面容器，**Vol.003 风格**，替代 Vol.002 的 `yt-thumb`）
- `yt-rank`（数字徽章）
- `gold`（rank 修饰类，**仅 #1 加**）
- `vbox-btn`（lightbox 放大按钮，`onclick="openVbox('embedUrl?autoplay=1','iframe')"`）
- `yt-play-btn`（封面浮层播放按钮，`onclick="openVideo('embedUrl?autoplay=1')"`）
- `yt-play-icon`（播放按钮内部图标）
- `yt-views-chip`（**Vol.002 保留**：封面下角播放量 chip）
- `yt-info`（信息区右侧）
- `yt-header`
- `yt-title`
- `yt-channel`（**Vol.003 风格**：div 直接展示频道名，不再用 `<a class="yt-channel">@xxx ↗</a>`）
- `yt-dur`（**Vol.003 新增**：合并展示时长+发布日期，"59s · 2026-04-07"）
- `eng-badge`（**Vol.003 新增**：右上互动分高亮徽章，#1 用 "互动分 96M" / 播放冠军用 "播放量最高 48.2M"）
- `yt-meta`（4 项小卡容器）
- `yt-stat`（小卡）
- `sv`（小卡数值，#1 行 + 播放数加 `.hot` = 红色）
- `hot`（数值修饰：红色高亮）
- `sl`（小卡标签）
- `yt-tags`
- `yt-tag`
- `hook`（tag 修饰：钩子型，红色系）
- `fmt`（tag 修饰：格式型，蓝色系）

### 0.7 game-analysis（卡内三栏分析 · 与其他板块同套）
- `game-analysis`
- `ga-cols`
- `ga-col`
- `ga-col-header`
- `ga-list`
- `ga-score-row`
- `ga-score`
- `ga-label`
- `ga-label-a` / `ga-label-b` / `ga-label-c`（标签三选一）

### 0.8 sec-divider（视觉分块 · Vol.003 保留）
- `sec-divider`

### 0.9 data_table（数据总览表）
- `data-table`
- `rank-num`
- `author-link`
- `num-cell`

### 0.10 内联 `<style>` 安全网（Vol.002 保留）
Vol.002 在 `<div class="sec-desc">` 之后、`<div class="conclusion-box">` 之前包含一段
`<style>` 块，覆盖全部 yt-* 样式（200×356 grid 列、yt-rank-badge 黄边、yt-tag.hook/fmt 颜色等）。
**写作 subagent 必须原样保留**——主 hub.html 是否已注册 yt-* 完整样式表的状态可能因期数变化，
保留该 inline style 是确保板块独立可渲染的安全网。

---

## 1. DOM 嵌套伪代码（关键结构）

```
section-panel#s-youtube
└── sec-inner
    ├── sec-kicker
    ├── sec-title
    ├── sec-desc
    ├── stats-row
    │   └── stat-pill × 4
    ├── <style>（yt-* 样式覆盖 · 安全网原样保留）
    ├── conclusion-box
    │   ├── cb-header (cb-icon + cb-title + cb-tag)
    │   └── cb-grid
    │       └── cb-col × 3
    │           ├── cb-col-title (含 dot)
    │           └── cb-col-body (含若干 cb-highlight)
    ├── tk-section-title (含 num · "视频详情分析 / 按互动分排名 · Top 10")
    ├── yt-grid
    │   └── yt-card × 10
    │       ├── yt-cover
    │       │   ├── yt-rank (#1 加 .gold)
    │       │   ├── vbox-btn (放大按钮，openVbox)
    │       │   ├── img (封面缩略图)
    │       │   ├── yt-play-btn (浮层播放按钮，openVideo)
    │       │   │   └── yt-play-icon
    │       │   └── yt-views-chip (封面下角播放量)
    │       └── yt-info
    │           ├── yt-header
    │           │   ├── (left) yt-title + yt-channel + yt-dur
    │           │   └── (right) eng-badge
    │           ├── yt-meta
    │           │   └── yt-stat × 4 (播放/点赞/评论/时长)
    │           ├── yt-tags
    │           │   └── yt-tag.hook × 2 + yt-tag.fmt × 2
    │           ├── inline 描述段 (font-size:12px;color:var(--gray2);line-height:1.6)
    │           └── game-analysis
    │               ├── ga-cols
    │               │   └── ga-col × 3 (ga-col-header + ga-list)
    │               └── ga-score-row (ga-score × 4 + ga-label)
    ├── sec-divider
    ├── tk-section-title (含 num · "数据总览 / 互动分排行")
    └── data-table
        └── tbody > tr × 10
```

---

## 2. 板块顶层（section_meta）

| 字段 | 示例值 | 是否变动 | 写作约束 |
|------|---|---|---|
| `panel_id` | `s-youtube` | 固定 | div id 必须为 `s-youtube` |
| `sec_kicker` | `▶️ YouTube Shorts · VOL.003` | ⚠️ 期号每期换 | 格式：`▶️ YouTube Shorts · VOL.XXX` |
| `sec_title` | `YouTube Shorts 热门` | ❌ 固定 | 直接照抄；可加副词如 "Top 10" |
| `sec_desc` | 一段约 80-120 字 | ✅ 每期新 | 必须含本期最强信号（如最高播放视频）+ 数据来源（YouTube Data API mostPopular）+ 优先级声明（**广告 > 玩法演出 > 角色展示**） |

## 3. 顶部 stats_row（4 个 stat-pill · Vol.003 数据导向风格）

| 字段 | 示例 | 约束 |
|------|---|---|
| `pill_pool` | `📊 分析池 50 条 Shorts` | 取 `yt_top10.json.total_videos_analyzed` |
| `pill_top_view` | `🏆 最高播放 48.2M` | 取 50 条中最高 viewCount，转 "M" 显示 |
| `pill_top_eng` | `⚡ 最高互动分 96M（SceneBlink）` | 取 50 条中最高 engagementScore，括号注明频道 |
| `pill_period` | `📅 发布区间 04-07 – 04-12` | 取本期 Top 10 中最早 - 最晚发布日期 |

每个 stat-pill 内部格式：`emoji <strong>标签</strong> 值`

## 4. conclusion_box（本期 YouTube Shorts 游戏研发结论 · 三栏）

**Header**：
- `cb-icon`：`🎮`
- `cb-title`：`本期 YouTube Shorts 游戏研发结论`
- `cb-tag`：`优先级：广告 > 玩法 > 角色`（**YouTube 板块固定优先级**，与 TikTok 板块「角色 > 广告 > 玩法」、Trends 板块「玩法 > 角色 > 广告」**均不同**）

**三栏（cb-col）顺序固定：角色 → 玩法 → 广告**（虽然优先级是广告>玩法>角色，但栏位顺序保持视觉惯例「角色→玩法→广告」）

| 栏位 | 颜色（dot + cb-col-title） | 字数 | 必须包含 |
|------|---|---|---|
| `conclusion_role` 角色设计方向 | `#25f4ee`（青） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 3+ 个本期视频（按频道名/标题片段） |
| `conclusion_play` 活动/玩法方向 | `#ffc533`（黄） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、给出可落地的玩法名词或机制 |
| `conclusion_ad` 广告创意方向 | `#fe2c55`（红） | 200-280 字 | 多个 `<span class="cb-highlight">钩子/格式名</span>`、含可复用开场公式或时长建议 |

每栏内联 style 写法（保持两版一致）：
```html
<div class="cb-col-title" style="color:#25f4ee">
  <span class="dot" style="background:#25f4ee"></span> 角色设计方向
</div>
```

## 5. video_grid（10 张 yt-card · 必须）

> ⚠️ **数量固定 = 10**。卡片之间用 HTML 注释分隔：`<!-- YT #N {ChannelName} - {ShortKey} -->`（Vol.003 风格）
> 卡片整体由 `<div class="yt-grid">...</div>` 包裹

每张 card 字段：

```yaml
video_N:                            # N = 1..10
  rank: 1
  is_champion: true                  # 仅 #1
  rank_extra_class: "gold"           # #1 加 "gold"；其他不加 → 空字符串
  video_id: "yJN-6aDTMhs"
  embed_url: "https://www.youtube.com/embed/{video_id}"
  web_url: "https://www.youtube.com/shorts/{video_id}"
  thumbnail: "yt_images/01_just_passing_through.jpg"   # 本地缩略图（dl_imgs.mjs 下载）

  # yt-cover 区
  cover_alt: "Just passing through"

  # yt-views-chip（Vol.002 保留：封面下角播放量 chip）
  views_chip_text: "▶ 4262万 播放"      # 或 "4262万 播放"（保留 ▶ icon）

  # header 区（Vol.003 紧凑结构）
  title_main: "\"Just passing through\"? — 荒诞闯入喜剧"   # 含中文副标题，破折号分隔
  channel_name: "SceneBlink"                              # 不加 @、不加 ↗
  duration_published: "59s · 2026-04-07"                  # 时长 · 发布日期 合一行
  eng_badge_text: "互动分 96M"                            # 右上徽章，#1 可用 "互动分 96M"，播放冠军用 "播放量最高 48.2M"

  # yt-meta 4 项小卡（顺序固定：播放 / 点赞 / 评论 / 时长）
  metrics:
    - val: "42.6M"
      lbl: "播放"
      hot: true                      # #1 行的播放数加 .hot 红色高亮
    - val: "1.04M"
      lbl: "点赞"
      hot: false                     # 隐藏点赞场景填 val: "—" lbl: "点赞隐藏"
    - val: "11K"
      lbl: "评论"
      hot: false                     # 评论冠军可改 lbl: "评论 🏆"
    - val: "59s"
      lbl: "时长"
      hot: false

  # tags（保留 # 前缀，hook/fmt 各 2 个）
  tags:
    hook: ["#荒诞闯入", "#反转开场"]
    fmt:  ["#路人变英雄", "#喜剧节奏"]

  # 描述段（inline style，font-size:12px）
  description: "SceneBlink 荒诞闯入短片系列本周以 42.6M 播放、互动分高达 96M 领跑全榜……"   # 80-150 字

  # game-analysis 三栏 · 每栏正好 2 bullet（Vol.003 紧凑风格保留）
  game_analysis:
    role:                              # header: 🎭 角色设计
      - "<strong>闯入者/渗透者原型</strong>；「无处不在又无所属」的流浪侦探感"
      - "借用场景能力 = 适应型角色技能集"
    play:                              # header: ⚔️ 玩法/活动
      - "<strong>潜入/绕过机制</strong>；「不被发现就通过」的游戏设计"
      - "情境喜剧式关卡叙事"
    ad:                                # header: 🎬 广告制作
      - "<strong>意外出现的角色</strong> = 注意力钩子"
      - "荒诞情境开场：角色出现在完全不应该出现的地方"

  scores: {role: 3, play: 3, ad: 4, fit: 3}
  conclusion_label:
    code: "B"                          # A | B | C
    text: "B 结构借鉴"                 # A 契合度高 / B 结构借鉴(或"B 需改造") / C 仅参考
    css_class: "ga-label-b"            # ga-label-a | ga-label-b | ga-label-c
```

### 写作约束（极重要）

**yt-cover 排版（Vol.003 风格 + Vol.002 保留 yt-views-chip）**：
```html
<div class="yt-cover">
  <div class="yt-rank{ ' ' + rank_extra_class if is_champion }">{rank}</div>
  <button class="vbox-btn" onclick="openVbox('{embed_url}?autoplay=1','iframe')" title="放大查看">⤢</button>
  <img src="{thumbnail}" alt="{cover_alt}">
  <div class="yt-play-btn" onclick="openVideo('{embed_url}?autoplay=1')">
    <div class="yt-play-icon"></div>
  </div>
  <div class="yt-views-chip"><span class="yt-play-icon">▶</span> {views_chip_text}</div>
</div>
```
- 冠军用 `<div class="yt-rank gold">1</div>`，其他用 `<div class="yt-rank">N</div>`
- `vbox-btn` 与 `yt-play-btn` 函数依赖：`openVbox` / `openVideo` 须在主 hub.html 已定义；如未定义请回退到 Vol.002 仅用 `vbox-btn`（删 `yt-play-btn`）
- `yt-views-chip` 固定包含一个 `<span class="yt-play-icon">▶</span>` 红色三角

**yt-header 排版（Vol.003 紧凑结构）**：
```html
<div class="yt-header">
  <div>
    <div class="yt-title">{title_main}</div>
    <div class="yt-channel">{channel_name}</div>
    <div class="yt-dur">{duration_published}</div>
  </div>
  <span class="eng-badge">{eng_badge_text}</span>
</div>
```
- `yt-channel` 是 div 直接渲染频道名（**不**再用 Vol.002 的 `<a class="yt-channel">@xxx ↗</a>`）
- `yt-dur` 文本固定格式：`"{duration}s · {YYYY-MM-DD}"`
- `eng-badge` 内容由情况决定：
  - #1（互动分排名第 1）：`"互动分 {数值}M"`
  - 当前视频是 50 条池中**播放量最高**：`"播放量最高 {数值}M"`
  - 其他：`"互动分 {数值}M"`
- 整个 header 用 flex 两端对齐（左 div + 右 eng-badge）

**yt-meta 排版（4 张小卡，顺序固定）**：
```html
<div class="yt-meta">
  <div class="yt-stat"><span class="sv hot">{播放}</span><span class="sl">播放</span></div>
  <div class="yt-stat"><span class="sv">{点赞}</span><span class="sl">点赞</span></div>
  <div class="yt-stat"><span class="sv">{评论}</span><span class="sl">评论</span></div>
  <div class="yt-stat"><span class="sv">{时长}</span><span class="sl">时长</span></div>
</div>
```
- 第 1 张（播放数）默认加 `.hot` → 红色高亮
- 隐藏点赞场景：`<span class="sv">—</span><span class="sl">点赞隐藏</span>`
- 评论冠军（本期评论数最高）：`<span class="sl">评论 🏆</span>`

**yt-tags 排版（保留 # 前缀）**：
```html
<div class="yt-tags">
  <span class="yt-tag hook">#荒诞闯入</span>
  <span class="yt-tag hook">#反转开场</span>
  <span class="yt-tag fmt">#路人变英雄</span>
  <span class="yt-tag fmt">#喜剧节奏</span>
</div>
```
- hook 2 个 + fmt 2 个，**合计正好 4 个**
- 全部带 `#` 前缀（与 TikTok 板块一致；与 Trends 板块的 `ttc-tag` 5 个不同）

**描述段（inline style）**：
```html
<div style="font-size:12px;color:var(--gray2);line-height:1.6;">{description}</div>
```
80-150 字，提炼"为什么这条视频值得被列入 Top 10"的核心理由 + 具体数据印证。

**game-analysis 三栏 bullet 数量规则（v1 锁定）**：

| 栏位 | header | bullet 数 | 首条规则 |
|------|---|---|---|
| 角色设计 | `🎭 角色设计` | **正好 2** | 首条**必须**含 1 个 `<strong>角色原型/能力关键词</strong>` |
| 玩法/活动 | `⚔️ 玩法/活动` | **正好 2** | 首条**必须**含 1 个 `<strong>玩法机制名词</strong>` |
| 广告制作 | `🎬 广告制作` | **正好 2** | 首条**必须**含 1 个 `<strong>钩子/格式名</strong>` |

> ⚠️ **YouTube 板块的 ga-list 是 2 bullet**，与 TikTok v2（3 bullet）、Trends（3-5 bullet）**均不同**。
> 这是因为 YouTube 卡内已有 description 段承载主分析，再多 bullet 会让卡片过高。

每条 bullet 字数 25-50 字。

**ga-score-row（评分条 · 4 项 + 1 label，与其他板块同套）**：
```html
<div class="ga-score-row">
  <span class="ga-score">角色 <b>{role}</b>/5</span>
  <span class="ga-score">玩法 <b>{play}</b>/5</span>
  <span class="ga-score">广告 <b>{ad}</b>/5</span>
  <span class="ga-score">适配 <b>{fit}</b>/5</span>
  <span class="ga-label {css_class}">{text}</span>
</div>
```
- 4 项评分顺序固定：`角色 / 玩法 / 广告 / 适配`
- 数字用 `<b>` 包裹（不是 strong）
- label 文字格式：`"A 契合度高"` / `"B 结构借鉴"`（或 "B 需改造"）/ `"C 仅参考"`

## 6. tk-section-title × 2（板块内部分隔标题 · Vol.003 保留）

**6.1 视频卡片区前**（紧接 conclusion-box 之后）：
```html
<div class="tk-section-title"><span>视频详情分析</span><span class="num">按互动分排名 · Top 10</span></div>
```

**6.2 数据总览前**（紧接 yt-grid 之后、sec-divider 之前/之后）：
```html
<div class="sec-divider"></div>
<div class="tk-section-title" style="margin-top:8px;"><span>数据总览</span><span class="num">互动分排行</span></div>
```

## 7. data_table（数据总览 · 10 行）

字段（每行）：
- `rank`（数字，<td class="rank-num">）
- `author_link`（HTML：`<a class="author-link" href="https://www.youtube.com/shorts/{video_id}" target="_blank">@{ChannelTitle}</a>`，<td>）
- `content_summary`（≤30 字标题/描述，<td>）
- `views_display`（"42.6M" 或 "4262万"，<td class="num-cell">；#1 行加 `style="color:#ff4444;"` 并末尾 `🏆`）
- `likes_display`（"1.04M" 或隐藏 `—`，<td class="num-cell">；#1 行加 `style="color:#ff4444;"` 并末尾 `🏆`）
- `published_short`（"04-07"，<td class="num-cell">）
- `content_type`（"荒诞喜剧" / "家庭守护" 等 4-6 字分类，<td class="num-cell">）

**特殊样式**：
- 第 1 行 `<tr>` 加 `style="background:#1a0305;"`
- 第 1 行播放/点赞列加 `style="color:#ff4444;"` 与 `🏆`
- 表头：`<thead><tr><th>#</th><th>频道</th><th>标题</th><th>播放量</th><th>点赞</th><th>发布日期</th><th>内容类型</th></tr></thead>`

排序按互动分（与 Top 10 一致），不要按播放量重排序。

---

## 8. 字段对照表（与 TikTok / Trends 模板的差异 · 防混用）

| 维度 | TikTok 板块 | Trends 板块 | YouTube 板块（本模板） |
|------|---|---|---|
| 主组件 class | `video-card` | `trend-topic-card` | `yt-card` |
| 主组件数 | 10 | 10 | 10 |
| 主组件容器 | (无固定 grid) | (无固定 grid) | **`yt-grid`** |
| 顶部三栏优先级 | 角色 > 广告 > 玩法 | 玩法 > 角色 > 广告 | **广告 > 玩法 > 角色** |
| stats-row 内容 | 4 项数据导向（含 top_view） | 4 项身份导向（地区/来源/视角） | 4 项数据导向（**含互动分**） |
| 排名口径 | 按播放量 | (按搜索量预审) | **按 engagementScore 互动分** |
| 卡内信号提炼层 | 有（analysis_signal） | 无 | 无 |
| 卡内 metrics 小卡（3 张） | 有 | 无 | 无（用 yt-meta 4 张代替） |
| 卡内 yt-meta 小卡 | 无 | 无 | **有（4 张：播放/点赞/评论/时长）** |
| 卡内 yt-views-chip 封面下角 | 无 | 无 | **有** |
| 卡内 eng-badge 右上徽章 | 无（用 score_badge） | 无 | **有（互动分高亮）** |
| 卡内 yt-dur 时长+发布日合一 | 无 | 无 | **有** |
| 每栏 ga-list bullet | 固定 3 | 角色/玩法 3-5、广告固定 3 | **固定 2** |
| 每条 ga-list 首部 strong | 强制 | 强制 | **强制** |
| tags 数量 | hook + fmt 共 4-5 | 固定 5（ttc-tag） | **hook 2 + fmt 2 = 4** |
| tags 类名 | `tag emotion` / `tag format` | `ttc-tag` | `yt-tag hook` / `yt-tag fmt` |
| 数据总览表 | 有（5 列） | 无 | **有（7 列含点赞）** |
| 趋势分析卡 | 有（trend-grid 2 张） | 无 | **无** |
| 内联 `<style>` 安全网 | 无 | 有（图片覆盖） | **有（yt-* 全套覆盖）** |
| 评分项 | 4 项 | 4 项 | 4 项 |
| 标签分级 | A/B/C | A/B/C | A/B/C |
| 图片 | embed iframe | 3 张静态图（img-trio） | 1 张静态封面 + embed iframe（vbox 弹层） |

> **YouTube 板块特有组件**：`yt-cover` / `yt-rank.gold` / `yt-play-btn` / `yt-views-chip` / `yt-info` / `yt-channel` / `yt-dur` / `eng-badge` / `yt-meta` / `yt-stat` / `sv.hot` / `sl` / `yt-tag.hook` / `yt-tag.fmt` / `yt-grid`

> **特殊提示**：
> - 不要把 TikTok 的 `metrics`（3 张小卡）和 `analysis-list`（信号提炼）搬到 YouTube
> - 不要把 Trends 的 `img-trio` 搬到 YouTube（YouTube 是单封面 + iframe 弹层）
> - YouTube 的 `yt-views-chip` 是封面下角的 chip（与 yt-meta 中"播放"小卡有意冗余，因为视觉位置不同，**不要**当成 bug 删掉）

---

## 写作 subagent 必读

收到本蓝图 + 上期 hub.html 中 youtube 板块行号区间后，**强制工作流**：

1. **Read 上期 hub.html 指定行号区间**，输出该区间用到的所有 CSS class 清单（写在你回复里，作为审计痕迹）。对照本模板第 0 节，确认 0 偏差
2. **Read 本蓝图（youtube.md）**，校验：
   - 10 张 yt-card 字段齐全
   - 每张 card：1 张缩略图（`yt_images/...`）+ 4 项 yt-meta + 4 个 yt-tag + 3 栏 game-analysis + 4 项评分 + 1 个 label
   - 每张 card 三栏 ga-list 各 **正好 2 bullet**
   - 每条 ga-list 首条含 `<strong>...</strong>`
   - 评分均为 1-5 整数
   - conclusion_label 三字段（code/text/css_class）一致
   - eng_badge_text 已填（#1 / 播放冠军 / 其他三种格式之一）
   - rank=1 卡 → `yt-rank gold` + sv.hot 应用
3. 严格按上期 DOM 嵌套生成 HTML，**禁止凭记忆改 class 名**
4. **保留** sec-desc 后的 `<style>` 块（yt-* 安全网）
5. **保留** 两个 tk-section-title 分隔标题与 sec-divider
6. 用 Write/Edit 写入目标文件
7. 返回主对话：写入位置 + 「已使用 CSS class：X, Y, Z」+ 「未填字段警告（如有）」+ 「bullet 数偏离警告（如有）」

**禁止行为**：
- ❌ 用其他板块的 CSS class（例如 `meme-analysis-4`、`video-card`、`trend-topic-card`、`metrics`、`analysis-list`、`ttc-tag`、`img-trio`）
- ❌ 自创不在第 0 节清单内的 class
- ❌ 引入 TikTok v2 的 `metrics`（3 张小卡）/ `analysis-list`（信号提炼）/ ga-list 强制 3 bullet —— **YouTube 是 2 bullet**
- ❌ 引入 Trends 的 `img-trio`（3 张静态图）—— **YouTube 是单封面 + iframe**
- ❌ 删除 sec-desc 后的 `<style>` 块（yt-* 安全网）
- ❌ 删除封面 `yt-views-chip`（保留 Vol.002 风格）
- ❌ data_table 列数 ≠ 7
- ❌ yt-card ≠ 10
- ❌ yt-tag ≠ 4（hook 2 + fmt 2）
- ❌ ga-list 任一栏 bullet ≠ 2
- ❌ 评分项 ≠ 4 项
- ❌ cb-tag 写成「角色 > 广告 > 玩法」（那是 TikTok 板块的）或「玩法 > 角色 > 广告」（那是 Trends 板块的）

---

## 校验清单（写完 HTML 后由主对话核对）

- [ ] 板块 6 个一级组件齐全：sec_meta + stats_row(4) + 内联`<style>` + conclusion_box(3 cols) + tk-section-title("视频详情分析") + yt-grid(10 cards) + sec-divider + tk-section-title("数据总览") + data_table(10 行)
- [ ] section-panel id = `s-youtube`
- [ ] sec_kicker 含 `VOL.XXX` 期号
- [ ] stat-pill 数 = 4，含「分析池 / 最高播放 / 最高互动分 / 发布区间」
- [ ] conclusion-box `cb-tag` 文案 = `优先级：广告 > 玩法 > 角色`
- [ ] conclusion-box 三栏颜色顺序：青(#25f4ee) → 黄(#ffc533) → 红(#fe2c55)
- [ ] yt-card 数 = 10，外层有 `<div class="yt-grid">` 包裹
- [ ] 每张 card 含 yt-cover（rank + vbox-btn + img + yt-play-btn + yt-views-chip）
- [ ] #1 卡的 `yt-rank` 加 `gold` 修饰类
- [ ] 每张 card 含 yt-header（左 title+channel+dur，右 eng-badge）
- [ ] 每张 card 含 yt-meta 4 项小卡（播放/点赞/评论/时长，#1 行播放数 .hot）
- [ ] 每张 card 含 yt-tags 4 个（hook 2 + fmt 2，全部带 #）
- [ ] 每张 card 含 inline 描述段（80-150 字）
- [ ] 每张 card 含 game-analysis 三栏 + 评分行
- [ ] 每栏 ga-list bullet 数 = 2
- [ ] 每栏 ga-list 首条含 `<strong>`
- [ ] 每张 card 4 项评分齐全（角色/玩法/广告/适配）
- [ ] 每张 card 含 ga-label，且 css_class 与 code/text 一致
- [ ] 含 2 个 tk-section-title（"视频详情分析" / "数据总览"），各带 num 副标识
- [ ] 含 sec-divider（数据总览前）
- [ ] data_table 7 列（# / 频道 / 标题 / 播放量 / 点赞 / 发布日期 / 内容类型）
- [ ] data_table 10 行，#1 行高亮（背景 #1a0305，播放/点赞列红色 + 🏆）
- [ ] data_table 排序按互动分（与 Top 10 一致）
- [ ] sec-desc 后的 `<style>` 块完整保留
- [ ] **没有**引入 TikTok 的 metrics(3张) / analysis_signal / ga-list 3-bullet
- [ ] **没有**引入 Trends 的 img-trio / ttc-tag(5个) / ttc-bullets
