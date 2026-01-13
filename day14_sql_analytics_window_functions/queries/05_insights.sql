WITH paid_orders AS (
    SELECT customer_id, COUNT(*) AS order_cnt
    FROM orders
    WHERE status = 'paid'
    GROUP BY 1

)
SELECT 
    ROUND(AVG(CASE WHEN order_cnt >= 2 THEN 1 ELSE 0 END)::numeric,4) AS repeat_purchase_rate,
    COUNT(*) AS total_customers
FROM paid_orders;

WITH paid_orders AS (
    SELECT order_id
    FROM orders
    WHERE status = 'paid'
),
rev AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM paid_orders po
    JOIN order_items oi ON oi.order_id = po.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY 1
),
tot AS (
    SELECT SUM(revenue) AS total_revenue FROM rev
)
SELECT
    r.category,
    ROUND(r.revenue,2) AS revenue,
    ROUND(r.revenue / NULLIF(t.total_revenue,0) * 100, 2) AS revenue_share_pct
FROM rev r
CROSS JOIN tot t
ORDER BY revenue DESC;

WITH paid AS (
    SELECT customer_id, order_date
    FROM orders
    WHERE status = 'paid'
),
seq AS (
    SELECT
        customer_id,
        order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
    FROM paid
)

SELECT
    customer_id,
    order_date,
    next_order_date,
    (next_order_date - order_date) AS gap_days
FROM seq
WHERE next_order_date IS NOT NULL
ORDER BY gap_days DESC
LIMIT 10;