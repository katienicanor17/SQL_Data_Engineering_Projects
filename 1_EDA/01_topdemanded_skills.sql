/*
Question: What are the most in-demand skills for data engineers?
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings 
- Why? 
    Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work 
*/

SELECT 
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY 
    sd.skills
ORDER BY 
    demand_count DESC
LIMIT 10;

/*
Breakdown:
SQL And Python are the most in-demand skills with around 29,000 job postings each nearly double than the 3rd place skill
AWS is leading with 18,000 postings followed byu Azure at about 14,000 postings for cloud platforms 
Apache Spark coompletes the top 5 with nearly 13,000 postings, highlighting the importance of big data tools

Key Takeaways:
- SQL and Python remain fundementional skills for data engineers
- Cloud Platforms such as AWS and Azure are critical for data engineering
- Big data tools like Spark are highly valued
- Data pipeline tools (Airflow,Snowflake,Databricks) show growing demand
- Java and GCP round out the top 10 most requested skills 
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
*/
