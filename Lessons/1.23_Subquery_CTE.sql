--Subquery

SELECT * 
FROM (
    SELECT * 
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
) AS valid_salary
LIMIT 10;

--CTE
WITH valid_salary AS (
      SELECT * 
    FROM data_jobs.job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
SELECT * FROM valid_salary
LIMIT 10;

-- Scenario 1: Subquery in 'SELECT'
-- Show each job's salary next to the overall market median: 
SELECT 
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN (salary_year_avg)
        FROM data_jobs.job_postings_fact
    )AS market_median_salary
FROM data_jobs.job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating to determine the remote median salary per job:
SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN (salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM data_jobs.job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;


--Scenario 3 - Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median:
SELECT 
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN (salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT 
        job_title_short,
        salary_year_avg
    FROM data_jobs.job_postings_fact
    WHERE job_work_from_home = TRUE
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
        SELECT MEDIAN (salary_year_avg)
        FROM data_jobs.job_postings_fact
        WHERE job_work_from_home = TRUE
    )
LIMIT 10;

---------
--CTE example
--Compare how much more or less remote roles pay compared to onsite roles for each job title
--Use a CTE to calculate the median salary by title and work arrangement, the compare those mediands
WITH title_median AS(
    SELECT 
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_market_salary
    FROM data_jobs.job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY 
        job_title_short, 
        job_work_from_home
)
SELECT 
    r.job_title_short,
    r.median_market_salary AS remote_median_salary,
    o.median_market_salary AS onsite_median_salary,
    (r.median_market_salary - o.median_market_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o ON
    r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;


SELECT *
FROM range(3) AS src(key);

SELECT *
FROM range(2) AS tgt(key);

SELECT *
FROM range(3) AS src(key)
WHERE EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

-- FINAL example
-- Identify job postings that have no associated skills before laoding them into a data mart
--src
SELECT * 
FROM data_jobs.job_postings_fact
ORDER BY job_id
LIMIT 10;
--tgt
SELECT * 
FROM data_jobs.skills_job_dim
ORDER BY job_id
LIMIT 40;


SELECT * 
FROM data_jobs.job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM data_jobs.skills_job_dim AS src
    WHERE src.job_id = tgt.job_id
)
ORDER BY job_id;