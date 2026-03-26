-- Sprint 03 - Manipulación de tablas

-- Nivel 1
-- Ejercicio 1
-- Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito. 
-- La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación adecuada con las otras 
-- dos tablas ("transaction" y "company"). Después de crear la tabla será necesario que ingreses la información del documento 
-- denominado "datos_introducir_credit". Recuerda mostrar el diagrama y realizar una breve descripción del mismo.

USE transactions;

    CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
	iban VARCHAR(34),						-- IBAN máximo 34 caracteres (estándar ISO)
	pan VARCHAR(255),						-- es el número de tarjeta
	pin VARCHAR(255),
	cvv VARCHAR(255),
	expiring_date VARCHAR(255)
);

-- Carga de datos a partir del documento demoninado datos_introducir_credit

-- Calcular la longitud máxima exacta de las columnas que necesito y sumarle el 20%

SELECT 'id' AS columna, MAX(LENGTH(pan)) AS longitud_maxima, CEIL(MAX(LENGTH(id)) * 1.2) AS 'mas_20%'
FROM credit_card

UNION ALL

SELECT 'pan', MAX(LENGTH(pan)), CEIL(MAX(LENGTH(pan)) * 1.2)
FROM credit_card

UNION ALL

SELECT 'pin', MAX(LENGTH(pin)), CEIL(MAX(LENGTH(pin)) * 1.2)
FROM credit_card

UNION ALL

SELECT 'cvv', MAX(LENGTH(cvv)), CEIL(MAX(LENGTH(cvv)) * 1.2)
FROM credit_card

UNION ALL

SELECT 'expiring_date', MAX(LENGTH(expiring_date)), CEIL(MAX(LENGTH(expiring_date)) * 1.2)
FROM credit_card;

ALTER TABLE credit_card
	MODIFY COLUMN pan VARCHAR(23),						
	MODIFY COLUMN pin VARCHAR(5),
	MODIFY COLUMN cvv VARCHAR(4),
	MODIFY COLUMN expiring_date VARCHAR(10);

-- para relacionar la tabla credit_card con transaction

ALTER TABLE transaction						-- ALTER TABLE 
ADD CONSTRAINT fk_credit_card				-- fk_tabla
FOREIGN KEY (credit_card_id)				-- FOREIGN KEY(variable en transaction)
REFERENCES credit_card(id);					-- REFERENCES tabla(variable)


-- Nivel 1
-- Ejercicio 2
-- El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a su tarjeta de crédito 
-- con ID CcU-2938. La información que debe mostrarse para este registro es: TR323456312213576817699999. Recuerda mostrar 
-- que el cambio se realizó.

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';


-- Nivel 1
-- Ejercicio 3
-- En la tabla "transaction" ingresa una nueva transacción con la siguiente información:

SELECT *
FROM company
WHERE id = 'b-9999';

INSERT INTO company (id, company_name, phone, email, country, website)
VALUES ('b-9999', NULL, NULL, NULL, NULL, NULL);
-- ON DUPLICATE KEY UPDATE id = id;   					-- Traducción: "Si 'b-9999' ya existe, no hagas nada"

SELECT *
FROM company
WHERE id = 'b-9999';

INSERT INTO transaction
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', NULL, '111.11', '0');

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';


-- Nivel 1
-- Ejercicio 4
-- Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. Recuerda mostrar el cambio realizado.

SELECT *
FROM credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card;


-- Nivel 2
-- Ejercicio 1
-- Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


-- Nivel 2
-- Ejercicio 2
-- La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
-- Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
-- Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. 
-- Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. Presenta la vista creada, 
-- ordenando los datos de mayor a menor promedio de compra.

CREATE VIEW VistaMarketing AS
SELECT comp.id AS id_empresa, comp.company_name AS nombre_empresa, comp.phone AS telefono, comp.country AS pais, 
AVG(trans.amount) AS media
FROM company AS comp
INNER JOIN transaction AS trans
ON comp.id = trans.company_id
GROUP BY comp.id;

SELECT * FROM VistaMarketing
ORDER BY media DESC;

-- Nivel 2
-- Ejercicio 3
-- Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"

SELECT *
FROM VistaMarketing
WHERE country = 'Germany';


-- Nivel 3
-- Ejercicio 1
-- La próxima semana tendrás una nueva reunión con los gerentes de marketing. Un compañero de tu equipo realizó 
-- modificaciones en la base de datos, pero no recuerda cómo las realizó. Te pide que le ayudes a dejar los 
-- comandos ejecutados para obtener el siguiente diagrama:
-- Recordatorio
-- En esta actividad, es necesario que describas el "paso a paso" de las tareas realizadas. Es importante realizar 
-- descripciones sencillas, simples y fáciles de comprender. Para realizar esta actividad deberás trabajar con los 
-- archivos denominados "estructura_datos_user" y "datos_introducir_user".
-- Recuerda seguir trabajando sobre el modelo y las tablas con las que ya has trabajado hasta ahora.

-- En la tabla transaction, únicamente hay que modificar la longitud de la variable credit_card_id a 20 (entiendo que dice 20).


ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(20);

SHOW CREATE TABLE transaction;

ALTER TABLE transaction 
DROP FOREIGN KEY transaction_ibfk_1;

ALTER TABLE company
MODIFY COLUMN id VARCHAR(15);

ALTER TABLE transaction						 
ADD CONSTRAINT fk_company				
FOREIGN KEY (company_id)				
REFERENCES company(id);

ALTER TABLE company
DROP COLUMN website;

SELECT *
FROM company;

-----------------
SHOW CREATE TABLE transaction;

ALTER TABLE transaction 					--
DROP FOREIGN KEY fk_credit_card;

ALTER TABLE transaction
MODIFY COLUMN user_id INT;

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

ALTER TABLE transaction						 
ADD CONSTRAINT fk_credit_card				
FOREIGN KEY (credit_card_id)				
REFERENCES credit_card(id);

ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50);

ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR(4);

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20);

ALTER TABLE credit_card
MODIFY COLUMN CVV INT;

ALTER TABLE credit_card
ADD fecha_actual DATE;

SELECT *
FROM credit_card;

CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

-- cargar los datos a partir del documento 'datos introducir sprint3 user'

SELECT *
FROM user;

SHOW CREATE TABLE transaction;

ALTER TABLE transaction 					--
DROP FOREIGN KEY user_id;

ALTER TABLE user
MODIFY COLUMN id INT;

INSERT INTO user (id, name, surname, phone, email, birth_date, country, city, postal_code, address)
VALUES ('9999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

ALTER TABLE user
RENAME COLUMN email TO personal_email;

RENAME TABLE transactions.user TO transactions.data_user;

ALTER TABLE transaction	
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id)
REFERENCES data_user(id);


-- Nivel 3
-- Ejercicio 2
-- La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:
-- •	ID de la transacción
-- •	Nombre del usuario/a
-- •	Apellido del usuario/a
-- •	IBAN de la tarjeta de crédito usada.
-- •	Nombre de la compañía de la transacción realizada.
-- •	Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar de nombre 
-- columnas según sea necesario.
-- Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.

CREATE VIEW InformeTecnico AS
SELECT trans.id AS id_transaccion, u.name AS nombre_usuario, u.surname AS apellido_usuario, cc.iban, 
comp.company_name AS nombre_empresa
FROM transaction AS trans
INNER JOIN data_user AS u
ON trans.user_id = u.id
INNER JOIN credit_card AS cc
ON trans.credit_card_id = cc.id
INNER JOIN company AS comp
ON trans.company_id = comp.id;

SELECT *
FROM InformeTecnico
ORDER BY id_transaccion DESC;
