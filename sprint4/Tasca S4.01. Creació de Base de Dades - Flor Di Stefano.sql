-- Level 1
-- Download the CSV files, study them, and design a database with a star schema containing at least 4 tables, 
-- with which you can perform the following queries:

CREATE DATABASE IF NOT EXISTS store;

USE store;

CREATE TABLE IF NOT EXISTS american_users (
											id VARCHAR(255),
                                            name VARCHAR(255),
                                            surname VARCHAR(255),
                                            phone VARCHAR(255),
                                            email VARCHAR(255),
                                            birth_date VARCHAR(255),
                                            country VARCHAR(255),
                                            city VARCHAR(255),
                                            postal_code VARCHAR(255),
                                            address VARCHAR(255)
										   );

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\american_users.csv"
INTO TABLE american_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS european_users (
											id VARCHAR(255),
                                            name VARCHAR(255),
                                            surname VARCHAR(255),
                                            phone VARCHAR(255),
                                            email VARCHAR(255),
                                            birth_date VARCHAR(255),
                                            country VARCHAR(255),
                                            city VARCHAR(255),
                                            postal_code VARCHAR(255),
                                            address VARCHAR(255)
										   );

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\european_users.csv"
INTO TABLE european_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS credit_cards (
											id VARCHAR(255),
                                            user_id VARCHAR(255),
                                            iban VARCHAR(255),
                                            pan VARCHAR(255),
                                            pin VARCHAR(255),
                                            cvv VARCHAR(255),
                                            track1 VARCHAR(255),
                                            track2 VARCHAR(255),
                                            expiring_date VARCHAR(255)
										);

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\credit_cards.csv"
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS companies (
										company_id VARCHAR(255),
                                        company_name VARCHAR(255),
                                        phone VARCHAR(255),
                                        email VARCHAR(255),
                                        country VARCHAR(255),
                                        website VARCHAR(255)
									);

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS products (	id VARCHAR(255),
										product_name VARCHAR(255),
                                        price VARCHAR(255),
                                        colour VARCHAR(255),
                                        weight VARCHAR(255),
                                        warehouse_id VARCHAR(255)
									);

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS transactions (
											id VARCHAR(255),
											card_id VARCHAR(255),
											business_id VARCHAR(255),
                                            timestamp VARCHAR(255),
                                            amount VARCHAR(255),
                                            declined VARCHAR(255),
                                            product_ids VARCHAR(255),
                                            user_id VARCHAR(255),
                                            lat VARCHAR(500),
                                            longitude VARCHAR(500)
										);

LOAD DATA LOCAL INFILE "C:\\Users\\Usuari\\Desktop\\Dades\\Especialidad IT Academy\\Sprint 4\\transactions.csv"
INTO TABLE transactions
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'  	
LINES TERMINATED BY '\n'	
IGNORE 1 ROWS;

-- modification in users

CREATE TABLE IF NOT EXISTS users AS	
									SELECT *, 'America' AS continent
									FROM american_users
									UNION ALL
                                    SELECT *, 'Europe' AS continent
									FROM european_users
                                    ;

SELECT 'id' AS column_name, MAX(LENGTH(id)) AS maximum_length, CEIL(MAX(LENGTH(id) * 1.2)) AS 'plus_20'
FROM users
UNION ALL
SELECT 'phone', MAX(LENGTH(phone)), CEIL(MAX(LENGTH(phone) * 1.2))
FROM users
UNION ALL
SELECT 'email', MAX(LENGTH(email)), CEIL(MAX(LENGTH(email) * 1.2))
FROM users
UNION ALL
SELECT 'country', MAX(LENGTH(country)), CEIL(MAX(LENGTH(country) * 1.2))
FROM users
UNION ALL
SELECT 'city', MAX(LENGTH(city)), CEIL(MAX(LENGTH(city) * 1.2))
FROM users
UNION ALL
SELECT 'postal_code', MAX(LENGTH(postal_code)), CEIL(MAX(LENGTH(postal_code) * 1.2))
FROM users
UNION ALL
SELECT 'continent', MAX(LENGTH(continent)), CEIL(MAX(LENGTH(continent) * 1.2))
FROM users;

ALTER TABLE users
	MODIFY COLUMN id INT UNSIGNED PRIMARY KEY,
	MODIFY COLUMN name VARCHAR(255) NOT NULL,
    MODIFY COLUMN surname VARCHAR(255) NOT NULL,
    MODIFY COLUMN phone VARCHAR(20),
	MODIFY COLUMN email VARCHAR(100),
    MODIFY COLUMN country VARCHAR(60),
    MODIFY COLUMN city VARCHAR(60),
    MODIFY COLUMN postal_code VARCHAR(10),
    MODIFY COLUMN address VARCHAR(100),
    MODIFY COLUMN continent VARCHAR(30);

SET SQL_SAFE_UPDATES = 0;
UPDATE users 
SET birth_date = STR_TO_DATE(birth_date, '%b %d, %Y');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE users 
MODIFY COLUMN birth_date DATE;

-- modifications in companies
SELECT 'company_id' AS column_name, MAX(LENGTH(company_id)) AS maximum_length, CEIL(MAX(LENGTH(company_id)) * 1.2) AS 'plus_20%' -- alias
FROM companies
UNION ALL
SELECT 'phone', MAX(LENGTH(phone)), CEIL(MAX(LENGTH(phone)) * 1.2)
FROM companies
UNION ALL
SELECT 'email', MAX(LENGTH(email)), CEIL(MAX(LENGTH(email)) * 1.2)
FROM companies
UNION ALL
SELECT 'country', MAX(LENGTH(country)), CEIL(MAX(LENGTH(country)) * 1.2)
FROM companies
UNION ALL
SELECT 'website', MAX(LENGTH(website)), CEIL(MAX(LENGTH(website)) * 1.2)
FROM companies;

ALTER TABLE companies
	MODIFY COLUMN company_id VARCHAR(8) PRIMARY KEY,					-- modify it in transactions fk constraint !!!
    MODIFY COLUMN company_name VARCHAR(255) NOT NULL,
	MODIFY COLUMN phone VARCHAR(20),
	MODIFY COLUMN email VARCHAR(50),
    MODIFY COLUMN country VARCHAR(60),
    MODIFY COLUMN website VARCHAR(255);

-- modifications in credit_cards
SELECT 'id' AS card_id, MAX(LENGTH(id)) AS maximum_length, CEIL(MAX(LENGTH(id)) * 1.2) AS 'plus_20%'
FROM credit_cards
UNION ALL
SELECT 'user_id', MAX(LENGTH(user_id)), CEIL(MAX(LENGTH(user_id)) *  1.2)
FROM credit_cards
UNION ALL
SELECT 'iban', MAX(LENGTH(iban)), CEIL(MAX(LENGTH(iban)) * 1.2)
FROM credit_cards
UNION ALL
SELECT 'pan', MAX(LENGTH(pan)), CEIL(MAX(LENGTH(pan)) *  1.2)
FROM credit_cards
UNION ALL
SELECT 'pin', MAX(LENGTH(pin)), CEIL(MAX(LENGTH(pin)) *  1.2)
FROM credit_cards
UNION ALL
SELECT 'cvv', MAX(LENGTH(cvv)), CEIL(MAX(LENGTH(cvv)) *  1.2)
FROM credit_cards
UNION ALL
SELECT 'track1', MAX(LENGTH(track1)), CEIL(MAX(LENGTH(track1)) *  1.2)
FROM credit_cards
UNION ALL
SELECT 'track2', MAX(LENGTH(track2)), CEIL(MAX(LENGTH(track2)) *  1.2)
FROM credit_cards;

ALTER TABLE credit_cards
	MODIFY COLUMN id VARCHAR(20) PRIMARY KEY,			
	MODIFY COLUMN user_id INT UNSIGNED NOT NULL,		
	MODIFY COLUMN iban VARCHAR(34) NOT NULL,			-- INT ocupa menos que otros: Para 1 millón de usuarios:
	MODIFY COLUMN pan VARCHAR(20) NOT NULL,				
	MODIFY COLUMN pin CHAR(4) NOT NULL,					
	MODIFY COLUMN cvv CHAR(4) NOT NULL,					
	MODIFY COLUMN track1 VARCHAR(100),
    MODIFY COLUMN track2 VARCHAR(100),
    MODIFY COLUMN expiring_date VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;
UPDATE credit_cards 
SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE credit_cards
	MODIFY COLUMN expiring_date DATE;
    
-- modification in transactions
SELECT 'id' AS id_transaction, MAX(LENGTH(id)) AS maximum_length, CEIL(MAX(LENGTH(id) * 1.2)) AS 'plus_20%'
FROM transactions
UNION ALL
SELECT 'lat', MAX(LENGTH(LAT)), CEIL(MAX(LENGTH(lat) * 1.2))
FROM transactions
UNION ALL
SELECT 'longitude', MAX(LENGTH(longitude)), CEIL(MAX(LENGTH(longitude) * 1.2))
FROM transactions;

ALTER TABLE transactions
    MODIFY COLUMN id VARCHAR(50) PRIMARY KEY,
    MODIFY COLUMN card_id VARCHAR(20) NOT NULL,
    CHANGE COLUMN business_id company_id VARCHAR(8) NOT NULL,
    MODIFY COLUMN timestamp TIMESTAMP,
    MODIFY COLUMN amount DECIMAL(10,2),
    MODIFY COLUMN declined BOOLEAN,
    MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
    CHANGE COLUMN lat latitude DECIMAL(9,6),
    MODIFY COLUMN longitude DECIMAL(9,6); 

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_card_id FOREIGN KEY (card_id) REFERENCES credit_cards(id),
ADD CONSTRAINT fk_transactions_company_id FOREIGN KEY (company_id) REFERENCES companies(company_id),
ADD CONSTRAINT fk_transactions_user_id FOREIGN KEY (user_id) REFERENCES users(id);

-- Exercise 1
-- Make a subquery that shows all users with more than 80 transactions, using at least 2 tables.

SELECT u.id
FROM users AS u
WHERE EXISTS	(	SELECT t.user_id
					FROM transactions AS t
					WHERE t.user_id = u.id
                    HAVING COUNT(t.id) >= 80
				);

-- check result with JOIN
SELECT u.id, COUNT(t.id) AS transactions_per_user
FROM users AS u
JOIN transactions AS t
ON u.id = t.user_id
GROUP BY u.id
HAVING transactions_per_user >= 80;


-- Level 1
-- Exercise 2
-- Show the average amount per IBAN of credit cards from the company Donec Ltd. Use at least 2 tables.

SELECT cc.iban AS iban, ROUND(AVG(t.amount),2) AS average
FROM transactions AS t
JOIN credit_cards AS cc
ON t.card_id = cc.id
JOIN companies AS c
ON t.company_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
AND t.declined = 0
GROUP BY cc.iban
ORDER BY average;


-- Level 2
-- Exercise 1
-- Create a new table that reflects the status of credit cards: if the last three transactions were declined, 
-- the status is inactive; if at least one was not declined, the status is active.

CREATE TABLE IF NOT EXISTS card_status (	
WITH ranked_transactions AS	(	
		SELECT t.id, t.card_id, t.timestamp, t.declined, ROW_NUMBER() OVER (
																			PARTITION BY t.card_id
																			ORDER BY t.timestamp DESC
                                                                            ) AS row_num
		FROM transactions AS t
							),
last3transactions AS	(
		SELECT rt.id, rt.card_id, rt.timestamp, rt.declined
		FROM ranked_transactions AS rt
		WHERE rt.row_num <= 3
						)
SELECT l3t.card_id, CASE
						WHEN SUM(declined) = 3 THEN 'inactive'
						ELSE 'active'
					END AS card_status 
FROM last3transactions AS l3t
GROUP BY l3t.card_id
);

ALTER TABLE card_status
	MODIFY COLUMN card_id VARCHAR(20) PRIMARY KEY;


-- Based on this table, answer: 
-- Exercise  1
-- How many cards are active?

SELECT COUNT(cs.card_id) AS active_cards
FROM card_status AS cs
WHERE cs.card_status = 'active';

-- check w/ inactive
SELECT COUNT(cs.card_id) AS inactive_cards
FROM card_status AS cs
WHERE cs.card_status = 'inactive';


-- Level 3
-- Create a new table that will allow us to join the data from the new products.csv file with the existing database,
-- considering that the transaction table contains product_ids.

SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET price = REPLACE(price, '$', '');

UPDATE transactions 
SET product_ids = REPLACE(product_ids, ', ', ',');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE products
	MODIFY COLUMN id INT PRIMARY KEY,
    MODIFY COLUMN price DECIMAL (10,2),
    MODIFY COLUMN colour VARCHAR(10),
    MODIFY COLUMN warehouse_id VARCHAR(20);

CREATE TABLE transactions_products AS (
SELECT t.id AS transaction_id, value AS product_id
FROM transactions AS t
JOIN JSON_TABLE (
	CONCAT('["', REPLACE(t.product_ids, ',', '","'), '"]'), '$[*]' COLUMNS (
																			value INT PATH '$'
																			)
				) AS jt
WHERE t.product_ids IS NOT NULL
									);

ALTER TABLE transactions_products
ADD PRIMARY KEY (transaction_id, product_id),
ADD CONSTRAINT fk_transactions_products_products 
	FOREIGN KEY (product_id) REFERENCES products(id),
ADD CONSTRAINT fk_transactions_products_transactions 
	FOREIGN KEY (transaction_id) REFERENCES transactions(id);

-- Generate the following query:
-- Exercise 1
-- We need to know how many times each product has been sold.

SELECT tp.product_id, COUNT(tp.product_id) AS times_sold
FROM transactions_products AS tp
INNER JOIN transactions AS t
ON tp.transaction_id = t.id
WHERE t.declined = 0
GROUP BY tp.product_id
ORDER BY tp.product_id;



