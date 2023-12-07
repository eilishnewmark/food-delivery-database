USE Food_delivery;

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

CALL add_new_order('Dave', 'Graham', 102, 'Cedars Street', 'LS67AH', 'Leeds', 'Lasagne');