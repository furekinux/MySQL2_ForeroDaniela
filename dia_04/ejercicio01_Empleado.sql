-- ################################
-- #### DIA 04/05 - AUTORENTAL ####
-- ################################

-- Usuario: empleado
-- Contraseña: ********

use mysql2_d04;

show tables;


-- Permisos:
-- * Ver historial de alquiler

-- Información habilitada
select *
from alquiler;

select id, nombres, apellidos
from empleado;

select id, nombres, apellidos
from cliente;

select ciudad
from sucursal;

-- Consulta
select id_vehiculo as ID_Vehiculo, concat(c.nombres," ",c.apellidos) as Cliente, concat(e.nombres," ",e.apellidos) as Empleado,
s.ciudad as Salida_de, fecha_salida as Salida, s2.ciudad as Llega_a, fecha_llegada as Llegada, fecha_esperada_llegada as Fecha_esperada
from alquiler a
inner join empleado e on e.id = a.id_empleado
inner join cliente c on c.id = a.id_cliente
inner join sucursal s on s.id = a.id_sucursal_salida
inner join sucursal s2 on s2.id = a.id_sucursal_llegada
order by id_vehiculo;
