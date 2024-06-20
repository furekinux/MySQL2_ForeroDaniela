-- ############################
-- #### Dia 02 - Ejercicio ####
-- ############################

-- Crear base de datos
CREATE DATABASE mysql2_dia02_ejercicio2;
USE mysql2_dia02_ejercicio2;

-- Tabla de departamento
CREATE TABLE departamento (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
presupuesto DOUBLE UNSIGNED NOT NULL,
gastos DOUBLE UNSIGNED NOT NULL
);

-- Tabla de empleadp
CREATE TABLE empleado (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nif VARCHAR(9) NOT NULL UNIQUE,
nombre VARCHAR(100) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
id_departamento INT UNSIGNED,
FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- 1. Lista el primer apellido de todos los empleados.
select apellido1 as Primer_Apellido
from empleado;

-- 2. Lista el primer apellido de los empleados eliminando los apellidos que estén repetidos.


-- 3. Lista todas las columnas de la tabla empleado.


-- 4. Lista el nombre y los apellidos de todos los empleados.


-- 5. Lista el identificador de los departamentos de los empleados que aparecen en la tabla empleado.


-- 6. Lista el identificador de los departamentos de los empleados que aparecen en la tabla
-- empleado, eliminando los identificadores que aparecen repetidos.


-- 7. Lista el nombre y apellidos de los empleados en una única columna.


-- 8. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los
-- caracteres en mayúscula.


-- 9. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los
-- caracteres en minúscula.


-- 10. Lista el identificador de los empleados junto al nif, pero el nif deberá aparecer en dos
-- columnas, una mostrará únicamente los dígitos del nif y la otra la letra.


-- Insertar información departamento
INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);

-- Insertar información empleado
INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero',
NULL);

-- Desarrollado por Daniela Forero / ID 1.142.714.225
