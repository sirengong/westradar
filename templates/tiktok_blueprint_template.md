# TikTok 板块 · 写作蓝图模板（Template v2）

> **版本说明**：v2 在 Vol.002 基础上沉淀 Vol.003 的 4 项改进 + Vol.003 风格 stats-row。
> tags 仍保留 `#` 前缀（与 Vol.002 一致）。
> 适用于 Vol.004+ 所有 TikTok 板块生成。
>
> **🔗 卡 id 命名规范（Vol.005+ 强制）**：每个 `<div class="video-card …">` 必须加 `id="tt-N"`（N = 该卡 rank，1-10）。Overview 板块 v2 的关键词跳转依赖此 id。漏加会导致点击 Overview 关键词跳到本卡时定位失败。

> 本文件是 TikTok 板块的「字段清单 + 写作约束」。每期分析阶段须按此模板填出 `tiktok.md`，
> 写作 subagent 严格按填好的 `tiktok.md` + 上一期对应板块的 HTML 格式写出最终 hub.html。

---

## 1. 板块顶层（section_meta）

| 字段 | 示例值 | 是否变动 | 写作约束 |
|------|---|---|---|
| `sec_kicker` | `🎵 TikTok · VOL.003`（含期号） | ⚠️ 期号每期换 | 格式：`🎵 TikTok · VOL.XXX` |
| `sec_title` | `TikTok 热门内容` | ❌ 固定 | 直接照抄 |
| `sec_desc` | 一段约 80-100 字描述 | ✅ 每期新 | 必须含本期最强信号 + 关键创作者/视频引用 |

## 2. 顶部 stats_row（4 个 stat-pill · Vol.003 风格）

| 字段 | 示例 | 约束 |
|------|---|---|
| `pill_source` | `📱 来源 TikTok Explore` | 固定 |
| `pill_period` | `📅 周期 04-09 – 04-16` | 改成本期日期范围 |
| `pill_method` | `🎯 方法 人工去重，排除新闻/政治，选游戏研发相关` | 微调 |
| `pill_top_view` | `👁 最高播放 20.9M` | 取本期 #1 播放量 |

## 3. method_box（排名方法论）

| 字段 | 约束 |
|------|---|
| `method_title` | 含「按播放量排名」字样 |
| `method_desc` | 80-150 字。说明：① 数据源（TikTok Explore + 美区 VPN + CDP）② 排名依据 ③ 采集量 ④ 平台优先级（角色 > 广告 > 玩法） |

## 4. conclusion_box（本期 TikTok 游戏研发结论 · 三栏）

**优先级标签**：固定为「优先级：角色 > 广告 > 玩法」

每栏字段约束：

| 栏位 | 颜色 | 字数 | 必须包含 |
|------|---|---|---|
| `conclusion_role` 角色设计方向 | `#25f4ee`（青） | 150-220 字 | 多个 `<span class="cb-highlight">关键概念</span>`、引用 3+ 个本期视频 |
| `conclusion_play` 活动/玩法方向 | `#ffc533`（黄） | 150-220 字 | 多个 `<span class="cb-highlight">关键概念</span>`、给出可落地玩法名词 |
| `conclusion_ad` 广告创意方向 | `#fe2c55`（红） | 150-220 字 | 多个 `<span class="cb-highlight">钩子结构</span>`、含可复用开场公式 |

## 5. video_grid（10 张 video-card · 必须）

> ⚠️ **v2 新版结构（Vol.003 改进）**：每张卡新增 metrics（3 张小卡）+ analysis-list（信号提炼）。
> ga-list 每栏 3 bullet（不再是 Vol.002 的 2 bullet）。

每张 card 字段：

```yaml
video_N:                          # N = 1..10
  rank: 1
  is_champion: true               # 仅 #1
  rank_badge_class: "gold"        # #1=gold；其他空
  video_id: "7616849748359728415"
  embed_url: "https://www.tiktok.com/embed/v2/{video_id}"
  author_handle: "collinskey"
  author_url: "https://www.tiktok.com/@{handle}/video/{video_id}"

  # video-header 排版（Vol.003 新风格）
  video_title_main: "#boneka #brainrot — AI Doll Meme 爆发"   # 标题—说明 合一行
  video_author_display: "@collinskey"                          # 单独一行
  score_badge: "20.9M 播"                                       # 浮右独立

  # metrics 区 · 3 张小卡（Vol.003 新增）
  metrics:
    - icon: "👁"
      val: "20.9M"
      lbl: "播放"
      highlight: true             # 必有 1 个，类 .metric.highlight，红色
    - icon: "🏷"                  # 第 2 张：话题/标签
      val: "#boneka"
      lbl: "话题"
    - icon: "🤖"                  # 第 3 张：内容类型/核心信号
      val: "AI 娃娃"
      lbl: "内容类型"

  # tags（保留 # 前缀，Vol.002 风格）
  tags:
    emotion: ["#自信", "#人格魅力"]   # 2-3 个
    format:  ["#真人出镜", "#人设展示"] # 2 个

  # 信号提炼段落（Vol.003 新增）· 必须 3 bullet
  analysis_signal:
    - "Boneka（印尼语\"娃娃\"）+ Italian Brainrot 融合——亚文化正在跨文化合流"
    - "AI 生成娃娃造型：无固定叙事 + 奇异外观 = 粉丝自发填充 Lore"
    - "Collins Key（2000万+ 粉）创作此类内容 = 文化破圈确认信号"

  # game-analysis 三栏 · 每栏必须 3 bullet（Vol.003 新风格）
  game_analysis:
    role:
      - "<strong>开放 Lore AI 角色</strong>作为种子 IP；无背景设定，由玩家社区自发创造"
      - "奇异外观/混血文化审美；娃娃/玩偶原型可做魔法召唤系"
      - "粉丝命名权/故事权 = 社区共创留存"
    play:
      - "<strong>随机生成角色外观</strong>系统；每次召唤结果不可预测"
      - "玩家自定义 Lore 填写（角色故事由玩家众包）"
      - "Brainrot 混乱属性做 Rogue 技能池"
    ad:
      - "角色登场 + 零解释 = 好奇心驱动点击"
      - "奇怪外形+正常背景的强反差钩子"
      - "不建议硬蹭 Brainrot 梗，视觉逻辑比文字解释更重要"

  scores: {role: 5, play: 4, ad: 4, fit: 4}
  conclusion_label:
    code: "A"                     # A | B | C
    text: "A 契合度高"
    css_class: "ga-label-a"       # ga-label-a | ga-label-b | ga-label-c
```

### 写作约束（极重要）

**video-header 排版（Vol.003 新结构）**：
```html
<div class="video-header">
  <div>
    <div class="video-title">{video_title_main}</div>
    <div class="video-author">{video_author_display}</div>
  </div>
  <div class="score-badge">{score_badge}</div>
</div>
```

**metrics 排版（Vol.003 新增 · 必须 3 张小卡）**：
```html
<div class="metrics">
  <div class="metric highlight"><span class="icon">{icon}</span><span class="val">{val}</span><span class="lbl">{lbl}</span></div>
  <div class="metric">...</div>
  <div class="metric">...</div>
</div>
```
- 第 1 张必须 `.metric.highlight`（播放量，红色高亮）
- 第 2 张：本期最相关话题/hashtag
- 第 3 张：内容类型 / 核心信号 / 情绪标签 / 风格标签（按视频特点选）
- 三张内容互不重复（不要 metric 1 和 metric 2 都是播放数）

**analysis_signal 段落（Vol.003 新增）**：
```html
<div class="analysis-title">信号提炼</div>
<ul class="analysis-list">
  <li>{bullet 1}</li>
  <li>{bullet 2}</li>
  <li>{bullet 3}</li>
</ul>
```
- 必须**正好 3 bullet**
- 每 bullet 30-60 字
- 内容应"提炼这条视频值得分析的根本理由"，与下方 game-analysis（落地建议）层次区分
- analysis_signal 多用「为什么」「文化信号」「破圈」类抽象判断
- game-analysis 多用「角色原型/玩法名词/广告公式」类可落地的具体建议

**game-analysis bullet（Vol.003 新规格）**：
- 每栏**正好 3 bullet**（不再是 Vol.002 的 2）
- **首 bullet 必须**含 1 个 `<strong>...</strong>` 关键词高亮
- 后两 bullet 视情况加 strong（鼓励但不强制）
- 每 bullet 25-50 字

**tags（保留 # 前缀）**：
```html
<div class="tags">
  <span class="tag emotion">#自信</span>
  <span class="tag emotion">#人格魅力</span>
  <span class="tag format">#真人出镜</span>
</div>
```
- emotion 2-3 个、format 2 个，合计 4-5 个
- 全部带 `#` 前缀

## 6. data_table（数据总览 · 10 行）

字段（每行）：
- `rank`（数字）
- `author_link`（HTML：`<a class="author-link" href="..." target="_blank">@xxx</a>`）
- `content_summary`（≤25 字，与 video-card title 精炼版一致）
- `views_display`（与 card 一致，#1 末尾加 `🏆`）
- `tags_summary`（2 个 tag，从 video tags 中精选，**保留 #**）

**特殊样式**：第 1 行加 `style="background:#1a0508;"` 和 `class="num-cell top-val"` 在播放量列。

## 7. trend_grid（2 张 trend-card）

### 7.1 内容类型分布（5 行 bar-item）

按本期 10 个视频的内容类型聚类，每行：
- 类型名（5-15 字）→ 数量（X / 10）→ bar-fill width = X*10%
- 5 个分类合计必须 = 10

### 7.2 播放量 Top 3（4 行 bar-item）

- 第 1 行：本期 #1（width = 100，基准）
- 第 2 行：本期 #2（width = 本期#2/本期#1 * 100，四舍五入）
- 第 3 行：本期 #3（width 同上）
- 第 4 行：vs 上期 #1 对比，灰色 `background:rgba(255,255,255,0.15)`，width 上限 100

---

## 写作 subagent 必读

收到本蓝图 + 上期 hub.html 行号区间后，**强制工作流**：

1. **Read 上期 hub.html 指定行号区间**，输出该区间用到的所有 CSS class 清单（写在你回复里，作为审计痕迹）
2. **Read 本蓝图（tiktok.md）**，校验所有字段已填、metric/analysis_signal/ga-list bullet 数量正确、评分 1-5
3. 严格按上期 DOM 嵌套生成 HTML，**禁止凭记忆改 class 名**
4. 用 Write/Edit 写入目标文件
5. 返回主对话：写入位置 + 「已使用元素：X, Y, Z」+ 「未填字段警告（如有）」

**禁止行为**：
- ❌ 用其他板块的 CSS class（例如 `meme-analysis-4`）
- ❌ 自创新组件
- ❌ 跳过任何字段
- ❌ metrics ≠ 3 张
- ❌ analysis_signal bullet ≠ 3
- ❌ ga-list 任一栏 bullet ≠ 3

---

## 校验清单（写完 HTML 后由主对话核对）

- [ ] 7 个组件齐全：sec_meta + stats_row(4) + method_box + conclusion_box + video_grid + data_table + trend_grid
- [ ] video-card 数 = 10
- [ ] 每张 card metrics = 3 张（首张 .highlight）
- [ ] 每张 card analysis-list bullet = 3
- [ ] 每张 card 三栏 ga-list 各 3 bullet
- [ ] 每张 card 4 项评分齐全
- [ ] tags 全部带 #
- [ ] data_table 10 行，#1 高亮
- [ ] trend_grid 内容类型分布合计 = 10
- [ ] vs 上期对比行存在
