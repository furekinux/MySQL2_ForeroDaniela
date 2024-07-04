-- #########################################
-- ######### Dia - 06 SUBCONSULTAS #########
-- #########################################

use mysql2_dia05;
-- SE USAN PARA REALIZAR OPERACIONES QUE REQUIEREN UN CONJUNTO DE DATOS QUE SE OBTIENE DE MANERA DINÁMICA A TRAVÉS de otra consulta

-- Subconsulta ESCALAR: TODA Subconsulta que devuelve un SOLO valor(fila y columna)
-- EJ: Devuelve nombre del país con la mayor población
select Name
from country
where Population = (select max(Population) from country);

-- Subconsulta de Columna Única: Devuelve una columna con múltiples filas.
-- EJ: Encuentre los nombre de todas las ciudades en los paises que tienen un aream mayor a 1000000 km2
select Name
from city
where CountryCode In (
select Code from country where SurfaceArea > 1000000);

-- Subconsulta de MÚLTIPLES COLUMNAS: Devuelve múltiples columnas de múltiples filas.
-- EJ: Encontrar las ciudades que tenga la misma población y distrito que cualquier ciudad del país. 'USA'
select Name,CountryCode,District,Population
from city
where (District,Population) in (select District,Population from
 city where CountryCode = 'USA');

-- Subconsulta Correlacionada: Depende de la consulta externa para cada fila procesada.
-- EJ: Liste las ciudades con una población mayor al promedio de la población de las ciudades en el mismo país
select Name,CountryCode,Population
from city c1
where Population >(
select avg(Population) from city c2 where c1.CountryCode = c2.CountryCode);

-- Subconsulta Multiple:
-- EJ: Listar ciudades que tengan la misma población que la capital del país
-- 'JPN' (Japón)
select Name
from city
where Population =
(select Population from city where ID=
(select Capital from country where Code = 'JPN'));

-- INDEXACIÓN
select * from city;

-- CREAR índice en la columna 'Name' de City
create index idx_city_name on city(Name);
select * from city;
select Name from city;

-- CREAR índice compuestro de las columnas 'District' y 'Population'
create index idx_city_district_population on city(District,Population);

-- Datos estadísticos para ver los índices creados
SELECT
    TABLE_NAME,
    INDEX_NAME,
    SEQ_IN_INDEX,
    COLUMN_NAME,
    CARDINALITY,
    SUB_PART,
    INDEX_TYPE,
    COMMENT
FROM
    information_schema.STATISTICS
WHERE
    TABLE_SCHEMA = 'mysql2_dia5';
-- Revisar tamaño de Indexaciones creadas
SELECT
    TABLE_NAME,
    INDEX_LENGTH
FROM
    information_schema.TABLES
WHERE
    TABLE_SCHEMA = 'mysql2_dia5';


-- Transacciones
-- Secuencias de uno o mas operaciones SQL, las cuales son ejecutadas como unica unidad de trabajo.
-- en otras palabras, aseguran que todas las operaciones se realicen de manera correcta antes de ser
-- ejecutadas en la bbdd real, buscando cumplir con las propiedades
-- ACID, (atomicidad, consistencia, aislamiento, durabilidad)

-- 1º Paso: Inicar transacción(hacen cambios pero no en tiempo real en la BBDD
start transaction;
-- 2º Paso: Realizar cambios
-- EJ: Actualizar la población de la ciudad de 'New York'
update city
set population = 9000000
where Name = 'New York';

select * from city where Name= 'New York';

-- 3º Paso:
--   Mantener cambios: COMMIT
--   Revertir cambios: ROLLBACK
commit;
rollback;

-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
