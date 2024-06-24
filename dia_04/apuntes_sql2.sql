-- ############################
-- ######## DIA 3 - MySQL2 #########
-- ############################
show databases;
create database mysql2_dia04;
use mysql2_dia04;

-- Creación de usuarios con acceso desde cualquier parte
create user 'camper'@'%' identified by 'campus2023';

-- VER PERMISOS DE USUARIO ESPECIFICO
show grants for 'camper'@'%';
-- Permite acceder pero no tiene permiso completo!!!

-- Crear tabla de personas
create table persona (
	id int primary key,
    nombre varchar(255),
    apellido varchar(255)
);
insert into persona (id,nombre,apellido) values
	(1,'Juan','Perez'),
    (2,'Andres','Pastrana'),
    (3,'Pedro','Gómez'),
    (4,'Camilo','Gonzales'),
    (5,'Stiven','Maldonado'),
    (6,'Ardila','Perez'),
    (7,'Ruben','Gómez'),
    (8,'Andres','Portilla'),
    (9,'Miguel','Carvajal'),
    (10,'Andrea','Gómez');

-- Asignar permisos a usuario para que acceda a la tabla y BBDD
grant select on mysql2_dia04.persona to 'camper'@'%';
flush privileges; -- Refrescar base de datos!!!

-- Permitir CRUD:
grant update, insert, delete on mysql2_dia04.persona to 'camper'@'%';
-- ELIMINAR PERMITE BORRAR INFO PERO NOO TABLAS


-- OTRA TABLA
create table persona2 (
	id int primary key,
    nombre varchar(255),
    apellido varchar(255)
);
insert into persona2 (id,nombre,apellido) values (1,'Juan','Perez');
insert into persona2 (id,nombre,apellido) values (2,'Andres','Pastrana');
insert into persona2 (id,nombre,apellido) values (3,'Pedro','Gómez');
insert into persona2 (id,nombre,apellido) values (4,'Camilo','Gonzales');
insert into persona2 (id,nombre,apellido) values (5,'Stiven','Maldonado');
insert into persona2 (id,nombre,apellido) values (6,'Ardila','Perez');
insert into persona2 (id,nombre,apellido) values (7,'Ruben','Gonzales');
insert into persona2 (id,nombre,apellido) values (8,'Andres','Portilla');
insert into persona2 (id,nombre,apellido) values (9,'Johlver','Carvajal');
insert into persona2 (id,nombre,apellido) values (10,'Andrea','Gómez');

-- PELIGRO (NO HACER) CREAR USUARIO CON PERMISOS A TOOOOODO DESDE
-- CUALQUIER IP CON MALA CONTRASEÑA
create user 'todito'@'%' identified by 'todo';

grant all on *.* to 'todito'@'%'; -- HISSSSSSSSSSSSSS
-- (Acceso a todo a todo literalmente base de datos y tablas)
show grants for 'todito'@'%';

-- QUITAR PERMISOS
revoke all on *.* from 'todito'@'%'; -- CONFIAR CONSOLSA IGNORAR LA EQUIS X

-- ELIMINAR USUARIOS
drop user 'todito'@'%';

-- Crear un límite para que solamente se hagan x cantidad especifica de consultas por hora
alter user *.* to 'camper'@'%' with MAX_QUERIES_PER_HOUR 5;
flush privileges;
-- alter user *.* to 'camper'@'%' with MAX_QUERIES_PER_HOUR 0;

-- REVISAR LIMITES O PERMISOS QUE TIENE EL USUARIO A NIVEL DE MOTOR
select * from mysql.user;
select * from mysql.user where Host='%';

-- PERMISOS PARA QUE CONSULTE DE UNA BASE DE DATOS, DE UNA TABLA, DE UNA COLUMNA
revoke all on *.* from 'camper'@'%';
grant select (nombre) on mysql2_dia04.persona to 'camper'@'%';
