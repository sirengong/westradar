# 欧美内容情报站 · Westradar · 操作手册

> 为游戏研发团队提供美区社媒热点分析与创意灵感  
> 线上地址：https://sirengong.github.io/westradar/  
> 游戏类型：西幻卡牌游戏

---

## 一、项目概览

### 五大内容板块

| 板块 | 数据源 | 采集方式 | 是否需要 API |
|------|--------|----------|-------------|
| 🔥 热搜分析 | Google Trends 美区 | pytrends API | 不需要 |
| 🎵 TikTok 热门 | TikTok 全平台热门（默认） | CDP 爬 Explore 页面 | 不需要 |
| ▶️ YouTube Shorts | YouTube 美区热门（默认） | YouTube Data API | `YOUTUBE_API_KEY` |
| 😂 表情包 Memes | Reddit r/memes 等 | Reddit JSON API | 不需要 |
| 📢 平台热门广告 | 广大大 guangdada.net | CDP 浏览器 | 需要登录账号 |

### 每期产出

- `hub.html` — 集合界面，侧栏导航切换五大板块（含总览）
- `share-card.html` — 白底分享图，用于发社区平台
- `index.html` — 归档首页（更新每期数据卡片）

---

## 二、每周执行流程

### 准备工作（执行前一次性确认）

```
1. 打开 Chrome
2. 确认已登录广大大 (guangdada.net)
3. 确认 CDP Proxy 运行中：node ~/.claude/skills/web-access/scripts/check-deps.mjs
4. 确认环境变量配置：APIFY_TOKEN / YOUTUBE_API_KEY / GEMINI_API_KEY
```

---

### Phase 1 · 数据采集（约 15 分钟）

**Step 1 — 创建本期文件夹**
```bash
DATE="2026-04-23"   # 修改为当周日期（每周三）
REPORT_DIR="/c/Users/gongjue/tiktok-reports/$DATE"
mkdir -p "$REPORT_DIR/trend_images" "$REPORT_DIR/yt_images" \
         "$REPORT_DIR/meme_images" "$REPORT_DIR/ads_images_gdd" \
         "$REPORT_DIR/ads_videos_gdd"
```

**Step 2 — Google Trends**
```bash
python3 ~/.claude/skills/trends-research/scripts/fetch_trends.py \
  --output "$REPORT_DIR/trends_raw.json" --top-n 15 --timeframe "now 7-d"
```
> ⚠️ **采集后先展示话题列表给用户确认**。体育赛事占比过高时，用 web 搜索补充游戏/影视/文化话题。
> 确认后用 CDP + Google Images 为每个话题下载 3 张图片到 `trend_images/`

**Step 3 — TikTok 热门（CDP Explore 页面）**
> ⚠️ 不使用 Apify 搜索模式（日期过滤无效），改用 CDP 直接爬 TikTok Explore 页面

**Step 4 — YouTube Shorts（默认美区 trending）**
```bash
python3 ~/.claude/skills/youtube-research/scripts/fetch_youtube.py \
  --days 7 --limit 50 --output "$REPORT_DIR/yt_raw.json"
python3 ~/.claude/skills/youtube-research/scripts/analyze_youtube.py \
  --input "$REPORT_DIR/yt_raw.json" --output "$REPORT_DIR/yt_top10.json" --top 10
# 之后 CDP 下载 YouTube 缩略图到 yt_images/
```

**Step 5 — Reddit Memes**
```bash
python3 ~/.claude/skills/westradar/scripts/fetch_memes.py \
  --output "$REPORT_DIR/memes_raw.json" --limit 50
# 之后 CDP 下载 meme 图片到 meme_images/
```

**Step 6 — 广大大广告（⚠️ 必须当天完成，不能事后补）**

> ⚠️ **用户手动设置筛选条件**（人气值Top1% + 游戏分类），Claude **绝不触碰筛选**。
> ⚠️ **HTML 类型广告跳过**，只提取有视频的广告，顺延补位至 10 条。
> ⚠️ 关闭弹窗只用 **ESC 键**，禁用 `[class*=close]` 通配符选择器。

---

### Phase 2 · ★ 蓝图驱动 + Subagent 分块生成（约 60 分钟）

> ⚠️ **总原则：主对话不亲自写 hub.html。** Vol.003 教训——主对话同时背着 5 份 raw JSON + 上期完整 hub.html + 50 条分析在脑内，写到 hub 时陷入"再读一个文件"循环。Vol.004+ 改用「蓝图 + subagent」流水线：主对话只编排，重活全交给 subagent 在隔离上下文里跑。

> ⚠️ **真相源分工**：
> - **格式真相源** = 上一期 hub.html 对应板块（每个 subagent 自己读，主对话不读）
> - **内容真相源** = 本期 blueprint.md（分析阶段产出，给写作 subagent 当填表数据）
> - **字段约束源** = `~/tiktok-reports/templates/{板块}_blueprint_template.md`（沉淀好，跨期复用）

> ⚠️ **6 模板已就绪**（`~/tiktok-reports/templates/`）：
> overview / tiktok / youtube / memes / trends / ads —— 每份含 CSS class 审计 + DOM 嵌套伪代码 + 字段清单 + 写作约束 + 防混用对照 + subagent 强制工作流

---

#### Phase 2a · 填蓝图（约 30 分钟）

每板块独立调一个 **分析 subagent**，输入：
- 模板路径：`~/tiktok-reports/templates/{板块}_blueprint_template.md`
- 本期数据 JSON 路径
- 本期图片资产路径
- 上期 hub.html 中对应板块的行号区间（仅作为分析风格参考，蓝图自己填字段）

subagent 输出：`$REPORT_DIR/blueprints/{板块}.md`

**执行顺序**：
1. **5 数据板块并行**（trends / tiktok / youtube / memes / ads）—— 互不依赖
2. 主对话审核 5 份蓝图（关键点：字段齐 / 评分合理 / 跨板块编号能对上）
3. **再做 overview 蓝图**（依赖 5 份蓝图作为综合依据，不能并行）
4. 主对话审核 overview（重点看 ov-signal 跨源印证是否真实有 ≥2 平台证据）

#### Phase 2b · 写 HTML fragment（约 20 分钟）

每板块独立调一个 **写作 subagent**，输入：
- 蓝图 .md 路径（`$REPORT_DIR/blueprints/{板块}.md`）
- 模板路径（兜底约束）
- **上期 hub.html 行号区间**（subagent 自己 Read，提取 CSS class 审计）

subagent 强制工作流（已写在每个模板里）：
1. Read 上期对应板块 → 输出 CSS class 清单作为审计痕迹
2. Read 蓝图 → 校验字段齐全
3. 按上期 DOM + 蓝图字段生成 HTML fragment
4. Write 到 `$REPORT_DIR/poc_{板块}_section.html`
5. 返回主对话审计报告（行号 / 元素清单 / 字段使用情况 / 警告）

**执行顺序**：6 板块可全部并行（互不依赖，主对话只收审计摘要）

#### Phase 2c · 拼接 hub.html（约 5 分钟）

主对话用 head + cat + tail 拼接 6 fragment：

```bash
VOL_PREV="../2026-XX-XX/hub.html"   # 上期 hub 路径
DIR="$REPORT_DIR"
OUT="$DIR/hub.html"

# 1. 找上期 hub.html 的 section 边界
grep -n 'id="s-' $VOL_PREV     # 6 个 section 起始行
grep -n '</main>' $VOL_PREV    # JS 块起始行

# 2. 拼接（以 s-overview 起始行 = N，</main> 行 = M 为例）
head -n $((N-1)) $VOL_PREV > $OUT
cat $DIR/poc_overview_section.html >> $OUT
cat $DIR/poc_tiktok_section.html >> $OUT
cat $DIR/poc_youtube_section.html >> $OUT
cat $DIR/poc_memes_section.html >> $OUT
cat $DIR/poc_trends_section.html >> $OUT
cat $DIR/poc_ads_section.html >> $OUT
tail -n +$M $VOL_PREV >> $OUT
```

拼接后主对话改 4 处：
1. `<header>` 里的 Vol 编号 + 日期
2. sidebar `sidebar-group-label` Vol 编号 + 日期
3. sidebar 「全部期刊」加本期 + 旧期标识降级
4. 旧期 hub.html 侧栏也加本期链接（防 Phase 4 漏 commit）

校验：`grep -n 'id="s-' hub.html` 应输出 6 行，顺序 overview/tiktok/youtube/memes/trends/ads。

#### Phase 2d · 审核暂停

同 Phase 3，主对话告知用户本期 hub.html 路径 + 重点检查项，等用户确认后进入 Phase 4。

---

### ✅ JS 函数兼容性（已在 Vol.003 修复）

历史背景：Vol.002 → Vol.003 时 JS 重构，`openVbox` 被替换成 `openVideo` + `openAdVideo`，但 TikTok 卡的 onclick 没同步改 → Vol.003 hub.html 的 TikTok ⤢ 按钮报错。

**已在 2026-04-17 修复**：在 Vol.003 hub.html 的 `</script>` 之前补回了 openVbox 函数。

下期 Vol.004 拼接时，`tail -n +M $VOL_PREV` 会自动把 openVbox 一起拷过来，**无需手动补丁**。

校验命令（每期拼接后跑一次）：
```bash
grep -c "function openVbox" hub.html   # 期望输出 1
```
如果输出 0，说明 JS 块异常，停下检查上期 hub.html。

---

### Phase 3 · 完整性检查 + 人工审核（发布前必做）

> ⚠️ **Claude 必须在此阶段暂停，等待用户确认后才能进行 Phase 4 推送。**

**本地预览**：`python3 -m http.server 8080`，访问 `http://localhost:8080/$DATE/hub.html`
（YouTube iframe 不支持 file:// 协议，必须用 HTTP 服务器预览）

#### 3a. ★ 每板块「三件套」强制检查

> Vol.003 教训：Memes 和广告板块均遗漏了 method-box / conclusion-box / 数据表。

每个板块（热搜/TikTok/YouTube/Memes/广告）**必须**包含：
- [ ] **method-box**：数据来源 + 分析框架说明
- [ ] **conclusion-box**：3 列结论总结
- [ ] **数据总览表**：排名表格

#### 3b. ★ 格式一致性强制检查

> Vol.003 教训：YouTube 指标用了错误 CSS class，高亮用了青色而非红色，Memes 用了 3 列而非 4 列。

- [ ] YouTube 指标：`.yt-meta` / `.yt-stat` / `.sv` / `.sv.hot` / `.sl`（不是 `.yt-metrics`/`.ym-val`）
- [ ] YouTube 标签：`.yt-tags` / `.yt-tag.hook` / `.yt-tag.fmt`（每张卡必须有）
- [ ] Memes 分析：`.meme-analysis-4` / `.ma4-cols`（4列：视觉/情绪/角色/Remix），不是 `.game-analysis`（3列）
- [ ] Memes 评分：视觉/情绪/角色/Remix（不是 角色/玩法/广告/适配）
- [ ] 数据表 #1 行背景：`#1a0305`（深红），**不是** `#0a1a1a`（深绿）
- [ ] 数据表最高值颜色：`#ff4444`（红），**不用** `var(--accent)`（#25f4ee 青）
- [ ] 广告板块含 style override（`.ads-grid .ad-card { grid-template-columns: 240px 1fr; }`）

#### 3c. 板块内容检查

**总览**：
- [ ] 跨平台信号卡片：角色/玩法/广告三列，每列含平台标签 + 信号描述
- [ ] 信号强度矩阵表：5 平台 × 3 维度 + 本期最强关键词
- [ ] 导航卡片：5 个板块入口，点击可跳转

**热搜**：
- [ ] 10 条话题卡片，每条含 3 张**真实图片**（非占位色块）
- [ ] 图片区 220px 宽，三张 grid 均分
- [ ] 话题与游戏研发有关联性

**TikTok**：
- [ ] 10 条视频卡片，每条含 TikTok iframe 嵌入 + ⤢ 弹窗
- [ ] 数据总览表 + 趋势分析

**YouTube Shorts**：
- [ ] 10 条卡片（缩略图 + 链接 + ⤢ 弹窗 + 描述段落）
- [ ] 数据总览表（频道用 author-link 可点击）

**Memes**：
- [ ] 10 条卡片，每条含本地图片 + **4 列分析**（视觉/情绪/角色/Remix）

**广告**：
- [ ] 10 条卡片，视频直接播放（autoplay muted loop）+ ⤢ 弹窗放大
- [ ] 无 HTML 类型广告

#### 3d. 全局 + 附属文件检查

- [ ] NEW 标记有 localStorage 清除逻辑（`switchSection` 内 `badge.remove()` + 页面加载恢复）
- [ ] 侧栏「全部期刊」列出所有期数 + 当前期高亮
- [ ] Emoji 全部正常渲染（无 ?? 或乱码）
- [ ] share-card.html：填入真实内容（非占位符）
- [ ] index.html：新期 featured 卡片已添加
- [ ] index.html：coming-card 更新为 Vol.N+1
- [ ] index.html：footer「最新一期」链接指向本期
- [ ] 旧期刊（Vol.N-1, N-2）侧边栏已加入本期链接

---

### Phase 4 · 发布

```bash
cd /c/Users/gongjue/tiktok-reports

# ⚠️ 先检查所有需要提交的文件（包括旧期刊侧边栏修改！）
git status

# 显式 add 所有需要的文件
git add $DATE/ index.html
# ⚠️ 旧期刊侧边栏修改容易遗漏！
git add 2026-XX-XX/hub.html  # Vol.N-1
git add 2026-XX-XX/hub.html  # Vol.N-2（如有修改）

git commit -m "feat: Vol.00X · $DATE 欧美内容情报"
git push origin main

# ⚠️ 提交后再检查一次
git status  # 确认 working tree clean，无遗漏文件
```

> Vol.003 教训：`git add` 只加了新文件夹 + index.html，漏掉了旧期刊的侧边栏修改，导致二次 commit。

发布后地址：`https://sirengong.github.io/westradar/$DATE/hub.html`

---

## 三、分析框架 SOP

### 核心视角

> 不是「这个热点能做什么 UA 素材」，而是「这个热点能启发什么角色 / 玩法 / 广告」  
> 结论要具体到「西幻卡牌 + AI 角色验证」场景，不要泛用建议

### 标准三栏（热搜 / TikTok / YouTube / 广告）

```
🎭 角色设计         ⚔️ 玩法/活动          🎬 广告制作
▸ 角色原型          ▸ 核心机制转译        ▸ 开场钩子
▸ 外观关键词        ▸ 常驻/活动包装       ▸ 视频结构
▸ 人设/关系         ▸ 情感留存循环        ▸ 情绪基调
```

### ★ Memes 专用四栏（不是三栏！）

```
📐 视觉模板    😈 情绪结构    🎭 角色原型    🔄 Remix 机制
```
评分维度：视觉/情绪/角色/Remix（不是 角色/玩法/广告/适配）

### 评分 + 优先级标签

```
角色 X/5 | 玩法 X/5 | 广告 X/5 | 适配 X/5 | [A/B/C]
Memes: 视觉 X/5 | 情绪 X/5 | 角色 X/5 | Remix X/5 | [A/B/C]

A 直接可用 — 能马上形成方案
B 结构借鉴 — 值得抽取结构
C 观察储备 — 先记着
```

### 各板块分析优先级

| 板块 | 优先级顺序 |
|------|-----------|
| Google Trends | 玩法/活动 > 角色 > 广告 |
| TikTok | 角色 > 广告 > 玩法 |
| YouTube Shorts | 广告 > 玩法 > 角色 |
| Memes | 角色/情绪 > 玩法包装 > 广告 |
| 广告 | 广告钩子 > 玩法留存 > 角色 |

### 西幻卡牌专项关注点

**角色分析**：优先 AI 快速出图可验证的西幻视觉风格；「陪伴型受难 NPC」「反差搭档」等高传播公式

**玩法分析**：卡牌主玩法之外的前期钩子；模拟经营/日常化习惯设计（二线玩法方向）

**广告分析**：哪种素材适合 AI 低成本生成 + 快速验证；「广告是角色设计测试场」视角

---

## 四、广告视频采集规则

### 核心规则：必须当天采集

广大大热榜每日轮替，当天采集的广告次日可能已下榜。**元数据和视频必须在同一天完成**。

### 视频采集方案（单页打开）

```
Step 1  运行 fetch_guangdada.py → 拿到 10 条广告 + 缩略图
Step 2  运行 fetch_ads_with_video.py（对同一批广告）：
         点卡片 → 弹出「创意详情」modal
         → 点右上角「单页打开」→ 新 tab 打开独立详情页
         → 提取 <video src="...cdn.../xxx.mp4"> 直链
         → 下载到 ads_videos_gdd/
         → 输出 ads_videos.json
Step 3  运行 patch_ad_videos.py → hub.html 广告区 img 替换为 video + ⤢ 按钮
```

### 相关脚本

| 脚本 | 状态 | 路径 |
|------|------|------|
| `fetch_guangdada.py` | ✅ 可用 | `~/.claude/skills/ads-research/scripts/` |
| `fetch_ads_with_video.py` | ✅ 可用 | 同上 |
| `patch_ad_videos.py` | ✅ 可用 | `~/patch_ad_videos.py` |

---

## 五、格式速查表

### YouTube 指标（必须用这些 class）
```html
<div class="yt-meta">
  <div class="yt-stat"><span class="sv hot">42.6M</span><span class="sl">播放</span></div>
  <div class="yt-stat"><span class="sv">1.04M</span><span class="sl">点赞</span></div>
</div>
<div class="yt-tags">
  <span class="yt-tag hook">#钩子标签</span>
  <span class="yt-tag fmt">#格式标签</span>
</div>
```

### Memes 分析（4 列，不是 3 列）
```html
<div class="meme-analysis-4">
  <div class="ma4-cols">
    <div><div class="ma4-col-header">📐 视觉模板</div><ul class="ma4-list">...</ul></div>
    <div><div class="ma4-col-header">😈 情绪结构</div><ul class="ma4-list">...</ul></div>
    <div><div class="ma4-col-header">🎭 角色原型</div><ul class="ma4-list">...</ul></div>
    <div><div class="ma4-col-header">🔄 Remix 机制</div><ul class="ma4-list">...</ul></div>
  </div>
  <div class="ga-score-row">
    <span class="ga-score">视觉 <b>X</b>/5</span>
    <span class="ga-score">情绪 <b>X</b>/5</span>
    <span class="ga-score">角色 <b>X</b>/5</span>
    <span class="ga-score">Remix <b>X</b>/5</span>
    <span class="ga-label ga-label-a">A/B/C</span>
  </div>
</div>
```

### 数据表颜色（不可变更）
| 元素 | 颜色 | 错误示范 |
|------|------|---------|
| #1 行背景 | `#1a0305`（深红） | ~~#0a1a1a（深绿）~~ |
| 最高值 | `#ff4444`（红） | ~~var(--accent) #25f4ee（青）~~ |
| A 级标签 | `#4ade80`（绿） | — |
| B 级标签 | `#fbbf24`（黄） | — |
| C 级标签 | `#888`（灰） | — |

---

## 六、文件结构

```
tiktok-reports/                        ← GitHub Pages 仓库根
├── index.html                         ← 归档首页
├── PROJECT.md                         ← 本文件（操作手册）
│
├── 2026-04-16/                        ← Vol.003（最新）
│   ├── hub.html                       ← 集合界面
│   ├── share-card.html                ← 分享卡片
│   ├── trend_images/                  ← 热搜图
│   ├── yt_images/                     ← YouTube 缩略图
│   ├── meme_images/                   ← Meme 图片
│   ├── ads_images_gdd/                ← 广告缩略图
│   └── ads_videos_gdd/                ← 广告视频
│
├── 2026-04-09/                        ← Vol.002
└── 2026-04-01/                        ← Vol.001

~/.claude/skills/                      ← 采集脚本（不进 Git）
├── westradar/scripts/collect_all.sh
├── trends-research/
├── tiktok-research/
├── youtube-research/
├── ads-research/scripts/
├── video-content-analyzer/
└── web-access/
```

---

## 七、API Keys

```bash
APIFY_TOKEN=apify_api_xxxx         # TikTok 采集（备用）
YOUTUBE_API_KEY=AIzaxxxx           # YouTube Data API v3
GEMINI_API_KEY=AIzaxxxx            # AI 视频分析（Gemini）

# 广大大：无需 API，用 Chrome CDP（保持浏览器登录即可）
```

---

## 八、已知限制

### 热搜图片高度无法自适应
- 现状：`height: 240px` + `align-items: start` = 图片固定高度
- 尝试过 `height: 100%` + stretch → 文字短的卡片被图片撑高
- 尝试过 absolute 定位 → 布局崩溃
- **结论**：保持固定 240px，接受此限制。
