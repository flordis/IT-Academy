-- Hola!

-- Nivel 1
-- Ejercicio 1

CREATE DATABASE IF NOT EXISTS transactions;

USE transactions;

 CREATE TABLE IF NOT EXISTS company (
									id VARCHAR(15) PRIMARY KEY,
									company_name VARCHAR(255),
									phone VARCHAR(15),
									email VARCHAR(100),
									country VARCHAR(100),
									website VARCHAR(255)
									);
                                    
CREATE TABLE IF NOT EXISTS transaction (
										id VARCHAR(255) PRIMARY KEY,
										credit_card_id VARCHAR(15) REFERENCES credit_card(id),
										company_id VARCHAR(20), 
										user_id INT REFERENCES user(id),
										lat FLOAT,
										longitude FLOAT,
										timestamp TIMESTAMP,
										amount DECIMAL(10, 2),
										declined BOOLEAN,
										FOREIGN KEY (company_id) REFERENCES company(id) 
										);

-- 

SELECT * FROM transaction;
DESCRIBE transaction;

SELECT * FROM company;
DESCRIBE company;

-- Nivel 1
-- Ejercicio 2: Utilizando JOIN, realitzarás las siguientes consultas:

-- Lista de países que están generando ventas

SELECT comp.country
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
WHERE trans.declined = 0		-- representa que la venta no fue rechazada
GROUP BY comp.country;

-- Desde cuántos paises se generan las ventas

SELECT COUNT(DISTINCT comp.country) AS paises_con_ventas
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
WHERE trans.declined = 0;

-- Identifica la empresa con la media más alta de ventas

SELECT comp.company_name, ROUND(AVG(trans.amount),2) AS media_ventas
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
WHERE trans.declined = 0
GROUP BY comp.company_name
ORDER BY media_ventas DESC
LIMIT 1;

-- Nivel 1
-- Ejercicio 3: Utilitzando solo subconsultas (sin utilizar JOIN):

-- Muestra todas las transacciones realizadas para empreses de Alemania

SELECT trans.company_id AS id_transaccion
FROM transaction AS trans
WHERE EXISTS 	(	SELECT *
					FROM company AS comp
					WHERE comp.country = 'Germany'
					AND comp.id = trans.company_id
				)
;

-- con JOIN para corroborar
-- SELECT transaction.id 
-- FROM transaction
-- JOIN company
-- ON transaction.company_id = company.id
-- WHERE company.country = 'Germany';

-- Listar las empreses que han realizado transacciones por una cantidad superior a la media de todas las transacciones.

SELECT comp.company_name
FROM company AS comp
WHERE EXISTS	(	SELECT *
					FROM transaction AS trans
					WHERE amount >	(	SELECT ROUND(AVG(transaction.amount), 2) AS Media
										FROM transaction
									) 
					AND trans.company_id = comp.id);

-- para corroborar
-- SELECT DISTINCT comp.company_name
-- FROM company AS comp
-- JOIN transaction AS trans
-- ON comp.id = trans.company_id
-- WHERE trans.amount > (	SELECT ROUND(AVG(transaction.amount), 2)
-- 							FROM transaction
-- 						)
-- ;

-- Se eliminarán del sistema las empresas que no tienen transacciones registrades, entrega el listado de estas empreses.

SELECT comp.company_name AS empresas_sin_transacciones
FROM company AS comp
WHERE NOT EXISTS (	SELECT trans.company_id
					FROM transaction AS trans
					WHERE trans.company_id = comp.id);

-- comprobar con JOIN
-- SELECT comp.company_name
-- FROM company AS comp
-- JOIN transaction AS trans
-- ON comp.id = trans.company_id
-- WHERE trans.company_id IS NULL;


-- Nivel 2
-- Ejercicio 1

-- Identifica los cinco días en los que se generó la cantidad más alta de ingresos en la empresa por ventas. 
-- Muestra la fecha de cada transacción junto con el total de ventas.

SELECT DATE(trans.timestamp) AS fecha, SUM(amount) AS total_ventas
FROM transaction AS trans
WHERE trans.declined = 0					-- para filtrar las ventas reales (no rechazadas)
GROUP BY fecha
ORDER BY total_ventas DESC
LIMIT 5;

-- Nivel 2
-- Ejercicio 2
-- ¿Cuál es la media de ventas por país? Presenta los resultados de las medias ordenados de mayor a menor.

SELECT comp.country AS pais, ROUND(AVG(trans.amount),2) AS media
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
WHERE trans.declined = 0
GROUP BY pais
ORDER BY media DESC;

-- Nivel 2
-- Ejercicio 3
-- En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacerle competencia a la empresa 
-- “Non Institute”. Para ello, te pedimos la lista de todas las transacciones realizadas para empresas que están situadas en el 
-- mismo país que dicha empresa.
-- Muestra la lista aplicando JOIN y subconsultas

SELECT trans.id AS id_transaccion, comp.company_name
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
WHERE comp.country =	(	SELECT country
							FROM company
							WHERE company_name = 'Non Institute'
						)
AND comp.company_name != 'Non Institute'
;

-- Muestra la lista aplicando solo subconsultas

SELECT trans.id AS id_transaccion, 	(	SELECT comp.company_name
										FROM company AS comp
                                        WHERE comp.id = trans.company_id) AS company_name
FROM transaction AS trans
WHERE trans.company_id IN	(	SELECT comp.id
								FROM company AS comp
								WHERE country =	(	SELECT country
													FROM company AS c
													WHERE c.company_name = 'Non Institute'
												)
								AND comp.company_name != 'Non Institute'
							);
;            

-- Nivel 3
-- Ejercicio 1
-- Presenta el nombre, teléfono, país, fecha y cantidad de aquellas empresas que realizaron transacciones con un valor entre 
-- 350 y 400 euros (incluyéndolos) y en alguna de las siguientes fechas: 29 de abril del 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
-- Ordena los resultados de mayor a menor cantidad.

SELECT comp.company_name AS nombre_empresa, comp.phone AS telefono, comp.country AS pais, date AS fecha, t.cantidad AS total
FROM company AS comp
JOIN	(	SELECT trans.company_id, DATE(timestamp) AS date, ROUND(SUM(trans.amount),2) AS cantidad
			FROM transaction AS trans
            WHERE amount BETWEEN 350 AND 400
			AND DATE(timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
			GROUP BY trans.company_id, date
		) t
ON comp.id = t.company_id
ORDER BY t.cantidad DESC;

-- Nivel 3
-- Ejercicio 2
-- Necesitamos optimizar la asignación de los recursos y esto dependerá de la capacidad operativa que se requiera, por lo que te piden 
-- la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente 
-- y quiere un listado de las empresas (company_id) en donde especifiques si tienen más de 400 transacciones o menos.

SELECT trans.company_id AS id_empresa, comp.company_name AS nombre_empresa, COUNT(trans.id) AS total_transacciones, 	CASE
																															WHEN COUNT(trans.id) > 400 THEN 'Más de 400'
																															ELSE 'Igual o menos de 400'
																														END AS mas_menos_400
FROM transaction AS trans
JOIN company AS comp
ON trans.company_id = comp.id
GROUP BY trans.company_id;
