
-- ---------------------------------------------------------------------------------
--               CREATE CLIENT DATABASE / SCHEMA
-- (any created database/table is permanent in the serverm,
--  and accessible from any script)
-- ---------------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS client_management;

-- ---------------------------------------------------------------------------------
--                   CREATE / ADD TABLES
-- (this is where you store records, accessed later through SQL queries)
-- (note: any created table is empty, you have to manually add records later)
-- ---------------------------------------------------------------------------------

-- 01_(a) Create Table--------------------------------------------------------------
USE client_management; 
CREATE TABLE clients (
    client_ID INT PRIMARY KEY,
    client_name VARCHAR(50),
    street_address VARCHAR(100),
    City VARCHAR(50),
    State CHAR(2),
    Phone_number VARCHAR(15)
);

-- 01_(b) insert data into table --------------------------------------
INSERT INTO clients
(client_ID, client_name, street_address, City, State, Phone_number)
VALUES
(1,'Vinte','3 Nevada Parkway','Syracuse','NY','315-252-7305'),
(2,'Myworks','34267 Glendale Parkway','Huntington','WV','304-659-1170'),
(3,'Yadel','096 Pawling Parkway','San Francisco','CA','415-144-6037'),
(4,'Kwideo','81674 Westerfield Circle','Waco','TX','254-750-0784'),
(5,'Topiclounge','0863 Farmco Road','Portland','OR','971-888-9129');

-- 01_(c) add/import preexisting tables -----------------------------------------------------------

-- additionally you can import existing tables feom excel csv files ,
-- and add them to the database.
-- On the right panel (Navigator): 
-- Rt-click Tables-->Table data Import Wizard-->Browse and add file-->
-- follow prompts to finish adding , then click the refresh icon next to Schemas

-- ---------------------------------------------------------------------------------
--                   RUN QUERIES TO RETRIEVE RECORDS
--       (this is where you filter, retrieve or modify the data you want)
-- ---------------------------------------------------------------------------------

-- 01_See records / Visualize Table ------------------------------------------------
SELECT * FROM clients;
SELECT * FROM client_management.clients;

-- 02_DATA RETRIEVAL (SINGLE TABLE)---------------------------------------------------

-- (a) find unique states of customers
SELECT DISTINCT State
FROM customers;

-- (b) Raise price of products by 1.1x
SELECT 
    name,
    unit_price,
    unit_price * 1.1 AS new_price
FROM products;

-- (c) find all invoices since june 2019
SELECT 
    invoice_id,
    client_id,
    invoice_total,
    payment_total,
    invoice_date,
    due_date
FROM invoices
WHERE invoice_date > '2019-06-30';

-- (d) get customers born after 1990 who have more than 1000 points
SELECT *
FROM customers
WHERE birth_date > '1990-12-31'
AND points > 1000;

-- (e) find out any payments over 20$ made by client '5'
SELECT *
FROM payments
WHERE client_id = 5
AND amount > 20.00;

-- (f) identify products less expensive than lettuce (by highest to lowest price)
SELECT * 
FROM products
WHERE unit_price < (
  SELECT unit_price
  FROM products
  WHERE name LIKE '%Lettuce%'
 )
 ORDER BY unit_price DESC ;
 


-- 03_DATA RETRIEVAL (MULTIPLE TABLES)-------------------------------------------------

-- (a) show all  available payment methods
SELECT DISTINCT pm.name
FROM payments p
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id;

-- (b) show info about clients and their invoices
SELECT
    c.client_id,
    c.name,
    c.state,
    i.payment_total,
    i.due_date,
    i.payment_date,
    c.phone
FROM clients c
JOIN invoices i
    ON c.client_id = i.client_id;

-- (c) find clients that have no invoice records in the database
SELECT c.name
FROM clients c
LEFT JOIN invoices i
    ON c.client_id = i.client_id
WHERE i.invoice_id IS NULL;

-- (d) find clients whose invoice total is larger than that of client '3'
SELECT 
    c.*, i.*
FROM clients c
JOIN invoices i
    ON c.client_id = i.client_id
WHERE i.invoice_total > (
    SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

-- (e) Group and rank clients based on their spending
SELECT
    client_id,
    SUM(invoice_total) AS total_invoice_amount
FROM invoices
GROUP BY client_id
ORDER BY total_invoice_amount DESC;

-- (f) find clients with at least 2 invoices or more
SELECT 
    c.name,
    COUNT(i.invoice_id) AS invoice_count
FROM clients c
JOIN invoices i
    ON c.client_id = i.client_id
GROUP BY c.client_id, c.name
HAVING COUNT(i.invoice_id) >= 2;

-- (g) find the number of clients that used payment method 1
SELECT COUNT(*) AS number_of_invoices
FROM invoices i
JOIN payments p
    ON i.invoice_id = p.invoice_id
WHERE p.payment_method = 1;
 
      



