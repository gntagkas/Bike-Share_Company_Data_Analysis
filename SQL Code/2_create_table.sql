/*
The format of tripduration is in the following form: x,xxx.xx (e.g., 1,353.20). This format is not recognized by SQL as numeric due to the comma. 
To adress this, we create a temporary table where tripduration is stored as TEXT.

First, we insert the values into the temp table, and later we will insert them into our main table, converting the column 
tripduration from TEXT to NUMERIC and replacing ',' with ''. This ensure the format become: xxxx.xx (e.g., 1353.20).
*/


-- Creating the main table for Q1 2019 (tripduration stored as NUMERIC).
CREATE TABLE cyclistic_q1_2019 (
    trip_id INTEGER PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bikeid INT,
    tripduration NUMERIC,
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    usertype TEXT,
    gender TEXT,
    birthyear INT
);


-- Creating the temporary table for Q1 2019 (tripduration stored as TEXT).
CREATE TEMP TABLE temp_cyclistic_q1_2019 (
    trip_id INTEGER PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bikeid INT,
    tripduration TEXT, -- Will be converted to NUMERIC in the main table.
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    usertype TEXT,
    gender TEXT,
    birthyear INT
);


-- Copying data into the temporary table from the CSV file (Q1 of 2019).
COPY temp_cyclistic_q1_2019
FROM 'D:\SQL_Data_For_Projects\Data_For_Cyclist\cyclistic_q1_2019.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', ENCODING 'UTF8');

SELECT * FROM temp_cyclistic_q1_2019 LIMIT 100;


-- Inserting data into the main table. Replacing ',' with '' and converting tripduration from TEXT to NUMERIC.
INSERT INTO cyclistic_q1_2019
SELECT
    trip_id,
    start_time,
    end_time,
    bikeid,
    REPLACE(tripduration::TEXT, ',', '')::NUMERIC, -- Removing ',' and converting to NUMERIC.
    from_station_id,
    from_station_name,
    to_station_id,
    to_station_name,
    usertype,
    gender,
    birthyear
FROM temp_cyclistic_q1_2019;

SELECT * FROM cyclistic_q1_2019 LIMIT 100;


-- Creating the main table for Q2 2019 (tripduration stored as NUMERIC).
CREATE TABLE cyclistic_q2_2019 (
    trip_id INTEGER PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bikeid INT,
    tripduration NUMERIC,
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    usertype TEXT,
    gender TEXT,
    birthyear INT
);


-- Creating the temporary table for Q2 2019 (tripduration stored as TEXT).
CREATE TEMP TABLE temp_cyclistic_q2_2019 (
    trip_id INTEGER PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bikeid INT,
    tripduration TEXT, -- Will be converted to NUMERIC in the main table.
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    usertype TEXT,
    gender TEXT,
    birthyear INT
);


-- Copying data into the temporary table from the CSV file (Q2 of 2019).
COPY temp_cyclistic_q2_2019
FROM 'D:\SQL_Data_For_Projects\Data_For_Cyclist\cyclistic_q2_2019.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', ENCODING 'UTF8');

SELECT * FROM temp_cyclistic_q2_2019 LIMIT 100;


-- Inserting data into the main table. Replacing ',' with '' and converting tripduration from TEXT to NUMERIC.
INSERT INTO cyclistic_q2_2019
SELECT
    trip_id,
    start_time,
    end_time,
    bikeid,
    REPLACE(tripduration::TEXT, ',', '')::NUMERIC, -- Removing ',' and converting to NUMERIC.
    from_station_id,
    from_station_name,
    to_station_id,
    to_station_name,
    usertype,
    gender,
    birthyear
FROM temp_cyclistic_q2_2019;

SELECT * FROM cyclistic_q2_2019 LIMIT 100;


-- Merging data from Q1 & Q2 2019 into a central table (cyclistic_2019).
-- We combine the two datasets using UNION ALL function.
CREATE TABLE cyclistic_2019 AS
SELECT
    *
FROM cyclistic_q1_2019
UNION ALL
SELECT
    *
FROM cyclistic_q2_2019;

-- We add the primary key for our new table.
ALTER TABLE cyclistic_2019 ADD PRIMARY KEY (trip_id);

SELECT * FROM cyclistic_2019 LIMIT 100;


-- We will rename columns for clarity.
-- Renaming 'from_station_id' to 'start_station_id' and 'from_station_name' to 'start_station_name'.
ALTER TABLE cyclistic_2019
RENAME COLUMN from_station_id TO start_station_id;

ALTER TABLE cyclistic_2019
RENAME COLUMN from_station_name TO start_station_name;

-- Renaming 'to_station_id' to 'end_station_id' and 'to_station_name' to 'end_station_name'.
ALTER TABLE cyclistic_2019
RENAME COLUMN to_station_id TO end_station_id;

ALTER TABLE cyclistic_2019
RENAME COLUMN to_station_name TO end_station_name;


-- We are asked to add two extra columns in our dataset.

-- First adding the 'age' column.
ALTER TABLE cyclistic_2019
ADD age INTEGER;

UPDATE cyclistic_2019
SET age = 2019 - birthyear;


-- Second, adding 'day_of_week' column to record the day of the week each ride started.
ALTER TABLE cyclistic_2019
ADD day_of_week TEXT;
-- Monday = 1, Tuesday = 2, Wednesday = 3, etc.
UPDATE cyclistic_2019
SET day_of_week = CASE
    WHEN EXTRACT(ISODOW FROM start_time) = 1 THEN 'Monday'
    WHEN EXTRACT(ISODOW FROM start_time) = 2 THEN 'Tuesday'
    WHEN EXTRACT(ISODOW FROM start_time) = 3 THEN 'Wednesday'
    WHEN EXTRACT(ISODOW FROM start_time) = 4 THEN 'Thursday'
    WHEN EXTRACT(ISODOW FROM start_time) = 5 THEN 'Friday'
    WHEN EXTRACT(ISODOW FROM start_time) = 6 THEN 'Saturday'
    WHEN EXTRACT(ISODOW FROM start_time) = 7 THEN 'Sunday'
    ELSE 'Unknown'
END;


-- Verifying that the 'day_of_week' column was updated correctly.
SELECT DISTINCT(day_of_week) FROM cyclistic_2019;
-- No issues detected.

SELECT * FROM cyclistic_2019 LIMIT 100;


-- Creating an index for start_time column to improve performance in searches.
CREATE INDEX idx_start_time ON cyclistic_2019(start_time);


ALTER TABLE cyclistic_2019 OWNER TO postgres;


-- Exploring the dataset.
SELECT DISTINCT(start_station_id) FROM cyclistic_2019;

SELECT DISTINCT(start_station_name) FROM cyclistic_2019;

SELECT DISTINCT(end_station_id) FROM cyclistic_2019;

SELECT DISTINCT(end_station_name) FROM cyclistic_2019;

SELECT bikeid, COUNT(*) FROM cyclistic_2019 GROUP BY bikeid;


