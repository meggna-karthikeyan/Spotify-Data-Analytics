-- SPOTIFY ADVANCED SQL PROJECT

------------------------------
-- Exploratory Data Analysis
------------------------------
select count(*) from spotify; --20594

select count(distinct artist) from spotify; --2074

select count(distinct album) from spotify; --11853

select distinct album_type from spotify; --album, complilation, single

select distinct album from spotify; --11853

select max(duration_min) from spotify; --77.9343

select min(duration_min) from spotify; --0 (Can't be zero so digging deeper to find out)

select * from spotify where duration_min = 0; --2 songs found (solution: delete those 2 songs)

delete from spotify where duration_min = 0; --successfully deleted

select * from spotify where duration_min = 0; --checking it again. voila, you did it!

select distinct channel from spotify; --6673

select distinct most_played_on from spotify; --youtube, spotify