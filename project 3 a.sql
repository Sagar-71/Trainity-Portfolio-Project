create database TProject3;
USE TProject3;

CREATE TABLE job_data (
    ds DATE,
    job_id INT NOT NULL,
    actor_id INT NOT NULL,
    event VARCHAR(15) NOT NULL,
    language VARCHAR(15),
    time_spent INT NOT NULL,
    org CHAR(2)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_data.csv"
INTO TABLE job_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from job_data;


#Task 1

SELECT 
    review_date,
    jobs_reviewed,
    total_time_spent,
    jobs_reviewed * 3600 / total_time_spent AS jobs_reviewed_per_hour
FROM (
    SELECT 
        DATE(ds) AS review_date,
        COUNT(*) AS jobs_reviewed,
        SUM(time_spent) AS total_time_spent
    FROM 
        job_data
    WHERE 
        ds BETWEEN '2020/11/01' AND '2020/11/30'
    GROUP BY 
        review_date
) AS daily_stats
ORDER BY 
    review_date desc;
 
 #Task 2
WITH daily_events AS (
    SELECT
        DATE(ds) AS review_date,
        COUNT(*) AS daily_event_count
    FROM
        job_data
    GROUP BY
        review_date
),
rolling_avg AS (
    SELECT
        review_date,
        daily_event_count,
        AVG(daily_event_count) OVER (ORDER BY review_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_7day_throughput
    FROM
        daily_events
)
SELECT 
    review_date,
    daily_event_count,
    avg_7day_throughput / 86400 AS avg_7day_throughput_per_second
FROM 
    rolling_avg;
    
#Task 3

SELECT 
    language AS Languages,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM job_data), 2) AS Percentage
FROM
    job_data
GROUP BY 
    language;

#Task 4

SELECT 
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org,
    ds,
    COUNT(*) AS row_count
FROM
    job_data
GROUP BY job_id , actor_id , event , language , time_spent , org , ds
HAVING COUNT(*) > 1;





    



