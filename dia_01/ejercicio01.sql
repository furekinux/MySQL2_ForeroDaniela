-- #####################
-- ### EJERCICIO # 1 ###
-- #####################

create database ejercicio_01;
use ejercicio_01;

create table medico(
id int primary key not null auto_increment,
nombre varchar(100) not null,
direccion varchar(100) not null,
telefono varchar(9) not null,
poblacion varchar(25),
provincia varchar(25) not null,
codigo_postal varchar(10) not null,
nif varchar(9) not null,
numero_seguridad_social varchar(9) not null,
tipo enum('Médico Titular', 'Médico Interino', 'Médico Sustituto') not null
);
create table empleado(
id int primary key not null auto_increment,
nombre varchar(100) not null,
direccion varchar(100) not null,
telefono varchar(9) not null,
poblacion varchar(25),
provincia varchar(25) not null,
codigo_postal varchar(10) not null,
nif varchar(9) not null,
numero_seguridad_social varchar(9) not null,
tipo enum('ATS', 'ATS de zona', 'Auxiliares de Enfermería', 'Celadores y Administrativos') not null
);
create table sustitucion(
id int primary key not null auto_increment,
id_medico int not null,
foreign key(id_medico)references medico(id),
fecha_alta date not null,
fecha_baja date not null
);
create table horario(
id int primary key not null auto_increment,
id_medico int,
foreign key(id_medico)references medico(id)
);
create table dia(
id int primary key not null auto_increment,
id_horario int not null,
foreign key(id_horario)references horario(id),
dia_semana enum('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') not null
);

create table paciente(
id int primary key not null auto_increment,
nombre varchar(100) not null,
direccion varchar(100) not null,
telefono varchar(9) not null,
codigo_postal varchar(10) not null,
nif varchar(9) not null,
numero_seguridad_social varchar(9) not null,
id_medico int,
foreign key(id_medico)references medico(id)
);

-- Desarrollado por Daniela Forero / ID.1.142.714.225
