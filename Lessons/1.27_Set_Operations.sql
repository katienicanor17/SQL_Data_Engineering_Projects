SELECT UNNEST([1,1,1,2])
UNION
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
UNION ALL
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
INTERSECT
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
INTERSECT ALL
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
EXCEPT
SELECT UNNEST([1,1,3]);

SELECT UNNEST([1,1,1,2])
EXCEPT ALL
SELECT UNNEST([1,1,3]);

DESCRIBE
CREATE OR REPLACE TEMP TABLE jobs_2023 AS 
SELECT * EXCLUDE(job_id,job_posted_date)
FROM data_jobs.job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2023;

CREATE OR REPLACE TEMP TABLE jobs_2024 AS 
SELECT * EXCLUDE(job_id,job_posted_date)
FROM data_jobs.job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024;

--Which unique job postings appeared in either 2023 or 2024?

SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS row_count
FROM jobs_2023
UNION 
SELECT 
    'jobs_2024' AS table_name,
    COUNT(*) 
FROM jobs_2024;


SELECT * FROM jobs_2023
UNION 
SELECT * FROM jobs_2024;

--Which job posting appeared across both years, counting duplicates?

SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

--Which job postins appeared in 2023 but not in 2024?
SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

--Which job postings from 2023 remain after subtracting matching 2024 postings, on for one?
SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

--Which job postings appeared in 2023 and 2024? (duplicates removed assumption)
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

--What job posting appear in both year duplicates perserved?
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;