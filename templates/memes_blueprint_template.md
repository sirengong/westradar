# Memes 板块 · 写作蓝图模板（Template v2）

> **版本说明**：v2 在 Vol.002 基础上沉淀 Vol.003 的 4 项改进（数据总览表 / meme-thumb 顺序 / 差异化 status 文案 / stats-row 用本期数据点 / 跨平台双源印证话术 / ⚠️ 风险标注）。
> 4 列 `meme-analysis-4` 硬约束在 Vol.002 / Vol.003 均守住，本模板继续强制 4 列。
> tags/标注保留 `★` `⚠️` `💬` `🏆` 等 Vol.003 装饰符。
> 适用于 Vol.004+ 所有 Memes 板块生成。
>
> **🔗 卡 id 命名规范（Vol.005+ 强制）**：每个 `<div class="meme-card …">` 必须加 `id="meme-N"`（N = 该卡 rank，1-10）。Overview 板块 v2 的关键词跳转依赖此 id。

> 本文件是 Memes 板块的「字段清单 + 写作约束」。每期分析阶段须按此模板填出 `memes.md`，
> 写作 subagent 严格按填好的 `memes.md` + 上一期对应板块的 HTML 格式写出最终 hub.html。

---

## ⚠️ 板块独有硬约束（不可违反 · 三大红线）

1. **必须用 4 列 `meme-analysis-4`**（视觉 / 情绪 / 角色 / Remix），**不是** TikTok/Trends 的 3 列 `game-analysis`
2. **每张 card 必须含图片**（`meme-thumb` + `<img>`），与 trends 的 `img-trio`、tiktok 的 `embed iframe` 都不同
3. **评分维度固定 4 项**：`视觉 / 情绪 / 角色 / Remix`，**不是** TikTok/Trends 的 `角色/玩法/广告/适配`

---

## 0. CSS Class 完整审计（必须 100% 复用，禁止改名/自创）

> 写作 subagent **第一步**：Read 上期 hub.html 的 memes 板块行号区间，输出此清单作为审计痕迹。

### 0.1 板块顶层
- `section-panel`（外层容器，含 `id="s-memes"`）
- `sec-inner`
- `sec-kicker`
- `sec-title`
- `sec-desc`

### 0.2 stats-row
- `stats-row`
- `stat-pill`

### 0.3 method-box
- `method-box`（含子结构 `.icon` + `.title` + `.desc`）

### 0.4 conclusion-box（顶部三栏结论）
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

### 0.5 meme-card（10 张 meme 卡 · 板块独有）
- `meme-card`（卡片根）
- `meme-thumb`（左侧图片容器）
- `meme-rank`
- `meme-format-badge`
- `meme-info`（右侧文字容器）
- `meme-header`
- `meme-meta`
- `meme-name`
- `meme-origin`
- `meme-status`
- `meme-status-new` / `meme-status-surge`（status 类型修饰，二选一）
- `meme-desc`

### 0.6 meme-analysis-4（板块独有 4 列分析 · 核心组件）
- `meme-analysis-4`（外层容器）
- `ma4-cols`（4 列 grid）
- `ma4-col-header`（每列标题）
- `ma4-list`（ul 列表）
- `ga-score-row`（与 trends/tiktok 共享）
- `ga-score`
- `ga-label`
- `ga-label-a` / `ga-label-b` / `ga-label-c`

### 0.7 data-table（Vol.003 新增 · 数据总览）
- `tk-section-title`（小标题）
- `data-table`
- `rank-num`
- `num-cell`

---

## 1. DOM 嵌套伪代码（关键结构）

```
section-panel#s-memes
└── sec-inner
    ├── sec-kicker
    ├── sec-title
    ├── sec-desc
    ├── stats-row
    │   └── stat-pill × 3
    ├── method-box
    │   ├── .icon
    │   └── div
    │       ├── .title
    │       └── .desc
    ├── conclusion-box
    │   ├── cb-header
    │   │   ├── cb-icon (😂)
    │   │   ├── cb-title
    │   │   └── cb-tag
    │   └── cb-grid
    │       └── cb-col × 3
    │           ├── cb-col-title (含 dot)
    │           └── cb-col-body (含若干 cb-highlight)
    ├── meme-card × 10
    │   ├── meme-thumb
    │   │   ├── meme-rank
    │   │   ├── meme-format-badge
    │   │   └── img (onclick="openLightbox(this)")
    │   └── meme-info
    │       ├── meme-header
    │       │   ├── meme-meta (meme-name + meme-origin)
    │       │   └── meme-status.meme-status-{new|surge}
    │       ├── meme-desc
    │       └── meme-analysis-4
    │           ├── ma4-cols
    │           │   └── div × 4
    │           │       ├── ma4-col-header
    │           │       └── ul.ma4-list (li × 2)
    │           └── ga-score-row
    │               ├── ga-score × 4
    │               └── ga-label.ga-label-{a|b|c}
    ├── tk-section-title
    └── data-table
        ├── thead (tr × 1, th × 7)
        └── tbody (tr × 10)
```

---

## 2. 板块顶层（section_meta）

| 字段 | 示例值 | 是否变动 | 写作约束 |
|------|---|---|---|
| `panel_id` | `s-memes` | 固定 | div id 必须为 `s-memes` |
| `sec_kicker` | `😂 Reddit Memes · VOL.003`（含期号） | ⚠️ 期号每期换 | 格式：`😂 Reddit Memes · VOL.XXX` |
| `sec_title` | `表情包 Memes 热门` 或 `美区 Meme 热榜 Top 10` | ✅ 可微调 | 含 "Meme" 字样 |
| `sec_desc` | 一段约 80-130 字 | ✅ 每期新 | 必须含本期最强信号 + 关键 #1/#5 等卡的赞数验证 |

---

## 3. 顶部 stats_row（3 个 stat-pill · Vol.003 风格）

> ⚠️ Vol.003 改进：用**本期具体数据点**（最高赞/最高评论）替代 Vol.002 的「数据周期/视角」泛化文案。

| 字段 | 示例 | 约束 |
|------|---|---|
| `pill_source` | `📊 来源 r/memes top/week` | 固定 + 可补充其他 subreddit |
| `pill_top_upvote` | `🏆 最高赞 91.7K` | 取本期 #1 赞数 |
| `pill_top_comment` | `💬 最高评论 6740（#2 Many of them）` | 取本期评论数最高的 meme，标注名次和短标题 |

每个 stat-pill 内部格式：`emoji <strong>标签</strong> 值`

---

## 4. method_box（Meme 4 维拆解框架）

| 字段 | 约束 |
|------|---|
| `method_icon` | 固定 `💡` |
| `method_title` | `Meme 4 维拆解框架 · Vol.XXX`（期号每期换） |
| `method_desc` | 150-250 字。**必须**说明 4 个维度（📐 视觉模板 / 😈 情绪结构 / 🎭 角色原型 / 🔄 Remix 机制）+ 评分体系（4 项 X/5 + A/B/C 标签）+ 数据来源 + 本周日期范围 |

method_desc 模板（可复用文案）：
```
Meme 对游戏研发的价值不在「这个梗讲了什么」，而在其<strong style="color:#e0e0e0">可复用的格式与情绪</strong>。
本模块按 4 个维度拆解每条 Meme：<strong>📐 视觉模板</strong>（格式怎么套进游戏）、
<strong>😈 情绪结构</strong>（靠什么情绪驱动传播）、<strong>🎭 角色原型</strong>（梗里的「人」是什么原型）、
<strong>🔄 Remix 机制</strong>（为什么能二创、UGC 潜力如何）。
每条附 4 项 <code>X/5</code> 评分 + <code>A/B/C</code> 可用性标签。
数据来源：Reddit (r/memes, r/dankmemes, r/gaming, r/MemeEconomy)，本周 <code>YYYY-MM-DD ~ MM-DD</code> upvotes 排序。
```

---

## 5. conclusion_box（本期 Memes 游戏研发结论 · 三栏）

**Header**：
- `cb-icon`：`😂`
- `cb-title`：`本期 Memes 游戏研发结论`
- `cb-tag`：建议格式 `优先级：角色/叙事 > 玩法反信号 > UGC 机制`（Memes 板块的优先级 — 与 TikTok 的「角色 > 广告 > 玩法」、Trends 的「玩法 > 角色 > 广告」**均不同**）

**三栏（cb-col）颜色顺序固定**：青 → 黄 → 红（与 trends 一致）

| 栏位 | 颜色（dot + cb-col-title） | 字数 | 必须包含 |
|------|---|---|---|
| `conclusion_role` 角色/叙事方向 | `#25f4ee`（青） | 180-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 3+ 个本期 meme 编号、**鼓励标注「TikTok + Memes 双源印证」** |
| `conclusion_play` 玩法/活动方向 | `#ffc533`（黄） | 180-280 字 | 多个 `<span class="cb-highlight">关键概念</span>`、给出可落地玩法名词、含「玩法反信号」（哪些设计要避开） |
| `conclusion_ad` 社媒/UGC 方向 | `#fe2c55`（红） | 180-280 字 | 多个 `<span class="cb-highlight">钩子/句式</span>`、含可复用 UGC 句式模板、**政治/审查/争议话题明确 ⚠️ 标注** |

栏位标题写法（保持与 Vol.003 一致）：
```html
<div class="cb-col-title" style="color:#25f4ee">
  <span class="dot" style="background:#25f4ee"></span> 角色/叙事方向
</div>
```

> **Vol.003 关键话术沉淀**（鼓励复用）：
> - `「<span class="cb-highlight">#N XX</span> TikTok + Memes 双源印证」` — 跨板块联动
> - `「<span class="cb-highlight">⚠️ #N 政治话题</span>...严禁直接用于游戏内容」` — 风险拦截
> - `「<span class="cb-highlight">#N 玩法反信号</span> X 万人集体吐槽 = 必须避开的设计地雷」` — 反向情报

---

## 6. meme_card_grid（10 张 meme-card · 必须）

> ⚠️ **数量固定 = 10**。卡片之间用 HTML 注释分隔：`<!-- Meme #N -->`

每张 card 字段：

```yaml
meme_N:                              # N = 1..10
  rank: 1                             # 数字 1-10
  meme_slug: "You_got_this_bro"      # 用于图片命名：meme_images/0N_{slug}.jpg|gif
  image_path: "meme_images/01_You_got_this_bro.jpg"   # .jpg 或 .gif
  image_alt: "You got this bro"

  # meme-format-badge · Vol.002 风格（中文细分），不要用 Vol.003 的全英 IMAGE/GIF
  format_badge: "图片宏 · 支持型"     # 例：交替大小写 · 图片宏 / GIF 循环动图 / 视角切换 · 图片宏

  # meme-header
  meme_name: '"You got this bro"'    # 加双引号包裹原标题
  meme_origin: "r/memes · 91.7K 赞 · 417 评论"   # Vol.003 简洁格式（中文单位 · 不再带日期）

  # meme-status · Vol.003 改进：每张差异化文案，不再统一 "NEW"
  meme_status:
    text: "★ 全周最高"               # 见下方 status 文案库
    css_class: "meme-status-surge"   # meme-status-new | meme-status-surge

  # 一段 80-150 字描述
  meme_desc: "激励/支持类 meme 本周拿下全周最高赞，证明「支持文化」在欧美社交平台的强大共鸣力。「你能行兄弟」的无条件支持打败所有娱乐/嘲讽内容。"

  # meme-analysis-4 · 4 列固定 · 每列 2 bullet
  ma4:
    visual:                          # 📐 视觉模板
      - "<strong>单人信任框架</strong>：角色面对镜头+温暖眼神的标准「支持型」图片宏；格式极简，无特效，复用成本最低"
      - "套用路径：游戏内「鼓励通知」截图 + 「You got this」字幕 = 现成素材，零制作成本"
    emotion:                         # 😈 情绪结构
      - "<strong>★ 无条件支持</strong>：不带条件、不评判的支持触发「被接纳」深层情感需求；激励共鸣度本期最高"
      - "高赞低评论 = 「所有人都懂无需解释」的沉默共鸣型；分享意愿 > 讨论意愿"
    role:                            # 🎭 角色原型
      - "<strong>★ 陪伴守护型英雄</strong>：「无论如何都支持你」；TikTok + Memes 双源印证，本期最强守护型信号"
      - "直接适配受难侧路英雄/陪伴宠物设计；激励语音台词原型直接可用"
    remix:                           # 🔄 Remix 机制
      - "<strong>万用套句</strong>：任何「你能行」场景均可套用，文化跨度极大；UGC 门槛极低"
      - "玩家失败截图 + 「You got this bro」= 自嘲式病毒传播基因，官方无需推动"

  # 评分 · 4 项 · 1-5 整数 · 顺序固定：视觉 / 情绪 / 角色 / Remix
  scores:
    visual: 3
    emotion: 5
    role: 4
    remix: 4
  conclusion_label:
    code: "A"                        # A | B | C
    text: "A 契合度高"               # A 契合度高 / B 结构借鉴 / C 观察储备
    css_class: "ga-label-a"
```

### 6.1 meme-status 文案库（Vol.003 差异化沉淀）

> ❌ Vol.002 全部用 "NEW" — 信息密度低，**禁用**
> ✅ Vol.003 按本期数据特点差异化标注 — 强制采用

按角色分配建议（每期 10 张卡里**至少 4 张**用差异化标注，剩余可用 "NEW"）：

| 标注文案 | 触发条件 | css_class |
|---|---|---|
| `★ 全周最高` | 赞数本期 #1 | `meme-status-surge` |
| `💬 评论最高` | 评论数本期最高 | `meme-status-surge` |
| `★ A 级信号` | 跨板块（TikTok 双源印证） | `meme-status-new` |
| `★ 直接游戏信号` | r/gaming 来源或玩法相关 | `meme-status-new` |
| `道德灰度` / `地缘政治` / `升级/演化` / `冰冷/危险` / `社交验证` / `高能共鸣` | 内容主题分类 | `meme-status-new` |
| `NEW` | 兜底（其他常规） | `meme-status-new` |

### 6.2 写作约束（极重要）

**meme-thumb 子元素顺序（Vol.003 改进 · 强制采用）**：
```html
<div class="meme-thumb">
  <div class="meme-rank">{rank}</div>
  <div class="meme-format-badge">{format_badge}</div>
  <img src="{image_path}" alt="{image_alt}" onclick="openLightbox(this)">
</div>
```
- ❌ Vol.002 顺序（img → rank → badge）已废弃
- ✅ Vol.003 顺序（rank → badge → img）：rank 和 badge 在 img 之上叠加，CSS 渲染更可预测
- ⚠️ `onclick` 用 `openLightbox(this)`，**不**用 `openLightbox(this.src)`（与全站其他板块一致）

**format_badge 文案规则（Vol.002 风格 · 强制保留）**：
- ❌ Vol.003 的全英大写 `IMAGE` / `GIF` 信息密度过低 — **禁用**
- ✅ Vol.002 的中文细分（含格式 + 风格）— **强制采用**
  - 示例：`交替大小写 · 图片宏` / `GIF 循环动图` / `视角切换 · 图片宏` / `经典台词颠覆` / `造词 · 图片宏` / `进化对比` / `成就展示 · 怀旧`
- 格式：`{格式类型} · {风格修饰}`（中间 ` · ` 分隔），或单独的 `{格式名}`

**meme-origin 格式（Vol.003 简洁化 · 强制采用）**：
```
r/{subreddit} · {赞数中文化} · {评论数} 评论
```
- 示例：`r/memes · 91.7K 赞 · 417 评论` / `r/gaming · 38.2K 赞 · 349 评论`
- ❌ Vol.002 的长格式（`来源：r/memes · 69,024 pts · 2,553 评论 · 2026.04.02 · #1 MotW`）信息冗余 — 弃用
- 单位中文化：`91700` → `91.7K 赞`（保留一位小数）；评论数保留原数字
- **不**附日期（数据周期已在顶部 stats-row 体现）
- **不**附排名标注（rank 已在 meme-rank 显示）

**meme-header 排版**：
```html
<div class="meme-header">
  <div class="meme-meta">
    <div class="meme-name">{meme_name}</div>
    <div class="meme-origin">{meme_origin}</div>
  </div>
  <span class="meme-status {css_class}">{status_text}</span>
</div>
```

**meme-desc**：80-150 字。**必须**包含赞数/评论数验证句（说明这条为何上榜）+ 文化解读。**禁止**与 ma4 内容重复。

**meme-analysis-4 排版（4 列硬约束）**：
```html
<div class="meme-analysis-4">
  <div class="ma4-cols">
    <div>
      <div class="ma4-col-header">📐 视觉模板</div>
      <ul class="ma4-list">
        <li>{bullet 1}</li>
        <li>{bullet 2}</li>
      </ul>
    </div>
    <div>
      <div class="ma4-col-header">😈 情绪结构</div>
      <ul class="ma4-list">
        <li>{bullet 1}</li>
        <li>{bullet 2}</li>
      </ul>
    </div>
    <div>
      <div class="ma4-col-header">🎭 角色原型</div>
      <ul class="ma4-list">
        <li>{bullet 1}</li>
        <li>{bullet 2}</li>
      </ul>
    </div>
    <div>
      <div class="ma4-col-header">🔄 Remix 机制</div>
      <ul class="ma4-list">
        <li>{bullet 1}</li>
        <li>{bullet 2}</li>
      </ul>
    </div>
  </div>
  <div class="ga-score-row">...</div>
</div>
```

**ma4 4 列约束（绝对规则）**：
- ❌ 永远不允许漏列、永远不允许从 4 列变 3 列
- ✅ 4 列 header emoji 顺序固定：📐 → 😈 → 🎭 → 🔄
- ✅ 4 列标题文字固定：`视觉模板 / 情绪结构 / 角色原型 / Remix 机制`

**ma4-list bullet 规则**：
- 每列**正好 2 bullet**（Vol.002 / Vol.003 一致）
- 每 bullet **40-100 字**
- **首 bullet 必须**含 `<strong>...</strong>` 关键词高亮（强制）
- 第二 bullet 视情况加 strong（鼓励但不强制）
- ⚠️ 政治/审查/争议话题相关 bullet **必须**带 `⚠️` 前缀 + 风险提示（如「广告/游戏内容严禁直接使用」）
- 跨板块印证内容鼓励用 `<strong>★ ...</strong>` 或 `★★★ ...` 强化语气（仅 Vol.003 风格）

**ga-score-row（评分条 · 必须包含 4 项 + 1 label）**：
```html
<div class="ga-score-row">
  <span class="ga-score">视觉 <b>{visual}</b>/5</span>
  <span class="ga-score">情绪 <b>{emotion}</b>/5</span>
  <span class="ga-score">角色 <b>{role}</b>/5</span>
  <span class="ga-score">Remix <b>{remix}</b>/5</span>
  <span class="ga-label {css_class}">{label_text}</span>
</div>
```
- 4 项评分顺序固定：`视觉 / 情绪 / 角色 / Remix`（与 ma4 列顺序一致）
- 数字用 `<b>` 包裹（不是 strong）
- label 文字格式：`A 契合度高` / `B 结构借鉴` / `C 观察储备`

---

## 7. data_table（Vol.003 新增 · 强制采用）

> ⚠️ Vol.002 **没有**此组件 — 信息密度不足
> ✅ Vol.003 新增 — **明显改进，强制保留**

排在所有 meme-card 之后，section-panel 闭合之前。

**小标题**：
```html
<div class="tk-section-title" style="margin-top:8px;">
  <span>数据总览</span><span class="num">upvotes 排行</span>
</div>
```

**表格结构**：
```html
<table class="data-table" style="margin-bottom:28px;">
  <thead>
    <tr>
      <th>#</th><th>标题</th><th>来源</th><th>赞数</th><th>评论</th><th>格式</th><th>评级</th>
    </tr>
  </thead>
  <tbody>
    <!-- 第 1 行高亮 -->
    <tr style="background:#1a0305;">
      <td class="rank-num">1</td>
      <td>"You got this bro"</td>
      <td class="num-cell">r/memes</td>
      <td class="num-cell" style="color:#ff4444;">91.7K 🏆</td>
      <td class="num-cell">417</td>
      <td class="num-cell">图片宏</td>
      <td class="num-cell"><span style="color:#4ade80;font-weight:700;">A</span></td>
    </tr>
    <!-- 其余 9 行无背景色 -->
    <tr>
      <td class="rank-num">2</td>
      ...
    </tr>
  </tbody>
</table>
```

**表格字段约束**：

| 列 | 字段 | 约束 |
|---|---|---|
| `#` | rank | 数字 1-10，写在 `<td class="rank-num">` |
| `标题` | meme_name 简版 | 与 meme-card 一致；保留双引号；裁短超 25 字内容 |
| `来源` | subreddit | `r/memes` / `r/gaming` 等 |
| `赞数` | 赞数 | 中文化单位；**第 1 行**额外加 ` 🏆` 后缀；评论数最高的那行也可加 🏆 |
| `评论` | 评论数 | 原数字；**评论数最高**的行字体红 `style="color:#ff4444;"` + 加 🏆 |
| `格式` | format 简版 | `图片宏` / `GIF` / `游戏截图` / `进化图` |
| `评级` | A/B/C | A=`#4ade80`（绿） / B=`#fbbf24`（黄） / C=`#888`（灰），`font-weight:700` |

**特殊样式**：
- 第 1 行（赞数最高）整行 `style="background:#1a0305;"`（深红色背景）
- 赞数列第 1 行 `style="color:#ff4444;"`（红色字体）
- 评论数最高行同样处理（如 Vol.003 #2 评论 6740）

---

## 8. 字段对照表（与其他板块的差异 · 防混用）

| 维度 | TikTok 板块 | Trends 板块 | **Memes 板块（本模板）** |
|------|---|---|---|
| `panel_id` | `s-tiktok` | `s-trends` | **`s-memes`** |
| 主组件 class | `video-card` | `trend-topic-card` | **`meme-card`** |
| 主组件数 | 10 | 10 | 10 |
| 卡内分析栏组件 | `game-analysis` (3 cols) | `game-analysis` (3 cols) | **`meme-analysis-4` (4 cols)** ⚠️ |
| 卡内栏数 | **3** | **3** | **4**（视觉/情绪/角色/Remix） |
| 每栏 bullet | 固定 3（v2） | 角色/玩法 3-5、广告固定 3 | **固定 2** |
| 每栏 header emoji | 🎭 / ⚔️ / 🎬 | 🎭 / ⚔️ / 🎬 | **📐 / 😈 / 🎭 / 🔄** |
| 评分项 | 4 项（角色/玩法/广告/适配） | 4 项（角色/玩法/广告/适配） | **4 项（视觉/情绪/角色/Remix）** ⚠️ |
| 评分项与栏位关系 | 一致 | 一致 | **一致**（4 评分对应 4 列） |
| 标签三档 | A/B/C 直接可用/需改造/仅参考 | A/B/C 同 | **A/B/C 直接可用/结构借鉴/观察储备** |
| 顶部 conclusion 优先级 | 角色 > 广告 > 玩法 | 玩法 > 角色 > 广告 | **角色/叙事 > 玩法反信号 > UGC 机制** |
| 图片资产 | embed iframe | 3 张静态图（img-trio） | **1 张图片**（meme_images/0N_{slug}.jpg\|gif） |
| stats-pill 数 | 4 | 4 | **3** |
| method_box | ✅ | ❌ | ✅ |
| conclusion_box | ✅ | ✅ | ✅ |
| data_table | ✅ | ❌ | ✅（Vol.003 起） |
| metrics 小卡 | ✅（3 张） | ❌ | ❌ |
| analysis_signal 段落 | ✅ | ❌ | ❌（融合在 meme-desc + ma4） |
| trend_grid 趋势卡 | ✅ | ❌ | ❌ |
| tags 字段 | emotion + format | ttc-tag × 5 | **无独立 tags**（主题词融在 meme-status / format-badge） |

> **核心防混用提示**：
> - `meme-analysis-4` ≠ `game-analysis`：**4 列 vs 3 列** — 永远不可互换
> - 评分维度 `视觉/情绪/角色/Remix` ≠ `角色/玩法/广告/适配` — 永远不可互换
> - meme-card **每栏正好 2 bullet** ≠ tiktok 的 3 bullet ≠ trends 的 3-5 bullet

---

## 写作 subagent 必读

收到本蓝图 + 上期 hub.html 行号区间后，**强制工作流**：

1. **Read 上期 hub.html 指定行号区间**（s-memes 板块），输出该区间用到的所有 CSS class 清单（写在你回复里，作为审计痕迹）。对照本模板第 0 节，确认 0 偏差
2. **Read 本蓝图（memes.md）**，校验：
   - 10 张 meme-card 字段齐全
   - 每张 card：1 张图、4 列 ma4、每列 2 bullet、4 项评分、1 个 label
   - **ma4 必须 4 列，emoji 顺序 📐 → 😈 → 🎭 → 🔄**
   - 评分顺序：视觉 → 情绪 → 角色 → Remix
   - meme-thumb 子元素顺序：rank → badge → img
   - meme-origin 格式：`r/{sub} · {X.XK 赞} · {N} 评论`
   - meme-status 至少 4 张差异化（不全是 "NEW"）
   - format_badge 中文细分（不是全英 IMAGE/GIF）
   - data_table 必须存在，10 行
3. 严格按上期 DOM 嵌套生成 HTML，**禁止凭记忆改 class 名**
4. 用 Write/Edit 写入目标文件
5. 返回主对话：写入位置 + 「已使用 CSS class：X, Y, Z」+ 「未填字段警告（如有）」+ 「ma4 4 列守住情况」

**禁止行为**：
- ❌ **把 4 列 ma4 写成 3 列 game-analysis**（最严重红线）
- ❌ **评分维度写成 角色/玩法/广告/适配**（最严重红线）
- ❌ 漏 ma4 任意一列
- ❌ 每列 bullet ≠ 2
- ❌ format_badge 用全英 IMAGE/GIF（Vol.003 的退化）
- ❌ meme-status 全部统一 "NEW"（Vol.002 的退化）
- ❌ meme-origin 还带日期/排名/MotW（Vol.002 的退化）
- ❌ meme-thumb 用 img → rank → badge 顺序（Vol.002 的退化）
- ❌ onclick 用 `openLightbox(this.src)`（Vol.003 的局部退化，用 `(this)` 与全站一致）
- ❌ 删除 data_table（Vol.003 的明显改进）
- ❌ 用其他板块的 CSS class（`video-card`、`trend-topic-card`、`metrics`、`analysis-list`、`ttc-*`）
- ❌ 自创组件
- ❌ 政治/审查议题不带 ⚠️ 标注

---

## 校验清单（写完 HTML 后由主对话核对）

- [ ] 7 个组件齐全：sec_meta + stats_row(3) + method_box + conclusion_box(3 cols) + meme-card × 10 + tk-section-title + data_table
- [ ] section-panel id = `s-memes`
- [ ] stats-pill 数 = 3（含本期最高赞 + 最高评论）
- [ ] method_box 期号正确
- [ ] conclusion-box `cb-tag` 文案体现 Memes 优先级（角色/叙事 > 玩法反信号 > UGC 机制 或类似）
- [ ] conclusion-box 三栏颜色顺序：青(#25f4ee) → 黄(#ffc533) → 红(#fe2c55)
- [ ] meme-card 数 = 10
- [ ] **每张 card ma4 = 4 列**（视觉/情绪/角色/Remix）⚠️ 红线
- [ ] 每张 card ma4 每列 bullet = 2
- [ ] 每张 card ma4 每列首 bullet 含 `<strong>`
- [ ] 每张 card 4 项评分齐全（**视觉/情绪/角色/Remix** · 顺序固定）⚠️ 红线
- [ ] 每张 card 含 ga-label，css_class 与 code/text 一致
- [ ] meme-thumb 子元素顺序：rank → badge → img
- [ ] 所有 img 的 `onclick="openLightbox(this)"`（不是 `(this.src)`）
- [ ] 所有 format_badge 中文细分（不是全英 IMAGE/GIF）
- [ ] meme-origin 格式：`r/{sub} · {X.XK 赞} · {N} 评论`（无日期/无 MotW 标注）
- [ ] 至少 4 张 meme-status 文案差异化（不全是 NEW）
- [ ] data_table 10 行 + 表头
- [ ] data_table 第 1 行（赞数最高）背景 `#1a0305` + 赞数列字体红 `#ff4444` + 加 🏆
- [ ] data_table 评论数最高行字体红 + 加 🏆
- [ ] 评级列 A=绿/B=黄/C=灰 颜色齐全
- [ ] 政治/审查/争议话题相关 ma4 bullet 含 `⚠️` 标注
- [ ] **没有**引入 metrics 小卡 / analysis_signal / video-card / trend-topic-card / game-analysis（这些都是其他板块的）
