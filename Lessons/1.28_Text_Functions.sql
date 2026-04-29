Select LENGTH('SQL');
Select CHAR_LENGTH('SQL');

Select LOWER('SQL');
Select UPPER('Sql');

Select LEFT('SQL',2);
Select RIGHT('SQL',2);
Select SUBSTRING('SQL',2,1);

SELECT CONCAT('SQL','-' ,'Functions');
SELECT 'SQL' || '-' || 'Functions';

SELECT TRIM(' SQL ') ;

SELECT REPLACE('SQL','Q','_');
SELECT REPLACE('SQL','Q','_');
SELECT REGEXP_REPLACE('data.nerd@gmail.com','^.*(@)','\1');

WITH title_lower AS (
    SELECT
        job_title, 
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM data_jobs.job_postings_fact
)
SELECT 
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
FROM title_lower
ORDER BY RANDOM()
LIMIT 20;

SELECT NULLIF(5+5,10);
SELECT NULLIF(10,20);

--to clean up data and ensure that the 0 values will be NULL
SELECT
    MEDIAN(NULLIF(salary_year_avg,0)),
    MEDIAN(NULLIF(salary_hour_avg,0))
FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

SELECT COALESCE(0,1,2);
SELECT COALESCE(NULL,1,2);
SELECT COALESCE(NULL,NULL,2);

SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg,salary_hour_avg*2080)
FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


SELECT 
     job_title_short,
     salary_year_avg,
     salary_hour_avg,
     COALESCE(salary_year_avg,salary_hour_avg*2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg,salary_hour_avg*2080) < 150_000 THEN 'Medium'
        ELSE 'High'
    END AS salary_bucket
FROM data_jobs.job_postings_fact
ORDER BY standardized_salary DESC;