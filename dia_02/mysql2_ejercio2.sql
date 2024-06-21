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
delimiter //
create procedure Primer_Apellido()
begin
	select apellido1 as Primer_Apellido
	from empleado;
end //
delimiter ;

call Primer_Apellido();

-- 2. Lista el primer apellido de los empleados eliminando los apellidos que estén repetidos.
delimiter //
create procedure Primer_Apellido_Dist()
begin
	select distinct apellido1 as Primer_Apellido
	from empleado;
end //
delimiter ;
call Primer_Apellido_Dist();

-- 3. Lista todas las columnas de la tabla empleado.
delimiter //
create procedure E_Columns()
begin
	select *
	from empleado;
end //
delimiter ;
call E_Columns();
-- or...
delimiter //
create procedure E_Columns_Lit()
begin
	show COLUMNS
	from mysql2_dia02_ejercicio2.empleado;
end //
delimiter ;
call E_Columns_Lit();

-- 4. Lista el nombre y los apellidos de todos los empleados.
delimiter //
create procedure Nom_Ape_E()
begin
	select nombre as Nombre, apellido1 as Apellido_1, apellido2 as Apellido_2
	from empleado;
end //
delimiter ;
call Nom_Ape_E();

-- 5. Lista el identificador de los departamentos de los empleados que aparecen en la tabla empleado.
delimiter //
create procedure Dep()
begin
	select id_departamento as Identificadores
	from empleado
	where id_departamento is not null;
end //
delimiter ;
call Dep();

-- 6. Lista el identificador de los departamentos de los empleados que aparecen en la tabla
-- empleado, eliminando los identificadores que aparecen repetidos.
delimiter //
create procedure Dep_Dist()
begin
	select distinct id_departamento as Identificadores
	from empleado
	where id_departamento is not null;
end //
delimiter ;
call Dep_Dist();

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

delimiter //
create procedure Nom_Ape_Concat()
begin
	select Nombre_Apellidos(e.nombre,e.apellido1,e.apellido2)
	from empleado e;
end //
delimiter ;
call Nom_Ape_Concat();

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

delimiter //
create procedure Nom_Ape_Concat_Up()
begin
	select Nombre_Apellidos_Upper(e.nombre,e.apellido1,e.apellido2)
	from empleado e;
end //
delimiter ;
call Nom_Ape_Concat_Up();

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

delimiter //
create procedure Nom_Ape_Concat_Lo()
begin
	select Nombre_Apellidos_Lower(e.nombre,e.apellido1,e.apellido2)
	from empleado e;
end //
delimiter ;
call Nom_Ape_Concat_Lo();

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

delimiter //
create procedure E_Nif_Col2()
begin
	select id as ID, nif_num(nif) as NIF_Num, nif_text(nif) as NIF_Letter
	from empleado
	order by id;
end //
delimiter ;
call E_Nif_Col2();


-- 11. Lista el nombre de cada departamento y el valor del presupuesto actual del que dispone. Para calcular este dato tendrá
-- que restar al valor del presupuesto inicial (columna presupuesto) los gastos que se han generado (columna gastos). Tenga
-- en cuenta que en algunos casos pueden existir valores negativos. Utilice un alias apropiado para la nueva columna columna
-- que está calculando.
delimiter //
create function presuesto_actual(presupuesto DOUBLE, gastos DOUBLE)
returns DOUBLE deterministic
begin
	return presupuesto-gastos;
end//
delimiter ;

delimiter //
create procedure Dep_PresupAct()
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	order by presupuesto;
end //
delimiter ;
call Dep_PresupAct();

-- 12. Lista el nombre de los departamentos y el valor del presupuesto actual ordenado de forma ascendente.
delimiter //
create procedure Dep_PresupAct_Asc()
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	order by presupuesto asc;
end //
delimiter ;
call Dep_PresupAct_Asc();

-- 13. Lista el nombre de todos los departamentos ordenados de forma ascendente.
delimiter //
create procedure Dep_Nom_Asc()
begin
	select nombre
	from departamento
	order by nombre asc;
end //
delimiter ;
call Dep_Nom_Asc();

-- 14. Lista el nombre de todos los departamentos ordenados de forma descendente.
delimiter //
create procedure Dep_Nom_Desc()
begin
	select nombre
	from departamento
	order by nombre desc;
end //
delimiter ;
call Dep_Nom_Desc();

-- 15. Lista los apellidos y el nombre de todos los empleados, ordenados de forma alfabética tendiendo en cuenta en primer lugar sus apellidos y luego su nombre.
delimiter //
create function Apellidos_Nombre(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
	if apellido2 is null then
    	return CONCAT(apellido1," ",nombre);
	else
		return CONCAT(apellido2," ",apellido1," ",nombre);
	end if;
end//
delimiter ;

delimiter //
create procedure E_Ape_Nom()
begin
	select Apellidos_Nombre(nombre,apellido1,apellido2) as Nombre_Completo
	from empleado
	order by Nombre_Completo asc;
end //
delimiter ;
call E_Ape_Nom();

-- 16. Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen mayor presupuesto.
delimiter //
create procedure Dep_PresAct_Top3_Des()
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	order by Presupuesto_Actual desc
	limit 3;
end //
delimiter ;
call Dep_PresAct_Top3_Des();

-- 17. Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen menor presupuesto.
delimiter //
create procedure Dep_PresAct_Top3_Asc()
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	order by Presupuesto_Actual asc
	limit 3;
end //
delimiter ;
call Dep_PresAct_Top3_Asc();

-- 18. Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen mayor gasto.
delimiter //
create procedure Dep_PresAct_Gastos_Top3_Des()
begin
	select nombre as Departamento, gastos as Gastos
	from departamento
	order by Gastos desc
	limit 3;
end //
delimiter ;
call Dep_PresAct_Gastos_Top3_Des();

-- 19. Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen menor gasto.
delimiter //
create procedure Dep_PresAct_Gastos_Top3_Asc()
begin
	select nombre as Departamento, gastos as Gastos
	from departamento
	order by Gastos asc
	limit 3;
end //
delimiter ;
call Dep_PresAct_Gastos_Top3_Asc();

-- 20. Devuelve una lista con 5 filas a partir de la tercera fila de la tabla empleado. La tercera fila se debe incluir en la
-- respuesta. La respuesta debe incluir todas las columnas de la tabla empleado.

-- 21. Devuelve una lista con el nombre de los departamentos y el presupuesto, de aquellos que tienen un presupuesto mayor o igual a 150000 euros.
delimiter //
create procedure Dep_PresAct_MayorIgual(in mayor_igual decimal(10,2))
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	where presuesto_actual(presupuesto, gastos) >= mayor_igual;
end //
delimiter ;
call Dep_PresAct_MayorIgual(150000);

-- 22. Devuelve una lista con el nombre de los departamentos y el gasto, de aquellos que tienen menos de 5000 euros de gastos.
delimiter //
create procedure Dep_Gast_Menor(in menor decimal(10,2))
begin
	select nombre as Departamento, gastos as Gastos
	from departamento
	where gastos < menor;
end //
delimiter ;
call Dep_Gast_Menor(5000);

-- 23. Devuelve una lista con el nombre de los departamentos y el presupuesto, de aquellos que tienen un presupuesto entre
-- 100000 y 200000 euros. Sin utilizar el operador BETWEEN.
delimiter //
create procedure Dep_Pres_betwnobetw(in less_than decimal(10,2),in higher_than decimal(10,2))
begin
	select nombre as Departamento, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	where presuesto_actual(presupuesto, gastos) < less_than and presuesto_actual(presupuesto, gastos) > higher_than;
end //
delimiter ;
call Dep_Pres_betwnobetw(200000,100000);

-- 24. Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. Sin
-- utilizar el operador BETWEEN.
delimiter //
create procedure Dep_Pres_betwnobetw_diff(in less_than decimal(10,2),in higher_than decimal(10,2))
begin
	select nombre as Departamento
	from departamento
	where presuesto_actual(presupuesto, gastos) > higher_than
	union
	select nombre as Departamento
	from departamento
	where presuesto_actual(presupuesto, gastos) < less_than;
end //
delimiter ;
call Dep_Pres_betwnobetw_diff(100000,200000);

-- 25. Devuelve una lista con el nombre de los departamentos que tienen un presupuesto entre 100000 y 200000 euros. Utilizando
-- el operador BETWEEN.
delimiter //
create procedure Dep_Pres_between(in a int,in b int)
begin
	select nombre as Departamento
	from departamento d
	where presuesto_actual(d.presupuesto, d.gastos) BETWEEN a AND b;
end //
delimiter ;
call Dep_Pres_between(100000,200000);

-- 26. Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. Utilizando
-- el operador BETWEEN.
delimiter //
create procedure Dep_Pres_between_diff(in a int,in b int)
begin
	select nombre as Departamento
	from departamento d
	where presuesto_actual(d.presupuesto, d.gastos) not BETWEEN a AND b;
end //
delimiter ;
call Dep_Pres_between_diff(100000,200000);

-- 27. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos donde los gastos
-- sean mayores que el presupuesto del que disponen.
delimiter //
create procedure Dep_Gast_Mayorque_Pres()
begin
	select nombre as Departamento, gastos as Gastos, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	where presuesto_actual(presupuesto, gastos)<gastos;
end //
delimiter ;
call Dep_Gast_Mayorque_Pres();

-- 28. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos donde los gastos
-- sean menores que el presupuesto del que disponen.
delimiter //
create procedure Dep_Gast_minque_Pres()
begin
	select nombre as Departamento, gastos as Gastos, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	where presuesto_actual(presupuesto, gastos)>gastos;
end //
delimiter ;
call Dep_Gast_minque_Pres();

-- 29. Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos donde los gastos
-- sean iguales al presupuesto del que disponen.
delimiter //
create procedure Dep_Gast_igual_Pres()
begin
	select nombre as Departamento, gastos as Gastos, presuesto_actual(presupuesto, gastos) as Presupuesto_Actual
	from departamento
	where presuesto_actual(presupuesto, gastos)=gastos;
end //
delimiter ;
call Dep_Gast_igual_Pres();

-- 30. Lista todos los datos de los empleados cuyo segundo apellido sea NULL.
delimiter //
create procedure E_Ape_Null()
begin
	select *
	from empleado
	where apellido2 is null;
end //
delimiter ;
call E_Ape_Null();

-- 31. Lista todos los datos de los empleados cuyo segundo apellido no sea NULL.
delimiter //
create procedure E_Ape_NotNull()
begin
	select *
	from empleado
	where apellido2 is not null;
end //
delimiter ;
call E_Ape_NotNull();

-- 32. Lista todos los datos de los empleados cuyo segundo apellido sea López.
delimiter //
create procedure E_Ape2_Busc(in ape2 varchar(255))
begin
	select *
	from empleado
	where apellido2=ape2;
end //
delimiter ;
call E_Ape2_Busc('López');

-- 33. Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno. Sin utilizar el operador IN.
delimiter //
create procedure E_Ape2_Busc2(in ape2_1 varchar(255),in ape2_2 varchar(255))
begin
	select *
	from empleado
	where apellido2=ape2_1 or apellido2=ape2_2;
end //
delimiter ;
call E_Ape2_Busc2('Díaz','Moreno');

-- 34. Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno. Utilizando el operador IN.
delimiter //
create procedure E_Ape2_Busc2_In(in ape2_1 varchar(255),in ape2_2 varchar(255))
begin
	select *
	from empleado
	where apellido2 in (ape2_1,ape2_2);
end //
delimiter ;
call E_Ape2_Busc2_In('Díaz','Moreno');

-- 35. Lista los nombres, apellidos y nif de los empleados que trabajan en el departamento 3.
create procedure E_Info_Dep_Busc(in dep int)
begin
	select nombre as Nombre, apellido1 as Apellido_1, apellido2 as Apellido_2, nif as NIF
	from empleado
	where id_departamento = dep;
end //
delimiter ;
call E_Info_Dep_Busc(3);

-- 36. Lista los nombres, apellidos y nif de los empleados que trabajan en los departamentos 2, 4 o 5.
delimiter //
create procedure E_Info_Dep_Busc3(in a int,in b int,in c int)
begin
	select nombre, apellido1, apellido2, nif
	from empleado
	where id_departamento in (a,b,c);
end //
delimiter ;
call E_Info_Dep_Busc3(2,4,5);

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
