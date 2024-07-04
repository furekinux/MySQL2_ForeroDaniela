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

-- Desarrollado por Daniela Forero Ballén / ID 1.142.714.225
