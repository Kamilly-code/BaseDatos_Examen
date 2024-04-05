#1-Calcula el número total de productos que hay en la tabla productos.
use tienda;
select count(id)
from producto;

#2-Calcula el número total de fabricantes que hay en la tabla fabricante.
use tienda;
select  count(id)
from fabricante;

#3-Calcula el número de valores distintos de identificador de fabricante aparecen en la tabla productos.
use tienda;
select count(distinct id_fabricante)
from producto;

#4-Calcula la media del precio de todos los productos.
use tienda;
select avg(precio)
from producto;

#5-Calcula el precio más barato de todos los productos.
select min(precio)
from producto;

#6-Calcula el precio más caro de todos los productos.
select max(precio)
from producto;
#7-Lista el nombre y el precio del producto más barato.

use tienda;
select p.nombre, p.precio
from producto as p
order by precio asc
limit 1;


#8-Lista el nombre y el precio del producto más caro.
use tienda;
select p.nombre, p.precio
from producto as p
order by precio desc
limit 1;

#9-Calcula la suma de los precios de todos los productos.
use tienda;
select sum(precio)
from producto;

#10-Calcula el número de productos que tiene el fabricante Asus.
use tienda;

select count(p.id)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Asus';

#11-Calcula la media del precio de todos los productos del fabricante Asus.
select avg(precio)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Asus';
#12-Calcula el precio más barato de todos los productos del fabricante Asus.
select min(precio)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Asus';
#13-Calcula el precio más caro de todos los productos del fabricante Asus.
select max(precio)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Asus';
#14-Calcula la suma de todos los productos del fabricante Asus.
select sum(precio)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Asus';
#15-Muestra el precio máximo, precio mínimo, precio medio y el número total de productos que tiene el fabricante Crucial.
select max(precio), min(precio), avg(precio), count(*)
from fabricante as f join producto as p
on f.id = p.id_fabricante
where f.nombre = 'Crucial';

#16-Muestra el número total de productos que tiene cada uno de los fabricantes. El listado también debe incluir los fabricantes que no tienen ningún producto. El resultado mostrará dos columnas, una con el nombre del fabricante y otra con el número de productos que tiene. Ordene el resultado descendentemente por el número de productos.
    select  f.nombre, count(p.id)
    from producto as p right join fabricante as f # quiero todos los fabricantes entao eu coloco o join no lado do trem que eu quero (que é o fabricante), direito
    on p.id_fabricante = f.id
    group by f.nombre
    order by count(p.id) desc; #ordena descendentemente o numero dos produtos

#17-Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes. El resultado mostrará el nombre del fabricante junto con los datos que se solicitan.

    select f.nombre ,max(p.precio), min(p.precio), avg(p.precio)
    from  fabricante as f join producto as p
    on f.id = p.id_fabricante
    group by f.nombre;


#18-Muestra el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que tienen un precio medio superior a 200€. No es necesario mostrar el nombre del fabricante, con el identificador del fabricante es suficiente.

    select f.id, max(p.precio), min(p.precio), avg(p.precio), count(*) #eso mostra o número total de produtos
    from fabricante as f join producto as p
    on f.id = p.id_fabricante #esqueci disso
    group by f.id #certo
    having avg(p.precio) > 200;



#19-Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que tienen un precio medio superior a 200€. Es necesario mostrar el nombre del fabricante.

    select f.nombre, max(p.precio), min(p.precio), avg(p.precio), count(*)
    from fabricante as f join producto as p
    on f.id = p.id_fabricante
    group by f.id
    having avg(p.precio) > 200;



#20-Calcula el número de productos que tienen un precio mayor o igual a 180€.

#21-Calcula el número de productos que tiene cada fabricante con un precio mayor o igual a 180€.

#22-Lista el precio medio los productos de cada fabricante, mostrando solamente el identificador del fabricante.

#23-Lista el precio medio los productos de cada fabricante, mostrando solamente el nombre del fabricante.

#24-Lista los nombres de los fabricantes cuyos productos tienen un precio medio mayor o igual a 150€.

#25-Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.

#26-Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio superior o igual a 220 €. No es necesario mostrar el nombre de los fabricantes que no tienen productos que cumplan la condición.

#27-Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio superior o igual a 220 €. El listado debe mostrar el nombre de todos los fabricantes, es decir, si hay algún fabricante que no tiene productos con un precio superior o igual a 220€ deberá aparecer en el listado con un valor igual a 0 en el número de productos.

#28-Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus productos es superior a 1000 €.

#29-Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. El resultado debe tener tres columnas: nombre del producto, precio y nombre del fabricante. El resultado tiene que estar ordenado alfabéticamente de menor a mayor por el nombre del fabricante.