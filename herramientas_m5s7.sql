CREATE TABLE empresas(
rut VARCHAR(10) PRIMARY KEY,
nombre VARCHAR(120) NOT NULL,
direccion VARCHAR(120) NOT NULL,
telefono VARCHAR(15) NOT NULL,
correo VARCHAR(80) NOT NULL,
web VARCHAR(50)
);

CREATE TABLE clientes(
rut VARCHAR(10) PRIMARY KEY,
nombre VARCHAR(120) NOT NULL,
correo VARCHAR(80) NOT NULL,
direccion VARCHAR(120) NOT NULL,
celular VARCHAR(15) NOT NULL
);

CREATE TABLE herramientas (
id_herramienta SERIAL PRIMARY KEY,
nombre VARCHAR(120) NOT NULL,
precio_dia NUMERIC(12,2) CHECK(precio_dia >0) NOT NULL
);

CREATE TABLE arriendos(
id_arriendo SERIAL PRIMARY KEY,
folio SERIAL NOT NULL,
fecha DATE DEFAULT CURRENT_DATE NOT NULL,
dias INTEGER DEFAULT (0) CHECK (dias > 0) NOT NULL,
garantia  VARCHAR(30),
id_herramienta INTEGER REFERENCES herramientas(id_herramienta),
cliente_rut  VARCHAR(10) REFERENCES clientes(rut)
);

--Inserte los datos de una empresa.

INSERT INTO empresas (rut, nombre, direccion, telefono, correo, web) VALUES
('11111111-1','ECONOMI','Las lomas', '22456123','economy@economy.cl','www.economy.cl');
SELECT * FROM empresas;


--Inserte 5 herramientas.

INSERT INTO herramientas(nombre, precio_dia) VALUES
('taladro',5000),
('sierra electrica', 25000),
('Motosierra', 15000),
('taladro percutor', 18000),
('soldador',50000);

SELECT * FROM herramientas;

--Inserte 3 clientes. 

INSERT INTO clientes (rut,nombre, correo, direccion, celular) VALUES
('11111111-2', 'Pedro Martinez','pedro@mmm.cl','lomas verdes 52','9456789'),
('11111111-3','Ricardo Soto', 'ricardo@lqsea.cl','praderas 1245','9789456'),
('11111111-4','Estavan Yanez','esteban@lqsea.cl','El llano 478','9456123');
SELECT * FROM clientes;

-- Insertar datos en arriendos

INSERT INTO arriendos VALUES
('15','2024-01-15',5,'25000',1,'11111111-4'),
('18','2024-05-21',15,'18000',4,'11111111-2'),
('19','2024-06-05',6,'50000',5,'11111111-3');

--Listar los clientes sin arriendos por medio de una subcons

SELECT * FROM clientes
WHERE rut NOT IN (SELECT cliente_rut FROM arriendos);


--  Listar todos los arriendos con las siguientes columnas: Folio, Fecha, Dias, ValorDia, NombreCliente, RutClient

SELECT 
	a.folio, a. fecha, a.dias,
	h.precio_dia AS CostoDiario,
	c.rut AS rutCliente
FROM arriendos a
JOIN herramientas h ON a.id_herramienta = h.id_herramienta
JOIN clientes c ON a.cliente_rut = c.rut;


-- Clasificar los clientes según  ariendos de 0 y 1 :bajo, arriendo de 1 y 3:medio, 3 o mas arriendos:alto

SELECT 
	c.rut,
	c.nombre,
	COUNT(a.id_arriendo) AS total_arriendos,
CASE
	WHEN COUNT(a.id_arriendo) =  0 THEN 'bajo'
	WHEN COUNT(a.id_arriendo) BETWEEN 1 AND 3 THEN 'medio'
	WHEN COUNT(a.id_arriendo) >= 3 THEN 'alto'
END AS clasificacion
FROM clientes c
LEFT JOIN arriendos a ON c.rut = a.cliente_rut
GROUP BY c.rut, c.nombre
ORDER BY c.nombre DESC;


-- Clasificar los clientes según  ariendos de 0 y 1 :bajo, arriendo de 1 y 3:medio, 3 o mas arriendos:alto
SELECT 
	c.rut,
	c.nombre,
	COUNT(a.id_arriendo) AS total_arriendos,
CASE
	WHEN COUNT(a.id_arriendo) =  0 THEN 'bajo'
	WHEN COUNT(a.id_arriendo) BETWEEN 1 AND 3 THEN 'medio'
	WHEN COUNT(a.id_arriendo) >= 3 THEN 'alto'
END AS clasificacion
FROM clientes c
LEFT JOIN arriendos a ON c.rut = a.cliente_rut
GROUP BY c.rut, c.nombre
ORDER BY COUNT(*) DESC;





