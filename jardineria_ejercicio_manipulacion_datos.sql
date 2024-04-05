# 7.3 Jardinería
    use jardineria;
# Realice las siguientes operaciones sobre la base de datos jardineria.
#
# 01.- Inserta una nueva oficina en Almería.
INSERT INTO oficina VALUES ('AL-ES', 'Almería', 'España', 'Andalucía', '04001', '+34 950 322332', 'C/ Las Suertes, 27', null);
# 02.- Inserta un empleado para la oficina de Almería que sea representante de ventas.
INSERT INTO empleado VALUES (32, 'Pepe', 'Carbalho', null, '1010', 'pcarbalho@jardineria.es', 'AL-ES', 3, 'Representante Ventas');
# 03.- Inserta un cliente que tenga como representante de ventas el empleado que hemos creado en el paso anterior.
INSERT INTO cliente VALUES (39, 'Flowers & co.', 'Petra', 'Delicado', '+34 950 233223', '+34 950 233223', 'Avda. de Madrid, 27', null, 'Almería', 'Andalucía', 'Spain', '04002', 32, 50000);
# 04.- Inserte un pedido para el cliente que acabamos de crear, que contenga al menos dos productos diferentes.
INSERT INTO pedido VALUES (129, now(), now(), null,  'Pendiente', 'Investigando el pedido', 39);
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)
VALUES (129, 'FR-10', 2, 7, 1),
       (129, 'FR-2', 2, 6, 2);
#alter table detalle_pedido
#DROP constraint detalle_pedido_ibfk_1;
# 05.- Actualiza el código del cliente que hemos creado en el paso anterior y averigua si hubo cambios en las tablas relacionadas.
UPDATE cliente SET codigo_cliente = 1000 WHERE codigo_cliente = 39;

# niet. Es clave primaria que está relacionada (es clave foránea en las tablas pedido y pago)
# Para poder hacerlo tenemos que borrar la restricción de clave foránea en esas tablas y volverla a añadir con "on update cascade"
/* ALTER TABLE pedido
    DROP CONSTRAINT pedido_ibfk_1;

ALTER TABLE pedido
ADD (CONSTRAINT foreign key (codigo_cliente) references cliente (codigo_cliente)
ON UPDATE CASCADE);

ALTER TABLE pago
    DROP CONSTRAINT pago_ibfk_1;

ALTER TABLE pago
ADD (CONSTRAINT foreign key (codigo_cliente) references cliente (codigo_cliente)
ON UPDATE CASCADE);
 */

# al volver a ejecutar la instrucción UPDATE se actualiza la tabla cliente, pero no las relacionadas porque no ese cliente no ha realizado ni pedidos ni pagos.

# 06.- Borra el cliente y averigua si hubo cambios en las tablas relacionadas.
DELETE FROM cliente WHERE codigo_cliente = 39;
# NIET; POR LO MISMO

#### Práctica 5.2.- Actualizaciones y borrados con subconsultas ####

# 07.- Elimina los clientes que no hayan realizado ningún pedido.
# primero averiguamos cómo saber los clientes que no han realizado ningún pedido
/*SELECT p.codigo_cliente
FROM cliente LEFT JOIN jardineria.pago p on cliente.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
*/

DELETE FROM cliente
WHERE codigo_cliente NOT IN (SELECT DISTINCT codigo_cliente
                             FROM pedido);
# 08.- Incrementa en un 20% el precio de los productos que no tengan pedidos.
    # PRODUCTOS QUE NO TENGAN PEDIDOS -> QUE NO APAREZCAN EN LA TABLA DETALLE_PEDIDO
    /*SELECT DISTINCT codigo_producto
    FROM detalle_pedido;
    */

UPDATE producto
SET precio_venta = precio_venta + precio_venta * (20/100),
    precio_proveedor = precio_proveedor + precio_proveedor * (20/100)
WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto
                              FROM pedido);


# 09.- Borra los pagos del cliente con menor límite de crédito.

# 10.- Establece a 0 el límite de crédito del cliente que menos unidades pedidas tenga del producto 11679.
    select min(cantidad) as 'CANTIDAD_MINÍMA'
    from detalle_pedido
    where codigo_producto = '11679';

# 1) LAS UNIDADES PEDIDAS DE ESE PRODUCTO LAS ENCONTRAMOS EN DETALLE_PEDIDO, EN EL CAMPO 'cantidad'
SELECT * FROM detalle_pedido
WHERE codigo_producto = '11679';


# 2) NECESITAMOS SABER LA CANTIDAD MENOR
SELECT MIN(cantidad)
FROM detalle_pedido
WHERE codigo_producto = '11679';


# 3) NECESITAMOS EL CÓDIGO DE PEDIDO QUE CORRESPONDE A LA CONSULTA ANTERIOR
SELECT codigo_pedido
FROM detalle_pedido
WHERE cantidad = (SELECT MIN(cantidad)
                 FROM detalle_pedido
                 WHERE codigo_producto = '11679')
AND codigo_producto = '11679';

#OU ASSIM TAMBÉM:

select codigo_pedido
from detalle_pedido
where codigo_producto = '11679'
and cantidad = (select min(cantidad)
                from detalle_pedido
                where codigo_producto= '11679');

# 4)   AHORA NECESITAMOS SABER EL CLIENTE QUE HA REALIZADO EL PEDIDO ANTERIOR, Y ESO ESTÁ EN LA TABLA PEDIDO
SELECT codigo_cliente
FROM pedido
WHERE codigo_pedido = (SELECT codigo_pedido
                       FROM detalle_pedido
                       WHERE cantidad = (SELECT MIN(cantidad)
                                           FROM detalle_pedido
                                           WHERE codigo_producto = '11679')
                                           AND codigo_producto = '11679');
# 5) ya casi estamos. Ahora, para ese cliente, actualizamos(UPDATE) el límite de  crédito
UPDATE cliente
SET limite_credito = 0
WHERE codigo_cliente = (SELECT codigo_cliente
                       FROM pedido
                       WHERE codigo_pedido = (SELECT codigo_pedido
                                              FROM detalle_pedido
                                              WHERE cantidad = (SELECT MIN(cantidad)
                                                                FROM detalle_pedido
                                                                WHERE codigo_producto = '11679')
                                                                AND codigo_producto = '11679'));

# 11.- Modifica la tabla detalle_pedido para insertar un campo numérico llamado iva. Mediante una transacción, establece el valor de ese campo a 18 para aquellos registros cuyo pedido tenga fecha a partir de Enero de 2009. A continuación actualiza el resto de pedidos estableciendo el iva al 21.
# https://gestionbasesdatos.readthedocs.io/es/latest/Tema3/Teoria.html#creacion-modificacion-y-eliminacion-de-tablas

ALTER TABLE detalle_pedido
ADD (iva DECIMAL(4, 2));

# 2) Buscamos los pedidos desde enero de 2009
SELECT *
FROM pedido
WHERE fecha_pedido >= '2009-01-01';

# 3) Ahora actualizamos el campo iva para esos pedidos
UPDATE detalle_pedido
SET iva = 18.00
WHERE codigo_pedido IN (SELECT codigo_pedido
                       FROM pedido
                        WHERE fecha_pedido >= '2009-01-01');

# 4) Y ahora actualizamos el iva para los otros
UPDATE detalle_pedido
SET iva = 21.00
WHERE codigo_pedido IS NOT NULL;

# 12.- Modifica la tabla detalle_pedido para incorporar un campo numérico llamado total_linea y actualiza todos sus registros para calcular su valor con la fórmula:
#1) Añadimos el campo total_linea a detalle_pedido
ALTER TABLE detalle_pedido
ADD (total_linea DOUBLE);

# 2) Y ahora actualizamos su valor en todos los registros
UPDATE detalle_pedido
SET total_linea = precio_unidad*cantidad * (1 + (iva/100));
# total_linea = precio_unidad*cantidad * (1 + (iva/100));

# 13.- Borra el cliente que menor límite de crédito tenga. ¿Es posible borrarlo solo con una consulta? ¿Por qué?
DELETE FROM cliente WHERE limite_credito IN (SELECT MIN(limite_credito)
                                             FROM cliente);
# Da error
# No puedes modificar una tabla y seleccionar desde la misma tabla en una subconsulta en la misma consulta.
#
# La solución a este problema es utilizar una consulta anidada.

 DELETE FROM cliente
 WHERE limite_credito IN (
    SELECT * FROM (
        SELECT MIN(limite_credito) FROM cliente
    ) AS tmp);

# En este caso, la consulta interna SELECT MIN(limite_credito) FROM cliente se ejecuta primero y MySQL la almacena temporalmente como ‘tmp’. Luego, la consulta externa se ejecuta utilizando los resultados almacenados de ‘tmp’. De esta manera, no estás seleccionando directamente de la misma tabla que estás tratando de actualizar.
# 14.- Inserta una oficina con sede en Granada y tres empleados que sean representantes de ventas.
INSERT INTO oficina VALUES ('GR-ES','Granada', 'España', 'Andalucía', '04001', '+34 950 322332', 'C/ Las Suertes, 27', null);

INSERT INTO empleado VALUES (33, 'Sherlock', 'Holmes', null, '1010', 'sholmes@jardineria.es', 'GR-ES', 3, 'Representante Ventas');
INSERT INTO empleado VALUES (34, 'Eliott', 'Ness', null, '1010', 'eness@jardineria.es', 'GR-ES', 3, 'Representante Ventas');
INSERT INTO empleado VALUES (35, 'Mikael', 'Blomkvist', null, '1010', 'pcarbalho@jardineria.es', 'GR-ES', 3, 'Representante Ventas');
# 15.- Inserta tres clientes que tengan como representantes de ventas los empleados que hemos creado en el paso anterior.
INSERT INTO cliente VALUES (40, 'Plantitas', 'Philip', 'Marlowe', '+34 958 233223', '+34 958 233223', 'Avda. de Madrid, 27', null, 'Granada', 'Andalucía', 'Spain', '18001', 33, 50000);
INSERT INTO cliente VALUES (41, 'El jardín del edén', 'Kurt', 'Wallander', '+34 958 233224', '+34 958 233224', 'Avda. de Madrid, 27', null, 'Granada', 'Andalucía', 'Spain', '18001', 34, 50000);
INSERT INTO cliente VALUES (42, 'Under the lemon tree', 'Yoko', 'Ono', '+34 958 233225', '+34 958 233225', 'Avda. de Madrid, 27', null, 'Granada', 'Andalucía', 'Spain', '18001', 35, 50000);
# 16.- Realiza una transacción que inserte un pedido para cada uno de los clientes. Cada pedido debe incluir dos productos.
START TRANSACTION;
        INSERT INTO pedido VALUES (130, now(), now(), null,  'Pendiente', 'Investigando el pedido', 40);
        INSERT INTO detalle_pedido VALUES (130, 'FR-10', 2, 7, 1, 18, (2*7+2*7*0.18));
        INSERT INTO detalle_pedido VALUES (130, 'FR-2', 2, 6, 2, 18, (2*7+2*7*0.18));

        INSERT INTO pedido VALUES (131, now(), now(), null,  'Pendiente', 'Investigando el pedido', 41);
        INSERT INTO detalle_pedido VALUES (131, 'FR-10', 2, 7, 1,18, (2*7+2*7*0.18));
        INSERT INTO detalle_pedido VALUES (131, 'FR-2', 2, 6, 2,18, (2*7+2*7*0.18));

        INSERT INTO pedido VALUES (132, now(), now(), null,  'Pendiente', 'Investigando el pedido', 42);
        INSERT INTO detalle_pedido VALUES (132, 'FR-10', 2, 7, 1,18, (2*7+2*7*0.18));
        INSERT INTO detalle_pedido VALUES (132, 'FR-2', 2, 6, 2,18, (2*7+2*7*0.18));
COMMIT ;
# 17.- Borra uno de los clientes y comprueba si hubo cambios en las tablas relacionadas. Si no hubo cambios, modifica las tablas necesarias estableciendo la clave foránea con la cláusula ON DELETE CASCADE.
DELETE FROM cliente WHERE codigo_cliente = 40;
# Error que salta: [23000][1451] Cannot delete or update a parent row: a foreign key constraint fails (`jardineria`.`pedido`, CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`codigo_cliente`) REFERENCES `cliente` (`codigo_cliente` -> tenemos que modificar la restricción en la tabla pedido, esto es:
--     constraint pedido_ibfk_1
--      foreign key (codigo_cliente) references cliente (codigo_cliente)

ALTER TABLE pedido
    DROP CONSTRAINT pedido_ibfk_1;

ALTER TABLE pedido
ADD (CONSTRAINT pedido_ibfk_1
FOREIGN KEY (codigo_cliente)
REFERENCES cliente (codigo_cliente)
    ON DELETE CASCADE);

-- AL HACER ESTO Y VOLVER A INTENTAR EL DELETE, SALTA OTRO ERROR: Cannot delete or update a parent row: a foreign key constraint fails (`jardineria`.`detalle_pedido`, CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`codigo_pedido`) REFERENCES `pedido` (`codigo_pedido`))
    -- AHORA TENEMOS QUE HACER LO MISMO EN LA TABLA DETALLE_PEDIDO

ALTER TABLE detalle_pedido
    DROP CONSTRAINT detalle_pedido_ibfk_1;

ALTER TABLE detalle_pedido
ADD (CONSTRAINT detalle_pedido_ibfk_1
FOREIGN KEY (codigo_pedido)
REFERENCES pedido (codigo_pedido)
    ON DELETE CASCADE);

# 18.- Realiza una transacción que realice los pagos de los pedidos que han realizado los clientes del ejercicio anterior.
# aquí el tema está en calcular el total de cada pago para los dos clientes que quedan:
-- 1) en la siguiente consulta vemos lo que tiene que pagar el cliente con código 41
    SELECT *
    FROM detalle_pedido
    WHERE codigo_pedido IN (SELECT codigo_pedido
                            FROM pedido
                            WHERE codigo_cliente = 41);
-- 2) tenemos que sumar el total de las dos líneas (o las que fueran) que aparecen
    SELECT SUM(total_linea)
    FROM detalle_pedido
        WHERE codigo_pedido IN (SELECT codigo_pedido
                            FROM pedido
                            WHERE codigo_cliente = 41);

-- 3) ESE ES EL TOTAL QUE TENEMOS QUE AÑADIR EN EL PAGO. Podemos hacerlo de la siguiente forma: primero creamos el registro con todos los datos y el total = 0 y a continuación actualizamos ese campo al valor de la suma calculada en el punto 2
 START TRANSACTION;
    -- CLIENTE CÓDIGO 41
    INSERT INTO pago VALUES (41, 'PayPal', 'ak-std-000036', now(), 0);
    UPDATE pago
    SET total =  (SELECT SUM(total_linea)
                 FROM detalle_pedido
                 WHERE codigo_pedido IN (SELECT codigo_pedido
                                         FROM pedido
                                         WHERE codigo_cliente = 41))
    WHERE codigo_cliente = 41;

    -- CLIENTE CÓDIGO 42
    INSERT INTO pago VALUES (42, 'PayPal', 'ak-std-000037', now(), 0);
    UPDATE pago
    SET total =  (SELECT SUM(total_linea)
                 FROM detalle_pedido
                 WHERE codigo_pedido IN (SELECT codigo_pedido
                                         FROM pedido
                                         WHERE codigo_cliente = 42))
    WHERE codigo_cliente = 42;
COMMIT ;