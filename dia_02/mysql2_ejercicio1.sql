-- ###################################
-- ######## DIA 02 - MySQL 2 #########
-- ###################################
create database mysql2_dia_02;
use mysql2_dia_02;

create table productos(
	id int auto_increment,
	nombre varchar(100),
	precio decimal(10,2),
	primary key(id)
);
insert into productos values
	(1,"Pepito",23.2),
	(2,"MousePad",100000.21),
	(3,"Espionap",2500.25),
	(4,"BOB-ESPONJA",1500.25),
	(5,"Cary",23540000.23),
	(6,"OvulAPP",198700.23),
    (7,"PapayAPP",2000.00),
    (8,"Menosprecio",3800.00),
    (9,"PerfumeMascotas",2300.00),
    (10,"Perfume La Cumbre", 35000.25),
    (11,"Nevera M800",3000.12),
    (12,"Crema Suave", 2845.00),
    (13,"juego de mesa La Cabellera",9800.00),
    (14,"Cargador iPhone",98000.00);
    
show tables;
select * from productos;

-- ########################### Funciones ###########################

-- Crear función la cual me retorne el nombre
-- del producto con el precio mas IVA(19%)
-- Donde si vale más de 1000 se aplica u escuebto de 20%

-- FUNCIÓN GENERA UN **RETORNO**
delimiter //
create function TotalConIVA(precio decimal(10,2), iva decimal(5,3))
returns varchar(255) deterministic
begin
	if precio > 1000 then
		return CONCAT("Tu precio con el descuento es de: ",(precio+(precio*iva))-((precio+(precio*iva))*0.2));
	else
		return CONCAT("Tu precio completo es de: ",(precio+(precio*iva)));
	end if;
end//
delimiter ;

-- Eliminiar funcion :(
drop function TotalConIVA;

-- Utilizar función iva:
select TotalConIVA(25000,0.19);

-- Extrapolar función con datos de la base de datos
select TotalConIVA(p.precio,0.19)
from productos p;


-- Obterner el precio de un producto dado su nombre
delimiter //
create function obtener_precio_producto(nombre_producto varchar(100))
returns decimal(10,2)
deterministic
begin
	declare precio_producto decimal(10,2);
    select precio into precio_producto from productos
    where nombre = nombre_producto;
    return precio_producto;
end//
delimiter ;
select obtener_precio_producto('Crema Suave') as Precio;

-- Obterner el precio de un producto(con iva) dado su nombre
delimiter //
create function obtener_precio_producto_prom(nombre_producto varchar(100),iva decimal(5,3))
returns decimal(10,2)
deterministic
begin
	declare precio_producto decimal(10,2);
    select precio into precio_producto from productos
    where nombre = nombre_producto;
    if precio_producto > 1000 then
		return precio_producto+(precio_producto*iva)-(precio_producto+(precio_producto*iva))*0.2;
	else
		return precio_producto+(precio_producto*iva);
	end if;
end//
delimiter ;

drop function obtener_precio_producto_prom;

select obtener_precio_producto_prom('Crema Suave',0.19) as Precio;

-- Precio promedio de productos
delimiter //
create function precio_promedio_productos()
returns decimal (10,2)
deterministic
begin
	declare promedio decimal(10,2);
    select avg(precio) into promedio from productos;
    return promedio;
end//
delimiter ;

-- Usar funcion: SELECT
select precio_promedio_productos();

-- ########################### Procedimientos ###########################

-- Procedimiento para insertar un nuevo producto
delimiter //
create procedure insertar_producto(in nombre_producto varchar(100),
 IN precio_producto decimal(10,2))
 begin
	insert into productos (nombre, precio)
    values (nombre_producto, precio_producto);
 end //
 delimiter ;
 
-- Usar procedimiento: CALL
call insertar_producto('Delfin', 600.00);
select * from productos;

-- Procedimiento para eliminar un producto de acuerdo a su nombre
delimiter //
create procedure eliminar_producto (in nombre_producto varchar(100))
begin
	delete from productos where nombre = nombre_producto;
end //
delimiter ;

call eliminar_producto('Delfin');

-- ########################### Notas ###########################

-- DETERMINISTIC: siempre retorna el mismo resultado dado los mismo
-- parametros ingresados en el mismo estado de la base de datos

-- NON DETERMINISTIC: no necesariamente siempre devuelve el mismo
-- resultado de los mismos parámetros en el mismo estado de la base de datos

-- DELIMITER HACE COMANDOS INTERNOS DEL SISTEMA Y NO UNA CONSULTA NORMAL
