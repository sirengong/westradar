# Trends 板块 · 写作蓝图模板（Template v1，Vol.002 风格）

> **版本说明**：v1 严格基于 Vol.002 hub.html 的 trends 板块（L:872-1541）沉淀。
> **不**包含 Vol.003 改进。Vol.004+ 若沿用 Vol.002 风格，使用本模板。
> tags 保留 `#` 前缀。
>
> **🔗 卡 id 命名规范（Vol.005+ 强制）**：每个 `<div class="trend-topic-card …">` 必须加 `id="trend-N"`（N = 该卡 rank，1-10）。Overview 板块 v2 的关键词跳转依赖此 id。

> 本文件是 trends（美区 Google Trends）板块的「字段清单 + 写作约束」。
> 每期分析阶段须按此模板填出 `trends.md`，写作 subagent 严格按填好的 `trends.md` + Vol.002 hub.html L:872-1541（唯一格式真相源）写出最终 HTML。

---

## ⚠️ 数据来源约定（重要 · 防 subagent 误判为 bug）

trends 板块的话题清单**经过人工预审**，与 `trends_raw.json` 的自动采集结果**不要求一致**。

工作流：
1. `trends-research` skill 跑 `fetch_trends.py` → `trends_raw.json`（参考用，含原始热搜）
2. **人工预审**：从 raw.json + 时事 + 业务关注点中筛 10 个话题
3. **人工/CDP 下载图片** → `trend_images/0N_{slug}_{1,2,3}.jpg`
4. **图片资产即权威话题清单**：写蓝图/HTML 时，话题以 `trend_images/` 文件名为准
5. raw.json 仅作为话题热度/相关查询的补充参考，不强绑

**subagent 行为约束**：
- ✅ 发现 raw.json 与图片资产不一致时，**默认以图片资产为准**，不要报告为 bug
- ❌ 不要尝试"修复"raw.json 与图片不一致
- ❌ 不要拒绝写 HTML 因为找不到 raw.json 中的对应数据

---

## 0. CSS Class 完整审计（必须 100% 复用，禁止改名/自创）

> 写作 subagent **第一步**：Read Vol.002 L:872-1541，输出此清单作为审计痕迹。
> 下表是从 Vol.002 trends 板块按出现顺序、去重后提取的所有 class。

### 0.1 板块顶层
- `section-panel`（外层容器，含 `id="s-trends"`）
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

### 0.4 trend-topic-card（10 张话题卡）
- `trend-topic-card`（卡片根）
- `ttc-top`
- `ttc-images`
- `img-trio`
- `ttc-info`
- `ttc-header`
- `ttc-rank`
- `ttc-topic-meta`
- `ttc-en`
- `ttc-zh`
- `ttc-traffic`
- `ttc-tags`
- `ttc-tag`
- `ttc-bullets`

### 0.5 game-analysis（卡内三栏分析）
- `game-analysis`
- `ga-cols`
- `ga-col`
- `ga-col-header`
- `ga-list`
- `ga-score-row`
- `ga-score`
- `ga-label`
- `ga-label-a` / `ga-label-b` / `ga-label-c`（标签三选一）

### 0.6 内联 style（板块顶部覆盖样式 · 必须保留）
Vol.002 在 `<div class="sec-desc">` 之后、`<div class="conclusion-box">` 之前包含一段
`<style>` 块覆盖图片排版（`.trend-topic-card .ttc-top`、`.img-trio` 等）——
**写作 subagent 必须原样保留**。

---

## 1. DOM 嵌套伪代码（关键结构）

```
section-panel#s-trends
└── sec-inner
    ├── sec-kicker
    ├── sec-title
    ├── sec-desc
    ├── stats-row
    │   └── stat-pill × 4
    ├── <style>（图片覆盖样式 · 原样保留）
    ├── conclusion-box
    │   ├── cb-header
    │   │   ├── cb-icon
    │   │   ├── cb-title
    │   │   └── cb-tag
    │   └── cb-grid
    │       └── cb-col × 3
    │           ├── cb-col-title (含 dot)
    │           └── cb-col-body (含若干 cb-highlight)
    └── trend-topic-card × 10
        └── ttc-top
            ├── ttc-images
            │   └── img-trio
            │       └── img × 3
            └── ttc-info
                ├── ttc-header
                │   ├── ttc-rank
                │   ├── ttc-topic-meta (ttc-en + ttc-zh)
                │   └── ttc-traffic
                ├── ttc-tags (ttc-tag × 5)
                ├── ttc-bullets (li × 3)
                └── game-analysis
                    ├── ga-cols
                    │   └── ga-col × 3
                    │       ├── ga-col-header
                    │       └── ga-list (li × 3-5)
                    └── ga-score-row
                        ├── ga-score × 4
                        └── ga-label.ga-label-{a|b|c}
```

---

## 2. 板块顶层（section_meta）

| 字段 | 示例值 | 是否变动 | 写作约束 |
|------|---|---|---|
| `panel_id` | `s-trends` | 固定 | div id 必须为 `s-trends` |
| `sec_kicker` | `🔥 US Google Trends · 文化热点情报` | 固定（可微调期号） | 含 emoji 🔥 + 数据源描述 |
| `sec_title` | `美区热搜 Top 10` | 固定 | Top 10 数字固定 |
| `sec_desc` | 一段约 80-120 字 | ✅ 每期新 | 必须含数据周期 + SOP 优先级声明（玩法/活动 > 角色设计 > 广告） |

## 3. 顶部 stats_row（4 个 stat-pill · 必须）

| 字段 | 示例 | 约束 |
|------|---|---|
| `pill_period` | `📅 数据周期 2026.04.02 – 04.09` | 改为本期日期范围 |
| `pill_region` | `🌎 地区 美国` | 固定 |
| `pill_source` | `📊 来源 Google Trends + 人工筛选` | 固定 |
| `pill_view` | `🎮 视角 游戏研发 · 内容情报` | 固定 |

每个 stat-pill 内部格式：`emoji <strong>标签</strong> 值`

## 4. conclusion_box（本期热搜 游戏研发结论 · 三栏）

**Header**：
- `cb-icon`：`🎮`
- `cb-title`：`本期热搜 游戏研发结论`
- `cb-tag`：`优先级：玩法 > 角色 > 广告`（trends 板块固定优先级，与 TikTok 板块的「角色 > 广告 > 玩法」**不同**）

**三栏（cb-col）**：

| 栏位 | 颜色（dot + cb-col-title） | 字数 | 必须包含 |
|------|---|---|---|
| `conclusion_role` 角色设计方向 | `#25f4ee`（青） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 4+ 个本期话题（按英文/中文名引用） |
| `conclusion_play` 活动/玩法方向 | `#ffc533`（黄） | 200-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、给出可落地的玩法名词或机制 |
| `conclusion_ad` 广告创意方向 | `#fe2c55`（红） | 200-280 字 | 多个 `<span class="cb-highlight">视觉母题/钩子结构</span>`、含可复用素材公式 |

每栏内联 style 写法（保持 Vol.002 一致）：
```html
<div class="cb-col-title" style="color:#25f4ee">
  <span class="dot" style="background:#25f4ee"></span> 角色设计方向
</div>
```

## 5. trend_topic_grid（10 张 trend-topic-card · 必须）

> ⚠️ **数量固定 = 10**。卡片之间用 HTML 注释分隔：`<!-- ═══ 0N TOPIC NAME ═══ -->`（Vol.002 风格）

每张 card 字段：

```yaml
trend_N:                            # N = 1..10
  rank: "01"                         # 两位数字符串："01" 到 "10"
  topic_slug: "star_wars_maul"      # 用于图片命名：trend_images/{rank}_{slug}_{1|2|3}.jpg
  images:                            # 必须 3 张
    - "trend_images/01_star_wars_maul_1.jpg"
    - "trend_images/01_star_wars_maul_2.jpg"
    - "trend_images/01_star_wars_maul_3.jpg"
  image_alt: "Star Wars: Maul – Shadow Lord"   # 三张共用同一 alt

  # ttc-header
  topic_en: "Star Wars: Maul – Shadow Lord"     # 英文原名
  topic_zh: "星球大战：摩尔 - 暗影领主 · 反派主角叙事"  # 中文译名 + · + 标签副题
  traffic: "10M+ 搜索"                            # 量级，常见值：10M+ / 5M+ / 2M+ / 1M+

  # tags · 必须正好 5 个
  tags:
    - "#MaulShadowLord"
    - "#StarWars"
    - "#DisneyPlus"
    - "#DarthMaul"
    - "#Animation"

  # ttc-bullets · 必须正好 3 条
  bullets:
    - "Disney+ 动画剧集4月6日首播即拿下烂番茄100%满分..."   # 60-100 字
    - "剧集在30+国家登上流媒体榜首..."
    - "摩尔的双刃光剑战斗、地下世界美学..."

  # game-analysis 三栏
  game_analysis:
    role:                            # 角色设计 (header: 🎭 角色设计) · bullet 数 3-4
      - "<strong>堕落领主/暗影复生原型</strong>：被击败但以纯粹意志力存活..."
      - "<strong>反派主角叙事</strong>：欧美市场对'可共情的反派'需求..."
      - "<strong>双刃武器标志性设计</strong>：双刃光剑是摩尔的视觉icon..."
      - "<strong>视觉关键词</strong>：红黑纹身面妆、犄角、金属义肢..."   # 末条通常是"视觉关键词"
    play:                            # 玩法/活动 (header: ⚔️ 玩法/活动) · bullet 数 4-5
      - "<strong>'暗影崛起'反派养成线</strong>：从最低谷开始重建势力..."
      - "<strong>犯罪帝国/地下势力经营</strong>：模拟摩尔建立犯罪集团..."
      - "<strong>残躯重生/碎片收集机制</strong>：角色被击败后不会永久消亡..."
      - "<strong>双刃连击/链式技能</strong>：以双刃武器为基础的连击系统..."
    ad:                              # 广告制作 (header: 🎬 广告制作) · bullet 数固定 3
      - "<strong>'他们以为我死了'复仇叙事</strong>：黑屏→低沉独白..."
      - "<strong>暗影美学高光帧</strong>：红黑配色+烟雾+金属质感..."
      - "<strong>反派视角广告</strong>：'如果你是反派，你会怎么做？'..."

  # 评分 · 4 项 · 1-5 整数
  scores:
    role: 5
    play: 5
    ad: 4
    fit: 5                           # "适配" 项 = 与西幻卡牌的契合度
  conclusion_label:
    code: "A"                        # A | B | C
    text: "A 契合度高"               # 对应：A 契合度高 / B 需改造 / C 仅参考
    css_class: "ga-label-a"          # ga-label-a | ga-label-b | ga-label-c
```

### 写作约束（极重要）

**ttc-header 排版**：
```html
<div class="ttc-header">
  <div class="ttc-rank">{rank}</div>
  <div class="ttc-topic-meta">
    <div class="ttc-en">{topic_en}</div>
    <div class="ttc-zh">{topic_zh}</div>
  </div>
  <div class="ttc-traffic">{traffic}</div>
</div>
```

**img-trio**（必须 3 张，含 onclick lightbox）：
```html
<div class="ttc-images"><div class="img-trio">
  <img src="{img1}" alt="{image_alt}" onclick="openLightbox(this)">
  <img src="{img2}" alt="{image_alt}" onclick="openLightbox(this)">
  <img src="{img3}" alt="{image_alt}" onclick="openLightbox(this)">
</div></div>
```

**ttc-tags（必须 5 个，全部带 # 前缀）**：
```html
<div class="ttc-tags">
  <span class="ttc-tag">#Tag1</span>
  ...（共 5 个）
</div>
```

**ttc-bullets（必须正好 3 条，每条 60-100 字）**：
```html
<ul class="ttc-bullets">
  <li>...</li><li>...</li><li>...</li>
</ul>
```
每 bullet 内容：事实陈述（首播日期/收视数据/IMDb 评分等）+ 文化解读，**不**带 strong 高亮。

**game-analysis 三栏 bullet 数量规则（基于 Vol.002 实测）**：

| 栏位 | header | bullet 数 | 末条规则 |
|------|---|---|---|
| 角色设计 | `🎭 角色设计` | 3-4（多数 4） | 末条**通常**是 `<strong>视觉关键词</strong>：xxx`（必有 strong） |
| 玩法/活动 | `⚔️ 玩法/活动` | 4-5（多数 4） | 无固定末条 |
| 广告制作 | `🎬 广告制作` | **固定 3** | 无固定末条 |

**每条 bullet 的 strong 规则**：
- 角色 / 玩法栏：**每条 bullet 首部必须**含 `<strong>核心概念名词</strong>：` 形式
- 广告栏：**每条 bullet 首部必须**含 `<strong>钩子/公式名</strong>`（可加冒号或不加）
- 引号统一用中文单引号 `'xxx'` 包裹概念名

**bullet 字数**：50-130 字（角色/玩法栏可较长，广告栏较短）

**ga-score-row（评分条 · 必须包含 4 项 + 1 label）**：
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
- label 文字格式："A 契合度高" / "B 需改造" / "C 仅参考"

---

## 6. 字段对照表（与 TikTok 模板的差异 · 防混用）

| 维度 | TikTok 板块 | Trends 板块（本模板） |
|------|---|---|
| 主组件 class | `video-card` | `trend-topic-card` |
| 主组件数 | 10 | 10 |
| 顶部三栏优先级 | 角色 > 广告 > 玩法 | **玩法 > 角色 > 广告** |
| 卡内栏数 | 3（meme-analysis 等） | 3（ga-cols） |
| 每栏 bullet | 固定 3（v2） | 角色/玩法 3-5、广告固定 3 |
| 信号提炼层 | 有（analysis_signal） | **无** |
| metrics 小卡 | 有（3 张） | **无** |
| 数据总览表 | 有 | **无** |
| 趋势分析卡 | 有（trend-grid 2 张） | **无** |
| tags 数量 | emotion + format 共 4-5 | 固定 5 |
| 评分项 | 4 项（含 fit） | 4 项（含 fit） |
| 标签分级 | A/B/C | A/B/C |
| 图片 | embed iframe | 3 张静态图（img-trio） |

> **特殊提示**：Vol.002 trends 板块**没有** method_box、data_table、trend_grid 这三个组件——
> 不要从 TikTok 模板照搬。trends 的「方法论」是融合在 `sec-desc` 里一句话带过的。

---

## 写作 subagent 必读

收到本蓝图 + Vol.002 hub.html L:872-1541 后，**强制工作流**：

1. **Read Vol.002 hub.html L:872-1541**，输出该区间用到的所有 CSS class 清单（写在你回复里，作为审计痕迹）。对照本模板第 0 节，确认 0 偏差
2. **Read 本蓝图（trends.md）**，校验：
   - 10 张 trend-topic-card 字段齐全
   - 每张 card：3 图、5 tags、3 bullets、game-analysis 三栏、4 项评分、1 个 label
   - 角色栏 bullet 数 3-4、玩法栏 bullet 数 4-5、广告栏 bullet 数 = 3
   - 每条角色/玩法/广告 bullet 首部含 `<strong>...</strong>`
   - 评分均为 1-5 整数
   - conclusion_label 三字段（code/text/css_class）一致
3. 严格按 Vol.002 DOM 嵌套生成 HTML，**禁止凭记忆改 class 名**
4. **保留** sec-desc 后的 `<style>` 块（图片覆盖样式）
5. 用 Write/Edit 写入目标文件
6. 返回主对话：写入位置 + 「已使用 CSS class：X, Y, Z」+ 「未填字段警告（如有）」+ 「bullet 数偏离警告（如有）」

**禁止行为**：
- ❌ 用其他板块的 CSS class（例如 `meme-analysis-4`、`video-card`、`metrics`、`analysis-list`）
- ❌ 自创 Vol.002 没有的字段或组件
- ❌ 引入 Vol.003 改进（metrics 小卡、analysis_signal、ga-list 强制 3 bullet 等都是 TikTok 板块的，**trends 不要**）
- ❌ trend-topic-card ≠ 10
- ❌ tags ≠ 5
- ❌ ttc-bullets ≠ 3
- ❌ 广告栏 bullet ≠ 3
- ❌ 评分项 ≠ 4 项
- ❌ 删除 sec-desc 后的 `<style>` 块

---

## 校验清单（写完 HTML 后由主对话核对）

- [ ] 4 个组件齐全：sec_meta + stats_row(4) + 内联`<style>` + conclusion_box(3 cols) + trend-topic-card × 10
- [ ] section-panel id = `s-trends`
- [ ] stats-pill 数 = 4
- [ ] conclusion-box `cb-tag` 文案 = `优先级：玩法 > 角色 > 广告`
- [ ] conclusion-box 三栏颜色顺序：青(#25f4ee) → 黄(#ffc533) → 红(#fe2c55)
- [ ] trend-topic-card 数 = 10
- [ ] 每张 card：3 张图 + 5 tags + 3 bullets
- [ ] 每张 card 角色/玩法栏首条含 `<strong>`
- [ ] 每张 card 广告栏 bullet 数正好 = 3
- [ ] 每张 card 角色栏末条多为 `<strong>视觉关键词</strong>` 形式
- [ ] 每张 card 4 项评分齐全（角色/玩法/广告/适配）
- [ ] 每张 card 含 ga-label，且 css_class 与 code/text 一致
- [ ] 所有 tag 带 `#` 前缀
- [ ] 图片路径格式：`trend_images/{rank}_{slug}_{1|2|3}.jpg`
- [ ] 所有图片 onclick 含 `openLightbox(this)`
- [ ] 卡片间含 HTML 注释分隔 `<!-- ═══ 0N TOPIC ═══ -->`
- [ ] sec-desc 后的 `<style>` 块完整保留
- [ ] **没有**引入 method_box / data_table / trend_grid（这些是 TikTok 板块特有）
- [ ] **没有**引入 metrics 小卡 / analysis_signal / 强制 3-bullet ga-list（这些是 Vol.003 TikTok 改进）
