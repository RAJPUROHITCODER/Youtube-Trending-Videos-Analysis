# Youtube-Trending-Videos-Analysis
# 📊 YouTube Trending Videos – End‑to‑End Data Project

In this  project first I pulls the **latest‑trending YouTube videos** for every available country, cleans the data, stores it in SQL, and visualises insights in a **Power BI dashboard**.

## 1. Data Gathering  🚀

* Language, country and category look‑up tables are fetched first  
  (`/i18nRegions`, `/i18nLanguages`, `/videoCategories`).
* For **every country** we call  
  `/videos?chart=mostPopular&maxResults=50`  
  and collect:
  - video id, title, channel
  - views, likes, comments
  - duration, language, category
  - upload date‑time & country ISO code
* All results are saved to **`youtube_Trending_videos.xlsx`**.

> **File:** `data_gathering.py`

---

## 2. Data Cleaning  🧹

* Convert ISO 8601 durations → **minutes**  
* Split upload timestamp into `utc_date` / `utc_time`
* Fill missing language with `"Unknown"`
* Rename columns for clarity (`category_id` → `category`, etc.)
* Export the clean table to SQL (MySQL) as **`trending_videos`**.

> **File:** `data_cleaning.py`

---

## 3. Insights & Dashboard  📈

### SQL Analysis (sample queries)

| Theme | Query examples |
|-------|----------------|
| **Descriptive** | Top videos, % by category, daily upload count |
| **Channel** | Most‑liked channels, channels with most trending videos |
| **Country / Language** | Top 3 videos per country, languages with most views |
| **Engagement** | Like‑to‑view ratio, videos above category average |
| **Time** | Uploads by week, busiest upload hour |
| **Duration** | Avg length by category, longest video per category |

> **File:** `queries.sql`

### Power BI Dashboard (3 pages)

| Page | Main visuals |
|------|--------------|
| **A. Global Overview** | KPI cards, uploads over time, top languages & categories |
| **B. Category & Channel Insights** | Most‑viewed video per category, views vs likes scatter, top channels |
| **C. Country & Language Trends** | Map of views by category, top videos per country, popular languages |

