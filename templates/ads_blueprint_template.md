# Ads 板块 · 写作蓝图模板（Template v2，Vol.003 风格 + Vol.002 兼容）

> **版本说明**：v2 基于 Vol.002（2026-04-09 hub.html L:3504-end）+ Vol.003（2026-04-16 hub.html L:3525-end）对比沉淀。
> 默认采用 Vol.003 风格（保留所有改进），少数 Vol.002 强组件（method_box）合并保留。
> 适用于 Vol.004+ 所有 Ads（s-ads 板块）生成。
>
> **🔗 卡 id 命名规范（Vol.005+ 强制）**：每个 `<div class="ad-card …">` 必须加 `id="ad-N"`（N = 该卡 rank，1-10）。Overview 板块 v2 的关键词跳转依赖此 id。

> 本文件是 Ads 板块（广大大 GUANGDADA.NET · 多平台游戏广告情报）的「字段清单 + 写作约束」。
> 每期分析阶段须按此模板填出 `ads.md`，写作 subagent 严格按填好的 `ads.md` + 上一期对应板块（默认 Vol.003 hub.html L:3525-end）写出最终 hub.html。

---

## ⚠️ 数据来源约定（重要 · 防 subagent 误判为 bug）

ads 板块的 10 条广告**经过 ads-research skill + 人工兜底**得来，与 `ads_raw.json` 的字段映射关系：

| ads_raw.json 字段 | HTML 字段 | 备注 |
|---|---|---|
| `rank` | `ad-rank` | 1-10 |
| `name` | `ad-industry` | 游戏名（HTML 实体编码：`&` → `&amp;`，`'` 保留） |
| `dev` | `ad-advertiser` | 开发商原文 |
| `popularity` | `ad-metrics[0].am-val` 和 `ad-ctr-badge` | 转中文单位：12000.0 → "1.2万"；2677.0 → "2677" |
| `tags`（"Top1%"） | `ad-perf-tag` | 直接照写 |
| `creativeType` | `ad-creative-type` 一部分 | "Video" → 写作"Video · {时长} · {风格描述}" |
| `text` 中提取的时长（如 `1m 40s`） | `ad-creative-type` + `ad-metrics[1].am-val` | 写作 `1m40s` 紧凑格式 |
| `text` 中提取的"投放天数" | `ad-metrics[2].am-val` | "1天" |
| `thumbnail` | （不直接用，使用本地下载视频） | 视频路径：`ads_videos_gdd/0N_{slug}.mp4` |

**subagent 行为约束**：
- ✅ 数据真实化：Vol.003 已抛弃 Vol.002 的 `—` 占位符，必须填真实数字（来自 ads_raw.json）
- ✅ `popularity ≥ 10000` 用"X.X万"格式；< 10000 直接显示数字
- ✅ 视频文件路径以本地 `ads_videos_gdd/` 实际文件名为准
- ❌ 不要尝试"修复"raw.json 与最终 HTML 不一致（人工筛选可能调整顺序）
- ❌ 不要回退到 Vol.002 的 `—` 占位（除非 raw.json 真的没有该字段）

---

## 0. CSS Class 完整审计（必须 100% 复用，禁止改名/自创）

> 写作 subagent **第一步**：Read 上期 hub.html 的 ads 板块行号区间（默认 Vol.003 L:3525-end），输出此清单作为审计痕迹。

### 0.1 板块顶层
- `section-panel`（外层容器，含 `id="s-ads"`）
- `sec-inner`
- `sec-kicker`
- `sec-title`
- `sec-desc`

### 0.2 stats-row
- `stats-row`
- `stat-pill`

### 0.3 method-box（数据来源说明）
- `method-box`（含 `style="margin-bottom:24px;"`）
- `icon`（内嵌）
- `title`
- `desc`

### 0.4 内联 style 覆盖（必须保留）
覆盖广告卡的 grid 布局，控制视频缩略图尺寸：
```css
.ads-grid .ad-card { grid-template-columns: 240px 1fr; }
.ads-grid .ad-thumb { width: 240px; min-height: 320px; }
.ads-grid .ad-thumb video { width: 100%; height: 100%; object-fit: contain; background: #000; }
```

### 0.5 conclusion-box（顶部三栏结论 · 与 trends/tiktok 同名 class）
- `conclusion-box`（含 `style="margin-bottom:28px;"`）
- `cb-header`
- `cb-icon`
- `cb-title`
- `cb-tag`
- `cb-grid`
- `cb-col`
- `cb-col-title`
- `dot`
- `cb-col-body`
- `cb-highlight`

### 0.6 ads-grid + ad-card
- `ads-grid`（10 张卡的容器）
- `ad-card`
- `ad-thumb`
- `ad-rank`
- `ad-perf-tag`（如 `Top1%`）
- `ad-expand-btn`（Vol.003 改名，原 Vol.002 是 `vbox-btn`）
- `ad-info`
- `ad-header`
- `ad-meta`
- `ad-objective`（顶部小字 · **用户决策回退 Vol.002 中文细分**：`AppLovin · 模拟经营 · 烹饪`）
- `ad-industry`（游戏名 · 加粗）
- `ad-advertiser`（开发商）
- `ad-creative-type` ⭐ **Vol.003 新增**：「Video · 30s · 描述」一行
- `ad-ctr-badge`（右上角人气标）

### 0.7 ad-metrics（4 张小卡）
- `ad-metrics`
- `ad-metric`
- `ad-metric.highlight`（首张高亮，用真实人气值）
- `am-val`
- `am-lbl`

### 0.8 ad-analysis（广告策略洞察 · 短分析）
- `ad-analysis`
- `ad-analysis-label`
- `ad-analysis-list`

### 0.9 game-analysis（卡内三栏分析 · 与 trends 同结构）
- `game-analysis`（Vol.003 含 `style="margin-top:0;"`）
- `ga-cols`
- `ga-col`
- `ga-col-header`
- `ga-list`
- `ga-score-row`（Vol.003 含 `style="border-top:none;padding-top:0;"`）
- `ga-score`
- `ga-label`
- `ga-label-a` / `ga-label-b` / `ga-label-c`

### 0.10 ⚠️ Vol.002 已废弃的 class（**禁止使用**）
- ❌ `ad-platform-badge`（Vol.003 删除，改用 `ad-objective` 写品类）
- ❌ `ad-duration-badge`（Vol.003 删除，改用 `ad-creative-type` 写时长）
- ❌ `vbox-btn`（Vol.003 改名为 `ad-expand-btn`）
- ❌ `ad-link`（Vol.003 删除"在广大大查看详情→"链接）

---

## 1. DOM 嵌套伪代码（关键结构）

```
section-panel#s-ads
└── sec-inner
    ├── sec-kicker
    ├── sec-title
    ├── sec-desc
    ├── stats-row
    │   └── stat-pill × 4
    ├── method-box
    │   ├── icon
    │   └── div: title + desc
    ├── <style>（ads-grid 覆盖样式 · 必须保留）
    ├── conclusion-box
    │   ├── cb-header (cb-icon + cb-title + cb-tag)
    │   └── cb-grid
    │       └── cb-col × 3
    └── ads-grid
        └── ad-card × 10
            ├── ad-thumb
            │   ├── ad-rank
            │   ├── ad-perf-tag
            │   ├── video（autoplay muted loop playsinline）
            │   └── ad-expand-btn（onclick="openAdVideo(...)"）
            └── ad-info
                ├── ad-header
                │   ├── ad-meta (ad-objective + ad-industry + ad-advertiser + ad-creative-type)
                │   └── ad-ctr-badge
                ├── ad-metrics (ad-metric × 4)
                ├── ad-analysis (ad-analysis-label + ad-analysis-list)
                └── game-analysis
                    ├── ga-cols (ga-col × 3 · 各含 ga-list)
                    └── ga-score-row (ga-score × 4 + ga-label)
```

---

## 2. 板块顶层（section_meta）

| 字段 | 示例值 | 是否变动 | 写作约束 |
|------|---|---|---|
| `panel_id` | `s-ads` | 固定 | div id 必须为 `s-ads` |
| `sec_kicker` | `📢 广大大 GUANGDADA.NET · 多平台游戏广告情报` | ❌ 固定 | 直接照抄 |
| `sec_title` | `全球游戏 Top Ads · 人气值 Top1% · 当日热榜` | ❌ 固定 | 直接照抄 |
| `sec_desc` | 含筛选条件 + SOP 优先级声明 | 微调日期 | 必须含「优先级：广告钩子 > 玩法留存 > 角色」（**ads 板块特有顺序**），HTML 实体用 `&gt;` |

## 3. 顶部 stats_row（4 个 stat-pill · 必须）

| 字段 | 示例 | 约束 |
|------|---|---|
| `pill_date` | `📅 数据日期 2026-04-16` | 改为本期日期 |
| `pill_filter` | `🏆 筛选条件 人气值 Top1% · 当日热榜` | 固定 |
| `pill_platforms` | `🌐 平台覆盖 Google / AppLovin / UnityAds / TikTok / Mintegral / IronSource` | 固定 |
| `pill_count` | `📢 展示数量 10 条精选` | 固定（数量永远是 10） |

每个 stat-pill 内部格式：`emoji <strong>标签</strong> 值`

## 4. method_box（数据来源说明）

| 字段 | 约束 |
|------|---|
| `method_title` | 固定为「关于数据来源」 |
| `method_desc` | 80-180 字。说明：① 数据源（广大大热榜）② 筛选条件（Top1%）③ 渠道覆盖 ④ 三个核心指标（人气值/展示估值/热度）解释 ⑤ 视频获取方式（CDP 提取，X/10 含视频） |

> **保留理由**：Vol.002 + Vol.003 两版都有 method_box，是 ads 板块特有的"指标说明"区，不能删（用户首次看会困惑"人气值"是什么）。

## 5. conclusion_box（本期热门广告 游戏研发结论 · 三栏）

**Header**：
- `cb-icon`：`📢`
- `cb-title`：`本期热门广告 游戏研发结论`
- `cb-tag`：`优先级：广告钩子 > 玩法留存 > 角色`（HTML 实体：`&gt;` · **ads 板块特有顺序**，与 TikTok「角色>广告>玩法」、Trends「玩法>角色>广告」均不同）

**三栏（cb-col）**：

> ⚠️ **栏位顺序固定**：广告制作 → 玩法/留存 → 角色设计（**与 trends/tiktok 不同**，ads 板块把广告制作放在第一栏，因为 ads 板块本身的核心就是广告）

| 栏位 | 颜色（dot + cb-col-title） | 字数 | 必须包含 |
|------|---|---|---|
| `conclusion_ad` 广告制作方向 | `#fe2c55`（红） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 3+ 个本期广告（按英文游戏名引用） |
| `conclusion_play` 玩法/留存方向 | `#ffd700`（黄 · **注意：是 ffd700 不是 ffc533**） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、给出可落地玩法名词 |
| `conclusion_role` 角色设计方向 | `#25f4ee`（青） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 3+ 个本期广告角色原型 |

每栏内联 style 写法：
```html
<div class="cb-col-title" style="color:#fe2c55">
  <span class="dot" style="background:#fe2c55"></span> 广告制作方向
</div>
```

> **跨板块印证奖励**：Vol.003 conclusion 多次引用「跨平台共振」（如 Whiteout × Memes #8 寒冬主题双信号），是高质量信号，写作时鼓励主动找跨板块印证。

## 6. ads_grid（10 张 ad-card · 必须）

> ⚠️ **数量固定 = 10**。卡片之间用 HTML 注释分隔：`<!-- Ad #N {游戏名} -->`

每张 card 字段：

```yaml
ad_N:                                # N = 1..10
  rank: 1
  is_champion: true                  # 仅 #1
  video_filename: "01_Whiteout_Survival.mp4"   # 实际本地文件名
  video_url: "ads_videos_gdd/{video_filename}"

  # ad-thumb
  perf_tag: "Top1%"                  # 与 raw.json.tags 一致

  # ad-meta（4 行 · **用户决策回退 Vol.002 中文细分**）
  objective: "AppLovin · 4X 策略 · 末日生存"   # 中文「平台 · 品类 · 子品类」三层细分
                                              # 平台例：AppLovin / Google / UnityAds / TikTok / Mintegral / IronSource
                                              # 品类例：4X 策略 / 模拟经营 / MOBA / RPG / 休闲消除 / 合并 / 跨界联动
                                              # 子品类例：末日生存 / 烹饪 / 中世纪 / 三国 / 萌宠 / 电影联动
  industry: "Whiteout Survival"      # 游戏名（来自 raw.json.name）
  advertiser: "Century Games PTE. LTD."   # 开发商（来自 raw.json.dev）
  creative_type: "Video · 1m 40s 长视频"  # ⭐ Vol.003 新增字段
                                          # 格式：Video · {时长} · {简短风格标签}
                                          # 时长例：1m40s / 30s / 19s / 22s / 34s / 36s / 44s / 45s / 59s
                                          # 风格例：长视频 / 极短纯玩法 / 电影级动画 / 即时奖励 / Minecraft 跨界联动 / 王国策略 / 小厂崛起 / 生活模拟幽默 / 合并×旅行 / "An Ideal Time-Killer"

  # ad-ctr-badge（右上角人气标）
  ctr_badge: "人气 1.9万"            # 格式："人气 X.X万" 或 "人气 XXXX"
                                     # ≥10000 用 X.X万；< 10000 直接显示数字

  # ad-metrics · 4 张小卡（Vol.003 已抛弃 Vol.002 的 — 占位）
  metrics:
    - {val: "1.9万", lbl: "人气值", highlight: true}   # 第 1 张固定 highlight
    - {val: "1m40s", lbl: "创意时长"}                  # 时长（Vol.002 是"展示估值"，Vol.003 改）
    - {val: "1天", lbl: "投放天数"}                    # 不变
    - {val: "Top1%", lbl: "排名"}                      # Vol.003 第 4 张改为排名（Vol.002 是"热度"占位）

  # ad-analysis · 短分析段落（Vol.003 修订标签）
  analysis_label: "广告研发分析"     # ⭐ Vol.003 改名（Vol.002 是"📢 广告策略洞察"）
  analysis_bullets:                  # 必须 3-4 条
    - "<strong>关键策略点 1</strong>：解释 30-80 字"
    - "<strong>关键策略点 2</strong>：解释 30-80 字"
    - "<strong>关键策略点 3</strong>：解释 30-80 字"
    # 可选第 4 条（Arknights/Blood Strike 等高复杂度卡有）：
    - "<strong>对我们的启示</strong>：30-80 字"

  # game-analysis · 三栏 · ga-list bullet 数 2-3
  game_analysis:
    role:                            # header: 🎭 角色设计 · bullet 数 2-3
      - "<strong>核心角色原型</strong>：50-150 字深度分析（含跨板块印证 / 视觉参考 / 西幻迁移建议）"
      - "次要角色洞察 · 50-100 字（不强制 strong）"
      # 可选第 3 条
    play:                            # header: ⚔️ 玩法/活动 · bullet 数 2-3
      - "<strong>核心玩法机制</strong>：50-150 字（含验证逻辑 / 西幻卡牌迁移建议）"
      - "次要玩法点 · 50-100 字（不强制 strong）"
      # 可选第 3 条
    ad:                              # header: 🎬 广告制作 · bullet 数 2-3
      - "<strong>★/★★ 核心广告公式</strong>：50-200 字（最关键卡如 #1 用 ★★ 标记，鼓励直接迁移建议）"
      - "次要广告洞察 · 50-100 字"
      # 可选第 3 条（含 ⚠️ 合规警示等）

  # 评分 · 4 项 · 1-5 整数
  scores:
    role: 4
    play: 4
    ad: 4
    fit: 4                           # "适配" = 与西幻卡牌的契合度
  conclusion_label:
    code: "A"                        # A | B | C
    text: "A 契合度高"               # A 契合度高 / B 结构借鉴 / C 观察储备
                                     # ⭐ 顶级广告（如 Arknights）可加 ★ 前缀："★ A 契合度高"
    css_class: "ga-label-a"          # ga-label-a | ga-label-b | ga-label-c
```

### 写作约束（极重要）

**ad-thumb 排版**（Vol.003 风格 · `ad-rank` 和 `ad-perf-tag` 在 video 之前）：
```html
<div class="ad-thumb">
  <div class="ad-rank">1</div>
  <div class="ad-perf-tag">Top1%</div>
  <video src="ads_videos_gdd/01_Whiteout_Survival.mp4" autoplay muted loop playsinline></video>
  <button class="ad-expand-btn" onclick="openAdVideo('ads_videos_gdd/01_Whiteout_Survival.mp4')">⤢</button>
</div>
```
- ⚠️ Vol.002 的 `ad-platform-badge`、`ad-duration-badge`、`vbox-btn` 全部 **不要**
- ⚠️ video 标签**无内联 style**（Vol.002 有冗余的 `style="width:100%;..."`，Vol.003 已用顶部 `<style>` 覆盖）

**ad-meta 排版**（4 行 · `ad-creative-type` 是 Vol.003 新增）：
```html
<div class="ad-meta">
  <div class="ad-objective">AppLovin · 4X 策略 · 末日生存</div>
  <div class="ad-industry">Whiteout Survival</div>
  <div class="ad-advertiser">Century Games PTE. LTD.</div>
  <div class="ad-creative-type">Video · 1m 40s 长视频</div>
</div>
```
- ⭐ `ad-creative-type` 是 Vol.003 关键新增组件，**必填**
- `ad-objective` 用**中文「平台 · 品类 · 子品类」三层细分**（Vol.002 风格 · 用户决策）。如 `AppLovin · 模拟经营 · 烹饪`

**ad-ctr-badge**：
```html
<span class="ad-ctr-badge">人气 1.9万</span>
```
- ⚠️ Vol.003 用 `<span>`（Vol.002 用 `<div>`），span 更轻
- 数字必须真实（来自 raw.json.popularity），不要写 `Top1%` 或占位

**ad-metrics**（4 张小卡 · 必须有真实数字）：
```html
<div class="ad-metrics">
  <div class="ad-metric highlight"><div class="am-val">1.9万</div><div class="am-lbl">人气值</div></div>
  <div class="ad-metric"><div class="am-val">1m40s</div><div class="am-lbl">创意时长</div></div>
  <div class="ad-metric"><div class="am-val">1天</div><div class="am-lbl">投放天数</div></div>
  <div class="ad-metric"><div class="am-val">Top1%</div><div class="am-lbl">排名</div></div>
</div>
```
- ⚠️ 第 1 张固定 `.highlight` + 真实人气值（Vol.002 滥用 `—` 是回退点，**禁止**）
- 第 2 张固定为「创意时长」
- 第 3 张固定为「投放天数」
- 第 4 张固定为「排名」（值 = perf_tag = "Top1%"）

**ad-analysis（短分析）**：
```html
<div class="ad-analysis">
  <div class="ad-analysis-label">广告研发分析</div>
  <ul class="ad-analysis-list">
    <li><strong>...</strong>：...</li>
    <li>...</li>
  </ul>
</div>
```
- ⚠️ label 文字 **`广告研发分析`**（Vol.003 风格），不要写 Vol.002 的「📢 广告策略洞察」
- bullet 数：3-4 条（高价值卡 4 条，普通卡 3 条）
- 每条 bullet 30-80 字
- 首部含 `<strong>核心策略名</strong>：` 形式（不强制每条都有，但至少 2/3 条有）

**game-analysis 三栏 bullet 数量规则（基于 Vol.003 实测）**：

| 栏位 | header | bullet 数 | strong 规则 |
|------|---|---|---|
| 角色设计 | `🎭 角色设计` | 2-3（多数 2-3） | 首条**必须**含 `<strong>核心角色原型名</strong>` |
| 玩法/活动 | `⚔️ 玩法/活动` | 2-3 | 首条**必须**含 `<strong>核心玩法机制</strong>` |
| 广告制作 | `🎬 广告制作` | 2-3 | 首条**必须**含 `<strong>核心广告公式</strong>`，最关键卡可加 `★` 或 `★★` 前缀 |

> **bullet 字数**：50-200 字（比 trends 长，比 tiktok 长 · ads 板块的核心价值就是深度分析）
> **跨板块印证**：鼓励首条 bullet 包含「与本期 Memes #N / TikTok #N / Trends #N 形成跨平台共振」类印证语
> **西幻卡牌迁移**：玩法栏和广告栏的末条鼓励含「西幻卡牌可直接借鉴」类落地建议

**ga-score-row（评分条 · Vol.003 含特殊样式）**：
```html
<div class="ga-score-row" style="border-top:none;padding-top:0;">
  <span class="ga-score">角色 <b>4</b>/5</span>
  <span class="ga-score">玩法 <b>4</b>/5</span>
  <span class="ga-score">广告 <b>4</b>/5</span>
  <span class="ga-score">适配 <b>4</b>/5</span>
  <span class="ga-label ga-label-a">A 契合度高</span>
</div>
```
- ⚠️ Vol.003 含 `style="border-top:none;padding-top:0;"` 内联样式，**必须保留**（Vol.002 没有）
- 4 项评分顺序固定：`角色 / 玩法 / 广告 / 适配`
- 数字用 `<b>` 包裹（不是 strong）
- label 三选一："A 契合度高" / "B 结构借鉴" / "C 观察储备"
- 顶级广告可加 `★` 前缀如 `★ A 契合度高`

**game-analysis 容器（Vol.003 加内联 style）**：
```html
<div class="game-analysis" style="margin-top:0;">
```
- ⚠️ `style="margin-top:0;"` 必须保留

---

## 7. 字段对照表（与 TikTok / Trends 模板的差异 · 防混用）

| 维度 | TikTok 板块 | Trends 板块 | **Ads 板块（本模板）** |
|------|---|---|---|
| panel id | `s-tiktok` | `s-trends` | `s-ads` |
| 主组件 class | `video-card` | `trend-topic-card` | **`ad-card`** |
| 主组件数 | 10 | 10 | **10** |
| 顶部三栏优先级 | 角色 > 广告 > 玩法 | 玩法 > 角色 > 广告 | **广告钩子 > 玩法留存 > 角色** |
| 三栏栏位顺序 | 角色 / 玩法 / 广告 | 角色 / 玩法 / 广告 | **广告 / 玩法 / 角色**（广告在首位） |
| 黄色 dot 色值 | `#ffc533` | `#ffc533` | **`#ffd700`**（不同！） |
| 卡内栏数 | 3 (game-analysis) | 3 (ga-cols) | 3 (ga-cols) |
| 每栏 bullet | 固定 3（v2） | 角色/玩法 3-5、广告固定 3 | **2-3（多数 2-3）** |
| 信号提炼层 | 有（analysis_signal） | 无 | **无**（用 ad-analysis 代替） |
| metrics 小卡 | 3 张 | 无 | **4 张**（人气值/创意时长/投放天数/排名） |
| 视频/图片 | iframe embed | 3 张静态图 | **本地 mp4 video 标签**（autoplay muted loop） |
| 平台徽章 | 无 | 无 | **Vol.002 有，Vol.003 删除**（不要回退） |
| 时长徽章 | 无 | 无 | **Vol.002 有，Vol.003 删除**（信息合并到 ad-creative-type） |
| 创意类型字段 | 无 | 无 | **`ad-creative-type`**（Vol.003 新增 · 必填） |
| 数据总览表 | 有 | 无 | **无** |
| 趋势分析卡 | 有 | 无 | **无** |
| 数据是否真实 | 真实（播放量） | 真实（搜索量） | **必须真实（Vol.002 用 — 占位是回退点）** |
| method_box | 有（method-box） | 无（融合在 sec-desc） | **有（必须保留）** |
| 评分项 | 4 项 | 4 项 | 4 项（同） |
| 标签分级 | A/B/C | A/B/C | A/B/C（顶级可加 ★） |

> **特殊提示 1**：Ads 板块的黄色 dot 色值是 `#ffd700`（金色），**与 trends/tiktok 的 `#ffc533` 不同** —— 抄板块时不要随便统一色值。
>
> **特殊提示 2**：Ads 板块**没有**「平台徽章」概念了 —— Vol.002 用 `ad-platform-badge` 标 AppLovin/Google/TikTok 等，Vol.003 删除独立徽章（平台信息合并到 `ad-objective` 中文三层细分的**第 1 层**：`AppLovin · 模拟经营 · 烹饪`）。Vol.004+ **不要回退**到独立平台徽章。
>
> **特殊提示 3**：Ads 板块**没有**「Top10%/5%」分级标签 —— raw.json.tags 字段当前固定为 `Top1%`，写作时直接照写到 `ad-perf-tag`，不需要颜色映射。如果未来 raw.json 出现 `Top5%` / `Top10%` 等，再扩展配色规则。

---

## 写作 subagent 必读

收到本蓝图 + 上期 ads 板块行号区间（默认 Vol.003 hub.html L:3525-end）后，**强制工作流**：

1. **Read 上期 hub.html 指定行号区间**，输出该区间用到的所有 CSS class 清单（写在你回复里，作为审计痕迹）。对照本模板第 0 节，确认 0 偏差。**特别检查**：是否包含已废弃的 `ad-platform-badge` / `ad-duration-badge` / `vbox-btn` / `ad-link`（如有，说明引用源是 Vol.002，**改用 Vol.003 风格**）。
2. **Read 本蓝图（ads.md）**，校验：
   - 10 张 ad-card 字段齐全
   - 每张 card：4 行 ad-meta（含 ad-creative-type）+ ad-ctr-badge + 4 张 ad-metric + ad-analysis（3-4 bullet）+ game-analysis 三栏 + 4 项评分 + 1 个 label
   - 角色栏 bullet 数 2-3、玩法栏 bullet 数 2-3、广告栏 bullet 数 2-3
   - 每栏首条 bullet 含 `<strong>...</strong>`
   - ad-metric 第 1 张含 `.highlight`，且 am-val 是真实数字（不是 `—`）
   - ad-metric 第 4 张 lbl = "排名"，val = perf_tag
   - 评分均为 1-5 整数
   - conclusion_label 三字段（code/text/css_class）一致
3. 严格按 Vol.003 DOM 嵌套生成 HTML，**禁止凭记忆改 class 名**
4. **保留** sec-desc 后的 `<style>` 块（ads-grid 覆盖样式）
5. 用 Write/Edit 写入目标文件
6. 返回主对话：写入位置 + 「已使用 CSS class：X, Y, Z」+ 「未填字段警告（如有）」+ 「bullet 数偏离警告（如有）」+ 「数据真实性确认」

**禁止行为**：
- ❌ 用其他板块的 CSS class（例如 `meme-analysis-4`、`video-card`、`trend-topic-card`、`metrics`、`analysis-list`）
- ❌ 自创 Vol.003 没有的字段或组件
- ❌ 回退到 Vol.002 已废弃 class：`ad-platform-badge` / `ad-duration-badge` / `vbox-btn` / `ad-link`
- ❌ 回退到 Vol.002 的 `—` 占位（除非 raw.json 真没有）
- ❌ ad-card ≠ 10
- ❌ ad-metric ≠ 4 张
- ❌ 任一栏 ga-list bullet < 2 或 > 3
- ❌ 评分项 ≠ 4 项
- ❌ 缺少 `ad-creative-type`
- ❌ 删除 sec-desc 后的 `<style>` 块
- ❌ ga-score-row 缺 `style="border-top:none;padding-top:0;"` 和 game-analysis 缺 `style="margin-top:0;"`
- ❌ 顶部 cb-tag 写成 trends/tiktok 的优先级
- ❌ 黄色 dot 用 `#ffc533`（应为 `#ffd700`）

---

## 校验清单（写完 HTML 后由主对话核对）

### 板块顶部
- [ ] section-panel id = `s-ads`
- [ ] 5 个组件齐全：sec_meta + stats_row(4) + method-box + 内联`<style>` + conclusion_box(3 cols) + ads-grid
- [ ] stats-pill 数 = 4，第 1 个是本期日期
- [ ] method-box 含 title「关于数据来源」+ desc 含「人气值/展示估值/热度」三指标说明
- [ ] conclusion-box `cb-tag` 文案 = `优先级：广告钩子 > 玩法留存 > 角色`（HTML 用 `&gt;`）
- [ ] conclusion-box 三栏顺序：广告(`#fe2c55`) → 玩法(`#ffd700`) → 角色(`#25f4ee`)
- [ ] sec-desc 后的 `<style>` 块完整保留（含 `.ads-grid .ad-card` `.ads-grid .ad-thumb` `.ads-grid .ad-thumb video` 三条）

### ad-card × 10
- [ ] ad-card 数正好 = 10
- [ ] 每张 card 含 HTML 注释分隔 `<!-- Ad #N {游戏名} -->`

每张 card 内：
- [ ] ad-thumb 含 ad-rank + ad-perf-tag + video（autoplay muted loop playsinline，无内联 style）+ ad-expand-btn
- [ ] **不含**已废弃的 ad-platform-badge / ad-duration-badge / vbox-btn
- [ ] ad-meta 含 4 行：ad-objective（**中文「平台 · 品类 · 子品类」三层细分**）+ ad-industry + ad-advertiser + **ad-creative-type**（Vol.003 必填）
- [ ] ad-ctr-badge 用 `<span>` 标签 + 真实人气值（"人气 X.X万" 或 "人气 XXXX"）
- [ ] ad-metrics 含正好 4 张 ad-metric
  - 第 1 张：`.highlight` + 真实人气值 + 「人气值」label
  - 第 2 张：创意时长（如 "1m40s" / "30s"）
  - 第 3 张：投放天数（如 "1天"）
  - 第 4 张：排名（如 "Top1%" + 「排名」label）
  - **没有任何 `—` 占位**（除非 raw.json 真缺）
- [ ] ad-analysis label = `广告研发分析`（**不是** Vol.002 的「📢 广告策略洞察」）
- [ ] ad-analysis-list 有 3-4 个 bullet，至少 2 个含 `<strong>`
- [ ] game-analysis 含 `style="margin-top:0;"`
- [ ] ga-cols 含 3 个 ga-col：🎭 角色设计 / ⚔️ 玩法/活动 / 🎬 广告制作
- [ ] 每个 ga-col 的 ga-list bullet 数 = 2-3
- [ ] 每栏首条 bullet 含 `<strong>...</strong>`
- [ ] ga-score-row 含 `style="border-top:none;padding-top:0;"`
- [ ] ga-score 4 项齐全：角色 / 玩法 / 广告 / 适配（数字用 `<b>` 包裹）
- [ ] ga-label 三选一：A 契合度高 / B 结构借鉴 / C 观察储备（顶级可加 ★）
- [ ] css_class 与 code 一致（A→ga-label-a / B→ga-label-b / C→ga-label-c）

### 防混用
- [ ] **没有**引入 trends 板块的 trend-topic-card / ttc-* / img-trio
- [ ] **没有**引入 tiktok 板块的 video-card / metrics / analysis-list / .metric.highlight
- [ ] **没有**引入 ad-link「在广大大查看详情→」（Vol.003 删除）
- [ ] 黄色 dot 色值 = `#ffd700`（**不是** `#ffc533`）
- [ ] cb-tag 优先级 = `广告钩子 > 玩法留存 > 角色`（**不是** TikTok / Trends 顺序）
