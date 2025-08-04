-- Create Clients Table
CREATE TABLE Clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(255),
    contact_email VARCHAR(255),
    phone_number VARCHAR(20),
    address TEXT
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    unit_price DECIMAL(10, 2),
    Description TEXT
);

CREATE TABLE SalesRep (
    salesrep_id SERIAL PRIMARY KEY,
    salesrep_firstname VARCHAR(255),
    salesrep_lastname VARCHAR(255),
    contact_email VARCHAR(255),
    phone_number VARCHAR(20),
    Address TEXT
);

CREATE TABLE Transactions (
	transaction_id SERIAL Primary Key,
    transaction_date DATE,
	client_id SERIAL REFERENCES Clients(client_id),
    product_id SERIAL REFERENCES Products(product_id),
    salesrep_id SERIAL REFERENCES SalesRep(salesrep_id),
    quantity INT,
    total_price DECIMAL(10, 2),
    type VARCHAR(100),
    Description VARCHAR(255)
);

INSERT INTO Clients (client_name, contact_email, phone_number, Address)
VALUES
    ('Cameron Houpe', 'cshoupe@ncsu.edu', '919-223-4912', '332 Airpod Ln, Raleigh, NC'),
    ('Lamar Jackson', 'lmrjackson@ravens.com', '343-298-6764', '535 Raven Rd, Baltimore, MD'),
    ('Hayley Williams', 'hayleywillll@paramore.com', '267-663-9011', '311 Paramore Dr, Nashville, TN'),
    ('LeBron James', 'lbj@GOAT.com', '522-119-3868', '982 Basketball Ct, Los Angeles, CA'),
    ('TJ Watt', 'tjwatt@steelers.com', '555-211-9812', '456 Football Dr, Pittsburgh, PA'),
    ('Gracie Abrams', 'gabrams@singer.com', '833-190-2658', '190 Music St, Nashville, TN'),
    ('Taylor Swift', 'tswift@midnights.com', '777-221-3900', '101 Country Rd, Nashville, TN'),
    ('Selena Gomez', 'selenagomez@actress.com', '920-261-6619', '370 Hollywood Blvd, Los Angeles, CA'),
    ('Noah Kahan', 'noahkahan@musician.com', '542-880-5611', '237 Folk Lane, Burlington, VT'),
    ('Kevin Hart', 'kevinhart@comedian.com', '667-189-1789', '779 Laughter St, Philadelphia, PA');


INSERT INTO Products (product_name, unit_price, Description)
VALUES
    ('Microphone', 50, 'A microphone that can be used from many different types of shows and events.'),
    ('Acoustic Guitar', 200, 'A acoustic guitar that can be used for a wide variety of genres in music.'),
    ('Football', 100, 'A NFL quality football that is made with the finest materials.'),
    ('Basketball', 90, 'A NBA quality basketball made out of premium rubber.'),
    ('Apple Airpods', 250, 'Amazing sounding and long-lasting headphones by Apple.');


INSERT INTO SalesRep (salesrep_firstname, salesrep_lastname, contact_email, phone_number, Address)
VALUES
    ('Tony', 'Hawk', 'thawk@skater.com', '677-192-3358', '871 Skateboard Ln, Carlsbad, CA'),
    ('Michelle', 'Obama', 'michelleobama@president.com', '771-529-8911', '160 Obama, Washington, DC'),
    ('Bill', 'Gates', 'bgates@microsoft.com', '450-200-1543', '901 Microsoft Way, Redmond, WA'),
    ('Adam', 'Sandler', 'adamsandler@movie.com', '490-807-3890', '217 Funny Blvd, Los Angeles, CA'),
    ('George', 'Lopez', 'georgelopez@television.com', '222-890-2673', '556 Stand-up St, Los Angeles, CA');


INSERT INTO Transactions (transaction_date, client_id, product_id, salesrep_id, quantity, total_price, type, Description)
VALUES
    ('1-12-23', 1, 1, 1, 3, 750, 'credit card', 'The transaction was successfully completed'),
    ('2-08-23', 2, 3, 2, 2, 200, 'credit card', 'The transaction was successfully completed'),
    ('2-23-23', 3, 1, 3, 5, 250, 'debit card', 'The transaction was successfully completed'),
    ('3-01-23', 4, 4, 4, 1, 90, 'check', 'The transaction was successfully completed'),
    ('4-19-23', 5, 3, 5, 1, 100, 'cash', 'The transaction was successfully completed'),
    ('6-11-23', 6, 2, 1, 7, 1400, 'check', 'The transaction was successfully completed'),
    ('7-10-23', 7, 2, 2, 10, 2000, 'credit card', 'The transaction was successfully completed'),
    ('8-28-23', 8, 1, 3, 8, 400, 'cash', 'The transaction was successfully completed'),
    ('9-30-23', 9, 2, 4, 3, 600, 'debit card', 'The transaction was successfully completed'),
    ('12-07-23', 10, 1, 5, 3, 150, 'cash', 'The transaction was successfully completed'); 

SELECT COUNT(client_id) AS total_clients
FROM Clients;

SELECT AVG(unit_price) AS avg_unit_price
FROM Products;
	
SELECT p.product_name, SUM (t.total_price) AS total_revenue
FROM Products p
JOIN Transactions t ON p.product_id = t.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT s.salesrep_id, s.salesrep_firstname, s.salesrep_lastname, COUNT(t.transaction_id) AS transactions
FROM SalesRep s
JOIN Transactions t ON s.salesrep_id = t.salesrep_id
GROUP BY s.salesrep_id, s.salesrep_firstname, s.salesrep_lastname
ORDER BY transactions DESC;

SELECT s.salesrep_id, s.salesrep_firstname, s.salesrep_lastname, SUM(t.total_price) AS total_revenue
FROM SalesRep s
JOIN Transactions t ON s.salesrep_id = t.salesrep_id
GROUP BY s.salesrep_id, s.salesrep_firstname, s.salesrep_lastname
ORDER BY total_revenue DESC;


	


	

