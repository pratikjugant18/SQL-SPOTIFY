select count(*) from cleaned_dataset ;
select * from cleaned_dataset;

-- Easy Level
-- Q1 )Retrieve the names of all tracks that have more than 1 billion streams.
select distinct Track ,Stream  from cleaned_dataset where Stream > 1000000000;

-- Q2) List all albums along with their respective artists.
select distinct Album , Artist from cleaned_dataset;

-- Q3 Get the total number of comments for tracks where licensed = TRUE.
select sum(Comments) as TotalComments from cleaned_dataset where Licensed = 'TRUE';

-- Q4) Find all tracks that belong to the album type single.
select Track from cleaned_dataset where Album_type = 'single';

-- Q5) Count the total number of tracks by each artist.
Select Artist ,count(Track) as NoOfTracks from cleaned_dataset group by Artist ;

-- Medium Level
-- Q1) Calculate the average danceability of tracks in each album.
select Album ,avg(Danceability) as Avg_Danceability from cleaned_dataset group by Album order by avg(Danceability) ;

-- Q2) Find the top 5 tracks with the highest energy values.
with cte as (
select distinct Track ,Energy,row_number() over(order by Energy desc) as rnk from cleaned_dataset)
select Track , Energy from cte where rnk <=5;

-- Q3) List all tracks along with their views and likes where official_video = TRUE.
select distinct Track ,sum(Views) ,sum(Likes)  from cleaned_dataset where official_video = 'TRUE'  group by 1 ;

-- Q4) For each album, calculate the total views of all associated tracks.
select Album ,Track , sum(Views) as TotalViews  from cleaned_dataset group by Album ,Track order by sum(Views) desc  ;

-- Q5) Retrieve the track names that have been streamed on Spotify more than YouTube
with CTE as (
select Track ,
COALESCE(sum(case when most_playedon ='Spotify' then Stream end) ,0)as Streamed_on_YT  ,
COALESCE(sum(case when most_playedon ='Youtube' then Stream end) ,0)as Streamed_on_Spotify
 from cleaned_dataset   group by Track)
 select * from CTE where Streamed_on_Spotify>Streamed_on_YT and Streamed_on_YT <>0 ;
 
 

-- Advanced Level
-- Q1) Find the top 3 most-viewed tracks for each artist using window functions.
with cte as (
select Artist , Track , sum(Views) as total_views ,
dense_rank() over(partition by Artist order by sum(Views) desc) as rnk from cleaned_dataset group by Artist , Track  order by Artist ,sum(Views) desc )
select  Artist , Track , total_views from cte where rnk <=3  ;

-- Q2) Write a query to find tracks where the liveness score is above the average.
select Track , Liveness from cleaned_dataset where  Liveness >
                                                        ( select avg(Liveness ) as Avg_of_Liveness from cleaned_dataset) ;
-- Q3) Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with cte as (
select Album , max(Energy) as Highest_Energy  ,min(Energy) as Lowest_energy from cleaned_dataset group by Album )
select Album , Highest_Energy - Lowest_Energy as energy_difference from cte
;

-- Q4) Find tracks where the energy-to-liveness ratio is greater than 10.

with cte as (
select Track ,round(Energy/Liveness,2) as ratio from cleaned_dataset) 
select Track ,ratio from cte where ratio > 10;


-- Q5) Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT Album,
       views,
       likes,
       SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM cleaned_dataset; 

select Track , sum(likes) over (order by sum(likes) desc) from cleaned_dataset group by Track;



