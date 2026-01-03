# Day 3 – SQL Window Functions (Quick Notes)

> Goal: Understand and remember core SQL window functions
> for data analysis and interview questions.


### En Temel Şablon

SELECT
\*,
ROW_NUMBER() OVER (PARTITION BY column order BY column2 DESC) AS rn
FROM table;

PARTITION BY -> grup
ORDER BY -> Grup İçi Sıralama
OVER() - window

#### ROW_NUMBER

'Her Grupta Benzersiz Sıralama'
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC)

### RANK() VS DENSE_RANK()

RANK() -> atlar 1,1,3
DENSE_RANK() -> atlamaz 1,1,2

SELECT *
FROM (
SELECT \_, ROW_NUMBER() OVER (PARTITION BY departmant ORDER BY salary DESC) rn
FROM employes
) t
WHERE rn <= 3;

###

SELECT
date,
revenue,
revenue - LAG(revenue) OVER (ORDER BY date) AS diff
FROM sales;

###

SUM(amount) OVER (PARTITION BY customer_id ORDER BY date) AS running_total
