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
    sunroof tinyint(1) not null,
    motorr varchar(50) not null
);

-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
