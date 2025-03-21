-- SPOTIFY ADVANCED SQL PROJECT

--------------------------------------
-- Basic SQL Operations (Easy Level)
--------------------------------------
-- Question 1: Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify where stream > 1000000000; --385 songs

-- Question 2: List all albums along with their respective artists.
select count(distinct album) from spotify; --11853
select distinct album, artist from spotify; --14178
select
  (select count(distinct album || ' - ' || artist) from spotify) -
  (select count(distinct album) from spotify) as difference; --2325 explains the difference presented above. Many albums have more than one artist.

-- Question 3: Get the total number of comments for tracks where licensed = TRUE.
select * from spotify where licensed = 'true'; --14059 tracks
select sum(comments) as total_comments from spotify where licensed = 'true'; --497015695

-- Question 4: Find all tracks that belong to the album type single.
select * from spotify where album_type ilike 'single'; --4973

-- Question 5: Count the total number of tracks by each artist.
select artist, count(*) as total_number_of_tracks from spotify group by artist order by 2; --2074
