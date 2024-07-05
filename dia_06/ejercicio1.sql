use dia_03;

show tables;

-- 1- Escribe una consulta que permita agrupar los clientes de todos los empleados cuyo puesto sea
-- responsable de ventas. Se requiere que la consulta muestre:
-- Nombre del cliente, teléfono, la ciudad, nombre y primer apellido del responsable de ventas y su email.
create index idx_c_nombre_telefono_ciudad on cliente(nombre_cliente,telefono,ciudad);

select c.nombre_cliente as Cliente, c.telefono, c.ciudad, concat(e.nombre," ",e.apellido1) as Representante_Ventas, e.email as Email_Rep
from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado
where e.puesto="Representante Ventas";

-- 2- Se necesita obtener los registros de los pedidos entre el 15 de marzo del 2009 y el 15 de julio del
-- 2009, para todos los clientes que sean de la ciudad de Sotogrande. Se requiere mostrar el código del
-- pedido, la fecha del pedido, fecha de entrega, estado, los comentarios y el condigo del cliente que
-- realizo dicho pedido.
create index idx_p_codigo_fechasp_fechae_estado_clien on pedido(codigo_pedido,fecha_pedido,fecha_entrega,estado,codigo_cliente);

select p.codigo_pedido,p.fecha_pedido, p.fecha_entrega, p.estado,p.comentarios,p.codigo_cliente
from pedido p
left join cliente c on c.codigo_cliente = p.codigo_cliente
where c.ciudad='Sotogrande' and p.fecha_pedido between '2009-03-15' and '2009-07-15';

-- 3- Se desea obtener los productos cuya gama pertenezca a las frutas y que el proveedor sea Frutas
-- Talaveras S.A, se desea mostrar el código, nombre, descripción, cantidad en stock, y su precio con
-- 10% de descuento, de igual forma se pide la cantidad en los distintos pedidos que se han hecho.
create index idx_pr_codigo_nombre on producto(codigo_producto,nombre);
create index idx_pr_cant_precio on producto(cantidad_en_stock,precio_venta);
-- No recibe TEXT!!!!

select p.codigo_producto, p.nombre, p.descripcion, p.cantidad_en_stock, (p.precio_venta-(p.precio_venta*0.1)) as Precio_Descuento, count(d.codigo_pedido) as Pedidos_hechos
from producto p
left join detalle_pedido d on d.codigo_producto = p.codigo_producto
where p.gama="Frutales" and p.proveedor="Frutales Talavera S.A"
group by p.codigo_producto;
