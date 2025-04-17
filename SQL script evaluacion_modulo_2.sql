--- ejercicio 1 los nombres de las películas ---

USE sakila;
SELECT 
title
FROM film;

--- ejercicio 2  películas que tengan una clasificación de "PG-13"---

SELECT 
title
FROM film
WHERE rating = "PG-13";

--- ejercicio 3  título y descripción de las películas que contengan la palabra "amazing" ---

SELECT 
title,
description
FROM film
WHERE description LIKE '%amazing%';

--- ejercicio 4  título de las películas con una duración mayor a 120 minutos ---

SELECT
title
FROM film 
WHERE length > 120;

--- ejercicio 5  nombres de todos los actores ---

SELECT 
first_name
FROM actor;

--- ejercicio 6  nombre y apellido de los actores que tengan "Gibson" en su apellido ---

SELECT 
first_name,
last_name
FROM actor
WHERE last_name LIKE 'Gibson';

--- ejercicio 7  nombres de los actores que tengan un actor_id entre 10 y 20 ---

SELECT 
first_name 
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

--- ejercicio 8 título de las películas en la tabla film que no sean ni "R" ni "PG-13" ---

SELECT
title
FROM film
WHERE rating NOT LIKE "%R%" OR "%PG-13%";

--- ejercicio 9  cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación y el recuento ---


SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating;

--- ejercicio 10 total de películas alquiladas por cada cliente y muestra el ID del cliente, nombre y apellido junto con la cantidad ---

 -- voy a usar la tabla customer donde está el customer_id, first_name, last_name y la tabla rental donde encontraremos 
 -- las columnas rental_id y customer_id para asociar las películas alquiladas a cada cliente. Las voy a unir con un INNER JOIN
 -- despues agrupo las columnas de la tabla customer y las ordeno por orden ascendente
 
SELECT 
customer.customer_id,
customer.first_name,
customer.last_name,
COUNT(rental.rental_id) AS peliculas_alquiladas
FROM 
customer 
INNER JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY 
customer.customer_id, customer.first_name, customer.last_name
ORDER BY
peliculas_alquiladas ASC;

--- ejercicio 11  cantidad total de películas alquiladas por categoría y nombre de la categoría junto con el recuento de alquileres ---
 
 -- voy a usar la tabla category donde se encuentran las columnas category_id y name, la tabla rental donde está la columna rental_id
 -- la tabla film_category donde voy a usar category_id e inventory donde uso film_id. 


SELECT 
category.name AS categoria,
COUNT(rental.rental_id) AS alquiler_categorias_total
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id  = rental.inventory_id
GROUP BY 
category.name
ORDER BY
alquiler_categorias_total ASC;


--- ejercicio 12  promedio de duración de las películas para cada clasificación de la tabla film y 
--- muestra la clasificación junto con el promedio de duración.---
 
 -- voy a usar como se indica en el enunciado la tabla film donde se encuentra la columna lenght que indica la duración de cada
 -- película y la columna rating que indica la clasificación de las películas.
 
SELECT 
rating,
AVG(length) AS promedio_peliculas
FROM 
film
GROUP BY 
rating
ORDER BY 
promedio_peliculas ASC;


--- ejercicio 13  nombre y apellido de los actores que aparecen en la película con title "Indian Love". 

SELECT 
actor.first_name,
actor.last_name
FROM 
actor 
INNER JOIN film_actor  
ON actor.actor_id = film_actor.actor_id
INNER JOIN film  
ON film_actor.film_id = film.film_id
WHERE 
film.title = 'Indian Love';
 
 
--- ejercicio 14  Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.---

SELECT 
title
FROM 
film
WHERE description LIKE "%dog%" OR "%cat%";

--- ejercicio 15  título de todas las películas que fueron lanzadas entre el año 2005 y 2010 ---

SELECT 
title
FROM
film
WHERE release_year BETWEEN 2005 AND 2010;


--- ejercicio 16  título de todas las películas que son de la misma categoría que "Family" --- 

-- vamos a usar category, film category y film. Primero seleccionaré los titulos de las películas de la tabla film para luego relacionarlo
-- con el id_film de la tabla film_category. Despues uniré las tablas de category y film category a través de la columna category_id y por
-- último realizaré una subconsulta(subquery) para filtrar los resultados buscando que devuelva solo los registros de la categoria
-- "Family"

SELECT
title
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON category.category_id = film_category.category_id

WHERE 
category.category_id = (
	SELECT category_id
    FROM category
    WHERE name = "Family"
    );

--- ejercicio 17  título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.---


SELECT
title 
FROM
film 
WHERE rating LIKE 'R' AND length > 120;

--- ejercicios BONUS 18 nombre y apellido de los actores que aparecen en más de 10 películas.---

-- voy a usar las tablas: actor, film_actor --

SELECT 
actor.actor_id,
actor.first_name,
COUNT(film_actor.film_id) AS pelis_totales
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 10
ORDER BY pelis_totales DESC;

--- ejercicio 19 Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.---

--- ejercicio 20  categorías de películas que tienen un promedio de duración superior a 120 minutos y
--- muestra el nombre de la categoría junto con el promedio de duración.---


SELECT 
category.name AS categoria,
AVG(film.length) AS promedio_categoria
FROM 
category 
INNER JOIN film_category 
ON category.category_id = film_category.category_id
INNER JOIN film  
ON film_category.film_id = film.film_id
GROUP BY 
category.name
HAVING 
AVG(film.length) > 120
ORDER BY 
promedio_categoria ASC;


--- ejercicio 21 actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con
--- la cantidad de películas en las que han actuado.---

SELECT 
actor.first_name,
actor.last_name,
COUNT(film_actor.film_id) AS cantidad_peliculas
FROM 
actor 
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
GROUP BY 
actor.actor_id, actor.first_name, actor.last_name
HAVING 
COUNT(film_actor.film_id) >= 5
ORDER BY 
cantidad_peliculas ASC;

--- ejercicio 22  título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
--- subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
--- películas correspondientes.---


--- ejercicio 23  nombre y apellido de los actores que no han actuado en ninguna película de la categoría
--- "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
--- categoría "Horror" y luego exclúyelos de la lista de actores.---


--- ejercicio 24  título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.---

SELECT 
film.title,
film.length
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE 
category.name= 'Comedy' AND film.length > 180;








    
    
 
 
 


