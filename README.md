# 🚀 Spotify Data Analytics | Advanced SQL & Query Optimization

![image](https://github.com/user-attachments/assets/2ff26b76-1cfb-49c5-bfd8-7e18451f4603)

## 📝 Overview  
This project focuses on **analyzing and optimizing a Spotify dataset** using **PostgreSQL**. It involves an **end-to-end process** of normalizing a **denormalized dataset**, writing **advanced SQL queries**, and applying **query performance optimization techniques**.  

Key objectives include:  
✅ **Exploratory Data Analysis (EDA)** using SQL queries  
✅ **Aggregations, Joins, and Window Functions** for insights  
✅ **Query Optimization** using Indexing and Execution Plans  
✅ **Performance Improvement using EXPLAIN ANALYZE**  

## 🛠 Technologies Used  

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791.svg?style=for-the-badge&logo=postgresql&logoColor=white)  ![SQL](https://img.shields.io/badge/SQL-%23007ACC.svg?style=for-the-badge&logo=Microsoft%20SQL%20Server&logoColor=white)  ![pgAdmin](https://img.shields.io/badge/pgAdmin-%23007ACC.svg?style=for-the-badge&logo=postgresql&logoColor=white)  ![Jupyter](https://img.shields.io/badge/Jupyter-%23F37626.svg?style=for-the-badge&logo=jupyter&logoColor=white)  

- **PostgreSQL** – Database engine for querying and optimization  
- **pgAdmin 4** – SQL query execution and performance analysis  
- **Jupyter Notebook** – SQL + Python for analysis (if applicable)  
- **SQL Concepts Used**: Window functions, CTEs, Indexing, Query Optimization  

## 📂 Dataset Overview  
The dataset consists of **Spotify track details**, including:  

| Column | Description |
|--------|------------|
| `artist` | Name of the artist |
| `track` | Track name |
| `album` | Album name |
| `energy` | Measure of energy level (0-1) |
| `liveness` | Detects the presence of a live audience |
| `duration_min` | Duration of the track in minutes |
| `views` | Views for the track |
| `likes` | Number of likes on YouTube |
| `licensed` | Boolean indicating if the track is officially licensed |
| `stream` | Number of Spotify streams |
| `most_played_on` | Most popular platform (Spotify/YouTube) |

🔗 **Dataset Source:** [Public Spotify Music Data](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)  

## 🛠 SQL Schema & Table Creation  
The dataset is stored in a **PostgreSQL database** with the following schema:  

```sql
drop table if exists spotify;
create table spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```


## 🔍 SQL Queries & Data Analysis  

### **1️⃣ Basic SQL Queries (Easy Level)**  

#### **Retrieve the names of all tracks that have more than 1 billion streams.**  
```sql
select * from spotify where stream > 1000000000;
```

#### **List all albums along with their respective artists.**  
```sql
select distinct album, artist from spotify;
```

#### **Get the total number of comments for tracks where licensed = TRUE.**  
```sql
select sum(comments) as total_comments from spotify where licensed = 'true';
```

#### **Find all tracks that belong to the album type single.**  
```sql
select * from spotify where album_type ilike 'single';
```

#### **Count the total number of tracks by each artist.**  
```sql
select artist, count(*) as total_number_of_tracks from spotify group by artist order by 2;
```

### **2️⃣ Intermediate SQL Queries (Medium Level)**  

#### **Calculate the average danceability of tracks in each album.**  
```sql
select album, avg(danceability) as avg_danceability from spotify group by album order by 2 desc;
```

#### **Find the top 5 tracks with the highest energy values.**  
```sql
select track, max(energy) as highest_energy from spotify group by 1 order by 2 desc limit 5;
```

#### **List all tracks along with their views and likes where official_video = TRUE.**  
```sql
select track, sum(views) as total_views, sum(likes) as total_likes
from spotify where official_video = 'true'
group by 1 order by 2 desc;
```

#### **For each album, calculate the total views of all associated tracks.**  
```sql
select album, track, sum(views) as total_views from spotify group by 1,2 order by 3 desc;
```

#### **Retrieve the track names that have been streamed on Spotify more than YouTube.**  
```sql
select * from (select track,
   coalesce(sum(case when most_played_on = 'Spotify' then stream End),0) as streamed_on_spotify,
   coalesce(sum(case when most_played_on = 'Youtube' then stream End),0) as streamed_on_youtube
from spotify
group by 1) as most_streamed
where streamed_on_spotify > streamed_on_youtube and streamed_on_youtube <> 0;
```

### **3️⃣ Advanced SQL Queries (Hard Level)**  

#### **Find the top 3 most-viewed tracks for each artist using window functions.**  
```sql
with ranking_artist as
	(select artist, track, sum(views) as total_views,
	dense_rank() over (partition by artist order by sum(views) desc) as rank 
	from spotify group by 1,2 order by 1,3 desc)
select * from ranking_artist where rank <=3;
```

#### **Find tracks where the liveness score is above the average.**  
```sql
select artist, track, liveness from spotify
where liveness > (select avg(liveness) from spotify) order by 1,3 desc;
```

#### **Calculate the difference between the highest and lowest energy values for tracks in each album.**  
```sql
with diff as (select album, max(energy) as highest_energy, min(energy) as lowest_energy
from spotify group by 1)
select album, highest_energy - lowest_energy as energy_difference from diff order by 2 desc;
```

#### **Find tracks where the energy-to-liveness ratio is greater than 1.2.**  
```sql
select track, energy, liveness, (energy / nullif(liveness, 0)) as energy_liveness_ratio from spotify
where (energy / nullif(liveness, 0)) > 1.2 order by 4 desc;
```

#### **Calculate the cumulative sum of likes for tracks ordered by views.**  
```sql
select track, views, likes, sum(likes) over (order by views desc) as cumulative_likes from spotify;
```

## 🚀 SQL Query Optimization  

### **Performance Before Indexing (Slow Execution)**  
Before indexing, filtering queries required a **sequential scan**, leading to high execution time.  

<img width="600" alt="flow before indexing" src="https://github.com/user-attachments/assets/e48f5697-e6fd-4186-86c1-f4bf2f219e08" />


**Execution Time (Before Indexing):**  
⏳ **5.593 ms**  

🚫 **Query Execution Plan (Before Indexing)**  
<img width="650" alt="performance before indexing" src="https://github.com/user-attachments/assets/1e2cfa82-34cb-4580-8608-829cb6a5e962" />

### **Indexing Optimization**  
To improve performance, we created an **index on the `artist` column** to speed up retrieval.  

```sql
CREATE INDEX idx_artist ON spotify (artist);
```

### **Performance After Indexing (Optimized Execution)**  
After indexing, PostgreSQL switched to a **Bitmap Index Scan**, reducing execution time by **97%**.  

<img width="700" alt="flow after indexing" src="https://github.com/user-attachments/assets/64cba349-2847-4af3-8f12-5aecbcea53dc" />

**Execution Time (After Indexing):**  
⚡ **0.088 ms**  

✅ **Query Execution Plan (After Indexing)**  

<img width="650" alt="performance after indexing" src="https://github.com/user-attachments/assets/44abd6a2-801f-4f5a-893f-b40d4f6d6a4e" />

## 🎯 Business Implications & Optimization Strategies  

**1️⃣ Identifying High-Performing Tracks & Artists:** By analyzing tracks with over **1 billion streams**, we can identify **top-performing songs**. This insight helps in prioritizing **marketing efforts, playlist placements, and collaborations** to boost engagement further.  

**2️⃣ Optimizing Single vs. Album Releases:**  The analysis of album types shows a **high number of single releases**. Artists and record labels can strategically release **singles before albums** to **build anticipation and maximize engagement** across streaming platforms.  

**3️⃣ Leveraging Platform-Specific Performance:**  Some tracks **perform better on Spotify than YouTube** and vice versa. This insight enables **targeted promotion strategies** where **Spotify-dominant tracks get playlist placements**, and **YouTube-dominant tracks receive music video promotions**.  

**4️⃣ Boosting Official Videos for Increased Visibility:**  Tracks with **official music videos** gain significantly **higher views and likes**. Encouraging artists to **release official videos** can help improve track visibility, fan engagement, and revenue generation. 

**5️⃣ Danceability & Energy-Based Recommendation Systems:**  Tracks with **high danceability and energy** are **more likely to go viral**. This data can be used to **enhance recommendation algorithms**, suggesting the right tracks for **workout, party, and relaxation playlists** to improve user retention.  
