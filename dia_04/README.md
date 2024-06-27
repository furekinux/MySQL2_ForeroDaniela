# ${\color{red}Auto \space \color{Goldenrod}Rental}$ :red_car:

Proyecto de creación de una base de datos para el manejo de información de una empresa de renta de vehículos. Esta base de datos cuenta con la información para la administración general de clientes, vehículos, empleados, sucursales y registro de alquileres realizados.

## Tablas
La información será organizada por medio de 5 tablas principales:

### Sucursal
* Esta tabla se encarga de almacenar la ciudad y dirección donde se ubica, teléfono fijo, celular y correo electrónico, de cada sucursal con la que cuenta la empresa AutoRental.

### Empleados
* Este listado cuenta con la información almacenada de la sucursal donde labora, cédula, nombres, apellidos, dirección y ciudad de residencia, celular y correo electrónico de cada uno de los empleados correspondientes a cada sucursal.

### Clientes
* Este conjunto de información se encarga de almacenar la información de cédula, nombres, apellidos, dirección y ciudad de residencia, celular y correo electrónico de los clientes registrados.

### Vehículos
* A continuación la tabla de vehículos que consta de la información de tipo de vehículo, placa, referencia, modelo, puertas, capacidad, sunroof, motor, color.

### Alquileres
* Finalmente, esta tabla se encarga de almacenar la información de los alquileres realizados en la empresa, conteniendo información como vehículo, cliente, empleado, sucursal y fecha de salida, sucursal y fecha de llegada, fecha esperada de llegada, valor de alquiler por semana, valor de alquiler por día, porcentaje de descuento, valor cotizado y valor pagado.

## Usuarios
El acceso a la información será posible por medio de los siguientes tipos de usuarios:

### ${\color{red}Administrador}$
Este tipo de usuario posee los siguientes privilegios en el sistema de información:

Creación/Ingreso de nueva fila de información a cualquiera de las tablas antes mencionadas, todo esto por medio del proceso: (Work in process...)
* Para hacer uso del proceso (work in process) se aplicará la sintáxis: (work in process).

Revisión/Lectura de la información contenida por cada tabla de la base de datos, para consultar puntos específicos se cuenta con los procesos: (work in process)
* Para revisar una única tabla por medio del proceso (work in process) se hará uso de la siguiente sintáxis: (work in process).

Actualización/Modificación de la información de cada tabla de la nase de datos, para realizar el proceso de actualización se cuenta con los siguientes procesos: (...)
* 

Descarte/Eliminación de informacion de la base de las tablas contenidas en la base de datos, para realizar este proceso se hará uso de los procesos: (...)
* 

### ${\color{RubineRed}Empleado}$ 
Este tipo de usuario posee las siguientes capacidades de acceso al sistema de información:

Revisión/Lectura de la información del historial de alquilieres realizados.
* Se utiliza el procedimiento listado_alquiler() de la siguiente manera:
```sql
-- Devuelve el listado con la información de cada uno de los alquileres realizados por los clientes
call listado_alquiler();
```

Revisión/Lectura de la información de los vehículos disponibles para alquiler de acuerdo al tipo.
* Se utiliza el procedimiento listado_vehiculos_disponibles(tipo) de la siguiente manera:
```sql
-- Devuelve el listado de los vehìculos disponibles y que son del tipo especificado entre paréntesis
call listado_vehiculos_disponibles("Sedán");
```

Revisión/Lectura de la información de el rango de precios de alquiler de acuerdo al tipo de vehículo para alquiler.

Revisión/Lectura de la información de las fechas de disponibilidad de un vehículo específico.
* Se utliza el procedimiento disponible_fecha(id_vehiculo) de la siguiente manera:
```sql
-- Devuelve el listado con la información de fechas de los autos alquilados
call disponible_fecha(8);
```

Creación/Ingreso de nuevos clientes y/o información de alquileres que se realice.
* Se utiliza el procedimiento nuevo_cliente(cedula,nombres,apellidos,direccion,ciudad,celular,email) de la siguiente manera:
```sql
-- Registra nuevos clientes en la base de datos
call nuevo_cliente("1299978900","Daniela","Forero Ballén","???","Somewhere","123456","test@gmail.com");
```
