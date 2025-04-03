# Cyclistic Bike-Share Case Study

##  Introduction to the Problem

As a junior data analyst we are working within the marketing analysis team at a bike-sharing company in Chicago, called Cyclistic.

**Cyclistic**: A bike-share program that features more than 5800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities
and riders who can’t use a standard two-wheeled bike.

The bikes can be unlocked from one station and returned to any other station in the system anytime. The company decided to offer flexible pricing plans, including: single-ride passes, full-day passes, and annual memberships.

- Casual Riders: Customers who purchase single-ride or fully-day passes.
- Annual Members: Customers who purchase annual memberships.

The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use the bikes to commute to work each day.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. The director of marketing (Moreno) believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a solid opportunity to convert casual riders into members.


### Goal of the Junior Data Analyst:


The primary goal is to design marketing strategies aimed at converting Casual Riders into Annual Members.

In order to achieve this, the team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics.

### Analysis and Report of the Junior Data Analyst:

Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

You will produce a report with the following deliverables:

1. A clear statement of the business task.
2. A description of all data sources used.
3. Documentation of any cleaning or manipulation of data.
4. A summary of your analysis.
5. Supporting visualizations and key findings.
6. Your recommendations based on your analysis


##  Solution to the Problem

### 1. Business Task

The company Cyclistic aims to increase the amount of its annual memberships, as Cyclistic members are more profitable compared to casual riders. Our main task is to design marketing strategies that will encourage casual riders to convert into Cyclist members. In order to achieve this, the team needs to understand from our analysis how casual riders use bicycles compared to Cyclist members or otherwise how casual riders differ from Cyclistic members.


### 2. Data Sources

We used  Cyclistic’s historical trip data to analyze and identify trends. More specifically, we used data from Q1 and Q2 of 2019. The data is public and more specifically, provides the following information about user trips:

- Unique trip ID
- Start and End time (Date and Time)
- Bike ID
- Tripduration (in seconds)
- Start and end station IDs
- Start and end station names
- Usertype (Subscriber for Cyclist Members or Customer for Casual riders)
- Gender
- Birthyear

Data Credibility is ensured by the following:

- The dataset is public and freely accessible to anyone.
- The data doesn't include personally identifable information for privacy reasons, so individual user behaviors cannot be tracked.
- The dataset has been made available by Motivate International Inc.

### 3. Data Cleaning & Manipulation

For this project we chose to work with SQL (PostgreSQL) due to the large size of the dataset, making data cleaning using spreadsheets impossible.

###  Data Manipulation

Handling tripduration format: 

The tripduration column was originally formattedas x,xxx.xx (e.g. 1,353.20). However this format isn't recognized by SQL an numeric due to the comma. To resolve this, we performed the following steps:

1. Created a temporary table for both Q1 and Q2 of 2019, where the tripduration column was stored as TEXT.
2. Inserted data into our temporary table.
3. Inserted the data to our main table, converting column tripduration from TEXT to NUMERIC while removing the comma.
4. Merged the Q1 and Q2 2019 tables into a single table.

Adding two new columns:

We were asked to introduce two new columns to our table:

1. Age: We calculated this using the birthyear column.
2. day_of_the_week: We used start_time to extract the day of the week each ride started.

###  Data Cleaning

Data Cleaning Steps & Actions Taken:

1. Duplicate Check: No duplicate records found.
2. Null Values Check: No missing values in important columns. 
3. Spelling Mistakes: No issues found in usertype and gender column (around ~14% of gender records missing, not a problem).
4. Date Validation: No inconsistencies in start_time and end_time and no records found outside of Q1-Q2 of 2019.
5. Station Names & ID Consistency: No issues detected.

While most checks showed no issues, two problems were identified and adressed:

**Tripduration errors**: 

- No negative values were found in tripduration column. 
- However, 412 records for Customers exceeded 24hours, which was considered invalid. These records were deleted.

*Definition for Customers: Customers who purchase single-ride or full-day passes are referred to as casual riders.*

**Birthyear Check**: 

- No negative values were found in the birthyear column.
- However, 386 records had birthyear earlier than 1929, which was considered invalid. These records were replaced with NULL values.

*Clarification: We consider any birthyear below 1929 to be invalid.*

### 4. Analysis Summary

Key Differences Between Casual Riders and Subscribers

**Ride duration**

- Casual riders tend to take longer rides than Subscribers.
- The average trip duration for a Casual Rider is 40.41 minutes, while for a Subscriber it's only 14 minutes.

**Popular Stations**

- The most popular stations vary between Casual Riders and Subscribers.
- No clear patterns were identified.

**Riding Patterns**

- Casual Riders tend to use bikes more on weekends, indicating entertainment purposes.
- Subscribers tend to use bikes more on weekdays, indicating work-related use.

**Age Patterns**

- Subscribers are slightly older than Casual Riders.
- Average age of a subscriber is 36 years old, compared to 30.6 years old for Casual Riders.
- This age gap remains across both genders, with Subscribers being about 5.5 years older on average.

### 5. Data Visualizations 

We present two key graphs: One focusing on ride duration and the other on riding patterns.

**Bar Chart**: Average Trip Duration by User Type

![Bar Chart](https://github.com/gntagkas/Bike_Company_Data_Analysis/blob/main/BarChart.png)

From the above chart, we can notice that the average trip duration is significantly longer for casual riders compared to subscribers.

**Line Chart**: Riding Patters by Day of the Week.

![Line Chart](https://github.com/gntagkas/Bike_Company_Data_Analysis/blob/main/Screenshot_4.png)

The line chart highlights a clear riding pattern:

- Subscribers use bikes more frequently on weekdays, suggesting that they primarily use them for commuting to work

- Customers on the other hand, tend to use bikes more on weekends, with a slight increase on Fridays, suggesting a preference for recreational use.
