-- Project 1, Cameron Houpe
-- The purpose of the script is to answer questions about the uptown schema and the tables inside.
use uptown;

-- a.	What is the list of all instrument rentals in inventory? (Show the list displayed in Figure 1, along with any other rentals in your database.)
select instrument
from instrument;

-- b.	What are the youngest and oldest customers of Uptown Rentals? Write one SQL program to display both.
select min(CustomerAge), max(CustomerAge)
from customer;
-- Youngest: 23, Oldest: 61

-- c.	List the aggregated (summed) rental amounts per customer. Sequence the result to show the customer with the highest rental amount first.
select sum((DueDate - RentalDate) * DailyRentalFee + LateFine) as TotalRentalAmount, Customer_Customer_ID, Customer_FName, Customer_LName
from rentals, customer
where Customer_Customer_ID = Customer_ID
group by Customer_Customer_ID, Customer_FName, Customer_LName
order by TotalRentalAmount desc;

-- d.	Which customer has the most rentals (the highest count) across all time?
select count(Rental_ID), Customer_Customer_ID, Customer_FName, Customer_LName
from rentals, customer
where Customer_Customer_ID = Customer_ID
group by Customer_Customer_ID
order by count(Rental_ID) desc
limit 1;
-- Ric Martin

-- e.	Which customer had the most rentals in January 2025, and what was their average rental total per rental?
select count(Rental_ID), Customer_Customer_ID, Customer_FName, Customer_LName, avg((DueDate - RentalDate) * DailyRentalFee + LateFine) as AverageRentalAmount
from rentals, customer
where Customer_Customer_ID = Customer_ID
and month(RentalDate) = 1
and year(RentalDate) = 2025
group by Customer_Customer_ID
order by count(Rental_ID) desc
limit 1;
-- Joseph Dow, AverageRentalAmount: $225

-- f.	Which staff member (name) is associated with the most rentals in January 2025?
select count(Rental_ID), Staff_Staff_ID, Staff_FName, Staff_LName
from rentals, staff
where Staff_Staff_ID = Staff_ID
and month(RentalDate) = 1
and year(RentalDate) = 2025
group by Staff_ID
order by count(Rental_ID) desc
limit 1;
-- DJ Burns

-- g.	For each customer that has an overdue rental, how many days have passed since the rental was due?
select customer_customer_ID, Customer_FName, Customer_LName, (ReturnDate - DueDate) as "DaysPassed"
from rentals, customer
where Customer_Customer_ID = Customer_ID
and (ReturnDate - DueDate) > 0;



-- h.	What is the total rental amount by Rental tier?
select sum((DueDate - RentalDate) * DailyRentalFee + LateFine) as TotalRentalAmount, RentalTier_RentalTier
from Rentals, Instrument
where SerialNum = Instrument_SerialNum
group by RentalTier_RentalTier;


-- i.	Who are the top three store staff members in terms of total rental amounts?
select sum((DueDate - RentalDate) * DailyRentalFee + LateFine) as TotalRentalAmount, Staff_Staff_ID, Staff_FName, Staff_LName
from Rentals, Staff
where Staff_ID = Staff_Staff_ID
group by Staff_ID
order by Staff_ID desc
limit 3;
-- Luka Doncic, Dalton Knect, Rui Hachimura

-- j.	What is the total rental amount by instrument type, where the instrument type is Flute or Bass Guitar?
select sum((DueDate - RentalDate) * DailyRentalFee + LateFine) as TotalRentalAmount, Instrument
from Rentals, Instrument
where SerialNum = Instrument_SerialNum
and instrument = "Flute"
or instrument = "Bass Guitar"
group by instrument;
-- Bass Guitar: $42,009 and Flute: $1,645

-- k.	What is the name of any customer who has two or more overdue rentals?
select customer_customer_ID, Customer_FName, Customer_LName, count(ReturnDate > DueDate) as OverDueRental
from rentals, customer
where Customer_Customer_ID = Customer_ID
and ReturnDate > DueDate
group by Customer_ID
having OverDueRental > 1;
-- Ric Martin and Luke Diago


-- l.	List all of the instruments in inventory in 2025 that were damaged upon return or needed maintenance. Include the employee that handled the rental, the repair cost, and the maintenance date.
select instrument, NeedsMaintenance, Staff_Staff_ID, Staff_FName, Staff_LName
from instrument, staff, Rentals
where Staff_ID = Staff_Staff_ID and SerialNum = Instrument_SerialNum and year(RentalDate) = 2025;

-- m.	Create a query of your choice that includes a subquery.
-- What are the repair costs higher then the highest repair cost in 2025
select RepairCost
from rentals
where RepairCost > (
select Max(RepairCost)
from rentals
where year(RentalDate) = 2025);
-- The only higher cost is $65


-- n.	Add another meaningful query of your choice. For example, you could create a query that answers the following question: 
-- What is the average age of customers by instrument?
select avg(CustomerAge), Instrument
from Customer, Rentals, Instrument
where SerialNum = Instrument_SerialNum and Customer_ID = Customer_Customer_ID
group by instrument;
