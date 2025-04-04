/*
The main Analysis.
*/

-- Average Tripduration for Customers, Subscribers.
SELECT 
    usertype,
    ROUND(AVG(tripduration),2) AS AVG_trip_duration_seconds
FROM cyclistic_2019
GROUP BY usertype;
-- CUSTOMER : 2424.69sec
-- Subscriber: 840.18sec


-- Checking if there is any pattern in most used start_stations between Customers, Subscribers.
SELECT
    start_station_name,
    usertype,
    COUNT(*) AS ride_count
FROM cyclistic_2019
GROUP BY start_station_name, usertype
ORDER BY ride_count DESC;
-- Νo pattern found.


-- Checking if there is any pattern in most used end_stations between Customers, Subscribers.
SELECT
    end_station_name,
    usertype,
    COUNT(*) AS ride_count
FROM cyclistic_2019
GROUP BY end_station_name, usertype
ORDER BY ride_count DESC;
-- Νo pattern found.


-- Calculating total rides for Customers/Subscribers.
SELECT
    usertype,
    COUNT(*) AS ride_count
FROM cyclistic_2019
GROUP BY usertype;
-- Customers: 282,337. Subscribers: 1,190,483
-- Subscribers doing significant more rides than Customers.


-- Exploring bike usage patterns by day of the week for both Customers/Subscribers.
SELECT
    usertype,
    day_of_week,
    COUNT(*) AS ride_count
FROM cyclistic_2019
GROUP BY day_of_week, usertype
ORDER BY day_of_week, usertype;
-- Customers tend to use bikes more on Weekends.
-- Subscribers tend to use bikes more on Weekdays.


-- Checking how many Females-Males use the bikes.
SELECT
    gender,
    COUNT(*) AS ride_count
FROM cyclistic_2019
WHERE gender IS NOT NULL
GROUP BY gender;
-- Male: 956.963, Female: 310.910


-- Checking if there is any difference between genders in usertype selection.
SELECT
    gender,
    usertype,
    COUNT(*) AS ride_count
FROM cyclistic_2019
WHERE gender IS NOT NULL
GROUP BY gender, usertype;
-- ~89% of females are Subscribers. ~95% of males are Subscribers.
-- Not a significant difference.


--AVG age of Customers/Subscribers.
SELECT
    usertype,
    ROUND(AVG(age),1) AS avg_age
FROM cyclistic_2019
GROUP BY usertype;
-- Age of Customers: 30.6yrs
-- Age of Subscribers: 36.0yrs
-- Subscribers are slightly older. 


-- AVG age of Customers/Subscribers for the two different genders.
SELECT
    gender,
    usertype,
    ROUND(AVG(age),1) AS avg_age
FROM cyclistic_2019
WHERE gender IS NOT NULL
GROUP BY gender,usertype;
-- Female - Customers: 29.7yrs
-- Female - Subscribers: 34.7yrs
-- Male - Customers: 31.2yrs
-- Male - Subscribers: 36.4yrs
-- Both male and female Subscribers are on average ~5.5 years older than Customers.
-- Older users are more likely to use the subscription plan.

