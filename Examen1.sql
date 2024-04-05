# 7.3 Jardinería
# Realice las siguientes operaciones sobre la base de datos jardineria.
#
# 01.- Inserta una nueva oficina en Almería.

# 02.- Inserta un empleado para la oficina de Almería que sea representante de ventas.

# 03.- Inserta un cliente que tenga como representante de ventas el empleado que hemos creado en el paso anterior.

# 04.- Inserte un pedido para el cliente que acabamos de crear, que contenga al menos dos productos diferentes.

# 05.- Actualiza el código del cliente que hemos creado en el paso anterior y averigua si hubo cambios en las tablas relacionadas.

# 06.- Borra el cliente y averigua si hubo cambios en las tablas relacionadas.

# 07.- Elimina los clientes que no hayan realizado ningún pedido.

# 08.- Incrementa en un 20% el precio de los productos que no tengan pedidos.

# 09.- Borra los pagos del cliente con menor límite de crédito.

# 10.- Establece a 0 el límite de crédito del cliente que menos unidades pedidas tenga del producto 11679.

# 11.- Modifica la tabla detalle_pedido para insertar un campo numérico llamado iva. Mediante una transacción, establece el valor de ese campo a 18 para aquellos registros cuyo pedido tenga fecha a partir de Enero de 2009. A continuación actualiza el resto de pedidos estableciendo el iva al 21.

# 12.- Modifica la tabla detalle_pedido para incorporar un campo numérico llamado total_linea y actualiza todos sus registros para calcular su valor con la fórmula:

# total_linea = precio_unidad*cantidad * (1 + (iva/100));
# 13.- Borra el cliente que menor límite de crédito tenga. ¿Es posible borrarlo solo con una consulta? ¿Por qué?

# 14.- Inserta una oficina con sede en Granada y tres empleados que sean representantes de ventas.

# 15.- Inserta tres clientes que tengan como representantes de ventas los empleados que hemos creado en el paso anterior.

# 16.- Realiza una transacción que inserte un pedido para cada uno de los clientes. Cada pedido debe incluir dos productos.

# 17.- Borra uno de los clientes y comprueba si hubo cambios en las tablas relacionadas. Si no hubo cambios, modifica las tablas necesarias estableciendo la clave foránea con la cláusula ON DELETE CASCADE.

# 18.- Realiza una transacción que realice los pagos de los pedidos que han realizado los clientes del ejercicio anterior.