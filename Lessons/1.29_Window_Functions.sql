-- Count Rows - Aggregation Only
SELECT  
    COUNT(*)
FROM data_jobs.job_postings_fact; 


--Count Rows - Window Function
SELECT 
    job_id,
    COUNT(*) OVER()
FROM data_jobs.job_postings_fact; 


Select
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER()
FROM data_jobs.job_postings_fact; 

Select
    AVG(salary_hour_avg) 
FROM data_jobs.job_postings_fact; 
--Partition BY - Find hourly salary
Select
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short,company_id
    )
FROM data_jobs.job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM ()
LIMIT 10; 

--ORDER BY - ranking hourly salary 
Select
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
    )
FROM data_jobs.job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 10; 

--PARTITION BY & ORDER BY - Running Average Hourly Salary 
Select
    job_posted_date,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    )AS running_avg_hourly_by_title
FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND 
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10; 
--PARTITION BY & ORDER BY - Running job_title_short 
Select
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    )
FROM data_jobs.job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
ORDER BY 
      salary_hour_avg DESC,
    job_title_short
LIMIT 10; 


--diff aggregate funtions - replace min with max,sum,avg
Select
    job_posted_date,
    job_title_short,
    company_id,
    salary_hour_avg,
    MAX(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    )AS running_avg_hourly_by_title
FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND 
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10; 

--RANKING FUNCTION - RANK() vs DENSE_RANK 
Select
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
    )
FROM data_jobs.job_postings_fact
    WHERE salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 20; 

--ROW_NUMBER () - Providing new job_id
SELECT 
    *,
    ROW_NUMBER() OVER(
        ORDER BY job_posted_date
    )
FROM 
    data_jobs.job_postings_fact
ORDER BY 
    job_posted_date
LIMIT 20;

--LAG() -TIME Based Comparison of Company Yearly Salary 
SELECT  
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )AS previous_posting_salary,
    salary_year_avg - LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )AS salary_change

FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY company_id,job_posted_date
LIMIT 60;


SELECT  
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )AS previous_posting_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    )AS salary_change

FROM 
    data_jobs.job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
ORDER BY company_id,job_posted_date
LIMIT 60;