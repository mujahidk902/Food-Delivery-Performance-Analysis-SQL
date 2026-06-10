create database food_delivery;

use food_delivery; 

-- Check Null Values -- 

select * from food_delivery
where city is null;

-- Count Missing Cities --

select count(*) from food_delivery
where city = 'Nan';   

-- Check the Percentage of Null or NaN values -- 
SELECT
ROUND(
COUNT(CASE WHEN City='NaN' THEN 1 END) * 100.0 / COUNT(*),
2
) AS missing_percentage
FROM food_delivery;
-- We have 3.08 % of null values so we can change the Mode for City Column --

-- Replacing With Mode in City Column -- 

SET SQL_SAFE_UPDATES = 0;

UPDATE food_delivery
SET City = 'Metropolitian'
WHERE City = 'NaN';
# Missing values in City (3.08%) were replaced with the mode (Metropolitian).

UPDATE food_delivery
SET Festival = 'No'
WHERE Festival = 'NaN';

--  EXPLORATORY SQL ANALYSIS --

# 1 . Total Orders 

SELECT COUNT(*) AS TOTAL_ORDERS
FROM food_delivery;
# Company processed 2988 orders.

# 2 Average Delivery Time

SELECT AVG(DELIVERY_TIME_MINS) AS Average_Delivery_Time
FROM food_delivery;
#Average delivery time is around 26 minutes.

# 3 Average Rider_Rating

SELECT AVG(Delivery_person_Ratings) AS Average_Rider_Rating
FROM food_delivery;
# Average Rider Rating 4.6 

# 4 Orders By City

SELECT CITY , COUNT(*) AS Orders FROM food_delivery
GROUP BY CITY 
ORDER BY Orders DESC;
# Most orders come from Metropolitian cities.

# 5 Orders by Vehicle Type

SELECT Type_of_vehicle , COUNT(*) AS Orders
FROM FOOD_DELIVERY
GROUP BY Type_of_vehicle
ORDER BY Orders DESC;
# Motorcycles handle most deliveries.

# 6 Orders by Traffic Density

SELECT ROAD_TRAFFIC_DENSITY , COUNT(*) AS Total_Orders
FROM food_delivery
GROUP BY ROAD_TRAFFIC_DENSITY 
ORDER BY TOTAL_ORDERS DESC;
# Low and Jam traffic dominate deliveries.

--           BUISNESS QUESTIONS           -- 

# Q1. Which Traffic Condition Causes Maximum Delivery Time?

SELECT Road_traffic_density,
       ROUND(AVG(delivery_time_mins),2) AS AVERAGE_TIME
FROM food_delivery
GROUP BY Road_traffic_density
ORDER BY AVERAGE_TIME DESC;
# Jam traffic produces the highest delays.

# Q2. Which Weather Condition Causes Delays?

SELECT WEATHER_CLEAN , ROUND(AVG(DELIVERY_TIME_MINS),2) AS AVERAGE_TIME
FROM food_delivery
GROUP BY WEATHER_CLEAN 
ORDER BY AVERAGE_TIME DESC;
# Cloudy and Foggy weather increase delivery time.

# Q3. Top 10 Fastest Delivery Partners.

SELECT DELIVERY_PERSON_ID , ROUND(AVG(DELIVERY_TIME_MINS),2) AS AVERAGE_TIME
FROM food_delivery 
GROUP BY DELIVERY_PERSON_ID
ORDER BY AVERAGE_TIME 
LIMIT 10;

# Q4. Top Rated Riders

SELECT DELIVERY_PERSON_ID, ROUND(AVG(DELIVERY_PERSON_RATINGS),2) AS AVERAGE_RATING
FROM food_delivery
GROUP BY DELIVERY_PERSON_ID
ORDER BY AVERAGE_RATING DESC
 ;

# Q5. Distance vs Delivery Time

SELECT
CASE
WHEN distance_km <= 5 THEN '0-5 KM'
WHEN distance_km <= 10 THEN '5-10 KM'
WHEN distance_km <= 15 THEN '10-15 KM'
ELSE '15+ KM'
END AS distance_range,
ROUND(AVG(delivery_time_mins),2) AVERAGE_TIME
FROM food_delivery
GROUP BY distance_range
ORDER BY AVERAGE_TIME DESC;
# Longer distances directly increase delivery time.

# Q6. Festival Impact

SELECT FESTIVAL , AVG(DELIVERY_TIME_MINS) AS AVERAGE_TIME
FROM food_delivery
GROUP BY FESTIVAL
ORDER BY AVERAGE_TIME DESC
;
# Deliveries take longer during festivals.

# Q7. Which Order Type Takes More Time?

SELECT 
    TYPE_OF_ORDER,
    ROUND(AVG(DELIVERY_TIME_MINS), 2) AS AVERAGE_TIME
FROM
    food_delivery
GROUP BY TYPE_OF_ORDER
ORDER BY AVERAGE_TIME DESC
;

# Q8. Late Delivery Percentage

SELECT 
    ROUND(SUM(IS_LATE) / COUNT(*), 2) AS LATE_DELIVERY_PCT
FROM
    FOOD_DELIVERY;
# Overall late delivery rate.

# Q9. City-wise Delivery Performance

SELECT 
    CITY, AVG(DELIVERY_TIME_MINS) AS AVERAGE_TIME
FROM
    FOOD_DELIVERY
GROUP BY CITY
ORDER BY AVERAGE_TIME DESC
;
# Semi-Urban has highest Average delivery time which is 50 min approx.

# Q10. Best Vehicle Type

SELECT 
    Type_of_vehicle,
    ROUND(AVG(delivery_time_mins), 2) AVERAGE_TIME
FROM
    food_delivery
GROUP BY Type_of_vehicle
ORDER BY AVERAGE_TIME;
# SCOOTER AND ELECTRIC SCOOTER ARE LESS AVERAGE TIME WHILE MOTORCYCLE TAKE MORE TIME.

# Q11. Rank Riders by Rating.

SELECT DELIVERY_PERSON_ID , DELIVERY_PERSON_RATINGS,
RANK() 
  OVER 
    (ORDER BY DELIVERY_PERSON_RATINGS DESC) AS RIDER_RNK
FROM food_delivery;

# Q12. Which is Top Peroforming Riders ?

WITH RIDER_PERFORMANCE AS (
SELECT DELIVERY_PERSON_ID , AVG(DELIVERY_TIME_MINS) AS AVERAGE_TIME
FROM FOOD_DELIVERY
GROUP BY DELIVERY_PERSON_ID
ORDER BY AVERAGE_TIME DESC
)

SELECT * FROM RIDER_PERFORMANCE
WHERE AVERAGE_TIME < 25;


# Q13. Find Riders Better Than Average

SELECT 
    Delivery_person_ID,
    ROUND(AVG(delivery_time_mins), 2) AS AVERAGE_TIME
FROM
    food_delivery
GROUP BY Delivery_person_ID
HAVING AVG(delivery_time_mins) < (SELECT 
        AVG(delivery_time_mins)
    FROM
        food_delivery);

# Q14 Top Cities by Orders.

SELECT 
    CITY, COUNT(*) AS TOTAL_ORDERS
FROM
    food_delivery
GROUP BY CITY
ORDER BY TOTAL_ORDERS DESC;
# Metropolitan cities have the highest order at 2,300, while semi-urban areas have the lowest order at 11.

# Q15 Rating vs Delivery Time.

SELECT 
    CASE
        WHEN DELIVERY_PERSON_RATINGS >= 4.5 THEN 'EXCELLENT'
        WHEN DELIVERY_PERSON_RATINGS >= 4.0 THEN 'GOOD'
        ELSE 'AVERAGE'
    END AS RIDER_CATEGORY,
    AVG(DELIVERY_TIME_MINS) AS AVERAGE_TIME
FROM
    FOOD_DELIVERY
GROUP BY RIDER_CATEGORY;

# Q16 Monthly Trend . 

SELECT 
    MONTH(order_date) AS MONTH, COUNT(*) AS ORDERS
FROM
    food_delivery
GROUP BY month;
# March reached 2499 Orders , but April dropped to the lowest point at 489 Orders.
