-- SPOTIFY ADVANCED SQL PROJECT

-----------------------------
-- Query Optimization
-----------------------------
-- before indexing
explain analyze
select artist, track, views from spotify where artist = 'Gorillaz' and most_played_on = 'Spotify' order by stream desc limit 25; --et 5.593ms pt 0.117ms

-- create index on artist
create index artist_index on spotify(artist);

-- after indexing
explain analyze
select artist, track, views from spotify where artist = 'Gorillaz' and most_played_on = 'Spotify' order by stream desc limit 25; --et 0.088ms pt 0.134ms