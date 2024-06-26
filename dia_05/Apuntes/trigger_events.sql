-- #####################################
-- ######### Dia - 05 TRIGGERS #########
-- #####################################

create database mysql2_dia05;
use mysql2_dia05;

select * from country;
select * from city;

-- Trigger para insertar o actualizar una ciudad
-- Before realizar algo antes de que ocurra un cambio
-- After realizar algo luego de que ocurra un cambio
delimiter //
create trigger after_city_insert_update
after insert on city -- Se puede decir tabla(columna también)
for each row
begin
	update country
    set Population = Population + NEW.Population -- Le suma la población de la nueva ciudad al país
    where Code = New.CountryCode;
end //
delimiter ;
-- TEST
insert into city (Name,CountryCode,District,Population) values("Artemis","AFG","Piso 6",1250000);


-- Trigger cuando se elimina una ciudad PORQUE SE VA POBLACIÓN
delimiter //
create trigger after_city_delete_update
after delete on city -- Funcion luego del CUANDO(before,after)
for each row
begin
	update country
    set Population = Population - OLD.Population -- Le resta la población de la vieja ciudad al país
    where Code = Old.CountryCode;
end //
delimiter ;
-- TEST!!!
select * from country;
select * from city where Name="Artemis";
insert into city (Name,CountryCode,District,Population) values("Artemis","AFG","Piso 6",1250000);
delete from city where Name="Artemis" and District = "Piso 6";


-- TABLA DE CITY AUDIT(como un historial de cambios en la población)
create table if not exists city_audit(
	audit_id int auto_increment primary key,
	city_id int,
    action varchar(10),
    old_population int,
    new_population int,
    change_time Timestamp default current_timestamp -- Fecha y tiempo(INCLUYE HORA ACTUAL) 
);


-- Trigger para auditoria de ciudades cuando se inserta nuevo, HISTORIAL DE CAMBIOS!!!
delimiter //
create trigger after_city_insert_audit
after insert on city
for each row
begin
	insert into city_audit(city_id,action,new_population)
    values (NEW.ID,'INSERT',NEW.Population); -- No hay población vieja porque solo se creando una ciudad NUEVA
    -- Va registrando los cambios cuando se agrega una ciudad, es decir, muestra el cambio
	-- change_time se ingresa automáticamente, como un registro de historial
end //
delimiter ;
-- TEST !!!
select * from city_audit;
insert into city (Name,CountryCode,District,Population) values("Artemis","AFG","Piso 6",1250000);
delete from city where Name="Artemis" and District = "Piso 6";
truncate city_audit;

-- Trigger para auditoria de ciudades cuando se actualiza, HISTORIAL DE CAMBIOS!!!
delimiter //
create trigger after_city_update_audit
after update on city
for each row
begin
	insert into city_audit(city_id,action,old_population,new_population)
    values (OLD.ID,'UPDATE',OLD.Population,NEW.Population); -- No hay población vieja porque solo se creando una ciudad NUEVA
    -- Va registrando los cambios cuando se agrega una ciudad, es decir, muestra el cambio
	-- change_time se ingresa automáticamente, como un registro de historial
end //
delimiter ;
-- TEST !!!
update city set Population = 150000 where ID=4086;
select * from city_audit;

-- EVENTOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOSS :DDD
-- Tabla para backups de ciudades
-- Longevidad de una tabla de backups importante !!!
create table if not exists city_backup(
	ID int Not null,
    Name char(35) not null,
    CountryCode char(3) not null,
    District char(20) not null,
    Population int not null,
    primary key (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

delimiter //
create event if not exists weekly_city_backup
on schedule every 1 week -- CADA UNA SEMANA
do
begin
	truncate table city_backup;
    insert into city_backup(ID,Name,CountryCode,District,Population)
    select ID,Name,CountryCode,District,Population from city;
end //
delimiter ;

-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
