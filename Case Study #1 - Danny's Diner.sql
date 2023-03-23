/* --------------------
   Case Study Questions
   --------------------*/


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
--- initial query
SELECT sales.customer_id, menu.product_name, COUNT(sales.product_id) AS total,
FROM dannys_diner.menu INNER JOIN dannys_diner.sales
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id, menu.product_name;

--- edited query
WITH popular_item_cte AS
	(
 		SELECT sales.customer_id, menu.product_name
		,COUNT(sales.product_id) AS total,
  		DENSE_RANK() OVER(PARTITION BY sales.customer_id
  		ORDER BY COUNT(sales.customer_id) DESC) AS dr
		FROM dannys_diner.menu INNER JOIN dannys_diner.sales
 		ON sales.product_id = menu.product_id
		GROUP BY sales.customer_id, menu.product_name
	)
SELECT customer_id, product_name, total
FROM popular_item_cte
WHERE dr = 1
ORDER BY customer_id, product_name;


-- 6. Which item was purchased first by the customer after they became a member?
--- initial query
SELECT sales.customer_id, join_date, order_date, product_name
FROM dannys_diner.sales INNER JOIN dannys_diner.members
ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
WHERE order_date > join_date
ORDER BY sales.customer_id, order_date;

--- edited query
WITH first_purchase_cte AS
	(
		SELECT sales.customer_id, join_date, order_date
		,product_name,
      	DENSE_RANK() OVER(PARTITION BY sales.customer_id
		ORDER BY order_date ASC) AS dr
		FROM dannys_diner.sales INNER JOIN dannys_diner.members
		ON sales.customer_id = members.customer_id
		INNER JOIN dannys_diner.menu
		ON sales.product_id = menu.product_id
		WHERE order_date >= join_date
		ORDER BY sales.customer_id, order_date
	)
SELECT customer_id, join_date, order_date, product_name
FROM first_purchase_cte
WHERE dr = 1
ORDER BY customer_id;


-- 7. Which item was purchased just before the customer became a member?
WITH purchased_before_memberCTE AS
	(
		SELECT sales.customer_id, join_date, order_date
		,product_name,
      		DENSE_RANK() OVER(PARTITION BY sales.customer_id
		ORDER BY order_date DESC) AS dr
		FROM dannys_diner.sales INNER JOIN dannys_diner.members
		ON sales.customer_id = members.customer_id
		INNER JOIN dannys_diner.menu
		ON sales.product_id = menu.product_id
		WHERE order_date < join_date
		ORDER BY sales.customer_id, order_date DESC
      )
SELECT customer_id, join_date, order_date, product_name
FROM purchased_before_memberCTE
WHERE dr = 1
ORDER BY customer_id;


-- 8. What is the total items and amount spent for each member before they became a member?
--- initial query
SELECT sales.customer_id, product_name, COUNT(sales.product_id), SUM(price)
FROM  dannys_diner.sales INNER JOIN dannys_diner.members
ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
WHERE order_date < join_date
GROUP BY sales.customer_id, product_name
ORDER BY sales.customer_id;

--- edited query
WITH total_amountItem_cte AS
	(
		SELECT sales.customer_id, product_name, COUNT(sales.product_id), SUM(price) AS totalspent
		FROM  dannys_diner.sales INNER JOIN dannys_diner.members
		ON sales.customer_id = members.customer_id
		INNER JOIN dannys_diner.menu
		ON sales.product_id = menu.product_id
		WHERE order_date < join_date
		GROUP BY sales.customer_id, product_name
		ORDER BY sales.customer_id
    )
SELECT total_amountItem_cte.customer_id, COUNT(DISTINCT(product_name)) AS uniqueItems, SUM(totalspent)
FROM total_amountItem_cte
GROUP BY total_amountItem_cte.customer_id;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
--- initial query
SELECT customer_id, order_date, sales.product_id, price,
CASE
    WHEN sales.product_id = 1 THEN (price*20)
    ELSE (price*10)
END AS points
FROM dannys_diner.sales INNER JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
ORDER BY customer_id, sales.product_id;

--- edited query
WITH customer_points_cte AS
	(
		SELECT customer_id, order_date, sales.product_id, price,
		CASE
    	WHEN sales.product_id = 1 THEN (price*20)
    	ELSE (price*10)
		END AS points
		FROM dannys_diner.sales INNER JOIN dannys_diner.menu
		ON sales.product_id = menu.product_id
		ORDER BY customer_id, sales.product_id
	)
SELECT customer_id, SUM(points)
FROM customer_points_cte
GROUP BY customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
--     how many points do customer A and B have at the end of January?
--- first query
WITH customerDates_cte AS
		(
			SELECT *, DATEADD(day, 6, join_date) AS firstweek_date, EOMONTH('2021-01-31') AS endJan_date
			FROM members
		)
SELECT cd.customer_id, cd.join_date, order_date, cd.firstweek_date, cd.endJan_date, 
	   sales.product_id, price,
	CASE
	WHEN order_date BETWEEN cd.join_date AND cd.firstweek_date THEN (price*20)
	WHEN order_date < firstweek_date AND sales.product_id = 1 THEN (price*20)
	WHEN order_date > firstweek_date AND sales.product_id = 1 THEN (price*20)
	ELSE (price*10)
	END AS points
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
INNER JOIN customerDates_cte cd
ON cd.customer_id = sales.customer_id
ORDER BY sales.customer_id, sales.product_id;

----------------------------------------------------
/* --------------------
     Bonus Questions
   --------------------
Join All The Things
Recreate the following table output using the available data:

customer_id	order_date	product_name	price	member
A		2021-01-01	curry		15	N
A		2021-01-01	sushi		10	N
A		2021-01-07	curry		15	Y
A		2021-01-10	ramen		12	Y
A		2021-01-11	ramen		12	Y
A		2021-01-11	ramen		12	Y
B		2021-01-01	curry		15	N
B		2021-01-02	curry		15	N
B		2021-01-04	sushi		10	N
B		2021-01-11	sushi		10	Y
B		2021-01-16	ramen		12	Y
B		2021-02-01	ramen		12	Y
C		2021-01-01	ramen		12	N
C		2021-01-01	ramen		12	N
C		2021-01-07	ramen		12	N

*/

--- query
SELECT sales.customer_id, sales.order_date, menu.product_name, menu.price,
	CASE
	WHEN sales.order_date >= members.join_date THEN 'Y'
	ELSE 'N'
	END AS member
FROM sales
FULL JOIN menu
ON sales.product_id = menu.product_id
FULL JOIN members
ON members.customer_id = sales.customer_id
ORDER BY sales.customer_id, sales.order_date, menu.product_name;


/* --------------------
     Bonus Questions
   --------------------
Rank All The Things
Danny also requires further information about the ranking of customer products, 
but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records 
when customers are not yet part of the loyalty program.

customer_id	order_date	product_name	price	member	ranking
A		2021-01-01	curry		15	N	null
A		2021-01-01	sushi		10	N	null
A		2021-01-07	curry		15	Y	1
A		2021-01-10	ramen		12	Y	2
A		2021-01-11	ramen		12	Y	3
A		2021-01-11	ramen		12	Y	3
B		2021-01-01	curry		15	N	null
B		2021-01-02	curry		15	N	null
B		2021-01-04	sushi		10	N	null
B		2021-01-11	sushi		10	Y	1
B		2021-01-16	ramen		12	Y	2
B		2021-02-01	ramen		12	Y	3
C		2021-01-01	ramen		12	N	null
C		2021-01-01	ramen		12	N	null
C		2021-01-07	ramen		12	N	null
*/

--- query
-- (with guidance from https://medium.com/analytics-vidhya/8-week-sql-challenge-case-study-week-1-dannys-diner-2ba026c897ab)

WITH joined_cte AS
		(
			SELECT sales.customer_id, sales.order_date, menu.product_name, menu.price,
				CASE
				WHEN sales.order_date >= members.join_date THEN 'Y'
				ELSE 'N'
				END AS member
			FROM sales
			FULL JOIN menu
			ON sales.product_id = menu.product_id
			FULL JOIN members
			ON members.customer_id = sales.customer_id
			
		)
SELECT *,
	CASE
	WHEN member = 'N' then NULL
	ELSE
		DENSE_RANK () OVER(PARTITION BY customer_id, member ORDER BY order_date)
	END AS ranking
FROM joined_cte;


