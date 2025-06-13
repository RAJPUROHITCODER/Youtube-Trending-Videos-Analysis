Basic Descriptive Insights

#1 count of videos by language
SELECT language,count(*) from trending_videos GROUP by `language` order by count(*) desc

# 2) Total likes,view,comments,counts per category
SELECT category,sum(`view`) "total views",sum(`like`) as "total likes" ,sum(comments) as "total comments",count(*) as "count" from trending_videos GROUP by category order by sum(`view`) DESC

# 3) percentage of videos by category
SELECT category,count(*)*100/(SELECT count(*) from trending_videos) as "percentage" from trending_videos GROUP by category ORDER by percentage

# 4) Top most viewed videos
SELECT channel_title,title,`view` from trending_videos ORDER by `view` DESC limit 10 

# 5) Average views per video and per category
SELECT AVG(`view`) as "avg views" from trending_videos ;
SELECT category,round(AVG(`view`)) as "avg_views" from trending_videos GROUP by category order by AVG(`view`) DESC

# 6) on which day most video uploaded which are trending
SELECT `utc_date` ,count(*) as "total_number_of_video" from trending_videos GROUP by `utc_date` ORDER by total_number_of_video DESC

# 7) Get video uploaded in last 3 days
SELECT * from trending_videos where totaldays_since_uploaded<=3

Performance by Channel
# 8) TOp % channel by total likes
SELECT channel_title,SUM(`view`) as "total view" ,SUM(`like`) as 'total likes' from trending_videos
GROUP by channel_title order by sum(`like`) DESC limit 5

Channels with the most trending videos
# 9) which channel have maximum trending video
SELECT channel_title,count(*) from trending_videos GROUP BY channel_title order by count(*) DESC limit 5

Top channels globally (aggregated)
# 10) top 3 most famous youtube globally
SELECT channel_title ,count(*) as "c" from (SELECT country, channel_title ,`views` from(SELECT country,channel_title,`view` as "views" ,rank() over(PARTITION by country ORDER by avg(`view`) DESC) as rn FROM youtube_trending_videos  GROUP by country,channel_title) as t where t.rn=1) r GROUP by r.channel_title order by c desc limit 3

Performance by Country
# 11) Top 3 liked videos per country
SELECT * from (SELECT country,title,`like` ,rank() over(PARTITION by country ORDER by `like` DESC) as rn from youtube_trending_videos ) as t where t.rn<=3

# 12) Most active channel in each country(highest number of video)
SELECT country channel_title ,c  from(SELECT country,channel_title,count(*) as "c" ,rank() over(PARTITION by country ORDER by count(*) DESC) as rn FROM youtube_trending_videos  GROUP by country,channel_title) as t where t.rn=1

# 13) channel which got highest view per country
SELECT country, channel_title ,`views` from(SELECT country,channel_title,`view` as "views" ,rank() over(PARTITION by country ORDER by avg(`view`) DESC) as rn FROM youtube_trending_videos  GROUP by country,channel_title) as t where t.rn=1 

Engagement Insights
# 14) video with Highest like-to-view ratio
SELECT  channel_title,title,(`like`/`view`) as "like to view ratio" FROM trending_videos order by `like to view ratio` desc LIMIT 3

# 15) identify videos with higher than average views in thier category
SELECT * from (SELECT category,title,`view` ,AVG(`view`) over(PARTITION by category ) as Average from trending_videos) as t where t.view>t.average;
SELECT * from trending_videos t where view > (SELECT Avg(`view`) from trending_videos where category=t.category)

Time-based Analysis
# 16) trend of videos uploads over time (week)
SELECT str_to_date(concat(year(`utc_date`),' ',week(`utc_date`,1),' Sunday'),'%X %V %W') as week,count(*) as "number of videos" FROM trending_videos GROUP by week

# 17) which hour of the day ses the most video uploads(local time)
SELECT hour(local_time) as "uploaded_hour",count(*) as "total_uploads" from trending_videos  GROUP by uploaded_hour order by total_uploads DESC

Category-Based Deep Dives
# 18) Top video per category
SELECT category , title,`view`from (SELECT category,title,`view`,rank() over(PARTITION by category ORDER by `view` DESC ) as rn from trending_videos) as t where t.rn=1

# 19) video with the longest duration in each category
SELECT * from (SELECT  category ,title ,duration ,rank() over(PARTITION by category ORDER by duration DESC) as rn from trending_videos GROUP by category,title) t where t.rn=1

# 20) Average duration of videos by category
SELECT category,round(AVG(duration),2) as "avg_duration" from trending_videos GROUP by category order by avg_duration desc

Language-Centric Trends
# 21) which language has most views
SELECT `language`,sum(`view`) as "total_views",count(*) as "total video" from trending_videos where `language`!="Unknown" group by `language` order by total_views DESC;

# 22) Most common video language by country
SELECT * from (SELECT country ,`language`,count(*),rank() over(PARTITION by country order by count(*) desc) as rn from youtube_trending_videos where `language` !="Unknown"   GROUP by country,`language`)t WHERE t.rn=1

