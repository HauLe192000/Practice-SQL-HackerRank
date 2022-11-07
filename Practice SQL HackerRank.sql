--Practice SQL HackerRank
--Sources:https://www.hackerrank.com/domains/sql?filters%5Bstatus%5D%5B%5D=unsolved&badge_type=sql

--CHALLENGES: Basic join
--Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.

with cte as (
select hacker_id as id, count(challenge_id) as countt
from challenges 
group by hacker_id
)
select id, h.name, countt 
from cte
join hackers h
on h.hacker_id = id
where 
(select max(countt) from cte) = countt 
or 
(countt in (select countt from cte group by countt having count(countt) = 1))

order by countt desc, id;



--SQL Project Planning: Advanced join
--Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

with start_table as (
     select start_date, row_number() OVER (ORDER BY start_date) as stt
      from projects
      where start_date not in 
            (select end_date from projects)
      ),
end_table as(
    select end_date, row_number() OVER (ORDER BY end_date) as stt2
    from projects
    where end_date not in 
          (select start_date from projects)
    )
    
SELECT start_date, end_date
FROM start_table 
JOIN end_table on stt = stt2
ORDER BY datediff(day, start_date, end_date), start_date;


--- Placements: Advanced join
--	Write a query to output the names of those students whose best friends got offered a higher salary than them.

with friend_salary as(
     select ID, salary as friend_salary
     from Packages )
SELECT name
FROM students s
join packages p on p.ID = s.ID
join friends f on f.ID = p.ID
join friend_salary fs on fs.ID = f.friend_ID
where friend_salary > salary
order by friend_salary;

--- Interviews: Hard Advanced join  
--Write a query to print the *contest_id*, *hacker_id*, *name*, and the sums of *total_submissions*, *total_accepted_submissions*, *total_views*, and *total_unique_views* for each contest sorted by *contest_id*.

with view_stats_2  as(
           select challenge_id,
                  sum(total_views) AS total_views,
                  sum(total_unique_views) AS total_unique_views
           from view_stats
           group by challenge_id
),
submission_stats_2 as(
           select challenge_id,
                  sum(total_submissions) AS total_submissions,
                  sum(total_accepted_submissions) AS total_accepted_submissions
           from submission_stats
           group by challenge_id
)

SELECT con.contest_id, con.hacker_id, con.name,
       SUM(ss.total_submissions) as total_submissions,
       SUM(ss.total_accepted_submissions) as total_accepted_submissions,
       SUM(vs.total_views) as total_views,
       SUM(vs.total_unique_views) as total_unique_views
FROM view_stats_2 vs
FULL OUTER JOIN submission_stats_2 ss on vs.challenge_id = ss.challenge_id
LEFT JOIN challenges ch on ss.challenge_id = ch.challenge_id OR ch.challenge_id = vs.challenge_id
LEFT JOIN colleges col on col.college_id = ch.college_id
LEFT JOIN contests con on con.contest_id = col.contest_id
GROUP BY con. contest_id, con.hacker_id, con.name
ORDER BY con.contest_id;


--Ollivander’s Inventory: Basic join
--Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.

with demo as(
          select w.id, wp.age, w.coins_needed, w.power,
                 dense_rank() OVER(PARTITION BY wp.age, w.power ORDER BY w.coins_needed) as dense_rank
          from wands w
          left join wands_property wp on w.code =wp.code
          where wp.is_evil = 0)
SELECT demo.id, demo.age, demo.coins_needed, demo.power
FROM demo
WHERE dense_rank = 1
ORDER BY power DESC, age DESC;



--Occupations: Advanced Select
--Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.


SELECT DOCTOR, PROFESSOR, SINGER, ACTOR 
FROM ( SELECT row_number() over(partition by OCCUPATION ORDER by NAME) as rn 
            , OCCUPATION 
            , NAME 
       FROM OCCUPATIONS ) as a 
PIVOT ( max(NAME) FOR OCCUPATION in ( DOCTOR, PROFESSOR, SINGER, ACTOR ) ) as abc


--Symmetric Pairs: Advanced Join( Self-ish joins)
--Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ? Y1.

WITH DEMO AS(SELECT
            ROW_NUMBER()OVER(ORDER BY X ASC) AS RANK
        , X,Y
            FROM Functions)
select D1.X,D1.Y
FROM DEMO D1 JOIN DEMO D2 ON D1.X=D2.Y AND D1.Y=D2.X
WHERE D1.RANK<D2.RANK 
ORDER BY D1.X ASC;




































