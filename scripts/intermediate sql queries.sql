-- SPOTIFY ADVANCED SQL PROJECT

--------------------------------------------
-- Intermediate SQL Logic (Medium Level)
--------------------------------------------
-- Question 6: Calculate the average danceability of tracks in each album.
select album, avg(danceability) as avg_danceability from spotify group by album order by 2 desc;

-- Question 7: Find the top 5 tracks with the highest energy values.
select track, max(energy) as highest_energy from spotify group by 1 order by 2 desc limit 5;

-- Question 8: List all tracks along with their views and likes where official_video = TRUE.
select track, sum(views) as total_views, sum(likes) as total_likes from spotify where official_video = 'true' group by 1 order by 2 desc;

-- Question 9: For each album, calculate the total views of all associated tracks.
select album, track, sum(views) as total_views from spotify group by 1,2 order by 3 desc;

-- Question 10: Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from (select track,
	coalesce(sum(case when most_played_on = 'Spotify' then stream End),0) as streamed_on_spotify,
	coalesce(sum(case when most_played_on = 'Youtube' then stream End),0) as streamed_on_youtube
from spotify
group by 1) as most_streamed
where streamed_on_spotify > streamed_on_youtube and streamed_on_youtube <> 0;
