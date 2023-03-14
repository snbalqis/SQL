/* --------------------
   Case Study Questions
   --------------------*/
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
--     how many points do customer A and B have at the end of January?

-- 1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, SUM(menu.price)
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY sales.customer_id;


-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date))
FROM dannys_diner.sales
GROUP BY customer_id;


-- 3. What was the first item from the menu purchased by each customer?
-- (with guidance from https://medium.com/analytics-vidhya/8-week-sql-challenge-case-study-week-1-dannys-diner-2ba026c897ab)

WITH first_order_CTE AS
	(
 		SELECT customer_id, order_date, product_name,
  		DENSE_RANK() OVER(PARTITION BY sales.customer_id
  		ORDER BY sales.order_date) AS dr
 		FROM dannys_diner.sales
 		INNER JOIN dannys_diner.menu
  		ON sales.product_id = menu.product_id
	)
SELECT customer_id, product_name
FROM first_order_CTE
WHERE dr = 1
GROUP BY customer_id, product_name
ORDER BY customer_id;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name, COUNT(product_name) AS total_number_purchased
FROM dannys_diner.menu INNER JOIN dannys_diner.sales
ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY COUNT(product_name) DESC;


-- 5. Which item was the most popular for each customer?


