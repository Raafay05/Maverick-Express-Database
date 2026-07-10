--************************************************************
-- Project Phase 4: Create Tables
-- Team 12, Section 008, Spring 2026
-- Raafay Baig, Remington Valadez, Mohammed Yassin
--************************************************************

--1. Create the User table (independent)
CREATE TABLE Spring26_S008_T12_User (
    user_id INT PRIMARY KEY,
    fname VARCHAR2(50) NOT NULL,
    lname VARCHAR2(50) NOT NULL,
    street VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(2)
);

--2. Create the Campus_Location Table (independent)
CREATE TABLE Spring26_S008_T12_Campus_Location (
    location_id INT PRIMARY KEY,
    Building_Name VARCHAR2(100) NOT NULL,
    Building_Type VARCHAR2(50),
    street VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(2),
    room_num VARCHAR2(10)
);

--3. Create the Restaurants Table (independent)
CREATE TABLE Spring26_S008_T12_Restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    vendor_type VARCHAR2(50),
    dist_frm_ctr NUMBER(5,2)
);

--4. Create the Menu_items Table (independent)
CREATE TABLE Spring26_S008_T12_Menu_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR2(100) NOT NULL,
    price NUMBER(10,2),
    is_food CHAR(1) CHECK (is_food IN ('Y', 'N')),
    is_drink CHAR(1) CHECK (is_drink IN ('Y', 'N'))
);

--5 Create the User_Email Table (Multi-Value User)
CREATE TABLE Spring26_S008_T12_User_Email (
    user_id INT,
    user_email VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_user_email PRIMARY KEY (user_id, user_email),
    CONSTRAINT fk_user_email_user FOREIGN KEY (user_id)
    REFERENCES Spring26_S008_T12_User(user_id)
);

--6 Create the User_Phone_Num Table (Multi-Value User)
CREATE TABLE Spring26_S008_T12_User_Phone_Num (
    user_id INT,
    user_phone_num VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_user_phone PRIMARY KEY (user_id, user_phone_num),
    CONSTRAINT fk_user_phone_user FOREIGN KEY (user_id)
    REFERENCES Spring26_S008_T12_User(user_id)
);

--7. Create the Customers Table (dependent of user)
CREATE TABLE Spring26_S008_T12_Customers (
    cust_user_id INT,
    role VARCHAR2(20),
    age_group VARCHAR2(20),
    CONSTRAINT Pk_cust_user PRIMARY KEY (cust_user_id),
    CONSTRAINT fk_cust_user FOREIGN KEY (cust_user_id) 
    REFERENCES Spring26_S008_T12_User(user_id)
);

--8. Create the Runners Table (dependent of user)
CREATE TABLE Spring26_S008_T12_Runners (
    runner_user_id INT,
    role VARCHAR2(20),
    CONSTRAINT Pk_runner_user PRIMARY KEY (runner_user_id),
    CONSTRAINT fk_runner_user FOREIGN KEY (runner_user_id) 
    REFERENCES Spring26_S008_T12_User(user_id)
);

--9. Create the Orders Table (dependent of Restaurants, Customers, Runners, Campus_Location)
CREATE TABLE Spring26_S008_T12_Orders (
    order_id INT PRIMARY KEY,
    cost NUMBER(10,2),
    order_type VARCHAR2(20),
    order_day VARCHAR2(10),
    order_time VARCHAR2(10),
    order_status VARCHAR2(20),
    tips NUMBER(10,2),
    scheduled_time TIMESTAMP,
    actual_time TIMESTAMP,
    delivery_status VARCHAR2(20),
    -- FOREIGN KEYS
    restaurant_id INT,
    cust_user_id INT,
    runner_user_id INT,
    location_id INT,
    CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id)
    REFERENCES Spring26_S008_T12_Restaurants(restaurant_id),
    CONSTRAINT fk_order_customer FOREIGN KEY (cust_user_id)
    REFERENCES Spring26_S008_T12_Customers(cust_user_id),
    CONSTRAINT fk_order_runner FOREIGN KEY (runner_user_id)
    REFERENCES Spring26_S008_T12_Runners(runner_user_id),
    CONSTRAINT fk_order_location FOREIGN KEY (location_id)
    REFERENCES Spring26_S008_T12_Campus_Location(location_id)
);

--10 Create the Shifts Table (weak entity)
CREATE TABLE Spring26_S008_T12_Shifts (
    runner_user_id INT,
    shift_id INT,
    shift_date DATE,
    scheduled_hours NUMBER(4,2),
    actual_hours NUMBER(4,2),
    CONSTRAINT pk_shifts PRIMARY KEY (runner_user_id, shift_id),
    CONSTRAINT fk_shift_runner FOREIGN KEY (runner_user_id)
    REFERENCES Spring26_S008_T12_Runners(runner_user_id)
);

--11 Create the Order_Contains Table (many to many relationship)
CREATE TABLE Spring26_S008_T12_Order_Contains (
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    CONSTRAINT pk_order_contains PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_order_contains_order FOREIGN KEY (order_id)
    REFERENCES Spring26_S008_T12_Orders(order_id),
    CONSTRAINT fk_order_contains_item FOREIGN KEY (item_id)
    REFERENCES Spring26_S008_T12_Menu_items(item_id)
);

--12 Create the Restaurant_Offers_Items Table (many to many relationship)
CREATE TABLE Spring26_S008_T12_Restaurant_Offers_Items (
    restaurant_id INT,
    item_id INT,
    CONSTRAINT pk_offers PRIMARY KEY (restaurant_id, item_id),
    CONSTRAINT fk_offers_res FOREIGN KEY (restaurant_id)
    REFERENCES Spring26_S008_T12_Restaurants(restaurant_id),
    CONSTRAINT fk_offers_item FOREIGN KEY (item_id)
    REFERENCES Spring26_S008_T12_Menu_items(item_id)
);
