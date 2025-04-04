/*
    File: 3_clean_data.sql
    Author: Ntagkas Ioannis
    Description: Data Cleaning 2019 Q1–Q2 Cyclistic trip data.
    Steps:
        1) Check formatting.
        2) Remove duplicates.
        3) Handle null values.
        4) Checking spelling mistakes.
        5) Checking for invalid values.
    Last updated: 2025-04-04
*/


/*
    DATA CLEANING 
*/


/*
1) Checking Tripduration Formatting.
*/
SELECT
    tripduration
FROM cyclistic_q1_2019
WHERE tripduration > 1000;
-- Fixed, our results is in this form: xxxx.xx


/*
2) Checking For Duplicate Records. Trip_id is the primary key.
*/
SELECT 
    trip_id,
    COUNT(*)
FROM cyclistic_2019
GROUP BY trip_id
HAVING COUNT(*) > 1;
-- No duplicate records.


/*
3) Checking For Null Values in imporant columns.
*/
SELECT
    trip_id
FROM cyclistic_2019
WHERE trip_id IS NULL
    OR start_time IS NULL
    OR end_time IS NULL
    OR bikeid IS NULL
    OR usertype IS NULL
    OR start_station_name IS NULL
    OR end_station_name IS NULL;
-- No missing values.


/*
4) Checking for spelling mistakes.
*/
-- Checking usertype.
SELECT
    DISTINCT usertype
FROM cyclistic_2019;
-- No spelling mistakes (Results: Customer, Subscriber)

-- Checking gender.
SELECT
    DISTINCT gender
FROM cyclistic_2019;
-- No spelling mistakes (Results: Female, Male, NULL). But we get the information we have missing values for genders.

-- Count of missing gender values.
SELECT
    gender,
    COUNT(*)
FROM cyclistic_2019
GROUP BY gender
/*
Female: ~310k
Male: ~957k
NULL: ~205k

Gender type missing for ~205k/~1,472k (~14%). It's not a problem for our analysis so we will move forward without deleting them.
*/


/*
5) Checking Tripduration Values.
*/
-- Checking for negative values on tripduration.
SELECT
    tripduration
FROM cyclistic_2019
WHERE tripduration < 0;
-- No negative values.

/*
Checking for non-logical values on tripduration for Casual riders. 
Definition of Casual riders shared by the company:
Customers who purchase single-ride or full-day passes are referred to as casual riders.
So tripduration for a casual rider need to be less than 24 hours. If tripduration is more than 24 hours they are invaled values.
Casual Rider = 'Customer' and Members = 'Subscriber' in our data.
*/
SELECT 
    COUNT(*)
FROM cyclistic_2019
WHERE usertype = 'Customer' AND tripduration > 86400; -- 1 day in seconds.
-- We have 412 records.

SELECT
    tripduration
FROM cyclistic_2019
WHERE usertype = 'Customer' AND tripduration > 86400;

-- Checking the average tripduration for this 412 records
SELECT 
    ROUND(AVG(tripduration),1)
FROM cyclistic_2019
WHERE usertype = 'Customer' AND tripduration > 86400; -- 1 day in seconds.
-- AVG_trip_duration = 381392.2sec ~ 4.42Days.

-- We decide to delete these 412 records. Casual riders ('Customers') tripduration need to be less than 86400sec (1 Day). 
DELETE FROM cyclistic_2019
WHERE usertype = 'Customer' AND tripduration > 86400


/*
6) Checking Invalid Date Values.
*/
-- Checking for incorrect start_time and end_time.
SELECT
    trip_id
FROM cyclistic_2019
WHERE start_time > end_time;
-- No issues detected.

-- Checking for records outside of Q1-Q2 2019.
SELECT
    trip_id
FROM cyclistic_2019
WHERE NOT start_time BETWEEN '2019-01-01 00:00:00' AND '2019-06-30 23:59:59';
-- No issues detected.


/*
7) Checking Birthyear Values.
*/
-- Checking for NULL values in birthyear. 
SELECT
    birthyear
FROM cyclistic_2019
WHERE birthyear IS NULL;
-- Around 199,000 NULL values but it's not a problem for our analysis.

-- Checking for incorrect values on birthyear. Any birthyear less than 1929 is considered invalid.
SELECT
    birthyear
FROM cyclistic_2019
WHERE birthyear < 1929;
-- Found 386 invalid values.

UPDATE cyclistic_2019
SET birthyear = NULL
WHERE birthyear < 1929;
-- Replacing this 386 values with NULL.


/*
8) Checking Station Name and ID Consistency
*/
-- Checking if the same start_station_name has multiple start_station_id values.
SELECT
    start_station_name,
    COUNT (DISTINCT start_station_id) AS unique_id
FROM cyclistic_2019
GROUP BY start_station_name
HAVING COUNT(DISTINCT start_station_id) > 1;
-- No issue detected.

-- Checking if the same end_station_name has multiple end_station_id values.
SELECT
    end_station_name,
    COUNT (DISTINCT end_station_id) AS unique_id
FROM cyclistic_2019
GROUP BY end_station_name
HAVING COUNT(DISTINCT end_station_id) > 1;
-- No issue detected.









