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


-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
