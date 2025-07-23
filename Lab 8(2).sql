-- Lab 8

use sale;

CREATE VIEW OrderTotal AS
SELECT sale.order.OrderID, SUM(quantity) AS Total
FROM sale.Order
GROUP by sale.order.OrderID
ORDER BY Total;

Select * From ordertotal;


CREATE VIEW RaleighInternships AS
SELECT OpeningID, OpeningDescription, OpeningDate, OpeningRole, OpeningType, company.CompanyCity
FROM opening, company
WHERE company.CompanyID = opening.CompanyID
AND OpeningType = "Internship"
AND company.CompanyCity = "Raleigh";

SELECT * FROM RaleighInternships;

-- Example 1:
CREATE INDEX part_of_description
ON customer (description(10));

-- Example 2:
CREATE INDEX shortName
ON city (name(5));

use world;

-- Example 2:
CREATE INDEX short_Name
ON city (name(5));

explain select * from city
where district = 'Ontario';

create index district on city (district);
explain select * from city where district - 'Ontario';

use sakila;

-- Create a trigger that fires when anyone inserts a new row into the film table
create trigger tr_ins_film
before insert on sakila.film
for each row
set new.title = upper(new.title);

select * from film;

-- Test the trigger 
insert into film (film_id, title, language_id)
values (9999, 'Maverick', 1);
select film_id, title
from film
where film_id = 9999;

USE sakila;
-- Establish a new delimter (instead of ;) since there are many semi-colons in the stored procedure.
DELIMITER $$


CREATE PROCEDURE createNewsletterEmailList(INOUT emails VARCHAR(4000))
BEGIN
	-- Declare some variables
	DECLARE terminate INT DEFAULT FALSE;	
	DECLARE emailAddr VARCHAR(255) DEFAULT "";
	-- Declare and name the cursor for the SQL to select all emails from address_id 101-104
	DECLARE collect_email CURSOR FOR
    SELECT email FROM sakila.customer WHERE (address_id > 100 AND address_id < 105);
	-- Declare and name the handler with the variable terminate set for the end of the loop
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminate = TRUE;
	-- Open the cursor
	OPEN collect_email;
	-- Start the loop with the label name, getEmails.
	getEmails: LOOP
	-- The first task is to fetch the cursor.
		FETCH collect_email INTO emailAddr;
		IF terminate = TRUE THEN
		LEAVE getEmails;
		END IF;
		SET emails = CONCAT(emailAddr, "|", emails);
	-- SET just stores a value for a variable. CONCAT will take the first string (emailAddr), add to it the pipe (I),
	-- then add to that the second string. Thus, the current line's email address will always appear "before" the prior ones (emai.
	END LOOP getEmails;
	-- Close the cursor
	CLOSE collect_email;
END$$

delimiter ;


-- Run the stored procedure (alternatively, run it from the MySQL Workbench Navigator Bar):
SET @emails = "";
CALL createNewsletterEmailList(@emails);	
SELECT @emails;


use world;
select * from city;
DROP TABLE city;


