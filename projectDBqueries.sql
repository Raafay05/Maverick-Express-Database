-- page formating 
SET PAGESIZE 100;
SET LINESIZE 150;

PROMPT;
PROMPT =========================== Query 1 =======================================;
PROMPT;

-- Business Goal 1
-- 1)	Identify restaurants whose total number of orders is above the
--      average number of orders per restaurant.

-- Formating
COLUMN restaurant_name FORMAT A25;
COLUMN total_orders FORMAT 9999;

SELECT r.name AS restaurant_name,
       COUNT(o.order_id) AS total_orders
FROM Spring26_S008_T12_Restaurants r
JOIN Spring26_S008_T12_Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name
HAVING COUNT(o.order_id) > (
    SELECT AVG(COUNT(order_id))
    FROM Spring26_S008_T12_Orders 
    GROUP BY restaurant_id
) 
ORDER BY total_orders DESC;

-- Expected Output 1
-- Restaurant_Name          Total_Orders
------------------------------------------
-- Subway                        15
-- Panda Express                 19

PROMPT;
PROMPT =========================== Query 2 =======================================;
PROMPT;

-- Buisness Goal 2
--2) Determine whether restaurants farther from campus center receive fewer 
--   orders than closer restaurants.
-- This query will use ROLLUP to aggregate order counts by Distance from the ceneter

-- Formatting
COLUMN distance_from_center FORMAT 9999;
COLUMN total_orders FORMAT 9999;

SELECT  r.dist_frm_ctr AS distance_from_center,
        COUNT(o.order_id) AS total_orders
FROM Spring26_S008_T12_Restaurants r
JOIN Spring26_S008_T12_Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY ROLLUP(r.dist_frm_ctr)
ORDER BY distance_from_center ASC;

-- Expected Output 2
-- Distance_From_Center    Total_Orders
--------------------------------------------
-- 1                         10
-- 2                         15
-- 3                         20

PROMPT;
PROMPT =========================== Query 3 =======================================;
PROMPT;

-- Buisness Goal 3 
-- 3) Identify the age group that placed the highest number of orders.
-- This querry will use aggrigate functions and fetch the age group with the maximum order count

-- Formating
COLUMN age_group FORMAT A20;
COLUMN total_orders FORMAT 9999;

SELECT c.age_group AS age_group,
       COUNT(o.order_id) AS total_orders
FROM Spring26_S008_T12_Customers c
JOIN Spring26_S008_T12_Orders o ON c.cust_user_id = o.cust_user_id
GROUP BY c.age_group
ORDER BY total_orders DESC
FETCH FIRST 1 ROW ONLY; 

-- Expected Output 3
-- Age_Group    Total_Orders
-----------------------------
-- 25-34         25

PROMPT;
PROMPT =========================== Query 4 =======================================;
PROMPT;

-- Buisness Goal 4
-- 4) Identify the one-hour time interval with the maximum number of orders.
-- This query will use the like operator to filter orders by hour

-- Formating
COLUMN time_interval FORMAT A20;
COLUMN total_orders FORMAT 9999;

SELECT '7:00 AM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '7:% AM'
UNION
SELECT '8:00 AM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '8:% AM'
UNION
SELECT '9:00 AM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '9:% AM'
UNION
SELECT '10:00 AM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '10:% AM'
UNION
SELECT '11:00 AM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '11:% AM'
UNION
SELECT '12:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '12:% PM'
UNION 
SELECT '1:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '1:% PM'
UNION 
SELECT '2:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '2:% PM'
UNION
SELECT '3:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '3:% PM'
UNION
SELECT '4:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '4:% PM'
UNION
SELECT '5:00 PM' AS time_interval,
       COUNT(*) AS total_orders
FROM Spring26_S008_T12_Orders
WHERE order_time LIKE '5:% PM'
ORDER BY total_orders DESC; 

-- EXPECTED OUTPUT 4
-- Time_Interval    Total_Orders
---------------------------------
-- 7:00 AM          30
-- 8:00 AM          25
-- 9:00 AM          20
-- 10:00 AM         15
-- 11:00 AM         10

PROMPT;
PROMPT =========================== Query 5 =======================================;
PROMPT;

-- Buisness Goal 5
--5)	Determine the number of orders that could NOT be assigned to runners,
--      grouped by time of day.

-- Formating
COLUMN day_of_week FORMAT A20;
COLUMN time_slot FORMAT A20;
COLUMN unassigned_count FORMAT 9999;

SELECT order_day AS day_of_week,
       order_time AS time_slot,
       COUNT(order_id) AS unassigned_count
FROM Spring26_S008_T12_Orders
WHERE runner_user_id IS NULL
GROUP BY order_day, order_time
ORDER BY unassigned_count DESC;

-- EXPECTED OUTPUT 5
-- Day_Of_Week    Time_Slot    Unassigned_Count
-------------------------------------------------
-- Monday         7:00 AM      5
-- Monday         8:00 AM      3
-- Tuesday        9:00 AM      2

PROMPT;
PROMPT =========================== Query 6 =======================================;
PROMPT;

-- BUSINESS GOAL 6
--6)   Identify the top 5 runners by:
--     Number of completed deliveries
--     Total tips earned

-- FORMATING
COLUMN RUNNER_NAME FORMAT A20;
COLUMN COMPLETED_DELIVERIES FORMAT 9999;
COLUMN TOTAL_TIPS FORMAT 9999;

SELECT      u.fname as RUNNER_NAME, COUNT(o.order_status) as COMPLETED_DELIVERIES, SUM(o.tips) as TOTAL_TIPS
FROM        Spring26_S008_T12_Orders o
JOIN        Spring26_S008_T12_Runners r ON o.runner_user_id = r.runner_user_id
JOIN        Spring26_S008_T12_User u ON r.runner_user_id = u.user_id
WHERE       o.order_status = 'Delivered'
GROUP BY    u.fname
ORDER BY    COMPLETED_DELIVERIES desc, TOTAL_TIPS desc
FETCH       FIRST 5 ROWS ONLY;
 
--EXPECTED OUTPUT 5
--RUNNER_NAME          COMPLETED_DELIVERIES TOTAL_TIPS
-------------------- -------------------- ----------
--Skelly                                  4         40
--Karena                                  3         13
--Cybill                                  2         32
--Philippa                                2         30
--Bennie      

PROMPT;
PROMPT =========================== Query 7 =======================================;
PROMPT;

-- Buisness Goal 7
--7)    Identify the top 5 most frequently ordered food items and top 5 
--      drink items during the quarter. 

-- FORMATING
COLUMN item_name FORMAT A30;
COLUMN total_orders FORMAT 9999;

SELECT m.item_name,
       SUM(oc.quantity) AS total_orders
FROM Spring26_S008_T12_Menu_items m
JOIN Spring26_S008_T12_Order_Contains oc
     ON m.item_id = oc.item_id
WHERE m.is_food = 'Y'
GROUP BY m.item_name
ORDER BY total_orders DESC
FETCH FIRST 5 ROWS ONLY;

--EXPECTED OUTPUT
-- Item_Name            Total_Orders
-- ------------------------------ ----------
-- Burger                            15
-- Pizza                             12
-- Salad                              8
-- Pasta                              6
-- Sandwich                           4


PROMPT;
PROMPT =========================== Query 8 =======================================;
PROMPT;

-- Business Goal 8
-- 8)	Identify the campus buildings with the highest number of deliveries.
--      This query uses NOT exists to find dead zones

-- FORMATING
COLUMN building_name FORMAT A50;
COLUMN building_type FORMAT A20;
COLUMN delivery_count FORMAT 9999;

SELECT l.building_name, l.building_type, 
        COUNT(o.order_id) AS delivery_count
FROM Spring26_S008_T12_Campus_Location l
JOIN Spring26_S008_T12_Orders o
     ON l.location_id = o.location_id
WHERE l.location_id IN (
    SELECT location_id
    FROM Spring26_S008_T12_Campus_Location
    MINUS
    SELECT location_id
    FROM Spring26_S008_T12_Campus_Location
    WHERE location_id < 0
)
GROUP BY l.building_name, l.building_type
ORDER BY delivery_count DESC;

--EXPECTED OUTPUT
-- Building_Name    Building_Type    Delivery_Count
-- ---------------------------------------------
-- Building 1          academic           2


PROMPT;
PROMPT =========================== Query 9 =======================================;
PROMPT;

-- Buisness Goal 9
--9)    Determine the number and percentage of repeat customers, define as 
--       customers who placed more than one order in the same quarter.

-- FORMATING
COLUMN repeat_customers FORMAT 9999;
COLUMN repeat_percentage FORMAT A15;

SELECT COUNT(r.cust_user_id) AS repeat_customers,
       ROUND((COUNT(r.cust_user_id) / total.total_count) * 100, 2) || '%' AS repeat_percentage
FROM (
    SELECT cust_user_id
    FROM Spring26_S008_T12_Orders
    GROUP BY cust_user_id
    HAVING COUNT(order_id) > 1
) r
CROSS JOIN (
    SELECT COUNT(DISTINCT cust_user_id) AS total_count
    FROM Spring26_S008_T12_Orders
) total
GROUP BY total.total_count;

--EXPECTED OUTPUT
-----------------------------------------
-- Repeat_Customers    Repeat_Percentage    
-- 10                  25.00

--PROMPT;-
--PROMPT =========================== Query 10 =======================================;
--PROMPT;

-- BUSINESS GOAL 10
-- Compare performance metrics for the current quarter.
-- Join Orders, Runners, and Shifts to calculate Utilization.

-- FORMATTING
--COLUMN Total_Revenue FORMAT $99,999.99;
--COLUMN Avg_Order_Value FORMAT $999.99;
--COLUMN Total_Orders FORMAT 9999;
--COLUMN Utilization_Rate FORMAT 0.99;

--SELECT 
  --  SUM(o.orer) AS Total_Revenue,
    --AVG(o.order_total) AS Avg_Order_Value,
    --COUNT(o.order_id) AS Total_Orders,
    -- Calculation: (Actual Delivery Time / Scheduled Shift Time)
   -- ROUND(SUM(o.actual_time) / SUM(s.scheduled_hours), 2) AS Utilization_Rate
--FROM Spring26_S008_T12_Orders o
--JOIN Spring26_S008_T12_Runners r ON o.runner_user_id = r.runner_user_id
--JOIN Spring26_S008_T12_Shifts s ON r.runner_user_id = s.runner_user_id
--WHERE o.scheduled_time BETWEEN '01-JAN-26' AND '31-MAR-26'
--AND NOT EXISTS (
  --  SELECT 1 FROM Spring26_S008_T12_Orders 
    --WHERE order_id = o.order_id AND runner_user_id IS NULL
--)
--GROUP BY s.actual_hours; 

-- EXPECTED OUTPUT 10
-- TOTAL_REVENUE AVG_ORDER_VALUE TOTAL_ORDERS UTILIZATION_RATE
-- ------------- --------------- ------------ ----------------
-- $12,450.50 $25.40 490 0.85