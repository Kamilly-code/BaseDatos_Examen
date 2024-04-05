# https://josejuansanchez.org/bd/unidad-11-teoria/index.html#ejercicios-pr%C3%A1cticos

    # INSERT INTO tabla (columna1, columna2, ....) VALUES (valor1, valor2,...);


# CADA VEZ QUE VAYAS A REALIZAR ESTOS EJERCICIOS ACUÉRDATE DE RESTAURAR LA BASE DE DATOS tienda A SU CONFIGURACIÓN ORIGINAL CON https://github.com/anaijg/BBDD-23-24/blob/main/tienda_esquema_y_datos.sql
DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;

CREATE TABLE fabricante (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DOUBLE NOT NULL,
  id_fabricante INT UNSIGNED NOT NULL,
  FOREIGN KEY (id_fabricante) REFERENCES fabricante(id)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');

INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);


# 7.1 Tienda de informática
# Realice las siguientes operaciones sobre la base de datos tienda.
use tienda;
# 01.- Inserta un nuevo fabricante indicando su código y su nombre.
# INSERT INTO tabla (columna1, columna2, ....) VALUES (valor1, valor2,...);
    insert into fabricante (id, nombre) VALUES (10, 'Apple');
    # comprobamos que se ha añadido
    select * from fabricante order by id desc limit 5;

# 02.- Inserta un nuevo fabricante indicando solamente su nombre.
    # como al crear la tabla fabricante con DDL hicimos el campo id AUTO_INCREMENT, no es necesario especificarlo en los inserts porque se autoincrementará automáticamente
    insert into fabricante (nombre) VALUES ('Dell'); # tiene el peligro de que si ejecutas n veces esta misma instrucción, se crearán n filas 'Dell', cada una con un id
# comprobamos que se ha insertado
    select * from fabricante order by id desc limit 3;

# 03.- Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La sentencia de inserción debe incluir: código, nombre, precio y código_fabricante.
    # 'Apple' -> 'Apple Vision pro' 3500
    insert into producto (id, nombre, precio, id_fabricante) values (12, 'Apple vision pro', 3500, 10);

    select * from producto where id > 7;
# 04.- Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La sentencia de inserción debe incluir: nombre, precio y código_fabricante.
    insert into producto (nombre, precio, id_fabricante) values ('Latitude 5440 Portátil', 1554.96, 11);

    select * from producto where id > 7;

# 05.- Crea una nueva tabla con el nombre fabricante_productos que tenga las siguientes columnas: nombre_fabricante, nombre_producto y precio. --> esto es DDL de la 1ª evaluación
create table fabricante_productos (
  nombre_fabricante varchar(100) not null,
  nombre_producto varchar(100) not null,
  precio decimal(6, 2) not null check ( precio > 0 )
);

# Una vez creada la tabla inserta todos los registros de la base de datos tienda en esta tabla haciendo uso de única operación de inserción.
# la sintaxis aquí sería: INSERT INTO tabla (columna1, columna2, ....) SELECT...;
    # HACEMOS PRIMERO EL SELECT PARA VER SI FUNCIONA
    # select f.nombre as nombre_fabricante, p.nombre as nombre_producto, precio
    # from fabricante as f join producto as p
    # on f.id = p.id_fabricante;
    insert into fabricante_productos (nombre_fabricante, nombre_producto, precio) SELECT f.nombre as nombre_fabricante, p.nombre as nombre_producto, precio
                                                                                    from fabricante as f join producto as p
                                                                                    on f.id = p.id_fabricante;

# 6.- Crea una vista con el nombre vista_fabricante_productosque tenga las siguientes columnas: nombre_fabricante, nombre_producto y precio.
-- eso no lo hemos dado todavía

# 07.- Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
delete from fabricante
where nombre = 'Asus';
# NO DEJA -> faltaría el on delete cascade porque eliminando un fabricante corrompemos la base de datos si hay productos que lo tengan como referencia

# 08.- Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
delete from fabricante
where nombre = 'Xiaomi'; # me deja porque no hay ningún producto que sea de Xiaomi (id=9)

# 09.- Actualiza el código del fabricante Lenovo y asígnale el valor 20. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
update fabricante set id = 20 where nombre = 'Lenovo'; # no deja porque id es clave primaria en la tabla productos y tenemos dos producto de Lenovo;

# 10.- Actualiza el código del fabricante Huawei y asígnale el valor 30. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
update fabricante set id = 30 where nombre = 'Huawei';
# 11.- Actualiza el precio de todos los productos sumándole 5 € al precio actual.
update producto set precio = precio + 5;

# 12.- Elimina todas las impresoras que tienen un precio menor de 200 €.
delete from producto
where nombre like '%impresora%' and precio < 200;