
DROP DATABASE IF EXISTS DataTracksSolutions;
CREATE DATABASE DataTracksSolutions;
USE DataTracksSolutions;

#Creamos las tablas 
#Tabla cliente
CREATE TABLE Clientes(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    sector VARCHAR(100),
    pais VARCHAR(50)
);
	
#Tabla proyectos
CREATE TABLE Proyectos(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    cliente_ID INT,
    FOREIGN KEY(cliente_ID) REFERENCES Clientes(ID)
);
#tabla Empleados 
CREATE TABLE Empleados(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    posicion VARCHAR(100),
    salario DECIMAL(10,2) NOT NULL
);
#tabla de asignaciones 
CREATE TABLE Asignaciones(
	empleado_ID INT,
    proyecto_ID INT,
    horas_asignadas INT,
    rol VARCHAR(100),
    PRIMARY KEY (empleado_ID,proyecto_ID),
    FOREIGN KEY (empleado_ID) REFERENCES Empleados(ID),
    FOREIGN KEY(proyecto_ID) REFERENCES Proyectos(ID)
);
#tabla de finanzas 
CREATE TABLE Finanzas(
	proyecto_ID INT PRIMARY KEY,
    costo_estimado DECIMAL(12,2),
    costo_real DECIMAL(12,2),
	ingresos DECIMAL(12,2),
    FOREIGN KEY (proyecto_ID) REFERENCES Proyectos(ID)
);
SELECT DATABASE();
#INSERTAMOS VALORES A LAS  TABLAS
#insertamos datos a la tabla clientes
INSERT INTO Clientes (nombre, sector, pais) VALUES
('TechCorp', 'Tecnología', 'Perú'),
('GreenLife', 'Energía Renovable', 'Chile'),
('FinSecure', 'Finanzas', 'México');

#inserta,ps datos a  la tabla proyectos 
INSERT INTO Proyectos (nombre, fecha_inicio, fecha_fin, cliente_ID) values
("Plataforma de datos","2025-01-10","2025-06-30",1),
("Sistema de  energia solar","2025-02-01",NULL,2),
("Analisis financiero AI","2025-03-15","2025-12-31",3);

#Insertamos datos a  la  tabla Empleados
INSERT INTO Empleados(nombre,posicion,salario)VALUES
("Ana Torres","Analista de datos",3500.00),
("Luis Perez","Cientifico de datos",500.00),
("Maria Gomez","Project Manager",6000.00),
("Carlos Rojas","Ingeniero de sofware",4000.00);

#Insertamos datos a la tabla de asignaciones 
INSERT INTO Asignaciones (empleado_ID, proyecto_ID, horas_asignadas, rol) VALUES
(1, 1, 120, 'Analista'),
(2, 1, 150, 'Data Scientist'),
(3, 1, 80, 'Gerente'),
(4, 2, 200, 'Desarrollador'),
(1, 3, 100, 'Analista'),
(2, 3, 160, 'Data Scientist');
#Insertamos datos a la tabla finanzas
INSERT INTO Finanzas (proyecto_ID, costo_estimado, costo_real, ingresos) VALUES
(1, 50000, 52000, 80000),
(2, 70000, 65000, 120000),
(3, 90000, 95000, 150000);

#1.	Lista de proyectos en curso,
# incluyendo el nombre del cliente y el país, ordenados por fecha de inicio.
SELECT
  p.ID AS proyecto_id,
  p.nombre AS nombre_proyecto,
  p.fecha_inicio,
  p.fecha_fin,
  c.ID AS cliente_id,
  c.nombre AS nombre_cliente,
  c.pais AS cliente_pais
FROM Proyectos p
JOIN Clientes c ON p.cliente_ID = c.ID
WHERE p.fecha_inicio <= CURDATE()
  AND (p.fecha_fin IS NULL OR p.fecha_fin >= CURDATE())
ORDER BY p.fecha_inicio;

#2.	Información de los empleados asignados a cada proyecto, 
#   mostrando el total de horas asignadas y el rol en el proyecto
SELECT 
	p.ID AS proyectos_id,
    p.nombre AS nombre_proyecto,
    e.ID AS empleado_id,
    e.nombre AS nombre_empleado,
    e.posicion,
    SUM(a.horas_asignadas) AS total_horas_asignadas,
    GROUP_CONCAT(DISTINCT a.rol ORDER BY a.rol SEPARATOR ', ') AS roles
FROM Proyectos p
JOIN Asignaciones a ON a.proyecto_ID = p.ID
JOIN Empleados e ON e.ID = a.empleado_ID
GROUP BY p.ID, e.ID
ORDER BY p.ID, total_horas_asignadas DESC;
#3 3.	Informe financiero de cada proyecto, que incluya el costo estimado, costo real, y la diferencia entre ambos.
SELECT
  p.ID AS proyecto_id,
  p.nombre AS nombre_proyecto,
  f.costo_estimado,
  f.costo_real,
  (f.costo_real - f.costo_estimado) AS diferencia,
  f.ingresos
FROM Proyectos p
JOIN Finanzas f ON f.proyecto_ID = p.ID
ORDER BY p.ID;
#4 4.	Salarios totales asignados por proyecto, agrupados por posición de los empleados.
SELECT
  p.ID AS proyecto_id,
  p.nombre AS nombre_proyecto,
  e.posicion,
  COUNT(DISTINCT e.ID) AS cantidad_empleados,
  SUM(e.salario) AS total_salarios_por_posicion
FROM Proyectos p
JOIN (
    SELECT DISTINCT proyecto_ID, empleado_ID
    FROM Asignaciones
) da ON da.proyecto_ID = p.ID
JOIN Empleados e ON e.ID = da.empleado_ID
GROUP BY p.ID, e.posicion
ORDER BY p.ID, total_salarios_por_posicion DESC;

#implementacion de transacciones y control de concurrencia
DELIMITER $$
CREATE PROCEDURE actualizar_finanzas_proyecto(
    IN p_proyecto_id INT,
    IN p_nuevo_costo_real DECIMAL(12,2),
    IN p_nuevos_ingresos DECIMAL(12,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Bloquea la fila de Finanzas para este proyecto (control de concurrencia)
    SELECT costo_real
    FROM Finanzas
    WHERE proyecto_ID = p_proyecto_id
    FOR UPDATE;
    -- Actualiza
    UPDATE Finanzas
    SET costo_real = p_nuevo_costo_real,
        ingresos = p_nuevos_ingresos
    WHERE proyecto_ID = p_proyecto_id;
    COMMIT;
END$$
DELIMITER ;
SHOW PROCEDURE STATUS
WHERE Db = 'DataTracksSolutions';
#CONTROL DE ACCESO
#CREAMOS VISTAS SIN INFORMACION FINANCIERA
CREATE VIEW vista_gerentes_proyecto AS
SELECT
  p.ID AS proyecto_id,
  p.nombre AS nombre_proyecto,
  p.fecha_inicio,
  p.fecha_fin,
  c.ID AS cliente_id,
  c.nombre AS nombre_cliente,
  c.pais AS cliente_pais,
  a.empleado_ID,
  e.nombre AS nombre_empleado,
  e.posicion,
  a.horas_asignadas,
  a.rol
FROM Proyectos p
JOIN Clientes c ON p.cliente_ID = c.ID
LEFT JOIN Asignaciones a ON a.proyecto_ID = p.ID
LEFT JOIN Empleados e ON e.ID = a.empleado_ID;

#VISTA PARA  EL DEPARTAMENTO FINANCIERO 
CREATE VIEW vista_finanzas_proyecto AS
SELECT
  p.ID AS proyecto_id,
  p.nombre AS nombre_proyecto,
  p.fecha_inicio,
  p.fecha_fin,
  f.costo_estimado,
  f.costo_real,
  f.ingresos,
  (f.costo_real - f.costo_estimado) AS diferencia
FROM Proyectos p
JOIN Finanzas f ON f.proyecto_ID = p.ID;
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

    
    
