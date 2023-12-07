-- Food delivery database
CREATE DATABASE Food_delivery;
USE Food_delivery;

-- Towns served 
CREATE TABLE Town 
(town_id INTEGER NOT NULL,
town_name VARCHAR(100),
CONSTRAINT pk_town_id
PRIMARY KEY (town_id)
);
    
-- Address of customer, restuarant or deliverer    
CREATE TABLE Address (
address_id INT NOT NULL,
building_number INT,
street VARCHAR(100),
add_town_id INT NOT NULL DEFAULT 0,
post_code VARCHAR(8),
CONSTRAINT pk_address_id
PRIMARY KEY (address_id),
CONSTRAINT fk_town_id
FOREIGN KEY (add_town_id) REFERENCES Town(town_id));

-- customer details
CREATE TABLE Customer 
(customer_id INT NOT NULL,
first_name VARCHAR(100) NOT NULL,
surname VARCHAR(100),
cus_town_id INT NOT NULL,
cus_address_id INT NOT NULL,
CONSTRAINT pk_customer_id
PRIMARY KEY (customer_id),
CONSTRAINT fk_cus_town_id
FOREIGN KEY (cus_town_id) REFERENCES Town(town_id),
CONSTRAINT fk_cus_address_id
FOREIGN KEY (cus_address_id) REFERENCES Address(address_id)
);

-- Restuarant details
CREATE TABLE Restaurant (
r_id INT NOT NULL,
r_address_id INT NOT NULL,
r_town_id INT NOT NULL,
`open` BOOLEAN NOT NULL,
CONSTRAINT pk_r_id
PRIMARY KEY (r_id),
CONSTRAINT fk_r_town_id
FOREIGN KEY (r_town_id) REFERENCES Town(town_id),
CONSTRAINT fk_r_address_id
FOREIGN KEY (r_address_id) REFERENCES Address(address_id)
);
    
-- Menu items for every restuarant. num_ordered counts how many ordered that day. 
-- When num_ordered is over a limit item_available is changed to FALSE
-- num_ordered and item_available reset to 0 and TRUE every morning.
CREATE TABLE Menu_items (
menu_id INT NOT NULL,
item_name VARCHAR(100) NOT NULL,
cost DECIMAL(5, 2) NOT NULL,
num_ordered INT NOT NULL,
item_available BOOLEAN NOT NULL,
CONSTRAINT pk_menu_id
PRIMARY KEY (menu_id));
    
-- Deliverer, the person who delivers the order.
-- commision is the runing total earned that day, reset to 0 each morning
-- based on the cost of the order delivered.
CREATE TABLE Deliverer (
del_id INT NOT NULL,
del_first_name VARCHAR(100) NOT NULL,
del_surname VARCHAR(100),
del_town_id INT  NOT NULL,
del_address_id INT NOT NULL,
commission DECIMAL(6, 2) NOT NULL,
CONSTRAINT pk_del_id
PRIMARY KEY (del_id),
CONSTRAINT fk_del_town_id
FOREIGN KEY (del_town_id) REFERENCES Town(town_id),
CONSTRAINT fk_del_address_id
FOREIGN KEY (del_address_id) REFERENCES Address(address_id));

-- Orders made by the customers references the customer, 
-- restaurant, town, menu item, and who's delivering. Complete is for when the order has been delivered.
CREATE TABLE Orders (
order_id INT NOT NULL,
order_customer_id INT NOT NULL,
order_r_id INT NOT NULL,
order_town_id INT NOT NULL,
order_menu_id INT NOT NULL,
order_del_id INT NOT NULL,
complete BOOLEAN NOT NULL,
CONSTRAINT pk_order_id
PRIMARY KEY (order_id),
CONSTRAINT fk_order_cumstomer_id
FOREIGN KEY (order_customer_id) REFERENCES Customer(customer_id),
CONSTRAINT fk_order_r_id
FOREIGN KEY (order_r_id) REFERENCES Restaurant(r_id),
CONSTRAINT fk_order_town_id
FOREIGN KEY (order_town_id) REFERENCES Town(town_id),
CONSTRAINT fk_order_menu_id
FOREIGN KEY (order_menu_id) REFERENCES Menu_items(menu_id),
CONSTRAINT fk_order_del_id
FOREIGN KEY (order_del_id) REFERENCES Deliverer(del_id));

-- Populate Town table
INSERT INTO Town
(town_id, town_name)
VALUES
(1, 'Leeds'),
(2, 'Ramsgate'),
(3, 'London'),
(4, 'Manchester');

-- Use Town IDs to populate Address table
INSERT INTO Address
(address_id, building_number, street, add_town_id, post_code)
VALUES
(1, 308, 'Lakeview Drive', 1, 'LS22 5DX'),
(2, 306, 'Valley Road', 4, 'M20 4UH'),
(3, 220, 'Cherry Lane', 3, 'SW15 6LG'),
(4, 305, 'Linden Street', 2, 'CT10 2TG'),
(5, 14, 'Union Street', 2, 'CT21 5BP'),
(6, 87, 'Hillside Avenue', 3, 'SW17 8SQ'),
(7, 383, 'Woodland Drive', 4, 'M43 6EF'),
(8, 156, 'Hawthorne Lane', 2, 'CT1 1AP'),
(9, 74, 'Myrtle Street', 1, 'LS17 7LT'),
(10, 288, 'Howard Street', 1, 'LS25 5BQ'),
(11, 14, 'Pizza Street', 1, 'LS9 9HE'),
(12, 1, 'Express Street', 2, 'CT20 3FT'),
(13, 102, 'Lunch Avenue', 3, 'W1U 1BE'),
(14, 10, 'Dough Street', 3, 'E14 7GR'),
(15, 11, 'Mozz Walk', 3, 'NE5 4BN'),
(16, 5, 'Dinner Lane', 4, 'M12 5PX'),
(17, 22, 'Orangery Street', 4, 'ME10 4PG'),
(18, 4, 'Leedle Place', 1, 'LS7 3QB');


-- Populate Customer table using corresponding Address and Town IDs with Address table
INSERT INTO Customer
(customer_id, first_name, surname, cus_town_id, cus_address_id)
VALUES
(1, 'Logan', 'Humphrey', 1, 1),
(2, 'Krew', 'Hayden', 4, 2),
(3, 'Avayah', 'Higgins', 3, 3),
(4, 'Sterling', 'Henderson', 2, 4),
(5, 'Maria', 'Santiago', 2, 5),
(6, 'Beckham', 'Sawyer', 3, 6),
(7, 'Marina', 'McGee', 4, 7),
(8, 'Conner', 'Gill', 2, 8),
(9, 'Jordan', 'Garrison', 1, 9),
(10, 'Noe', 'Cervantes', 1, 10);

-- Populate Restaurant table, where there are 8 restaurants overal 
-- and there can be multiple resturants in the same town (because this is a database for a chain) 
INSERT INTO Restaurant
(r_id, r_address_id, r_town_id, open)
VALUES
(1, 11, 1, TRUE),
(2, 12, 2, TRUE),
(3, 13, 3, TRUE),
(4, 14, 3, TRUE),
(5, 15, 3, TRUE),
(6, 16, 4, TRUE),
(7, 17, 4, TRUE),
(8, 18, 1, TRUE);

INSERT INTO Menu_items
(menu_id, item_name, cost, num_ordered, item_available)
VALUES
(1, 'Chicken Burger', 4.50, 25, FALSE),
(2, 'Beef Burger', 4.75, 32, True),
(3, 'Veggie Burger', 4.25, 30, TRUE),
(4, 'Pepperoni Pizza', 11.00, 49, FALSE),
(5, 'Hawaiian Pizza', 12.50, 56, TRUE),
(6, 'BBQ Pizza', 9.60, 60, TRUE),
(7, 'Nduja Calzone', 12.95, 53, TRUE),
(8, 'Sweet Chilli Chicken', 11.75, 55, FALSE);


INSERT INTO Deliverer
(del_id, del_first_name, del_surname, del_town_id, del_address_id, commission)
VALUES
(1, 'John', 'Smith', 1, 1, 5.50),
(2, 'Martin', 'Jones', 4, 2, 10.25),
(3, 'Joe', 'Jonas', 3, 3, 8.80),
(4, 'Gill', 'Williams', 2, 4, 11.30),
(5, 'Mandy', 'Farmer', 2, 5, 9.95),
(6, 'Tony', 'DCruze', 3, 6, 8.20),
(7, 'Beka', 'Bruce', 4, 7, 9.90),
(8, 'Duncan', 'Brown', 2, 8, 15.50),
(9, 'Claire', 'Johnson', 1, 9, 11.00),
(10,'Helen', 'Branigan', 1, 10, 9.05);

-- Could improve this by specifying amount of menu item that has been ordered and the 
-- time of order and price of order (menu item price + delivereer commission price) and any order notes
INSERT INTO Orders (order_id, order_customer_id, order_r_id, order_town_id, order_menu_id, order_del_id, complete)
VALUES (1, 1, 8, 1, 8, 9, 0),
(2, 2, 6, 4, 5, 7, 1),
(3, 3, 4, 3, 6, 6, 1),
(4, 4, 2, 2, 2, 5, 0),
(5, 5, 2, 2, 4, 8, 1),
(6, 6, 5, 3, 4, 6, 1),
(7, 7, 6, 4, 7, 2, 0),
(8, 8, 2, 2, 1, 8, 1),
(9, 9, 8, 1, 7, 9, 0),
(10, 10, 1, 1, 8, 10, 1);

-- view of deliveries in each town--
CREATE VIEW vw_orders_t4 AS SELECT order_id, order_customer_id, order_r_id, order_del_id, order_menu_id, complete, deliverer.* 
FROM orders
JOIN deliverer 
ON order_del_id = del_id AND order_town_id = 4;
SELECT * FROM vw_orders_t4;
-- replace 4 with 1,2,3 for other towns --

-- Stored Procedure to add new menu item to the Menu table
DELIMITER //
CREATE PROCEDURE add_new_menu_item(
	IN p_menu_id INT,
    IN p_item_name VARCHAR (100),
    IN p_cost DECIMAL (5,2),
    IN p_num_ordered INT,
    IN p_item_available BOOLEAN
)
BEGIN
	INSERT INTO menu_items (menu_id,
    item_name, cost, num_ordered, item_available)
    values (p_menu_id, p_item_name, p_cost,
    p_num_ordered, p_item_available);
		COMMIT;
END//
    DELIMITER ;
CALL add_new_menu_item(9, 'Lasagne', 12.30, 0, TRUE);

-- User defined function to calculate the commision earned on a delivery.
-- Parameters are the cost of the menu item and the percentage being earned by the deliverer
-- Returns the amount of commision to add to the deliverer's daily running total
-- It's a trivial job for a function to do as it's one line of code 
-- but could make the procedure that calls it easier to read and understand.
DELIMITER //
CREATE FUNCTION calc_commission (
cost DECIMAL(5,2), percent INT)
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
	DECLARE commission_earned DECIMAL(5,2);
    SET commission_earned = cost * (percent / 100.0);
	RETURN commission_earned;
END//
DELIMITER ;
​
-- User defined procedure to add commission to a deliverer's runnning total
-- the procedure is passed the order ID and the percentage to charge
-- First it makes a join with orders and menu items to finds the cost of the order
-- next it calls the function calc_commission
-- it then updates the deliverer's running total of daily commission earned
DELIMITER //
CREATE PROCEDURE proc_add_commission (
IN comm_order_id INT, IN percent INT)
BEGIN
	DECLARE commission_earned decimal(5,2);
    DECLARE ord_cost decimal(5,2);
    DECLARE comm_del_id INT;
    
    -- Find the cost of the order
    SELECT cost INTO ord_cost 
    FROM menu_items
    JOIN orders ON order_menu_id = menu_id
    WHERE order_id = comm_order_id;
    
    -- work out the commission due
	SET commission_earned = calc_commission(ord_cost, percent);
    
    -- find the deliverer Id to add the commission to
    SELECT order_del_id INTO comm_del_id 
    FROM orders
    WHERE order_id = comm_order_id;
    
    -- update the deliverer's commission total
    UPDATE deliverer
	SET commission = commission + commission_earned
    WHERE del_id = comm_del_id;
    
END//
DELIMITER ;

CALL proc_add_commission(1,10);


-- Trigger to increment number ordered by one every time an order for that menu item is created
-- and then change item_available to FALSE when 100 have been ordered (you'd run out of ingredients for that day!)
DELIMITER //
CREATE TRIGGER tr_update_available
AFTER INSERT ON orders FOR EACH ROW
BEGIN
	UPDATE menu_items
	SET num_ordered = num_ordered + 1
	WHERE
	menu_id = NEW.order_menu_id;
    
    -- check if the total ordered that day is > 100 and if so set item_available to FALSE
	IF (SELECT num_ordered FROM menu_items WHERE menu_id = NEW.order_menu_id)> 100 THEN 
		UPDATE menu_items
		SET item_available = FALSE WHERE menu_id = NEW.order_menu_id;
	END IF;
END//
DELIMITER ;

-- Here it is in action, first I set the number ordered to 100 and item_available to TRUE for  menu item 8
UPDATE menu_items
SET num_ordered = 100 WHERE menu_id = 8;
UPDATE menu_items
SET item_available = TRUE WHERE menu_id = 8;

-- I need to turn safe updates off in order for my trigger to updat menu_items
SET SQL_SAFE_UPDATES = 0;

-- Now I add a new order, if I check my menu_items table menu_id 8 
-- will have num_ordered equal to 101 and item_availabble changed to FALSE by the trigger 
INSERT INTO orders VALUES (12, 3, 3, 3, 8, 3, 0);​

-- *** Ensure that all tables allow the Primary Key ato Auto-Increment when you insert into them ***
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE Address MODIFY COLUMN address_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Customer MODIFY COLUMN customer_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Deliverer MODIFY COLUMN del_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Menu_items MODIFY COLUMN menu_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Orders MODIFY COLUMN order_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Restaurant MODIFY COLUMN r_id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE Town MODIFY COLUMN town_id INT NOT NULL AUTO_INCREMENT;
SET FOREIGN_KEY_CHECKS = 1;
    
SET GLOBAL event_scheduler = ON;
​
-- Event to close restaurant and set all Menu Item order numbers to 0 and availability to 1 at the end of each day.
DELIMITER //
CREATE EVENT reset_menu_availability_and_close
ON SCHEDULE EVERY 1 day
STARTS '2023-12-08 22:00:00'
DO BEGIN
    UPDATE Menu_items SET num_ordered = 0;
    UPDATE Menu_items SET item_available = 1;
    UPDATE Restaurant SET `open` = 0;
END //
DELIMITER ;
​
-- Event to Open all Restaurants at midday.
DELIMITER //
CREATE EVENT reopen_restaurants
ON SCHEDULE EVERY 1 DAY
STARTS '2023-12-08 12:00:00'
DO BEGIN
    UPDATE Restaurant SET `open` = 1;
END //
DELIMITER ;

-- Query with Subquery that calculates the total income made from the Orders in the Orders table
SELECT SUM(cost) AS 'Total income' FROM (SELECT cost FROM Menu_items JOIN Orders ON order_menu_id = menu_id) AS costs;


-- Stored Procedure to add a new order, also updating the Customer and Address tables
-- It doesn't allow a new order to be made if a Menu Item is set to
-- False or a Restaurant is set to closed, or if an address is entered for a town we don't cater for
DELIMITER //
CREATE PROCEDURE add_new_order(
	IN new_first_name VARCHAR(50),
    IN new_surname VARCHAR (50),
    IN new_building_number INT,
    IN new_street VARCHAR(50),
    IN new_post_code VARCHAR(8),
    IN new_town_name VARCHAR(20), 
    IN sel_menu_item_name VARCHAR(100)
    )
BEGIN
    DECLARE sel_town_id INT;
    DECLARE sel_add_id INT;
    DECLARE sel_cus_id INT;
    DECLARE sel_r_id INT;
    DECLARE sel_del_id INT;
    DECLARE sel_menu_id INT;
    DECLARE restaurant_open BOOLEAN;
    DECLARE menu_item_available BOOLEAN;
    
    -- First find the Town ID and Menu ID for the new Order and save it as sel_town_id/sel_menu_id
	SELECT town_id INTO sel_town_id FROM Town WHERE town_name = new_town_name;
    SELECT menu_id INTO sel_menu_id FROM Menu_items WHERE sel_menu_item_name = item_name AND item_available = 1;
    IF sel_town_id IS NULL OR sel_menu_id IS NULL THEN SELECT "Sorry, we either don't cater for your town or don't have that item available on our menu!";
    END IF;
    
    -- Then, add the new Address to the Adress table if it is not already there
    INSERT INTO Address (building_number, street, add_town_id, post_code)
    SELECT * FROM (SELECT new_building_number, new_street, sel_town_id, new_post_code) AS new_address 
    WHERE NOT EXISTS(SELECT address_id FROM Address WHERE building_number = new_building_number AND street = new_street AND post_code = new_post_code);
    -- If the address is already in the table, save it's ID
    SELECT address_id INTO sel_add_id FROM Address WHERE building_number = new_building_number AND street = new_street AND post_code = new_post_code;
	-- Get the last ID in the Address table as the relevant address ID for this new order if the address wasn't already in the table
    IF sel_add_id IS NULL THEN SELECT LAST_INSERT_ID() INTO sel_add_id;
	END IF;
    
    -- Next, add the new customer to the Customer table using the found Town and Address IDs if it is not already there
    INSERT INTO Customer (first_name, surname, cus_town_id, cus_address_id)
    SELECT * FROM (SELECT new_first_name, new_surname, sel_town_id, sel_add_id) AS new_customer
    WHERE NOT EXISTS (SELECT customer_id FROM Customer WHERE first_name = new_first_name AND surname = new_surname AND cus_address_id = sel_add_id);
    -- If the customer is already in the table, save it's ID
    SELECT customer_id INTO sel_cus_id FROM Customer WHERE first_name = new_first_name AND surname = new_surname AND cus_address_id = sel_add_id;
    -- Get the last ID in the Customer table as the relevant customer ID for this new order if the customer wasn't already in the table
    IF sel_cus_id IS NULL THEN SELECT LAST_INSERT_ID() INTO sel_cus_id;
    END IF;
    
    -- Find the Restaurant ID for the selected Town
    SELECT r_id INTO sel_r_id FROM Restaurant WHERE r_id = sel_town_id;
    
    -- Find a random Delivery driver that works in the selected Town
    SELECT del_id INTO sel_del_id FROM (SELECT * FROM Deliverer WHERE del_town_id = sel_town_id) AS available_deliverers
	ORDER BY RAND()
	LIMIT 1;

	-- Check if Restaurant is open
    SELECT `open` INTO restaurant_open FROM Restaurant WHERE r_id = sel_r_id;
    SELECT item_available INTO menu_item_available FROM Menu_items WHERE menu_id = sel_menu_id;
    
    -- Finally, update the Orders table with the new information
    IF restaurant_open AND menu_item_available THEN
    INSERT INTO Orders (order_customer_id, order_r_id, order_town_id, order_menu_id, order_del_id, complete)
    VALUES (sel_cus_id, sel_r_id, sel_town_id, sel_menu_id, sel_del_id, FALSE);
    ELSE SELECT "Restaurant is closed, sorry!"; 
	END IF;
END//
DELIMITER ;

CALL add_new_order('Dennie', 'Lovie', 3, 'Grant Rd', 'LS45OD', 'Leeds', 'Beef Burger');