CREATE DATABASE TProject3b;
show databases;

use TProject3b;

#Table-1 Users 

CREATE TABLE users (
    user_id int,
    created_at varchar(255),
    company_id int,
    language varchar(255),
    activated_at varchar(255),
    state varchar(255)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from users;

#Table 2 events 

CREATE TABLE events (
    user_id int,
    occurred_at varchar(255),
    event_type varchar(100),
    event_name varchar(255),
    location varchar(255),
    device varchar(255),
    user_type int
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from events;

# Table 3 email_events

CREATE TABLE email_events (
    user_id int,
    occurred_at varchar(255),
    action varchar(100),
	user_type int
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Task 1
SELECT 
    EXTRACT(YEAR FROM occurred_at) AS year,
    EXTRACT(WEEK FROM occurred_at) AS week,
    COUNT(DISTINCT user_id) AS active_users
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY year , week
ORDER BY year , week;

#Task 2
WITH weekly_new_users AS (
    SELECT 
        YEAR(created_at) AS year,
        WEEK(created_at, 1) AS week,
        COUNT(*) AS new_users
    FROM 
        users
    GROUP BY 
        YEAR(created_at), WEEK(created_at, 1)
),

cumulative_users AS (
    SELECT 
        year,
        week,
        new_users,
        SUM(new_users) OVER (ORDER BY year, week) AS cumulative_users
    FROM 
        weekly_new_users
)

SELECT 
    year,
    week,
    new_users,
    cumulative_users
FROM 
    cumulative_users
ORDER BY 
    year, week;


#Task 3
WITH cohort AS (
    SELECT 
        user_id, 
        YEARWEEK(created_at, 1) AS signup_week
    FROM 
        users
),


weekly_engagement AS (
    SELECT 
        user_id,
        YEARWEEK(occurred_at, 1) AS engagement_week
    FROM 
        events
    GROUP BY 
        user_id, engagement_week
),


retention AS (
    SELECT 
        c.user_id,
        c.signup_week,
        w.engagement_week,
        TIMESTAMPDIFF(WEEK, STR_TO_DATE(CONCAT(c.signup_week, '1'), '%X%V%w'), STR_TO_DATE(CONCAT(w.engagement_week, '1'), '%X%V%w')) AS retention_duration_weeks
    FROM 
        cohort c
    JOIN 
        weekly_engagement w ON c.user_id = w.user_id
    WHERE 
        w.engagement_week >= c.signup_week
)


SELECT 
    signup_week,
    engagement_week,
    COUNT(DISTINCT user_id) AS retained_users,
    retention_duration_weeks
FROM 
    retention
GROUP BY 
    signup_week, engagement_week, retention_duration_weeks
ORDER BY 
    signup_week, engagement_week;
    

WITH cohort AS (
    SELECT 
        user_id, 
        YEARWEEK(created_at, 1) AS signup_week
    FROM 
        users
),

weekly_engagement AS (
    SELECT 
        user_id,
        YEARWEEK(occurred_at, 1) AS engagement_week
    FROM 
        events
    GROUP BY 
        user_id, engagement_week
),

retention AS (
    SELECT 
        c.user_id,
        c.signup_week,
        w.engagement_week,
        TIMESTAMPDIFF(WEEK, STR_TO_DATE(CONCAT(c.signup_week, '1'), '%X%V%w'), STR_TO_DATE(CONCAT(w.engagement_week, '1'), '%X%V%w')) AS retention_duration_weeks
    FROM 
        cohort c
    JOIN 
        weekly_engagement w ON c.user_id = w.user_id
    WHERE 
        w.engagement_week >= c.signup_week
)

SELECT 
    user_id,
    signup_week,
    engagement_week,
    retention_duration_weeks
FROM 
    retention
ORDER BY 
    signup_week, engagement_week, user_id;
    
    
#Task 4
SELECT 
    extract(year from occurred_at) AS year,
    extract(week from occurred_at) AS week,
    device,
    COUNT(DISTINCT user_id) AS active_users
FROM 
    events
GROUP BY 
    year,week, device
ORDER BY 
    year,week, device;
    
    
WITH weekly_device_engagement AS (
    SELECT 
		extract(year from occurred_at) AS year,
        extract(week from occurred_at) AS week,
        device,
        COUNT(DISTINCT user_id) AS active_users
    FROM 
        events
    GROUP BY 
        year, week, device
),

ranked_devices AS (
    SELECT
		year,
        week,
        device,
        active_users,
        RANK() OVER (PARTITION BY week ORDER BY active_users DESC) AS ranking
    FROM
        weekly_device_engagement
)

SELECT
	year,
    week,
    device,
    active_users
FROM
    ranked_devices
WHERE
    ranking = 26 or ranking= 1
ORDER BY
    year,week;

    
#Task 5
    SELECT 
    extract(year from occurred_at) AS year,
	extract(week from occurred_at) AS week,
    action,
    COUNT(DISTINCT user_id) AS engaged_users
FROM 
    email_events
GROUP BY 
    year, week, action
ORDER BY 
   year, week, action;
    
    SELECT 
    action,
    COUNT(*) AS action_count,
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM email_events where action ='sent_weekly_digest') AS action_rate
FROM 
    email_events
GROUP BY 
    action
ORDER BY 
    action_count DESC;













