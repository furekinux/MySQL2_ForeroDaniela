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


-- ################ Consultas ################

-- Ver listado de alquiler
call listado_alquiler();
