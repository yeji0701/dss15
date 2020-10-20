# 1.
SELECT customer.customer_id, CONCAT(first_name, " ", last_name, " ") AS full_name,
	sum(amount) AS amount
FROM customer
JOIN payment
ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id
ORDER BY amount DESC
LIMIT 5

# 2.
SELECT actor.actor_id, CONCAT(actor.first_name, " ", actor.last_name, " ") AS full_name,
	COUNT(film_id) AS count
FROM actor
JOIN film_actor
ON actor.actor_id=film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY COUNT DESC
LIMIT 10

# 3.
SELECT category.NAME, SUM(amount) AS total_amount
FROM category, payment, film_category, rental, inventory
WHERE category.category_id=film_category.category_id
	and film_category.film_id=inventory.film_id
	AND inventory.inventory_id=rental.inventory_id
	and payment.rental_id=rental.rental_id
GROUP BY category.category_id
ORDER BY total_amount desc