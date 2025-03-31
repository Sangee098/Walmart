SELECT * FROM walmart
order by branch;

SELECT COUNT(*) FROM walmart;

SELECT DISTINCT payment_method FROM walmart;

SELECT payment_method,COUNT(*) FROM walmart
GROUP BY(payment_method);

SELECT COUNT(DISTINCT(branch)) FROM walmart;

SELECT MAX(quantity) FROM walmart;

--business 	
--1. Find different payment method and number of transactions, number of qty sold

SELECT DISTINCT payment_method,COUNT(*) AS transactions,SUM(quantity) AS quantity_sold FROM walmart
GROUP BY payment_method;

--2.Identify the highest-rated category in each branch, displaying the branch, category

SELECT * FROM (SELECT branch,category, AVG(rating) AS avg_rating,RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) FROM walmart
GROUP BY 1,2) WHERE rank =1;

--3.Identify the busiest day for each branch based on the number of transactions

SELECT date,TO_CHAR(TO_DATE(date,'DD/MM/YY'),'DAY') AS day_name FROM walmart;

SELECT date,TO_DATE(date,'DD/MM/YY') FROM walmart;

SELECT * FROM (SELECT branch,TO_CHAR(TO_DATE(date,'dd/mm/yy'),'day'),COUNT(*) AS transations,RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank FROM walmart
GROUP BY branch,2
ORDER BY 1) WHERE rank=1;


--4.Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT payment_method,--COUNT(*) AS order_no, 
SUM(quantity) AS total_quantity FROM walmart
GROUP BY payment_method;

--5.Determine the average, minimum, and maximum rating of category for each city. 

SELECT city,category,AVG(rating) AS Average_rating,MIN(rating) AS Min_rating,MAX(rating) AS Max_rating FROM walmart
GROUP BY city,category
ORDER BY city;

--6.Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit

SELECT category, SUM(unit_price * quantity) AS revenue,SUM(unit_price * quantity*profit_margin) AS total_profit FROM walmart
GROUP BY category
ORDER BY category;


--7. Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

SELECT * FROM (SELECT branch,payment_method,COUNT(*) AS transition,RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank FROM walmart
GROUP BY branch,payment_method
ORDER BY branch) WHERE rank=1;

--8.Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT CASE 
WHEN EXTRACT (HOUR FROM (time::time))<12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening' 
END AS Day_time,COUNT(*) AS invoice FROM walmart
GROUP BY Day_time
ORDER BY invoice;


--9.Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

WITH Sorted_date AS 
(SELECT branch,
SUM(CASE WHEN EXTRACT(YEAR FROM TO_DATE(date,'dd/mm/yy')) = 2023 THEN quantity*unit_price END) AS Revenue_2023, 
SUM(CASE WHEN EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2022 THEN quantity*unit_price END) AS Revenue_2022
FROM walmart
GROUP BY branch
ORDER BY branch)
SELECT *,(Revenue_2022-Revenue_2023)/Revenue_2022*100 AS revenue_Difference FROM Sorted_date
ORDER BY revenue_Difference DESC
LIMIT 5
;

WITH data_2022 AS
(SELECT branch, SUM(quantity*unit_price) AS revenue_2022
FROM walmart
WHERE EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2022
GROUP BY branch
ORDER BY branch),

data_2023 AS
(SELECT branch,SUM(quantity*unit_price) AS revenue_2023 FROM walmart
WHERE EXTRACT(YEAR FROM TO_DATE(date,'DD/MM/YY')) = 2023
GROUP BY branch
ORDER BY branch
)

SELECT ly.branch, ly.revenue_2022,cy.revenue_2023,(ly.revenue_2022-cy.revenue_2023)/ly.revenue_2022*100 AS revunue_differebce FROM data_2022 ly
JOIN data_2023 cy
ON ly.branch=cy.branch
ORDER BY revunue_differebce DESC
LIMIT 5;




