-- ################################
-- ##### DIA 04 - AUTORENTAL ######
-- ################################

create database mysql2_d04;
use mysql2_d04;

create table sucursal(
    id int primary key auto_increment not null,
    ciudad varchar(100) not null,
    direccion varchar(100) not null,
    telefono varchar(15) not null,
    celular varchar(15) not null,
    email varchar(200) not null
);

create table cliente(
    id int primary key auto_increment not null,
    cedula varchar(10) not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    direccion varchar(100) not null,
    ciudad varchar(100) not null,
    celular varchar(15) not null,
    email varchar(200) not null
);

create table vehiculo(
	id int primary key auto_increment not null,
    tipo enum("Sedán", "Compacto", "Camioneta Platón", "Camioneta lujo", "Deportivo") not null,
    placha varchar(7) not null,
    referencia varchar(100) not null,
    modelo YEAR not null,
    puertas tinyint(1) not null,
    capacidad varchar(50) not null,
    sunroof enum("Tiene","No tiene"),
    motor varchar(50) not null,
    color varchar(25) not null
);

create table empleado(
    id int primary key auto_increment not null,
    id_sucursal int,
    foreign key(id_sucursal)references sucursal(id),
    cedula varchar(10) not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    direccion varchar(100) not null,
    ciudad varchar(100) not null,
    celular varchar(15) not null,
    email varchar(200) not null
);

create table alquiler(
    id int primary key auto_increment not null,
    id_vehiculo int not null,
    foreign key(id_vehiculo)references vehiculo(id),
    id_cliente int not null,
    foreign key(id_cliente)references cliente(id),
    id_empleado int not null,
    foreign key(id_empleado)references empleado(id),
    id_sucursal_salida int not null,
    foreign key(id_sucursal_salida)references sucursal(id),
    fecha_salida DATE not null,
    id_sucursal_llegada int not null,
    foreign key(id_sucursal_llegada)references sucursal(id),
    fecha_llegada DATE,
    fecha_esperada_llegada DATE not null,
    valor_semana decimal(10,2),
    valor_dia decimal(10,2),
    descuento float,
    valor_cotizado decimal(10,2),
    valor_pagado decimal(10,2)
);

-- ######## Procedimientos ########

-- Ver listado de alquiler
delimiter //
create procedure listado_alquiler()
begin
	-- Consulta para historial
	select distinct id_vehiculo as ID_Vehiculo, concat(c.nombres," ",c.apellidos) as Cliente, concat(e.nombres," ",e.apellidos) as Empleado,
	s.ciudad as Salida_de, fecha_salida as Salida, s2.ciudad as Llega_a, fecha_llegada as Llegada, fecha_esperada_llegada as Fecha_esperada
	from alquiler a
	inner join empleado e on e.id = a.id_empleado
	inner join cliente c on c.id = a.id_cliente
	inner join sucursal s on s.id = a.id_sucursal_salida
	inner join sucursal s2 on s2.id = a.id_sucursal_llegada
	order by id_vehiculo;
end //
delimiter ;
call listado_alquiler();


delimiter //
create procedure listado_vehiculos_disponibles(in tipoV varchar(255))
begin
	-- Consulta para disponibilidad de vehiculos de acuerdo al tipo
	select distinct v.*
	from vehiculo v
	left join alquiler a on v.id = a.id_vehiculo
	where a.id_vehiculo is null and v.tipo=tipoV
	union
	select distinct v.*
	from vehiculo v
	left join alquiler a on v.id = a.id_vehiculo
	where DATE_FORMAT(a.fecha_llegada, "%Y %M %d") > CAST(CURRENT_TIMESTAMP AS DATE) and v.tipo=tipoV
	order by id;
end //
delimiter ;
call listado_vehiculos_disponibles("Sedán");


delimiter //
create procedure disponible_fecha(in idvehiculo int)
begin
	-- Información de disponibiliad según id
	select distinct a.id, a.id_vehiculo, v.tipo, v.placa, v.referencia, a.fecha_salida,a.fecha_esperada_llegada
	from vehiculo v
	left join alquiler a on v.id = a.id_vehiculo
	where a.id_vehiculo=idvehiculo
	order by id;
end //
delimiter ;
call disponible_fecha(8);


delimiter //
create procedure nuevo_cliente(in ce varchar(10),in nom varchar(100),
in apel varchar(100),in direc varchar(100),in ciu varchar(100),in cel varchar(15),in ema varchar(200))
begin
	declare newid int;
	insert into cliente(cedula,nombres,apellidos,direccion,ciudad,celular,email)
	values (ce,nom, apel,direc,ciu,cel,ema);
	select * from cliente
	where cedula = ce;
end //
delimiter ;
call nuevo_cliente("1299978900","pan de queso","jiji","narnia","perukistan","666","AAA@gmail.com");


delimiter //
create procedure listado_vehiculos()
begin
	select id as Identificador, tipo as Tipo, placa as Placa, referencia as Referencia,
    modelo as Modelo, puertas as Nº_Puertas, capacidad as Capacidad, sunroof as Sunroof,
    motor as Motor, color as Color
    from vehiculo;
end //
delimiter ;
call listado_vehiculos();


-- EMPLEADO - PERMISOS
create user 'empleado'@'%' identified by 'employee';
grant select on mysql2_d04.alquiler to 'empleado'@'%';
grant EXECUTE ON PROCEDURE listado_alquiler to 'empleado'@'%';
grant EXECUTE ON PROCEDURE listado_vehiculos_disponibles to 'empleado'@'%';
grant EXECUTE ON PROCEDURE disponible_fecha to 'empleado'@'%';
grant EXECUTE ON PROCEDURE nuevo_cliente to 'empleado'@'%';
grant EXECUTE ON PROCEDURE listado_vehiculos to 'empleado'@'%';

-- Revisiones
select * from mysql.user where Host='%';
show grants for 'empleado'@'%';
flush privileges; -- Refrescar

-- Revisión de las inserciones
select id_sucursal
from empleado a
order by id_sucursal;

-- Inserciones sucursal
INSERT INTO sucursal (ciudad, direccion, telefono, celular, email) VALUES
('Bogotá', 'Calle 123 # 456-789', '1101234567', '3112345678', 'autorental.bogota@gmail.com'),
('Medellín', 'Carrera 456 # 789-123', '4212345678', '3223456789', 'autorental.medellin@gmail.com'),
('Cali', 'Avenida 789 # 123-456', '2312345678', '3334567890', 'autorental.cali@gmail.com'),
('Barranquilla', 'Calle 987 # 654-321', '5412345678', '3445678901', 'autorental.barranquilla@gmail.com'),
('Cartagena', 'Carrera 654 # 321-987', '6512345678', '3556789012', 'autorental.cartagena@gmail.com');

-- Inserciones alquiler
INSERT INTO alquiler (id_vehiculo, id_cliente, id_empleado, id_sucursal_salida, fecha_salida, id_sucursal_llegada, fecha_llegada, fecha_esperada_llegada, valor_semana, valor_dia, descuento, valor_cotizado, valor_pagado)
VALUES
(10, 25, 50, 3, '2023-06-10', 4, '2023-06-13', '2023-06-15', 200.00, 28.50, 0.15, 570.00, 484.50),
(23, 36, 78, 5, '2023-07-15', 1, '2023-07-18', '2023-07-20', 225.00, 32.00, NULL, 620.00, 620.00),
(17, 15, 62, 2, '2023-08-20', 3, '2023-08-23', '2023-08-25', 210.00, 30.00, 0.1, 580.00, 522.00),
(31, 42, 89, 4, '2023-09-05', 2, '2023-09-08', '2023-09-10', 240.00, 34.00, NULL, 670.00, 670.00),
(45, 54, 73, 1, '2023-10-18', 5, '2023-10-21', '2023-10-23', 260.00, 36.50, 0.2, 720.00, 576.00),
(8, 12, 29, 3, '2023-11-12', 4, '2023-11-15', '2023-11-17', 190.00, 27.00, NULL, 520.00, 520.00),
(5, 7, 18, 5, '2023-12-08', 1, '2023-12-11', '2023-12-13', 175.00, 25.00, 0.12, 480.00, 422.40),
(37, 47, 83, 2, '2024-01-20', 3, '2024-01-23', '2024-01-25', 250.00, 35.00, NULL, 700.00, 700.00),
(14, 21, 55, 4, '2024-02-05', 2, '2024-02-08', '2024-02-10', 220.00, 31.00, 0.18, 600.00, 492.00),
(2, 5, 11, 1, '2024-03-10', 5, '2024-03-13', '2024-03-15', 195.00, 28.00, NULL, 560.00, 560.00),
(19, 32, 65, 3, '2024-04-15', 4, '2024-04-18', '2024-04-20', 230.00, 33.00, NULL, 660.00, 660.00),
(41, 49, 92, 5, '2024-05-20', 1, '2024-05-23', '2024-05-25', 255.00, 36.50, 0.2, 710.00, 568.00),
(28, 28, 79, 2, '2024-06-10', 3, '2024-06-13', '2024-06-15', 240.00, 34.00, NULL, 670.00, 670.00),
(50, 58, 95, 4, '2024-07-05', 2, '2024-07-08', '2024-07-10', 280.00, 40.00, NULL, 800.00, 800.00),
(13, 18, 57, 1, '2024-08-10', 5, '2024-08-13', '2024-08-15', 215.00, 30.50, 0.15, 590.00, 501.50),
(26, 37, 80, 3, '2024-09-15', 4, '2024-09-18', '2024-09-20', 250.00, 35.00, NULL, 700.00, 700.00),
(47, 55, 76, 5, '2024-10-10', 1, '2024-10-13', '2024-10-15', 270.00, 38.50, 0.22, 770.00, 600.60),
(9, 14, 31, 2, '2024-11-05', 3, '2024-11-08', '2024-11-10', 200.00, 29.00, NULL, 580.00, 580.00),
(24, 39, 67, 4, '2024-12-01', 2, '2024-12-04', '2024-12-06', 225.00, 32.50, 0.18, 620.00, 508.40),
(16, 23, 60, 1, '2025-01-15', 5, '2025-01-18', '2025-01-20', 230.00, 33.00, NULL, 660.00, 660.00),
(38, 51, 88, 3, '2025-02-20', 4, '2025-02-23', '2025-02-25', 255.00, 36.50, 0.2, 710.00, 568.00),
(6, 8, 22, 5, '2025-03-10', 1, '2025-03-13', '2025-03-15', 180.00, 26.00, NULL, 500.00, 500.00),
(30, 45, 84, 2, '2025-04-15', 3, '2025-04-18', '2025-04-20', 245.00, 35.00, NULL, 690.00, 690.00),
(22, 35, 72, 4, '2025-05-20', 2, '2025-05-23', '2025-05-25', 235.00, 33.50, 0.18, 670.00, 549.40),
(4, 6, 16, 1, '2025-06-10', 5, '2025-06-13', '2025-06-15', 175.00, 25.00, NULL, 480.00, 480.00),
(40, 53, 93, 3, '2025-07-05', 4, '2025-07-08', '2025-07-10', 260.00, 37.00, 0.25, 740.00, 555.00),
(11, 17, 38, 5, '2025-08-10', 1, '2025-08-13', '2025-08-15', 205.00, 29.50, NULL, 590.00, 590.00),
(35, 49, 87, 2, '2025-09-15', 3, '2025-09-18', '2025-09-20', 250.00, 35.00, 0.2, 700.00, 560.00),
(18, 29, 64, 4, '2025-10-20', 2, '2025-10-23', '2025-10-25', 225.00, 32.00, NULL, 620.00, 620.00),
(48, 57, 91, 1, '2025-11-15', 5, '2025-11-18', '2025-11-20', 275.00, 39.00, 0.22, 790.00, 615.80),
(29, 41, 82, 3, '2025-12-10', 4, '2025-12-13', '2025-12-15', 240.00, 34.50, NULL, 670.00, 670.00),
(7, 10, 24, 5, '2026-01-05', 1, '2026-01-08', '2026-01-10', 185.00, 27.00, 0.12, 510.00, 448.80),
(32, 46, 85, 2, '2026-02-10', 3, '2026-02-13', '2026-02-15', 245.00, 35.00, NULL, 690.00, 690.00),
(15, 26, 59, 4, '2026-03-15', 2, '2026-03-18', '2026-03-20', 220.00, 31.50, 0.18, 600.00, 492.00),
(3, 4, 14, 1, '2026-04-20', 5, '2026-04-23', '2026-04-25', 170.00, 24.50, NULL, 460.00, 460.00),
(42, 52, 90, 3, '2026-05-10', 4, '2026-05-13', '2026-05-15', 265.00, 38.00, 0.25, 750.00, 562.50),
(25, 38, 81, 5, '2026-06-15', 1, '2026-06-18', '2026-06-20', 230.00, 33.00, NULL, 660.00, 660.00),
(12, 19, 44, 2, '2026-07-10', 3, '2026-07-13', '2026-07-15', 210.00, 30.00, 0.15, 580.00, 493.00),
(46, 56, 77, 4, '2026-08-20', 2, '2026-08-23', '2026-08-25', 270.00, 38.50, 0.22, 770.00, 600.60),
(21, 34, 70, 1, '2026-09-25', 5, '2026-09-28', '2026-09-30', 235.00, 34.00, NULL, 670.00, 670.00),
(39, 50, 86, 3, '2026-10-10', 4, '2026-10-13', '2026-10-15', 255.00, 36.50, 0.2, 710.00, 568.00),
(1, 1, 3, 5, '2026-11-15', 1, '2026-11-18', '2026-11-20', 180.00, 26.00, NULL, 500.00, 500.00),
(27, 40, 80, 2, '2026-12-20', 3, '2026-12-23', '2026-12-25', 235.00, 33.50, 0.18, 670.00, 549.40),
(44, 55, 92, 4, '2027-01-10', 2, '2027-01-13', '2027-01-15', 270.00, 38.50, 0.25, 770.00, 577.50),
(20, 33, 68, 1, '2027-02-15', 5, '2027-02-18', '2027-02-20', 225.00, 32.00, NULL, 620.00, 620.00),
(34, 48, 89, 3, '2027-03-10', 4, '2027-03-13', '2027-03-15', 250.00, 35.50, 0.2, 700.00, 560.00),
(49, 59, 94, 5, '2027-04-20', 1, '2027-04-23', '2027-04-25', 280.00, 40.00, NULL, 800.00, 800.00),
(4, 2, 7, 2, '2027-05-25', 3, '2027-05-28', '2027-05-30', 175.00, 25.00, 0.12, 480.00, 422.40),
(33, 47, 85, 4, '2027-06-10', 2, '2027-06-13', '2027-06-15', 245.00, 35.00, NULL, 690.00, 690.00),
(18, 30, 63, 1, '2027-07-15', 5, '2027-07-18', '2027-07-20', 220.00, 31.50, 0.18, 600.00, 492.00),
(43, 54, 91, 3, '2027-08-10', 4, '2027-08-13', '2027-08-15', 265.00, 38.00, 0.25, 750.00, 562.50),
(15, 25, 61, 5, '2027-09-20', 1, '2027-09-23', '2027-09-25', 210.00, 30.00, NULL, 580.00, 580.00),
(7, 9, 21, 2, '2027-10-25', 3, '2027-10-28', '2027-10-30', 185.00, 27.00, 0.12, 510.00, 448.80),
(31, 43, 88, 4, '2027-11-10', 2, '2027-11-13', '2027-11-15', 240.00, 34.50, NULL, 670.00, 670.00),
(13, 19, 39, 1, '2027-12-15', 5, '2027-12-18', '2027-12-20', 215.00, 31.00, 0.15, 590.00, 501.50),
(26, 36, 81, 3, '2028-01-20', 4, '2028-01-23', '2028-01-25', 235.00, 33.50, NULL, 670.00, 670.00),
(48, 58, 95, 5, '2028-02-10', 1, '2028-02-13', '2028-02-15', 275.00, 39.00, 0.22, 790.00, 615.80),
(10, 16, 32, 2, '2028-03-25', 3, '2028-03-28', '2028-03-30', 205.00, 29.50, NULL, 590.00, 590.00),
(24, 41, 79, 4, '2028-04-10', 2, '2028-04-13', '2028-04-15', 225.00, 32.50, 0.18, 620.00, 508.40),
(16, 27, 64, 1, '2028-05-15', 5, '2028-05-18', '2028-05-20', 230.00, 33.00, NULL, 660.00, 660.00),
(38, 52, 89, 3, '2028-06-20', 4, '2028-06-23', '2028-06-25', 255.00, 36.50, 0.2, 710.00, 568.00),
(6, 5, 17, 5, '2028-07-10', 1, '2028-07-13', '2028-07-15', 180.00, 26.00, NULL, 500.00, 500.00),
(29, 44, 83, 2, '2028-08-15', 3, '2028-08-18', '2028-08-20', 235.00, 33.50, 0.18, 670.00, 549.40),
(1, 3, 8, 4, '2028-09-20', 2, '2028-09-23', '2028-09-25', 170.00, 24.50, NULL, 460.00, 460.00),
(19, 31, 66, 1, '2028-10-10', 5, '2028-10-13', '2028-10-15', 230.00, 33.00, NULL, 660.00, 660.00),
(41, 50, 90, 3, '2028-11-15', 4, '2028-11-18', '2028-11-20', 265.00, 38.00, 0.25, 750.00, 562.50),
(28, 39, 82, 5, '2028-12-10', 1, '2028-12-13', '2028-12-15', 240.00, 34.50, NULL, 670.00, 670.00),
(50, 60, 94, 2, '2029-01-05', 3, '2029-01-08', '2029-01-10', 280.00, 40.00, NULL, 800.00, 800.00),
(14, 22, 58, 4, '2029-02-20', 2, '2029-02-23', '2029-02-25', 220.00, 31.50, 0.18, 600.00, 492.00),
(2, 4, 12, 1, '2029-03-15', 5, '2029-03-18', '2029-03-20', 175.00, 25.00, NULL, 480.00, 480.00),
(37, 48, 86, 3, '2029-04-10', 4, '2029-04-13', '2029-04-15', 250.00, 35.50, 0.2, 700.00, 560.00),
(12, 20, 36, 5, '2029-05-15', 1, '2029-05-18', '2029-05-20', 210.00, 30.00, 0.15, 580.00, 493.00),
(5, 9, 16, 2, '2029-06-10', 3, '2029-06-13', '2029-06-15', 180.00, 26.00, NULL, 500.00, 500.00),
(30, 45, 83, 4, '2029-07-15', 2, '2029-07-18', '2029-07-20', 245.00, 35.00, 0.2, 690.00, 552.00),
(23, 35, 69, 1, '2029-08-20', 5, '2029-08-23', '2029-08-25', 225.00, 32.00, NULL, 620.00, 620.00),
(47, 57, 93, 3, '2029-09-05', 4, '2029-09-08', '2029-09-10', 270.00, 38.50, 0.22, 770.00, 600.60),
(11, 18, 37, 5, '2029-10-18', 1, '2029-10-21', '2029-10-23', 205.00, 29.50, NULL, 590.00, 590.00),
(36, 49, 87, 2, '2029-11-12', 3, '2029-11-15', '2029-11-17', 250.00, 35.50, 0.2, 700.00, 560.00),
(19, 29, 64, 4, '2029-12-08', 2, '2029-12-11', '2029-12-13', 230.00, 33.00, NULL, 660.00, 660.00),
(3, 5, 13, 1, '2030-01-20', 5, '2030-01-23', '2030-01-25', 175.00, 25.00, NULL, 480.00, 480.00),
(42, 53, 90, 3, '2030-02-05', 4, '2030-02-08', '2030-02-10', 265.00, 38.00, 0.25, 750.00, 562.50),
(25, 37, 81, 5, '2030-03-10', 1, '2030-03-13', '2030-03-15', 230.00, 33.00, NULL, 660.00, 660.00),
(8, 13, 30, 2, '2030-04-15', 3, '2030-04-18', '2030-04-20', 190.00, 27.00, NULL, 520.00, 520.00),
(51, 61, 95, 4, '2030-05-20', 2, '2030-05-23', '2030-05-25', 280.00, 40.00, NULL, 800.00, 800.00),
(14, 24, 57, 1, '2030-06-12', 5, '2030-06-15', '2030-06-17', 215.00, 31.00, 0.15, 590.00, 501.50),
(27, 41, 82, 3, '2030-07-05', 4, '2030-07-08', '2030-07-10', 235.00, 33.50, NULL, 670.00, 670.00),
(45, 55, 92, 5, '2030-08-20', 1, '2030-08-23', '2030-08-25', 260.00, 37.00, 0.25, 740.00, 555.00),
(10, 17, 33, 2, '2030-09-05', 3, '2030-09-08', '2030-09-10', 200.00, 29.00, NULL, 580.00, 580.00),
(34, 46, 86, 4, '2030-10-18', 2, '2030-10-21', '2030-10-23', 245.00, 35.00, 0.2, 690.00, 552.00),
(17, 28, 63, 1, '2030-11-12', 5, '2030-11-15', '2030-11-17', 210.00, 30.00, NULL, 580.00, 580.00),
(49, 59, 94, 3, '2030-12-08', 4, '2030-12-11', '2030-12-13', 275.00, 39.00, 0.22, 790.00, 615.80),
(22, 34, 70, 5, '2031-01-20', 1, '2031-01-23', '2031-01-25', 235.00, 34.00, NULL, 670.00, 670.00),
(7, 12, 23, 2, '2031-02-05', 3, '2031-02-08', '2031-02-10', 185.00, 27.00, 0.12, 510.00, 448.80),
(33, 48, 84, 4, '2031-03-10', 2, '2031-03-13', '2031-03-15', 245.00, 35.00, NULL, 690.00, 690.00),
(16, 26, 60, 1, '2031-04-15', 5, '2031-04-18', '2031-04-20', 230.00, 33.00, NULL, 660.00, 660.00),
(39, 51, 88, 3, '2031-05-20', 4, '2031-05-23', '2031-05-25', 255.00, 36.50, 0.2, 710.00, 568.00),
(2, 4, 11, 5, '2031-06-10', 1, '2031-06-13', '2031-06-15', 175.00, 25.00, NULL, 480.00, 480.00),
(26, 38, 83, 2, '2031-07-15', 3, '2031-07-18', '2031-07-20', 235.00, 33.50, 0.18, 670.00, 549.40),
(9, 15, 31, 4, '2031-08-10', 2, '2031-08-13', '2031-08-15', 200.00, 28.50, 0.15, 570.00, 484.50),
(44, 54, 91, 1, '2031-09-15', 5, '2031-09-18', '2031-09-20', 270.00, 38.50, 0.22, 770.00, 600.60),
(21, 33, 68, 3, '2031-10-20', 4, '2031-10-23', '2031-10-25', 235.00, 33.50, NULL, 670.00, 670.00),
(1, 2, 4, 1, '2031-11-10', 5, '2031-11-13', '2031-11-15', 180.00, 26.00, NULL, 500.00, 500.00);

-- Inseciones empleado
INSERT INTO empleado (id, id_sucursal, cedula, nombres, apellidos, direccion, ciudad, celular, email) VALUES
(1, 1, '1234567890', 'Juan Carlos', 'Gómez Ramírez', 'Carrera 10 # 11-12', 'Bogotá', '3123456789', 'juancarlos.gomez@gmail.com'),
(2, 2, '2345678901', 'María', 'González', 'Calle 20 # 21-22', 'Medellín', '3212345678', 'maria.gonzalez@gmail.com'),
(3, 3, '3456789012', 'Luis', 'Hernández', 'Avenida 30 # 31-32', 'Cali', '3323456789', 'luis.hernandez@gmail.com'),
(4, 4, '4567890123', 'Ana María', 'López', 'Carrera 40 # 41-42', 'Barranquilla', '3434567890', 'ana.lopez@gmail.com'),
(5, 5, '5678901234', 'Jorge', 'Martínez Gómez', 'Carrera 50 # 51-52', 'Cartagena', '3545678901', 'jorge.martinez@gmail.com'),
(6, 1, '6789012345', 'Paola Andrea', 'Rojas', 'Calle 60 # 61-62', 'Bogotá', '3656789012', 'paola.rojas@gmail.com'),
(7, 2, '7890123456', 'Andrés Felipe', 'Pérez', 'Avenida 70 # 71-72', 'Medellín', '3767890123', 'andres.perez@gmail.com'),
(8, 3, '8901234567', 'Sofía', 'García', 'Carrera 80 # 81-82', 'Cali', '3878901234', 'sofia.garcia@gmail.com'),
(9, 4, '9012345678', 'Carlos Alberto', 'Ramírez', 'Calle 90 # 91-92', 'Barranquilla', '3989012345', 'carlos.ramirez@gmail.com'),
(10, 5, '0123456789', 'Laura', 'Hernández Martínez', 'Carrera 100 # 101-102', 'Cartagena', '4090123456', 'laura.hernandez@gmail.com'),
(11, 1, '1234567890', 'Diego', 'Gómez', 'Calle 110 # 111-112', 'Bogotá', '4111234567', 'diego.gomez@gmail.com'),
(12, 2, '2345678901', 'Marcela', 'Londoño', 'Avenida 120 # 121-122', 'Medellín', '4222345678', 'marcela.londono@gmail.com'),
(13, 3, '3456789012', 'Andrea', 'Hernández López', 'Carrera 130 # 131-132', 'Cali', '4333456789', 'andrea.hernandez@gmail.com'),
(14, 4, '4567890123', 'José Luis', 'Sánchez', 'Calle 140 # 141-142', 'Barranquilla', '4444567890', 'jose.sanchez@gmail.com'),
(15, 5, '5678901234', 'Camila', 'Gómez Martínez', 'Avenida 150 # 151-152', 'Cartagena', '4555678901', 'camila.gomez@gmail.com'),
(16, 1, '6789012345', 'Felipe', 'Rodríguez', 'Carrera 160 # 161-162', 'Bogotá', '4666789012', 'felipe.rodriguez@gmail.com'),
(17, 2, '7890123456', 'Valentina', 'Gutiérrez', 'Calle 170 # 171-172', 'Medellín', '4777890123', 'valentina.gutierrez@gmail.com'),
(18, 3, '8901234567', 'Daniel', 'Gómez Ramírez', 'Avenida 180 # 181-182', 'Cali', '4888901234', 'daniel.gomez@gmail.com'),
(19, 4, '9012345678', 'Isabella', 'Martínez', 'Carrera 190 # 191-192', 'Barranquilla', '4999012345', 'isabella.martinez@gmail.com'),
(20, 5, '0123456789', 'Mateo', 'Hernández García', 'Calle 200 # 201-202', 'Cartagena', '5000123456', 'mateo.hernandez@gmail.com'),
(21, 1, '1234567890', 'Gabriela', 'López', 'Avenida 210 # 211-212', 'Bogotá', '5111234567', 'gabriela.lopez@gmail.com'),
(22, 2, '2345678901', 'Sebastián', 'Pérez', 'Carrera 220 # 221-222', 'Medellín', '5222345678', 'sebastian.perez@gmail.com'),
(23, 3, '3456789012', 'Valeria', 'Ramírez Gómez', 'Calle 230 # 231-232', 'Cali', '5333456789', 'valeria.ramirez@gmail.com'),
(24, 4, '4567890123', 'Martín', 'González', 'Avenida 240 # 241-242', 'Barranquilla', '5444567890', 'martin.gonzalez@gmail.com'),
(25, 5, '5678901234', 'Juliana', 'Hernández Pérez', 'Carrera 250 # 251-252', 'Cartagena', '5555678901', 'juliana.hernandez@gmail.com'),
(26, 1, '6789012345', 'Juan José', 'Sánchez', 'Calle 260 # 261-262', 'Bogotá', '5666789012', 'juan.sanchez@gmail.com'),
(27, 2, '7890123456', 'Carolina', 'Gómez', 'Avenida 270 # 271-272', 'Medellín', '5777890123', 'carolina.gomez@gmail.com'),
(28, 3, '8901234567', 'Andrés', 'Hernández Martínez', 'Carrera 280 # 281-282', 'Cali', '5888901234', 'andres.hernandez@gmail.com'),
(29, 4, '9012345678', 'Paula', 'Martínez Gómez', 'Calle 290 # 291-292', 'Barranquilla', '5999012345', 'paula.martinez@gmail.com'),
(30, 5, '0123456789', 'Miguel Ángel', 'López', 'Avenida 300 # 301-302', 'Cartagena', '6000123456', 'miguel.lopez@gmail.com'),
(31, 1, '1234567890', 'Valentina', 'Hernández', 'Carrera 310 # 311-312', 'Bogotá', '6111234567', 'valentina.hernandez@gmail.com'),
(32, 2, '2345678901', 'Javier', 'Gómez Ramírez', 'Calle 320 # 321-322', 'Medellín', '6222345678', 'javier.gomez@gmail.com'),
(33, 3, '3456789012', 'Fernanda', 'Pérez', 'Avenida 330 # 331-332', 'Cali', '6333456789', 'fernanda.perez@gmail.com'),
(34, 4, '4567890123', 'Santiago', 'Martínez', 'Carrera 340 # 341-342', 'Barranquilla', '6444567890', 'santiago.martinez@gmail.com'),
(35, 5, '5678901234', 'Luciana', 'Ramírez Gómez', 'Calle 350 # 351-352', 'Cartagena', '6555678901', 'luciana.ramirez@gmail.com'),
(36, 1, '6789012345', 'Emilio', 'González', 'Avenida 360 # 361-362', 'Bogotá', '6666789012', 'emilio.gonzalez@gmail.com'),
(37, 2, '7890123456', 'Antonella', 'Hernández Pérez', 'Carrera 370 # 371-372', 'Medellín', '6777890123', 'antonella.hernandez@gmail.com'),
(38, 3, '8901234567', 'Matías', 'Sánchez', 'Calle 380 # 381-382', 'Cali', '6888901234', 'matias.sanchez@gmail.com'),
(39, 4, '9012345678', 'Isabel', 'Gómez Ramírez', 'Avenida 390 # 391-392', 'Barranquilla', '6999012345', 'isabel.gomez@gmail.com'),
(40, 5, '0123456789', 'Simón', 'Martínez Gómez', 'Carrera 400 # 401-402', 'Cartagena', '7000123456', 'simon.martinez@gmail.com'),
(41, 1, '1234567890', 'Renata', 'López', 'Calle 410 # 411-412', 'Bogotá', '7111234567', 'renata.lopez@gmail.com'),
(42, 2, '2345678901', 'Gabriel', 'Pérez', 'Avenida 420 # 421-422', 'Medellín', '7222345678', 'gabriel.perez@gmail.com'),
(43, 3, '3456789012', 'Camilo', 'Ramírez Gómez', 'Carrera 430 # 431-432', 'Cali', '7333456789', 'camilo.ramirez@gmail.com'),
(44, 4, '4567890123', 'Valentina', 'González', 'Calle 440 # 441-442', 'Barranquilla', '7444567890', 'valentina.gonzalez@gmail.com'),
(45, 5, '5678901234', 'Daniel', 'Hernández Pérez', 'Avenida 450 # 451-452', 'Cartagena', '7555678901', 'daniel.hernandez@gmail.com'),
(46, 1, '6789012345', 'María José', 'Sánchez', 'Carrera 460 # 461-462', 'Bogotá', '7666789012', 'maria.sanchez@gmail.com'),
(47, 2, '7890123456', 'Julián', 'Gómez', 'Calle 470 # 471-472', 'Medellín', '7777890123', 'julian.gomez@gmail.com'),
(48, 3, '8901234567', 'Carla', 'Hernández Martínez', 'Avenida 480 # 481-482', 'Cali', '7888901234', 'carla.hernandez@gmail.com'),
(49, 4, '9012345678', 'Alejandro', 'Martínez Gómez', 'Carrera 490 # 491-492', 'Barranquilla', '7999012345', 'alejandro.martinez@gmail.com'),
(50, 5, '0123456789', 'Antonia', 'López', 'Calle 500 # 501-502', 'Cartagena', '8000123456', 'antonia.lopez@gmail.com'),
(51, 1, '1234567890', 'Sebastián', 'Hernández', 'Avenida 510 # 511-512', 'Bogotá', '8111234567', 'sebastian.hernandez@gmail.com'),
(52, 2, '2345678901', 'Valeria', 'Gómez Ramírez', 'Carrera 520 # 521-522', 'Medellín', '8222345678', 'valeria.gomez@gmail.com'),
(53, 3, '3456789012', 'Juan Pablo', 'Pérez', 'Calle 530 # 531-532', 'Cali', '8333456789', 'juanpablo.perez@gmail.com'),
(54, 4, '4567890123', 'Isabella', 'Martínez', 'Avenida 540 # 541-542', 'Barranquilla', '8444567890', 'isabella.martinez@gmail.com'),
(55, 5, '5678901234', 'Mateo', 'Ramírez Gómez', 'Carrera 550 # 551-552', 'Cartagena', '8555678901', 'mateo.ramirez@gmail.com'),
(56, 1, '6789012345', 'Luciana', 'González', 'Calle 560 # 561-562', 'Bogotá', '8666789012', 'luciana.gonzalez@gmail.com'),
(57, 2, '7890123456', 'Emilio', 'Hernández Pérez', 'Avenida 570 # 571-572', 'Medellín', '8777890123', 'emilio.hernandez@gmail.com'),
(58, 3, '8901234567', 'Antonella', 'Sánchez', 'Carrera 580 # 581-582', 'Cali', '8888901234', 'antonella.sanchez@gmail.com'),
(59, 4, '9012345678', 'Matías', 'Gómez Ramírez', 'Calle 590 # 591-592', 'Barranquilla', '8999012345', 'matias.gomez@gmail.com'),
(60, 5, '0123456789', 'Isabel', 'Martínez Gómez', 'Avenida 600 # 601-602', 'Cartagena', '9000123456', 'isabel.martinez@gmail.com'),
(61, 1, '1234567890', 'Simón', 'López', 'Carrera 610 # 611-612', 'Bogotá', '9111234567', 'simon.lopez@gmail.com'),
(62, 2, '2345678901', 'Renata', 'Pérez', 'Calle 620 # 621-622', 'Medellín', '9222345678', 'renata.perez@gmail.com'),
(63, 3, '3456789012', 'Gabriel', 'Ramírez Gómez', 'Avenida 630 # 631-632', 'Cali', '9333456789', 'gabriel.ramirez@gmail.com'),
(64, 4, '4567890123', 'Camila', 'González', 'Carrera 640 # 641-642', 'Barranquilla', '9444567890', 'camila.gonzalez@gmail.com'),
(65, 5, '5678901234', 'Daniel', 'Hernández Pérez', 'Calle 650 # 651-652', 'Cartagena', '9555678901', 'daniel.hernandez@gmail.com'),
(66, 1, '6789012345', 'María José', 'Sánchez', 'Avenida 660 # 661-662', 'Bogotá', '9666789012', 'maria.sanchez@gmail.com'),
(67, 2, '7890123456', 'Julián', 'Gómez', 'Carrera 670 # 671-672', 'Medellín', '9777890123', 'julian.gomez@gmail.com'),
(68, 3, '8901234567', 'Carla', 'Hernández Martínez', 'Calle 680 # 681-682', 'Cali', '9888901234', 'carla.hernandez@gmail.com'),
(69, 4, '9012345678', 'Alejandro', 'Martínez Gómez', 'Avenida 690 # 691-692', 'Barranquilla', '9999012345', 'alejandro.martinez@gmail.com'),
(70, 5, '0123456789', 'Antonia', 'López', 'Carrera 700 # 701-702', 'Cartagena', '0000123456', 'antonia.lopez@gmail.com'),
(71, 1, '1234567890', 'Sebastián', 'Hernández', 'Calle 710 # 711-712', 'Bogotá', '0111234567', 'sebastian.hernandez@gmail.com'),
(72, 2, '2345678901', 'Valeria', 'Gómez Ramírez', 'Avenida 720 # 721-722', 'Medellín', '0222345678', 'valeria.gomez@gmail.com'),
(73, 3, '3456789012', 'Juan Pablo', 'Pérez', 'Calle 730 # 731-732', 'Cali', '0333456789', 'juanpablo.perez@gmail.com'),
(74, 4, '4567890123', 'Isabella', 'Martínez', 'Avenida 740 # 741-742', 'Barranquilla', '0444567890', 'isabella.martinez@gmail.com'),
(75, 5, '5678901234', 'Mateo', 'Ramírez Gómez', 'Carrera 750 # 751-752', 'Cartagena', '0555678901', 'mateo.ramirez@gmail.com'),
(76, 1, '6789012345', 'Luciana', 'González', 'Calle 760 # 761-762', 'Bogotá', '0666789012', 'luciana.gonzalez@gmail.com'),
(77, 2, '7890123456', 'Emilio', 'Hernández Pérez', 'Avenida 770 # 771-772', 'Medellín', '0777890123', 'emilio.hernandez@gmail.com'),
(78, 3, '8901234567', 'Antonella', 'Sánchez', 'Carrera 780 # 781-782', 'Cali', '0888901234', 'antonella.sanchez@gmail.com'),
(79, 4, '9012345678', 'Matías', 'Gómez Ramírez', 'Calle 790 # 791-792', 'Barranquilla', '0999012345', 'matias.gomez@gmail.com'),
(80, 5, '0123456789', 'Isabel', 'Martínez Gómez', 'Avenida 800 # 801-802', 'Cartagena', '1000123456', 'isabel.martinez@gmail.com'),
(81, 1, '1234567890', 'Simón', 'López', 'Carrera 810 # 811-812', 'Bogotá', '1111234567', 'simon.lopez@gmail.com'),
(82, 2, '2345678901', 'Renata', 'Pérez', 'Calle 820 # 821-822', 'Medellín', '1222345678', 'renata.perez@gmail.com'),
(83, 3, '3456789012', 'Gabriel', 'Ramírez Gómez', 'Avenida 830 # 831-832', 'Cali', '1333456789', 'gabriel.ramirez@gmail.com'),
(84, 4, '4567890123', 'Camila', 'González', 'Carrera 840 # 841-842', 'Barranquilla', '1444567890', 'camila.gonzalez@gmail.com'),
(85, 5, '5678901234', 'Daniel', 'Hernández Pérez', 'Calle 850 # 851-852', 'Cartagena', '1555678901', 'daniel.hernandez@gmail.com'),
(86, 1, '6789012345', 'María José', 'Sánchez', 'Avenida 860 # 861-862', 'Bogotá', '1666789012', 'maria.sanchez@gmail.com'),
(87, 2, '7890123456', 'Julián', 'Gómez', 'Carrera 870 # 871-872', 'Medellín', '1777890123', 'julian.gomez@gmail.com'),
(88, 3, '8901234567', 'Carla', 'Hernández Martínez', 'Calle 880 # 881-882', 'Cali', '1888901234', 'carla.hernandez@gmail.com'),
(89, 4, '9012345678', 'Alejandro', 'Martínez Gómez', 'Avenida 890 # 891-892', 'Barranquilla', '1999012345', 'alejandro.martinez@gmail.com'),
(90, 5, '0123456789', 'Antonia', 'López', 'Carrera 900 # 901-902', 'Cartagena', '2000123456', 'antonia.lopez@gmail.com'),
(91, 1, '1234567890', 'Sebastián', 'Hernández', 'Calle 910 # 911-912', 'Bogotá', '2111234567', 'sebastian.hernandez@gmail.com'),
(92, 2, '2345678901', 'Valeria', 'Gómez Ramírez', 'Avenida 920 # 921-922', 'Medellín', '2222345678', 'valeria.gomez@gmail.com'),
(93, 3, '3456789012', 'Juan Pablo', 'Pérez', 'Calle 930 # 931-932', 'Cali', '2333456789', 'juanpablo.perez@gmail.com'),
(94, 4, '4567890123', 'Isabella', 'Martínez', 'Avenida 940 # 941-942', 'Barranquilla', '2444567890', 'isabella.martinez@gmail.com'),
(95, 5, '5678901234', 'Mateo', 'Ramírez Gómez', 'Carrera 950 # 951-952', 'Cartagena', '2555678901', 'mateo.ramirez@gmail.com'),
(96, 1, '6789012345', 'Luciana', 'González', 'Calle 960 # 961-962', 'Bogotá', '2666789012', 'luciana.gonzalez@gmail.com'),
(97, 2, '7890123456', 'Emilio', 'Hernández Pérez', 'Avenida 970 # 971-972', 'Medellín', '2777890123', 'emilio.hernandez@gmail.com'),
(98, 3, '8901234567', 'Antonella', 'Sánchez', 'Carrera 980 # 981-982', 'Cali', '2888901234', 'antonella.sanchez@gmail.com'),
(99, 4, '9012345678', 'Matías', 'Gómez Ramírez', 'Calle 990 # 991-992', 'Barranquilla', '2999012345', 'matias.gomez@gmail.com'),
(100, 5, '0123456789', 'Isabel', 'Martínez Gómez', 'Avenida 1000 # 1001-1002', 'Cartagena', '3000123456', 'isabel.martinez@gmail.com');

-- Inserciones para vehiculo
INSERT INTO vehiculo (tipo, placa, referencia, modelo, puertas, capacidad, sunroof, motor, color) VALUES
('Sedán', 'ABC123', 'Toyota Corolla', 2020, 4, '5 personas', 'No tiene', 'Motor 1.6', 'Azul'),
('Compacto', 'DEF456', 'Honda Civic', 2021, 4, '5 personas', 'Tiene', 'Motor 1.5', 'Rojo'),
('Camioneta Platón', 'GHI789', 'Mitsubishi L200', 2019, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Blanco'),
('Camioneta lujo', 'JKL012', 'Audi Q7', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'MNO345', 'BMW M3', 2020, 2, '2 personas', 'No tiene', 'Motor 3.2', 'Gris'),
('Sedán', 'PQR678', 'Toyota Corolla', 2021, 4, '5 personas', 'Tiene', 'Motor 1.6', 'Blanco'),
('Compacto', 'STU901', 'Honda Fit', 2018, 5, '5 personas', 'No tiene', 'Motor 1.3', 'Azul'),
('Camioneta Platón', 'VWX234', 'Mitsubishi L200', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Rojo'),
('Camioneta lujo', 'YZA567', 'Audi Q5', 2022, 5, '5 personas', 'Tiene', 'Motor 2.0', 'Blanco'),
('Deportivo', 'BCD890', 'Porsche 911', 2019, 2, '2 personas', 'Tiene', 'Motor 3.8', 'Rojo'),
('Sedán', 'EFG123', 'Nissan Sentra', 2020, 4, '5 personas', 'No tiene', 'Motor 1.8', 'Negro'),
('Compacto', 'HIJ456', 'Ford Fiesta', 2017, 5, '5 personas', 'No tiene', 'Motor 1.0', 'Azul'),
('Camioneta Platón', 'KLM789', 'Toyota Hilux', 2019, 2, '3 personas', 'No tiene', 'Motor 2.4', 'Blanco'),
('Camioneta lujo', 'NOP012', 'Mercedes-Benz GLE', 2021, 5, '7 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'QRS345', 'Chevrolet Camaro', 2020, 2, '2 personas', 'Tiene', 'Motor 6.2', 'Rojo'),
('Sedán', 'TUV678', 'Hyundai Elantra', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Gris'),
('Compacto', 'WXY901', 'Volkswagen Golf', 2018, 5, '5 personas', 'No tiene', 'Motor 1.4', 'Verde'),
('Camioneta Platón', 'ZAB234', 'Isuzu D-Max', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Blanco'),
('Camioneta lujo', 'CDE567', 'BMW X5', 2022, 5, '5 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'FGH890', 'Audi R8', 2019, 2, '2 personas', 'Tiene', 'Motor 5.2', 'Rojo'),
('Sedán', 'IJK123', 'Honda Accord', 2020, 4, '5 personas', 'No tiene', 'Motor 2.0', 'Azul'),
('Compacto', 'LMN456', 'Toyota Yaris', 2017, 5, '5 personas', 'No tiene', 'Motor 1.5', 'Blanco'),
('Camioneta Platón', 'OPQ789', 'Ford Ranger', 2019, 2, '3 personas', 'No tiene', 'Motor 2.2', 'Gris'),
('Camioneta lujo', 'RST012', 'Lexus RX', 2021, 5, '5 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'UVW345', 'Chevrolet Corvette', 2020, 2, '2 personas', 'Tiene', 'Motor 6.2', 'Rojo'),
('Sedán', 'XYZ678', 'Kia Optima', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Azul'),
('Compacto', 'ABC901', 'Mazda 3', 2018, 5, '5 personas', 'No tiene', 'Motor 1.6', 'Blanco'),
('Camioneta Platón', 'DEF234', 'Nissan Frontier', 2020, 2, '3 personas', 'No tiene', 'Motor 2.3', 'Rojo'),
('Camioneta lujo', 'GHI567', 'Range Rover Sport', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'JKL890', 'Ford Mustang', 2019, 2, '2 personas', 'Tiene', 'Motor 5.0', 'Rojo'),
('Sedán', 'MNO123', 'Hyundai Sonata', 2020, 4, '5 personas', 'No tiene', 'Motor 2.4', 'Gris'),
('Compacto', 'PQR456', 'Volkswagen Polo', 2017, 5, '5 personas', 'No tiene', 'Motor 1.0', 'Azul'),
('Camioneta Platón', 'STU789', 'Chevrolet Luv D-Max', 2019, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Blanco'),
('Camioneta lujo', 'VWX012', 'BMW X7', 2021, 5, '5 personas', 'Tiene', 'Motor 4.4', 'Negro'),
('Deportivo', 'YZA345', 'Porsche 718 Cayman', 2020, 2, '2 personas', 'Tiene', 'Motor 2.0', 'Rojo'),
('Sedán', 'BCD678', 'Toyota Camry', 2021, 4, '5 personas', 'Tiene', 'Motor 2.5', 'Azul'),
('Compacto', 'EFG901', 'Ford Fiesta', 2018, 5, '5 personas', 'No tiene', 'Motor 1.0', 'Blanco'),
('Camioneta Platón', 'HIJ234', 'Isuzu D-Max', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Rojo'),
('Camioneta lujo', 'KLM567', 'Audi Q8', 2022, 5, '5 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'NOP890', 'Chevrolet Camaro', 2020, 2, '2 personas', 'Tiene', 'Motor 6.2', 'Rojo'),
('Sedán', 'QRS123', 'Honda Civic', 2021, 4, '5 personas', 'No tiene', 'Motor 1.5', 'Azul'),
('Compacto', 'TUV456', 'Toyota Yaris', 2017, 5, '5 personas', 'No tiene', 'Motor 1.3', 'Blanco'),
('Camioneta Platón', 'WXY789', 'Ford Ranger', 2019, 2, '3 personas', 'No tiene', 'Motor 2.2', 'Gris'),
('Camioneta lujo', 'ZAB012', 'Mercedes-Benz GLE', 2021, 5, '7 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'CDE345', 'Nissan GT-R', 2020, 2, '2 personas', 'Tiene', 'Motor 3.8', 'Rojo'),
('Sedán', 'FGH678', 'Hyundai Elantra', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Gris'),
('Compacto', 'IJK901', 'Volkswagen Golf', 2018, 5, '5 personas', 'No tiene', 'Motor 1.4', 'Verde'),
('Camioneta Platón', 'LMN234', 'Toyota Hilux', 2020, 2, '3 personas', 'No tiene', 'Motor 2.4', 'Blanco'),
('Camioneta lujo', 'OPQ567', 'BMW X5', 2022, 5, '5 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'RST890', 'Audi R8', 2019, 2, '2 personas', 'Tiene', 'Motor 5.2', 'Rojo'),
('Sedán', 'UVW123', 'Kia Optima', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Azul'),
('Compacto', 'XYZ456', 'Mazda 3', 2018, 5, '5 personas', 'No tiene', 'Motor 1.6', 'Blanco'),
('Camioneta Platón', 'ABC789', 'Nissan Frontier', 2020, 2, '3 personas', 'No tiene', 'Motor 2.3', 'Rojo'),
('Camioneta lujo', 'DEF012', 'Range Rover Sport', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'GHI345', 'Ford Mustang', 2019, 2, '2 personas', 'Tiene', 'Motor 5.0', 'Rojo'),
('Sedán', 'JKL678', 'Honda Accord', 2020, 4, '5 personas', 'No tiene', 'Motor 2.0', 'Azul'),
('Compacto', 'MNO901', 'Toyota Yaris', 2017, 5, '5 personas', 'No tiene', 'Motor 1.5', 'Blanco'),
('Camioneta Platón', 'PQR234', 'Ford Ranger', 2019, 2, '3 personas', 'No tiene', 'Motor 2.2', 'Gris'),
('Camioneta lujo', 'STU567', 'Lexus RX', 2021, 5, '5 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'VWX890', 'Chevrolet Corvette', 2020, 2, '2 personas', 'Tiene', 'Motor 6.2', 'Rojo'),
('Sedán', 'YZA123', 'Toyota Camry', 2021, 4, '5 personas', 'Tiene', 'Motor 2.5', 'Azul'),
('Compacto', 'BCD456', 'Ford Fiesta', 2018, 5, '5 personas', 'No tiene', 'Motor 1.0', 'Blanco'),
('Camioneta Platón', 'EFG789', 'Isuzu D-Max', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Rojo'),
('Camioneta lujo', 'HIJ012', 'Audi Q8', 2022, 5, '5 personas', 'Tiene', 'Motor 4.4', 'Negro'),
('Deportivo', 'KLM345', 'Porsche 718 Cayman', 2020, 2, '2 personas', 'Tiene', 'Motor 2.0', 'Rojo'),
('Sedán', 'NOP678', 'Honda Civic', 2021, 4, '5 personas', 'No tiene', 'Motor 1.5', 'Azul'),
('Compacto', 'QRS901', 'Toyota Yaris', 2017, 5, '5 personas', 'No tiene', 'Motor 1.3', 'Blanco'),
('Camioneta Platón', 'TUV234', 'Ford Ranger', 2019, 2, '3 personas', 'No tiene', 'Motor 2.2', 'Gris'),
('Camioneta lujo', 'WXY567', 'Mercedes-Benz GLE', 2021, 5, '7 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'ZAB890', 'Nissan GT-R', 2020, 2, '2 personas', 'Tiene', 'Motor 3.8', 'Rojo'),
('Sedán', 'CDE123', 'Hyundai Elantra', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Gris'),
('Compacto', 'FGH456', 'Volkswagen Golf', 2018, 5, '5 personas', 'No tiene', 'Motor 1.4', 'Verde'),
('Camioneta Platón', 'IJK789', 'Toyota Hilux', 2020, 2, '3 personas', 'No tiene', 'Motor 2.4', 'Blanco'),
('Camioneta lujo', 'LMN012', 'BMW X5', 2022, 5, '5 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'OPQ345', 'Audi R8', 2019, 2, '2 personas', 'Tiene', 'Motor 5.2', 'Rojo'),
('Sedán', 'RST678', 'Kia Optima', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Azul'),
('Compacto', 'UVW901', 'Mazda 3', 2018, 5, '5 personas', 'No tiene', 'Motor 1.6', 'Blanco'),
('Camioneta Platón', 'XYZ234', 'Nissan Frontier', 2020, 2, '3 personas', 'No tiene', 'Motor 2.3', 'Rojo'),
('Camioneta lujo', 'ABC567', 'Range Rover Sport', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'DEF890', 'Ford Mustang', 2019, 2, '2 personas', 'Tiene', 'Motor 5.0', 'Rojo'),
('Sedán', 'GHI123', 'Toyota Camry', 2021, 4, '5 personas', 'Tiene', 'Motor 2.5', 'Blanco'),
('Compacto', 'JKL456', 'Honda Fit', 2018, 5, '5 personas', 'No tiene', 'Motor 1.3', 'Azul'),
('Camioneta Platón', 'MNO789', 'Mitsubishi L200', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Rojo'),
('Camioneta lujo', 'PQR012', 'Audi Q7', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'STU345', 'BMW M3', 2020, 2, '2 personas', 'No tiene', 'Motor 3.2', 'Gris'),
('Sedán', 'VWX678', 'Toyota Corolla', 2021, 4, '5 personas', 'Tiene', 'Motor 1.8', 'Negro'),
('Compacto', 'YZA901', 'Honda Civic', 2017, 5, '5 personas', 'No tiene', 'Motor 1.5', 'Blanco'),
('Camioneta Platón', 'BCD234', 'Toyota Hilux', 2019, 2, '3 personas', 'No tiene', 'Motor 2.4', 'Blanco'),
('Camioneta lujo', 'EFG567', 'Mercedes-Benz GLE', 2021, 5, '7 personas', 'Tiene', 'Motor 3.5', 'Negro'),
('Deportivo', 'HIJ890', 'Chevrolet Camaro', 2020, 2, '2 personas', 'Tiene', 'Motor 6.2', 'Rojo'),
('Sedán', 'KLM123', 'Hyundai Elantra', 2021, 4, '5 personas', 'Tiene', 'Motor 2.0', 'Gris'),
('Compacto', 'NOP456', 'Volkswagen Golf', 2018, 5, '5 personas', 'No tiene', 'Motor 1.4', 'Verde'),
('Camioneta Platón', 'QRS789', 'Isuzu D-Max', 2020, 2, '3 personas', 'No tiene', 'Motor 2.5', 'Blanco'),
('Camioneta lujo', 'TUV012', 'BMW X7', 2022, 5, '5 personas', 'Tiene', 'Motor 4.4', 'Negro'),
('Deportivo', 'WXY345', 'Porsche 718 Cayman', 2020, 2, '2 personas', 'Tiene', 'Motor 2.0', 'Rojo'),
('Sedán', 'ZAB678', 'Toyota Camry', 2021, 4, '5 personas', 'Tiene', 'Motor 2.5', 'Azul'),
('Compacto', 'CDE901', 'Ford Fiesta', 2018, 5, '5 personas', 'No tiene', 'Motor 1.0', 'Blanco'),
('Camioneta Platón', 'FGH234', 'Nissan Frontier', 2020, 2, '3 personas', 'No tiene', 'Motor 2.3', 'Rojo'),
('Camioneta lujo', 'IJK567', 'Range Rover Sport', 2022, 5, '7 personas', 'Tiene', 'Motor 3.0', 'Negro'),
('Deportivo', 'LMN890', 'Ford Mustang', 2019, 2, '2 personas', 'Tiene', 'Motor 5.0', 'Rojo');

-- Inserciones para cliente
INSERT INTO cliente (cedula, nombres, apellidos, direccion, ciudad, celular, email) VALUES
('1234567890', 'Juan Carlos', 'González Pérez', 'Calle 10 # 20-30', 'Bogotá', '3123456789', 'juancarlos.gonzalez@gmail.com'),
('2345678901', 'María Fernanda', 'Martínez López', 'Carrera 15 # 30-40', 'Medellín', '3209876543', 'mariafernanda.martinez@gmail.com'),
('3456789012', 'Luis Alberto', 'Rodríguez Ramírez', 'Avenida 5 # 10-20', 'Cali', '3112345678', 'luisalberto.rodriguez@gmail.com'),
('4567890123', 'Ana María', 'Gómez García', 'Calle 80 # 40-50', 'Barranquilla', '3145678901', 'anamaria.gomez@gmail.com'),
('5678901234', 'Jorge', 'Hernández Martínez', 'Carrera 20 # 50-60', 'Cartagena', '3101234567', 'jorge.hernandez@gmail.com'),
('6789012345', 'Laura', 'Pérez Rodríguez', 'Avenida 10 # 30-40', 'Bucaramanga', '3178901234', 'laura.perez@gmail.com'),
('7890123456', 'Carlos', 'Sánchez Gómez', 'Carrera 30 # 20-30', 'Santa Marta', '3182345678', 'carlos.sanchez@gmail.com'),
('8901234567', 'Diana Paola', 'Jiménez Pérez', 'Calle 50 # 40-50', 'Pereira', '3196789012', 'dianapaola.jimenez@gmail.com'),
('9012345678', 'Andrés Felipe', 'González Ramírez', 'Avenida 15 # 10-20', 'Cúcuta', '3153456789', 'andresfelipe.gonzalez@gmail.com'),
('0123456789', 'Valentina', 'Ramírez Gómez', 'Carrera 25 # 30-40', 'Bogotá', '3134567890', 'valentina.ramirez@gmail.com'),
('1234598765', 'Santiago', 'López Hernández', 'Calle 70 # 20-30', 'Medellín', '3209876543', 'santiago.lopez@gmail.com'),
('2345698765', 'Camila', 'Martínez Ramírez', 'Avenida 8 # 50-60', 'Cali', '3112345678', 'camila.martinez@gmail.com'),
('3456798765', 'Mateo', 'García López', 'Carrera 12 # 40-50', 'Barranquilla', '3145678901', 'mateo.garcia@gmail.com'),
('4567890765', 'Isabela', 'Hernández Gómez', 'Calle 45 # 30-40', 'Cartagena', '3101234567', 'isabela.hernandez@gmail.com'),
('5678901765', 'Daniel', 'Gómez Ramírez', 'Avenida 6 # 10-20', 'Bucaramanga', '3178901234', 'daniel.gomez@gmail.com'),
('6789012765', 'Valeria', 'Martínez Gómez', 'Carrera 35 # 20-30', 'Santa Marta', '3182345678', 'valeria.martinez@gmail.com'),
('7890123765', 'Sebastián', 'Hernández López', 'Calle 80 # 40-50', 'Pereira', '3196789012', 'sebastian.hernandez@gmail.com'),
('8901234765', 'Luciana', 'Pérez Ramírez', 'Avenida 25 # 30-40', 'Cúcuta', '3153456789', 'luciana.perez@gmail.com'),
('9012345765', 'Alejandro', 'González Gómez', 'Carrera 10 # 20-30', 'Bogotá', '3134567890', 'alejandro.gonzalez@gmail.com'),
('0123456781', 'Gabriela', 'López Martínez', 'Calle 60 # 50-60', 'Medellín', '3209876543', 'gabriela.lopez@gmail.com'),
('1234567892', 'Mateo', 'Martínez López', 'Avenida 7 # 40-50', 'Cali', '3112345678', 'mateo.martinez@gmail.com'),
('2345678903', 'Camila', 'Ramírez Gómez', 'Carrera 30 # 10-20', 'Barranquilla', '3145678901', 'camila.ramirez@gmail.com'),
('3456789014', 'Sofía', 'Gómez Hernández', 'Calle 40 # 30-40', 'Cartagena', '3101234567', 'sofia.gomez@gmail.com'),
('4567890125', 'Lucas', 'Hernández Martínez', 'Avenida 10 # 20-30', 'Bucaramanga', '3178901234', 'lucas.hernandez@gmail.com'),
('5678901236', 'Valentina', 'López Ramírez', 'Carrera 5 # 50-60', 'Santa Marta', '3182345678', 'valentina.lopez@gmail.com'),
('6789012347', 'Juan José', 'Gómez Pérez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'juanjose.gomez@gmail.com'),
('7890123458', 'Isabella', 'Ramírez Gómez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'isabella.ramirez@gmail.com'),
('8901234569', 'Matías', 'Hernández López', 'Carrera 18 # 40-50', 'Bogotá', '3134567890', 'matias.hernandez@gmail.com'),
('9012345670', 'Emilia', 'Gómez Ramírez', 'Calle 50 # 60-70', 'Medellín', '3209876543', 'emilia.gomez@gmail.com'),
('0123456781', 'Mariana', 'López Gómez', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'mariana.lopez@gmail.com'),
('1234567892', 'Daniel', 'Martínez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'daniel.martinez@gmail.com'),
('2345678903', 'Valeria', 'Ramírez López', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'valeria.ramirez@gmail.com'),
('3456789014', 'Juan Sebastián', 'Gómez Hernández', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'juansebastian.gomez@gmail.com'),
('4567890125', 'Renata', 'Hernández Martínez', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'renata.hernandez@gmail.com'),
('5678901236', 'Diego Alejandro', 'López Ramírez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'diegoalejandro.lopez@gmail.com'),
('6789012347', 'Valentina', 'Gómez Pérez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'valentina.gomez@gmail.com'),
('7890123458', 'Santiago', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Bogotá', '3134567890', 'santiago.ramirez@gmail.com'),
('8901234569', 'Mía', 'Hernández López', 'Calle 50 # 60-70', 'Medellín', '3209876543', 'mia.hernandez@gmail.com'),
('9012345670', 'Emiliano', 'Gómez Ramírez', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'emiliano.gomez@gmail.com'),
('0123456781', 'Abril', 'López Gómez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'abril.lopez@gmail.com'),
('1234567892', 'Tomás', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'tomas.martinez@gmail.com'),
('2345678903', 'Luciana', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'luciana.ramirez@gmail.com'),
('3456789014', 'Gabriel', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'gabriel.gomez@gmail.com'),
('4567890125', 'Valentina', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'valentina.hernandez@gmail.com'),
('5678901236', 'Martín', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'martin.lopez@gmail.com'),
('6789012347', 'Emilia', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'emilia.gomez@gmail.com'),
('7890123458', 'Isaac', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'isaac.ramirez@gmail.com'),
('8901234569', 'Camila', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'camila.hernandez@gmail.com'),
('9012345670', 'Julián', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'julian.gomez@gmail.com'),
('0123456781', 'Valentina', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'valentina.martinez@gmail.com'),
('1234567892', 'Juan David', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'juandavid.ramirez@gmail.com'),
('2345678903', 'María José', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'mariajose.gomez@gmail.com'),
('3456789014', 'Santiago', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'santiago.hernandez@gmail.com'),
('4567890125', 'Emilia', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'emilia.lopez@gmail.com'),
('5678901236', 'Martín', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'martin.gomez@gmail.com'),
('6789012347', 'Isabella', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'isabella.ramirez@gmail.com'),
('7890123458', 'Lucas', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'lucas.hernandez@gmail.com'),
('8901234569', 'Valeria', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'valeria.gomez@gmail.com'),
('9012345670', 'Daniel', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'daniel.martinez@gmail.com'),
('0123456781', 'Sofía', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'sofia.ramirez@gmail.com'),
('1234567892', 'Juan Sebastián', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'juan.sebastian.gomez@gmail.com'),
('2345678903', 'Camila', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'camila.hernandez@gmail.com'),
('3456789014', 'Mateo', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'mateo.lopez@gmail.com'),
('4567890125', 'Valentina', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'valentina.gomez@gmail.com'),
('5678901236', 'Juan Pablo', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'juanpablo.ramirez@gmail.com'),
('6789012347', 'Mariana', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'mariana.hernandez@gmail.com'),
('7890123458', 'Diego', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'diego.gomez@gmail.com'),
('8901234569', 'Valentina', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'valentina.martinez@gmail.com'),
('9012345670', 'Lucas', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'lucas.ramirez@gmail.com'),
('0123456781', 'Martina', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'martina.gomez@gmail.com'),
('1234567892', 'Santiago', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'santiago.hernandez@gmail.com'),
('2345678903', 'Isabella', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'isabella.lopez@gmail.com'),
('3456789014', 'Matías', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'matias.gomez@gmail.com'),
('4567890125', 'Emilia', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'emilia.ramirez@gmail.com'),
('5678901236', 'Julián', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'julian.hernandez@gmail.com'),
('6789012347', 'Valentina', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'valentina.gomez@gmail.com'),
('7890123458', 'Daniel', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'daniel.martinez@gmail.com'),
('8901234569', 'Luciana', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'luciana.ramirez@gmail.com'),
('9012345670', 'Gabriel', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'gabriel.gomez@gmail.com'),
('0123456781', 'Valeria', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'valeria.hernandez@gmail.com'),
('1234567892', 'Lucas', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'lucas.lopez@gmail.com'),
('2345678903', 'Mariana', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'mariana.gomez@gmail.com'),
('3456789014', 'Diego', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'diego.ramirez@gmail.com'),
('4567890125', 'Valentina', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'valentina.hernandez@gmail.com'),
('5678901236', 'Juan Pablo', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'juanpablo.gomez@gmail.com'),
('6789012347', 'Mariana', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'mariana.martinez@gmail.com'),
('7890123458', 'Tomás', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'tomas.ramirez@gmail.com'),
('8901234569', 'Luciana', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'luciana.gomez@gmail.com'),
('9012345670', 'Camilo', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'camilo.hernandez@gmail.com'),
('0123456781', 'Isabella', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'isabella.lopez@gmail.com'),
('1234567892', 'Matías', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'matias.gomez@gmail.com'),
('2345678903', 'Emilia', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'emilia.ramirez@gmail.com'),
('3456789014', 'Julián', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'julian.hernandez@gmail.com'),
('4567890125', 'Valentina', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'valentina.gomez@gmail.com'),
('5678901236', 'Daniel', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'daniel.martinez@gmail.com'),
('6789012347', 'Luciana', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'luciana.ramirez@gmail.com'),
('7890123458', 'Gabriel', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'gabriel.gomez@gmail.com'),
('8901234569', 'Valeria', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'valeria.hernandez@gmail.com'),
('9012345670', 'Lucas', 'López Ramírez', 'Avenida 20 # 30-40', 'Cúcuta', '3153456789', 'lucas.lopez@gmail.com'),
('0123456781', 'Mariana', 'Gómez Pérez', 'Calle 50 # 60-70', 'Bogotá', '3134567890', 'mariana.gomez@gmail.com'),
('1234567892', 'Diego', 'Ramírez Gómez', 'Carrera 18 # 40-50', 'Medellín', '3209876543', 'diego.ramirez@gmail.com'),
('2345678903', 'Valentina', 'Hernández López', 'Avenida 9 # 20-30', 'Cali', '3112345678', 'valentina.hernandez@gmail.com'),
('3456789014', 'Juan Pablo', 'Gómez Ramírez', 'Carrera 25 # 30-40', 'Barranquilla', '3145678901', 'juanpablo.gomez@gmail.com'),
('4567890125', 'Mariana', 'Martínez Ramírez', 'Calle 60 # 40-50', 'Cartagena', '3101234567', 'mariana.martinez@gmail.com'),
('5678901236', 'Tomás', 'Ramírez López', 'Avenida 5 # 30-40', 'Bucaramanga', '3178901234', 'tomas.ramirez@gmail.com'),
('6789012347', 'Luciana', 'Gómez Hernández', 'Carrera 30 # 10-20', 'Santa Marta', '3182345678', 'luciana.gomez@gmail.com'),
('7890123458', 'Camilo', 'Hernández Martínez', 'Calle 70 # 40-50', 'Pereira', '3196789012', 'camilo.hernandez@gmail.com');

-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
