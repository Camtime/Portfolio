use cars;

CREATE TABLE CarSalesFact (Txn int, Dim  varchar(8) , DimValue varchar(8));

INSERT INTO CarSalesFact (Txn, Dim, DimValue) VALUES (1, 'Make', 'Honda'),(1, 'Type', 'SUV'),
(1, 'Color', 'Red'),(2, 'Make', 'Honda'),(2, 'Type', 'SUV'),(2, 'Color', 'Black'),(3, 'Make', 'Honda'), (3, 'Type', 'Sedan'),(3, 'Color', 'Brown'),(4, 'Make', 'Toyota'),(4, 'Type', 'Compact'),(4, 'Color', 'Red'), (5, 'Make', 'Toyota'),(5, 'Color', 'Black'),(5, 'Type', 'Sedan'),(6, 'Make', 'Toyota'),(6, 'Color', 'Black'), (6, 'Type', 'Sedan'),(7, 'Make', 'Honda'),(7, 'Type', 'SUV'),(7, 'Color', 'Black'),(8, 'Make', 'Honda'), (8, 'Type', 'SUV'),(8, 'Color', 'Red'),(9, 'Make', 'Honda'),(9, 'Type', 'SUV'),(9, 'Color', 'Black'), (10, 'Make', 'Honda'),(10, 'Type', 'SUV'),(10, 'Color', 'Black'),(11, 'Make', 'Mazda'),(11, 'Type', 'SUV'), (11, 'Color', 'Black'),(12, 'Make', 'Mazda'),(12, 'Type', 'Compact'),(12, 'Color', 'Red'), (13, 'Make', 'Mazda'), (13, 'Type', 'Sedan'),(13, 'Color', 'Brown'),(14, 'Make', 'Mazda'),(14, 'Type', 'SUV'),(14, 'Color', 'Red');


CREATE TABLE `CarSales` (
  `Make` varchar(6) DEFAULT NULL,
  `Style` varchar(7) DEFAULT NULL,
  `Color` varchar(5) DEFAULT NULL,
  `Sales` int DEFAULT NULL);

INSERT INTO `CarSales` (`Make`, `Style`, `Color`, `Sales`) VALUES
('Honda', 'SUV', 'Red', 31),('Honda', 'SUV', 'Blue', 46),('Honda', 'SUV', 'Green', 48), ('Honda', 'Sedan', 'Red', 25),('Honda', 'Sedan', 'Blue', 41),('Honda', 'Sedan', 'Green', 34), ('Honda', 'Compact', 'Red', 48),('Honda', 'Compact', 'Blue', 26),('Honda', 'Compact', 'Green', 32), ('Toyota', 'SUV', 'Red', 39),('Toyota', 'SUV', 'Blue', 45),('Toyota', 'SUV', 'Green', 50), ('Toyota', 'Sedan', 'Red', 41),('Toyota', 'Sedan', 'Blue', 28),('Toyota', 'Sedan', 'Green', 21), ('Toyota', 'Compact', 'Red', 44),('Toyota', 'Compact', 'Blue', 50),('Toyota', 'Compact', 'Green', 26), ('Mazda', 'SUV', 'Red', 29),('Mazda', 'SUV', 'Blue', 28),('Mazda', 'SUV', 'Green', 40),('Mazda', 'Sedan', 'Red', 36), ('Mazda', 'Sedan', 'Blue', 48),('Mazda', 'Sedan', 'Green', 49),('Mazda', 'Compact', 'Red', 49), ('Mazda', 'Compact', 'Blue', 37),('Mazda', 'Compact', 'Green', 50);


SELECT Txn,
  GROUP_CONCAT(if(Dim = 'Make', DimValue, NULL)) AS 'Make',
  GROUP_CONCAT(if(Dim = 'Type', DimValue, NULL)) AS 'Type',
  GROUP_CONCAT(if(Dim = 'Color', DimValue, NULL)) AS 'Color'
FROM CarSalesFact
GROUP BY txn;


SELECT  CSF2.Make, CSF2.Type, CSF2.Color, Count(Txn) as Sales
FROM
(SELECT Txn,
  GROUP_CONCAT(if(Dim = 'Make', DimValue, NULL)) AS 'Make',
  GROUP_CONCAT(if(Dim = 'Type', DimValue, NULL)) AS 'Type',
  GROUP_CONCAT(if(Dim = 'Color', DimValue, NULL)) AS 'Color'
FROM CarSalesFact
GROUP BY txn
 ) as CSF2
 GROUP BY CSF2.Make, CSF2.Type, CSF2.Color;
 
 
 DROP TABLE CarSales;

CREATE TABLE CarSales (
  Make varchar(8) DEFAULT NULL,
  Type varchar(8) DEFAULT NULL,
  Color varchar(8) DEFAULT NULL,
  Sales int DEFAULT NULL);

Truncate TABLE CarSales;

INSERT into CarSales (
SELECT	 
  CSF2.Make, CSF2.Type, CSF2.Color, Count(Txn) as Sales
FROM
(SELECT
  Txn,
  GROUP_CONCAT(if(Dim = 'Make', DimValue, NULL)) AS 'Make',
  GROUP_CONCAT(if(Dim = 'Type', DimValue, NULL)) AS 'Type',
  GROUP_CONCAT(if(Dim = 'Color', DimValue, NULL)) AS 'Color'
FROM CarSalesFact
GROUP BY Txn
) AS CSF2
GROUP BY CSF2.Make, CSF2.Type, CSF2.Color);

SELECT * from CarSales;


SELECT 
	Ifnull(make, 'Totals') as Dims, sums.SUV, sums.Sedan, sums.Compact, sums.SUV + sums.Sedan + sums.Compact as Totals
From (
	Select
		Make, SUM(IF(TYPE='SUV',Sales,0)) as 'SUV', sum(IF(Type='Sedan',Sales,0)) as 'Sedan', SUM(IF(TYPE='Compact',Sales,0))
        As 'Compact'
	from CarSales
    Group by make with rollup
) as sums;

#rotate (pivot) the cube
select
	ifnull(Color, 'Totals') as Dims, sums.SUV, sums.Sedan, sums.Compact, sums.SUV + sums.Sedan + sums.Compact as Totals
From (
	select Color,
		Sum(if(type='SUV',Sales,0)) as 'suv',
        sum(if(type='sedan',Sales,0)) as 'Sedan',
        sum(if(type='Compact', Sales,0)) as 'Compact'
	From CarSales
    Group By Color With Rollup
    ) AS sums;
    

select
	ifnull(Color, 'Totals') as Dims,
    sums.Honda, sums.Toyota, sums.Mazda,
    sums.Honda + sums.Toyota + sums.Mazda AS Totals
From (
	Select
		Color,
        sum(If(Make='Honda',Sales,0)) as 'Honda',
        sum(If(Make='Toyota',Sales,0)) as 'Toyota',
        sum(If(Make='Mazda',Sales,0)) as 'Mazda'
	From CarSales
    Group By Color with rollup
    ) as sums;
    
    
    
    
select
	JSON_SET('{"Name": "Trey", "Gender": "Male"}', '$.Age', 31) as 'Result';
    
CREATE TABLE customer (customer_id int DEFAULT NULL, data JSON DEFAULT NULL);

update customer
Set data = JSON_SET('{"Name": "Trey", "Gender": "Male"}', '$.Age', 31)
where customer_id = 2;

select * from customer;
    
    
    