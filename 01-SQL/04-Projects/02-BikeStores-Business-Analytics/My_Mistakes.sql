/*
Q1 mn stuck hogya tha jab mujhe group by k sath total orders ka sum chahiye tha.
iske lie WINDOW FUNC use krna pada tha kyu ki har status ka count bhi chahiye tha aua
tamam orders ka sum bhi 
*/
SELECT
	CASE 
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Resolved'
		WHEN order_status = 3 THEN 'Cancelled'
		WHEN order_status = 4 THEN 'Shipped'
	END AS status_name,
	COUNT(*) AS order_count,
	COUNT(*) * 100.0  / SUM(COUNT(*)) OVER() AS percentage -- saare statuses ko count kia alag alag, then sum krdia
FROM sales.orders
GROUP BY order_status

/* Q2 mn bhi same window func ka hi issue tha. aur mene bila wajah cte bana k pir usko join kia tha
jabki uski zrurat hi nhi thi. jiski wajah se query mn bug tha
*/

