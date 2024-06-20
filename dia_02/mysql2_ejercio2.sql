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
select distinct apellido1 as Primer_Apellido
from empleado;

-- 3. Lista todas las columnas de la tabla empleado.
select *
from empleado;
-- or...
show COLUMNS
from mysql2_dia02_ejercicio2.empleado;

-- 4. Lista el nombre y los apellidos de todos los empleados.
select nombre as Nombre, apellido1 as Apellido_1, apellido2 as Apellido_2
from empleado;

-- 5. Lista el identificador de los departamentos de los empleados que aparecen en la tabla empleado.
select id_departamento as Identificadores
from empleado
where id_departamento is not null;

-- 6. Lista el identificador de los departamentos de los empleados que aparecen en la tabla
-- empleado, eliminando los identificadores que aparecen repetidos.
select distinct id_departamento as Identificadores
from empleado
where id_departamento is not null;

-- 7. Lista el nombre y apellidos de los empleados en una única columna.
delimiter //
create function Nombre_Apellidos(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
	if apellido2 is null then
    	return CONCAT(nombre," ",apellido1);
	else
		return CONCAT(nombre," ",apellido1," ",apellido2);
	end if;
end//
delimiter ;

select Nombre_Apellidos(e.nombre,e.apellido1,e.apellido2)
from empleado e;

-- 8. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los
-- caracteres en mayúscula.
delimiter //
create function Nombre_Apellidos_Upper(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
	if apellido2 is null then
    	return CONCAT(UPPER(nombre)," ",UPPER(apellido1));
	else
		return CONCAT(UPPER(nombre)," ",UPPER(apellido1)," ",UPPER(apellido2));
	end if;
end//
delimiter ;

select Nombre_Apellidos_Upper(e.nombre,e.apellido1,e.apellido2)
from empleado e;

-- 9. Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los
-- caracteres en minúscula.
delimiter //
create function Nombre_Apellidos_Lower(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
	if apellido2 is null then
    	return CONCAT(Lower(nombre)," ",Lower(apellido1));
	else
		return CONCAT(Lower(nombre)," ",Lower(apellido1)," ",Lower(apellido2));
	end if;
end//
delimiter ;

select Nombre_Apellidos_Lower(e.nombre,e.apellido1,e.apellido2)
from empleado e;

-- 10. Lista el identificador de los empleados junto al nif, pero el nif deberá aparecer en dos
-- columnas, una mostrará únicamente los dígitos del nif y la otra la letra.
DELIMITER // -- BORRAR TODOS LOS NÚMEROS DEL NIF
CREATE FUNCTION nif_text(nif varchar(9)) 
RETURNS varchar(9) deterministic
BEGIN
    DECLARE ctrNumber varchar(50);
    DECLARE finText text default ' ';
    DECLARE sChar varchar(2);
    DECLARE inti INTEGER default 1;
    IF length(nif) > 0 THEN
        WHILE(inti <= length(nif)) DO -- ITERAR EN NIF
            SET sChar= SUBSTRING(nif,inti,1);
            SET ctrNumber= FIND_IN_SET(sChar,'0,1,2,3,4,5,6,7,8,9');

            IF ctrNumber = 0 THEN
               SET finText=CONCAT(finText,sChar);
            ELSE
               SET finText=CONCAT(finText,'');
            END IF;
            SET inti=inti+1;
        END WHILE;
        RETURN finText;
    ELSE
        RETURN '';
    END IF;
END//
DELIMITER ;
DELIMITER // -- BORRAR TODOS LAS LETRAS DEL NIF
CREATE FUNCTION nif_num(nif varchar(9)) 
RETURNS varchar(9) deterministic
BEGIN
    DECLARE ctrNumber varchar(50);
    DECLARE finText text default ' ';
    DECLARE sChar varchar(2);
    DECLARE inti INTEGER default 1;
    IF length(nif) > 0 THEN
        WHILE(inti <= length(nif)) DO -- ITERAR EN NIF
            SET sChar= SUBSTRING(nif,inti,1);
            SET ctrNumber= FIND_IN_SET(sChar,'q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,ñ,z,x,c,v,b,n,m');

            IF ctrNumber = 0 THEN
               SET finText=CONCAT(finText,sChar);
            ELSE
               SET finText=CONCAT(finText,'');
            END IF;
            SET inti=inti+1;
        END WHILE;
        RETURN finText;
    ELSE
        RETURN '';
    END IF;
END//
DELIMITER ;

select id as ID, nif_num(nif) as NIF_Num, nif_text(nif) as NIF_Letter
from empleado
order by id;


-- 11. Lista el nombre de cada departamento y el valor del presupuesto actual del que dispone. Para calcular este dato tendrá
-- que restar al valor del presupuesto inicial (columna presupuesto) los gastos que se han generado (columna gastos). Tenga
-- en cuenta que en algunos casos pueden existir valores negativos. Utilice un alias apropiado para la nueva columna columna
-- que está calculando.


-- 12. Lista el nombre de los departamentos y el valor del presupuesto actual ordenado de forma ascendente.


-- 13. Lista el nombre de todos los departamentos ordenados de forma ascendente.


-- 14. Lista el nombre de todos los departamentos ordenados de forma descendente.


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
