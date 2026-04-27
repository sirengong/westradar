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
> ⚠️ **历史去重**：补充话题前 grep 前 3 期 hub.html，已讲过的话题（如 Coachella/Euphoria S3/The Boys/MJ biopic）必须替换。
> ⚠️ **图片下载用 Bing 不用 Google**：Google `tbm=isch` 反爬 + 懒加载抓不到图（Vol.004 验证 0/30 成功）；Bing `a.iusc[m]` 属性内 JSON `murl` 字段是真实 URL（30/30 成功）。脚本参考 `2026-04-23/_fetch_trend_images_bing.py`

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

> ⚠️ **caption 信息严重不足时禁止凭账号名编造**（Vol.004 教训：TikTok #3 caption 仅 `#fyp`，账号名 `power.scene.edits` 字面像"震撼场景剪辑"，subagent 编造了"影视/角色高燃混剪"，但实际视频是真人日常 + meta 钩子）。蓝图需明确标注"内容不可判断"或降级 B/C，**严禁靠账号名脑补内容**。

> ⚠️ **subagent 容易卡死**（流式看门狗 600s 无进度即超时）。Vol.004 中 ads 蓝图 + youtube fragment 各有一次 stall。**重启时用精简 prompt**：限制 Read 文件范围、明确"禁止读其他板块/PROJECT.md 全文/其他无关文件"、要求 200 字内返回。重启后通常秒过。

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

拼接后主对话改 5 处：
1. `<header>` 里的 Vol 编号 + 日期
2. sidebar `sidebar-group-label` Vol 编号 + 日期
3. sidebar 「全部期刊」加本期 + 旧期标识降级
4. 旧期 hub.html 侧栏也加本期链接（防 Phase 4 漏 commit）
5. **localStorage key `wrXXX_visited` → `wr{当期}_visited`**（3 处全局替换）。Vol.004 教训：key 写死会读到上期访问记录、把本期所有 NEW 标签清掉。
   ```bash
   # Vol.005 拼接时跑：
   sed -i 's/wr004_visited/wr005_visited/g' hub.html
   grep -c "wr005_visited" hub.html  # 期望输出 3
   ```

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

- [ ] NEW 标记 localStorage key 是 `wr{当期}_visited`（不是上期残留的 wr{N-1}_visited，避免 NEW 全清 bug）
- [ ] 侧栏「全部期刊」列出所有期数 + 当前期高亮
- [ ] Emoji 全部正常渲染（无 ?? 或乱码）
- [ ] share-card.html：填入真实内容（非占位符）
- [ ] index.html：新期 featured 卡片已添加
- [ ] index.html：coming-card 更新为 Vol.N+1
- [ ] index.html：footer「最新一期」链接指向本期
- [ ] 旧期刊（Vol.N-1, N-2）侧边栏已加入本期链接

#### 3e. ★ 定位 + 文案 + 留白机制检查（2026-04-30 起强制）

> Vol.004 教训：subagent 写完容易出现 110 处指令式/绝对化文案 + 14 张卡硬编无关联维度。本节是发布前自动化扫描清单。

**自动化校验脚本**（每期 commit 前跑一次）：
```bash
HUB=$REPORT_DIR/hub.html

echo "=== A. 文案语气禁用词扫描 ==="
grep -nE '必须|立刻|严禁|硬规则|现成模板|碾压|最强判断|DRD|务必|一定要|王炸|完胜|必胜|终极' $HUB | grep -v '^\s*//' | head -10
# 期望: ≤ 5 处保留语境(注释/反向参考)

grep -nE '直接套用|直接抄|直接复用|永久流量公式|最高优先级|最优起点|最优|最强|顶级|至高|史上|永远' $HUB | grep -v '^\s*//' | head -10
# 期望: ≤ 20 处保留语境(政治警告/修辞/游戏内文案)

echo "=== B. 数字建议禁用扫描 ==="
grep -nE '一周(内)?\s*(可|能)?\s*(出|跑|完成|生成|验证)\s*\d+|每周\s*\d+|可\s*(批量)?\s*(产|跑|出|验证|生成|测试)\s*\d+' $HUB | head -5
# 期望: 0 处

echo "=== C. A/B/C 标签命名校验 ==="
echo "  A 直接可用 (旧, 不应再有): $(grep -c 'A 直接可用' $HUB)  期望 0"
echo "  A 契合度高:               $(grep -c 'A 契合度高' $HUB)  期望 ≥ 1"
echo "  B 结构借鉴:               $(grep -c 'B 结构借鉴' $HUB)"
echo "  C 观察储备:               $(grep -c 'C 观察储备' $HUB)"

echo "=== D. 留白机制检查 ==="
GA_EMPTY=$(grep -c 'class="ga-col ga-col-empty"' $HUB)
MA4_EMPTY=$(grep -c 'class="ma4-col-empty"' $HUB)
TOTAL_EMPTY=$((GA_EMPTY + MA4_EMPTY))
echo "  ga-col-empty 数: $GA_EMPTY"
echo "  ma4-col-empty 数: $MA4_EMPTY"
echo "  合计留白栏: $TOTAL_EMPTY (50 张卡 × 3-4 栏 = 150-200 栏总数)"
# 留白率监控: 健康区间 < 30% (即 < 60 栏)

echo "=== E. Overview v2 结构校验 ==="
echo "  v2-judg 卡: $(grep -c 'class=\"v2-judg ' $HUB)  期望 3"
echo "  v2-judg-img-card: $(grep -c '<div class=\"v2-judg-img-card\"' $HUB)  期望 9"
echo "  v2-jump 跳转链接: $(grep -c 'class=\"v2-jump\"' $HUB)  期望 ≥ 9"
# 不应再有 v1 的 9 卡 ov-syn-card 形式
echo "  v1 ov-syn-card (应为 0): $(grep -c '<div class=\"ov-syn-card' $HUB)"

echo "=== F. 卡 id 命名校验 (跳转依赖) ==="
echo "  tt-N: $(grep -cE 'id=\"tt-[0-9]+\"' $HUB)  期望 10"
echo "  yt-N: $(grep -cE 'id=\"yt-[0-9]+\"' $HUB)  期望 10"
echo "  meme-N: $(grep -cE 'id=\"meme-[0-9]+\"' $HUB)  期望 10"
echo "  trend-N: $(grep -cE 'id=\"trend-[0-9]+\"' $HUB)  期望 10"
echo "  ad-N: $(grep -cE 'id=\"ad-[0-9]+\"' $HUB)  期望 10"

echo "=== G. JS 函数完整性 ==="
echo "  function openVbox: $(grep -c 'function openVbox' $HUB)  期望 1"
echo "  function jumpTo:   $(grep -c 'function jumpTo' $HUB)  期望 1"
echo "  function openLightbox: $(grep -c 'function openLightbox' $HUB)  期望 1"
```

**人工核对清单**（脚本无法自动判断的）：

- [ ] **数据总览表评级与卡片端 `ga-label` 同步**：全留白卡在表中评级必须是 C（颜色 `#888`）。手动检查 Memes 数据总览表（`grep -A 2 'rank-num">3<' hub.html` 等）
- [ ] **留白卡的 `ga-label` 是 C 观察储备**：扫描全留白卡（`ga-col-empty` × 3 / `ma4-col-empty` × 4 出现的卡），其 ga-label 必须 `ga-label-c`
- [ ] **conclusion-box 引用留白卡用反向措辞**：grep 各 conclusion 引用的留白卡编号，附近必须有「已留白 / 仅作 / 不输出借鉴 / ⚠️ 行业现象记录」之类反向词，不能当借鉴模板讨论
- [ ] **留白文案诚实简短**：每条 ga-empty-note / ma4-empty-note ≤ 25 字，明确说"X 维度关联较弱"原因
- [ ] **留白率 < 30%**：合计留白栏 / 总栏数 < 30%（Vol.004 实测 28%）
- [ ] **caption 信息严重不足的卡（如仅 #fyp）已降级**：检查 TikTok 中是否有 caption ≤ 3 个 hashtag 的卡仍被评为 A 级（应降为 B/C，避免重蹈 Vol.004 #3 硬编）

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

### 视频采集方案（modal 直抓 · Vol.004 起，2026-04-23 验证 10/10 全成功）

> ⚠️ **「单页打开」按钮在 Vol.004 已失效**（点击不弹新 tab）。改用 modal 直抓 video src 方案。

```
Step 1  运行 fetch_guangdada.py → 拿到 10 条广告 + 元数据
         （注：thumbUrl 当前 DOM 抓不到，缩略图全空，但视频可补）
Step 2  运行 _fetch_ads_video_simple.py（参考 Vol.004 留档脚本）：
         click 卡片 → 等 modal 弹出 → 直接读 [role=dialog] video src
         → 下载到 ads_videos_gdd/
         → ESC 关 modal → 下一个
         → 输出 ads_videos.json
Step 3  写 fragment 时直接用 ads_videos_gdd/{rank:02d}_{slug}.mp4 + autoplay muted loop
```

### 相关脚本

| 脚本 | 状态 | 路径 |
|------|------|------|
| `fetch_guangdada.py` | ✅ 可用（仅元数据，thumbUrl 失效） | `~/.claude/skills/ads-research/scripts/` |
| `fetch_ads_with_video.py` | ❌ 失效（单页打开按钮 click 不响应） | 同上（待修） |
| `_fetch_ads_video_simple.py` | ✅ Vol.004 验证可用 | `~/tiktok-reports/2026-04-23/` 留档 |
| `patch_ad_videos.py` | 未使用（Vol.004 起 fragment 直引用视频，不需 patch） | `~/patch_ad_videos.py` |

### 视频抓取 JS 核心（modal 弹出后）

```js
(function(){
  var dlg = document.querySelector('[role=dialog]');
  if(!dlg) return JSON.stringify({state:'no_dlg'});
  var v = dlg.querySelector('video');
  var src = v.src || (v.querySelector('source') && v.querySelector('source').src) || '';
  return JSON.stringify({state:'ok', src:src, poster:v.poster||''});
})()
```

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

### 广大大缩略图 thumbUrl 失效（Vol.004 起）
- `fetch_guangdada.py` 抓的 `thumbUrl` / `appIconUrl` 均为空（DOM 结构变化）
- 影响仅限 hub.html 加载时的占位图，不影响视频展示
- **暂解**：广告卡直接用视频 autoplay 替代缩略图
- **彻底修复**：待重写 fetch_guangdada.py 的 extract_ads selector

---

## 九、版本变更日志

### Vol.004 · 2026-04-23

**新增/修复**
- ✅ 广告视频采集换 modal 直抓方案（旧"单页打开"按钮失效，新方案 10/10 全成功）
- ✅ Trends 图片下载换 Bing Images（旧 Google Images 0/30，新 Bing 30/30）
- ✅ localStorage key 升级为 `wr004_visited`（修复 NEW 标签残留 bug）
- ✅ Memes lightbox 兼容 DOM 元素入参（onclick="openLightbox(this)" 旧函数签名只收 string）
- ✅ Trends 强化历史去重（grep 前 3 期 hub.html 排除已讲过话题）
- ✅ subagent stall 处理流程：精简 prompt 重启
- ✅ Met Gala 红毯图裁剪 + object-position: top（避开胸部正中焦点，share-card 友好化）

**Overview 板块 v2 重构**（2026-04-23 老板反馈后落地）
- ❌ v1 (9 卡 ov-syn-card) 弃用：信息密度过高、缺判断、像信息汇总
- ✅ v2 (3 卡 v2-judg) 上线：聚焦本期跨源印证最强 3 个观察，每卡含图片三连 + 跳转链接
- ✅ 文案语气从「指令式」改「参考式」：禁用「必须 / 立刻 / 严禁 / 硬规则 / 现成模板 / 碾压」等词
- ✅ 平台定位：情报雷达（information broker），不是策略指令交付
- ✅ 关键词跳转：50 张数据卡批量加 id (`tt/yt/meme/trend/ad-N`)，jumpTo() 函数支持切板块 + scrollIntoView + 1.8s 红框高亮
- ✅ 模板沉淀：`templates/overview_blueprint_template.md` 升级到 v2，5 板块模板加 "卡 id 命名规范"

**全板块文案清洗 + 数字建议禁用 + A 标签改名**（2026-04-30 落地）
- ❌ Vol.004 hub.html 5 板块 + Overview 共 110 处指令式/绝对化文案残留（subagent 写完没扫干净）
- ✅ 6 subagent 并行 + 主对话 hotfix 17 处 + 数字建议 4 处，共净改 95 处，残留 19 处合理保留（政治警告/修辞描述/游戏内文案引用）
- ✅ A 级标签从 "A 直接可用" 改为 "A 契合度高"（33 处）—— "直接可用" 听起来像指令，"契合度高" 用程度词描述、主动权交给读者
- ✅ 数字建议禁用（4 处）—— "一周可出 50+ 草图" 这种具体产出量被禁，因为出多少图不是 westradar 说了算
- ✅ 模板再沉淀：
  - `templates/overview_blueprint_template.md` 第 1 节"关于文案语气" 大幅扩展（禁用词分硬指令/绝对化两类 + verb 替换表 + 数字建议禁用 + A/B/C 标签命名）
  - 5 板块模板（trends/tiktok/youtube/memes/ads）加共用「🎯 文案语气约束」段落，指向 overview 模板第 1 节
  - 第 12 节校验脚本扩展：增加全 hub.html 文案语气扫描 + 数字建议扫描 + A/B/C 标签命名校验

**留白机制 + 数据总览同步 + conclusion 引用规则**（2026-04-30 落地）
- ❌ Vol.004 三栏强制分析导致 meta / 政治 / 合规类内容被硬编（如 TikTok #3 BGM hunt meta 被编成"影视/角色高燃混剪"，Trends #2 Trump-Iran 三栏全是强行套用的"和谈使者""停火协议"）
- ✅ 引入「诚实留白」机制：14 张卡（28%）应用，72% 仍保留实质分析，不影响内容密度
  - 6 张全留白：trend-2 / meme-3/4/9 / yt-10 / ad-1（政治、民生、博彩、合规、敏感）
  - 8 张部分留白：tt-3 / tt-9 / yt-6 / trend-7 / trend-10 / ad-3 / ad-6 / ad-8（单维度无关联）
- ✅ 留白栏视觉设计：
  - CSS class：`ga-col-empty` / `ga-empty-note`（3 列板块）+ `ma4-col-empty` / `ma4-empty-note`（4 列 memes）
  - 留白文字色 `#aaa`（同正常 ga-list）+ italic 区分；标题 92% / 评分 88% 透明度
  - 评分项用 `角色 —` 替代 0/1 数字（避免低分暗示）
- ✅ 全留白卡 = 强制 `ga-label-c` C 观察储备；部分留白卡维持原评级
- ✅ 数据总览表评级同步：Memes 表 #4 评级 B → C，与卡片 ga-label 一致
- ✅ 3 个 conclusion-box 重写引用语境（Memes 社媒/UGC / Trends 广告 / Ads 广告+角色）：
  - 留白卡引用必须用反向措辞（已留白 / 仅作 / 不输出借鉴 / ⚠️ 行业现象记录）
  - 不再当借鉴模板讨论
- ✅ 模板沉淀：6 个模板加「🕊️ 留白机制」段落（5 板块简版指向 overview，overview 含完整 CSS 清单 + 触发场景表 + 文案风格 + conclusion 引用规则）

**已知问题**
- ⚠️ `fetch_ads_with_video.py` 单页打开方案失效（待修脚本，临时方案见第四章）
- ⚠️ `fetch_guangdada.py` thumbUrl 抓不到（仅占位图受影响）
- ⚠️ subagent 容易在 600s 无进度后被流式看门狗杀掉
- ⚠️ Vol.004 留白率 28%（健康但偏高），根因在采集层面引入了过多无关内容（r/memes 政治化、Trends 体育/政治、博彩广告等）

**经验教训**
- caption 信息严重不足时（如仅 `#fyp`）禁止靠账号名脑补内容；必须降级 B/C 或显式标"内容不可判断"
- subagent 启动 prompt 必须明确限制 Read 文件范围 + 返回字数上限，否则容易 stall
- 数据源跨期重复是常态（Coachella/Euphoria/The Boys 都被前 3 期讲过）；Trends 选题必须 grep 历史排查
- **Overview 不是分析的搬运，是判断的输出**——信息密度高 ≠ 价值高，3 个清晰判断 > 9 个堆叠信号
- **平台定位决定语气**——情报雷达不应使用指令式语言，要让读者自己拿判断，不替他做决定
- **情报雷达定位不仅是 Overview，是全板块系统贯彻**——5 数据板块 subagent 写卡片时也容易掉回指令式语言；模板里的禁用词约束必须 5 板块都加（已在 2026-04-30 沉淀）
- **数字建议是绝对化的隐形入口**——「一周可出 50+ 草图」这种比「必须立刻执行」更隐蔽，但同样越界；模板已加专门禁用规则
- **标签命名需要"程度词"而非"动作词"**——A 直接可用/可以参考/借鉴 都是动作词暗示读者怎么做；A 契合度高/B 结构借鉴/C 观察储备 一档比一档弱，靠程度对比传递优先级，主动权在读者
- **三栏强制分析是硬编的根因**——给 subagent 一个"我无话可说"的合法出口（留白）比硬编 3 段话更尊重读者；留白率 < 30% 是健康区间
- **conclusion 与卡片必须语境一致**——留白卡若被 conclusion 引用必须用反向措辞，不能一边卡片留白一边 conclusion 又当借鉴模板讨论

---

## 十、下期 Vol.005 待办（2026-04-30 列出）

### 🎯 Vol.005 流水线跑前必读

1. **观察留白率变化**
   - 本期 28%，目标降到 < 20%（前置过滤生效后）
   - 跑完后扫一遍 `ga-col-empty` 数量，对比上期

2. **观察老板对留白机制 + 减"硬编"的二次反馈**
   - 留白栏视觉是否还想再调（当前 #aaa + italic 80% 透明度）
   - "情绪信号观察" 类反向措辞是否需要更明确

### 🛠️ 采集层前置过滤（如果 Vol.005 留白率仍 > 25% 就启用）

之前用户决策"先不动，下期跑起来看看再决定"。如果 Vol.005 留白率仍偏高，建议沉淀以下规则：

- **Reddit subreddit 过滤**：`r/memes` 改 `r/dankmemes` + `r/wholesomememes`（去政治化）
- **Trends 关键词黑名单**：Trump / Iran / 政治人物名 / 国际地缘冲突
- **Ads 品类黑名单**：Casino / Poker / 博彩 / 赌博 / 加密货币 / 烟酒
- **YouTube 内容预筛**：暴力 / 合规风险 / 极端政治
- **TikTok caption 信息量门槛**：caption 仅 `#fyp` 等无内容标签的视频，alt 文本也无信息时，主动降级为 C 观察储备（避免再发生 Vol.004 #3 的硬编事故）

### 📊 校验脚本扩展（在第 12 节继续加）

- ✅ 已有：禁用词扫描 / 数字建议扫描 / A/B/C 标签命名校验
- 🆕 待加：
  - 留白率监控：`grep -c "ga-col-empty\|ma4-col-empty" $HUB`，期望 ≤ 30 / 50（即 ≤ 60%）
  - 数据总览表评级同步检查：脚本对比卡片 `ga-label` 与表中评级是否一致
  - conclusion 引用留白卡的反向措辞检查：扫到留白卡编号时，附近必须出现「已留白 / 仅作 / 不输出借鉴」等反向词

### 🚧 长期优化（不限期）

- `fetch_ads_with_video.py` 单页打开方案失效问题待修复（当前用 modal 直抓 video src 临时方案）
- `fetch_guangdada.py` thumbUrl 抓不到问题待修复（当前广告板块靠 video 兜底）
- 下次发现某板块的数据总览表新加了评级列，要同步加进留白机制的同步检查

---

### Vol.003 · 2026-04-16

- 修复 openVbox JS 函数缺失（被 Vol.002 → Vol.003 重构误删）
- 引入「蓝图 + subagent」流水线（替代主对话亲自写 hub.html）
- 6 个板块模板沉淀到 `templates/`
