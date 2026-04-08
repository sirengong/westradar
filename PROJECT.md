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
| 🎵 TikTok 热门 | TikTok 全平台热门（默认） | Apify 搜索模式 | `APIFY_TOKEN` |
| ▶️ YouTube Shorts | YouTube 美区热门（默认） | YouTube Data API 搜索 | `YOUTUBE_API_KEY` |
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
DATE="2026-04-08"   # 修改为当周日期（每周二）
REPORT_DIR="/c/Users/gongjue/tiktok-reports/$DATE"
mkdir -p "$REPORT_DIR/trend_images" "$REPORT_DIR/yt_images" \
         "$REPORT_DIR/meme_images" "$REPORT_DIR/ads_images_gdd" \
         "$REPORT_DIR/ads_videos_gdd"
```

**Step 2 — Google Trends**
```bash
python3 ~/.claude/skills/trends-research/scripts/fetch_trends.py \
  --output "$REPORT_DIR/trends_raw.json" --top-n 15 --timeframe "now 7-d"
# 之后 CDP 浏览器为每个话题下载 3 张图片到 trend_images/
```

**Step 3 — TikTok 热门（默认全平台 trending）**
```bash
python3 ~/.claude/skills/tiktok-research/scripts/fetch_tiktok.py \
  --days 7 --limit 50 --output "$REPORT_DIR/tiktok_raw.json"
# 可选：--search-queries "cosplay" "fantasy"  定向搜索
# 可选：--hashtags characterdesign oc          按话题标签
# 可选：--usernames @MrBeast @tiktok          回退到指定账号
python3 ~/.claude/skills/tiktok-research/scripts/analyze_posts.py \
  --input "$REPORT_DIR/tiktok_raw.json" \
  --output "$REPORT_DIR/tiktok_outliers.json" --threshold 2.0
```

**Step 4 — YouTube Shorts（默认美区 trending）**
```bash
python3 ~/.claude/skills/youtube-research/scripts/fetch_youtube.py \
  --days 7 --limit 50 --output "$REPORT_DIR/yt_raw.json"
# 可选：--search-query "gaming"                定向搜索
# 可选：--category 20                          按分类（20=Gaming, 24=Entertainment）
# 可选：--handles @MrBeast                     回退到指定频道
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
```bash
# 6a. 抓取元数据 + 缩略图
python3 ~/.claude/skills/ads-research/scripts/fetch_guangdada.py \
  --output "$REPORT_DIR/ads_raw.json" \
  --images-dir "$REPORT_DIR/ads_images_gdd" \
  --top 10 --page display-ads

# 6b. 抓取视频（单页打开方案）
python3 ~/.claude/skills/ads-research/scripts/fetch_ads_with_video.py \
  --output "$REPORT_DIR/ads_videos.json" \
  --videos-dir "$REPORT_DIR/ads_videos_gdd"
```

> ⚠️ **广告视频必须当天抓**：广大大热榜每日更新，当天不抓次日就找不到原始素材了

---

### Phase 2 · AI 分析 + HTML 生成（约 25 分钟，Claude 执行）

告诉 Claude：**「生成本周报告，日期 2026-04-08」**

Claude 将自动：
1. 读取所有 JSON 数据文件
2. 按 SOP 框架逐条分析（三栏 + 评分）
3. 生成 `hub.html`（含 5 大板块 + 总览）
4. 广告板块自动运行 `patch_ad_videos.py` 嵌入视频
5. 生成 `share-card.html`（分享卡片）
6. 更新 `index.html` 归档首页

---

### Phase 3 · 人工审核（发布前必做）

> ⚠️ **Claude 必须在此阶段暂停，等待用户确认后才能进行 Phase 4 推送。**
> HTML 生成完毕后，Claude 主动告知用户"报告已生成，请审核后告诉我是否推送"，不得自行执行 git push。

检查清单：
- [ ] 总览板块：跨平台信号是否准确
- [ ] 每板块结论框：方向是否与西幻卡牌游戏相关
- [ ] 广告板块：视频是否正常播放，⤢ 弹窗是否正常
- [ ] TikTok / YouTube：⤢ 弹窗是否正常
- [ ] A 级洞察数量是否合理（通常 10-18 条）
- [ ] 分享卡片图片显示是否正常

如需调整，告诉 Claude 具体问题即可。调整完毕、确认无误后，再明确说「推送」或「发布」，Claude 才执行 Phase 4。

---

### Phase 4 · 发布（约 1 分钟）

```bash
cd /c/Users/gongjue/tiktok-reports
git add $DATE/ index.html
git commit -m "feat: Vol.00X · $DATE 欧美内容情报"
git push origin main
```

发布后地址：`https://sirengong.github.io/westradar/$DATE/hub.html`

---

## 三、分析框架 SOP

### 核心视角

> 不是「这个热点能做什么 UA 素材」，而是「这个热点能启发什么角色 / 玩法 / 广告」  
> 结论要具体到「西幻卡牌 + AI 角色验证」场景，不要泛用建议

### 标准三栏（热搜 / TikTok / YouTube）

```
🎭 角色设计         ⚔️ 玩法/活动          🎬 广告制作
▸ 角色原型          ▸ 核心机制转译        ▸ 开场钩子
▸ 外观关键词        ▸ 常驻/活动包装       ▸ 视频结构
▸ 人设/关系         ▸ 情感留存循环        ▸ 情绪基调
```

### Memes 专用四栏

```
📐 视觉模板    😈 情绪结构    🎭 角色原型    🔄 Remix 机制
```

### 评分 + 优先级标签

```
角色 X/5 | 玩法 X/5 | 广告 X/5 | 适配 X/5 | [A/B/C]

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

广大大热榜每日轮替，当天采集的广告次日可能已下榜。**6a（元数据）和 6b（视频）必须在同一天完成**。

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

### 相关脚本状态

| 脚本 | 状态 | 路径 |
|------|------|------|
| `fetch_guangdada.py` | ✅ 可用 | `~/.claude/skills/ads-research/scripts/` |
| `fetch_ads_with_video.py` | ✅ 可用 | 同上 |
| `patch_ad_videos.py` | ✅ 可用 | `~/patch_ad_videos.py` |

---

## 五、视频弹窗系统

### 当前状态（Vol.001 起生效）

| 内容 | 状态 | 说明 |
|------|------|------|
| TikTok 10 条 | ✅ | 每条右下角 `⤢` 按钮，9:16 全屏弹窗 |
| YouTube 10 条 | ✅ | 同上，弹窗自动 autoplay |
| 广告 10 条 | 🔲 | Vol.002 接入（视频文件到位后自动生效） |
| Memes / 热搜图片 | ✅ | 原有图片灯箱（点击放大） |

### 使用方式

- 点 `⤢` → 9:16 竖屏弹窗播放
- 关闭：ESC / 点击遮罩 / 切换左侧板块（均自动停止播放）

---

## 六、文件结构

```
tiktok-reports/                        ← GitHub Pages 仓库根
├── index.html                         ← 归档首页
├── PROJECT.md                         ← 本文件（操作手册）
│
├── 2026-04-01/                        ← Vol.001
│   ├── hub.html                       ← 集合界面
│   ├── share-card.html                ← 分享卡片
│   ├── trend_images/                  ← 热搜图
│   ├── yt_images/                     ← YouTube 缩略图
│   ├── meme_images/                   ← Meme 图片
│   ├── ads_images_gdd/                ← 广告缩略图
│   └── ads_videos_gdd/                ← 广告视频
│
└── 2026-04-08/                        ← Vol.002（下一期）

~/.claude/skills/                      ← 采集脚本（不进 Git）
├── westradar/scripts/collect_all.sh
├── trends-research/
├── tiktok-research/
├── youtube-research/
├── ads-research/scripts/
│   ├── fetch_guangdada.py             ✅
│   └── fetch_ads_with_video.py        ✅
├── video-content-analyzer/
└── web-access/
```

---

## 七、API Keys

```bash
APIFY_TOKEN=apify_api_xxxx         # TikTok 采集
YOUTUBE_API_KEY=AIzaxxxx           # YouTube Data API v3
GEMINI_API_KEY=AIzaxxxx            # AI 视频分析（Gemini）

# 广大大：无需 API，用 Chrome CDP（保持浏览器登录即可）
```

---

## 八、发布后检查

```
✓ hub.html 正常打开，5 个板块切换正常
✓ TikTok / YouTube ⤢ 弹窗正常播放
✓ 广告视频（Vol.002+）正常播放
✓ 热搜 / Meme 图片点击放大正常
✓ share-card.html 截图 → 发社区
✓ index.html 新期卡片显示正常
✓ GitHub Pages 新 URL 可访问
```
