--ADDING NEW DATA TO TABLES

-- Inserting data into the 'SPRING26_008_T12_User' table
INSERT INTO Spring26_S008_T12_User (user_id, fname, lname, street, city, state) VALUES (101, 'Carol', 'Smith', '123 Ocean Dr.', 'Miami', 'FL');

-- Inserting data into the 'SPRING26_S008_T12_Customers' table
INSERT INTO SPRING26_S008_T12_Customers (cust_user_id, role, age_group) VALUES (101, 'Faculty', '31-45');

-- Inserting data into the 'SPRING26_S008_T12_Restaurants' table
INSERT INTO SPRING26_S008_T12_Restaurants (Restaurant_ID, Name, Vendor_Type, Dist_Frm_Ctr) VALUES (551, 'Subway', 'Off-Campus', 0.97);

-- Inserting data into the 'SPRING26_S008_T12_Menu_Items' table
INSERT INTO SPRING26_S008_T12_Menu_Items (item_ID, item_Name, price, is_food, is_drink) VALUES (3051, 'Pasta', 4.99, 'Y', 'N');

-- Inserting data into the 'SPRING26_S008_T12_Restaurant_Offers_Items' table
INSERT INTO SPRING26_S008_T12_Restaurant_Offers_Items (restaurant_id, item_id) VALUES (551, 3051);

-- Inserting data into the 'SPRING26_S008_T12_Orders' table
INSERT INTO SPRING26_S008_T12_Orders 
(order_id, cost, tips, order_type, order_day, order_time, order_status, scheduled_time, actual_time, delivery_status, restaurant_id, cust_user_id, runner_user_id, location_ID)
VALUES 
(5051, 14.97, 1.49, 'Standard', 'Monday', '12:00 PM', 'Delivered', TO_TIMESTAMP('2026-03-21 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-21 12:31:01', 'YYYY-MM-DD HH24:MI:SS'), 'Late', 551, 101, 95, 1039);

-- Inserting data into the 'SPRING26_S008_T12_Order_Contains' table
INSERT INTO SPRING26_S008_T12_Order_Contains (order_id, item_id, quantity) VALUES (5051, 3051, 3);

-- UPDATING EXISTING DATA

-- Updating data in 'Spring26_S008_T12_Orders' table
UPDATE  Spring26_S008_T12_Orders
SET     delivery_status = 'On-Time', actual_time = TO_TIMESTAMP('2026-03-21 14:30:00', 'YYYY-MM-DD HH24:MI:SS')
WHERE   order_id = 5051;

UPDATE  Spring26_S008_T12_Orders
SET     order_status = 'Cancelled'
WHERE   order_id = 5001;

-- Updating data in 'Spring26_S008_T12_Menu_Items' table
-- This will affect the price calculations
UPDATE  Spring26_S008_T12_Menu_items
SET     price = 4.00
WHERE   item_id = 3051;

-- Updating data in 'Spring26_S008_T12_Orders' table
-- This will effect the total earnings
UPDATE  Spring26_S008_T12_Orders
SET     tips = 5.00
WHERE   order_id = 5051;

-- DELETING DATA

-- Deleting data in 'Spring26_S008_T12_Order_Contains' table
-- THis will effect the total quantity
DELETE FROM Spring26_S008_T12_Order_Contains
WHERE       order_id = 5051 AND item_id = 3051;

-- Deleting data in 'Spring26_S008_T12_Restaurant_Offers_Items' table
-- This will effect the item a restaurant offers
DELETE FROM Spring26_S008_T12_Restaurant_Offers_Items
WHERE       restaurant_id = 551 AND item_id = 3051;