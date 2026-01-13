WITH paid_orders AS (
    SELECT o.order_id, o.customer_id, o.order_date
    FROM orders o
    WHERE o.status = 'paid'
),
order_revenue AS (
    SELECT
        po.order_id,
        po.customer_id,
        po.order_date,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM paid_orders po
    JOIN order_items oi ON oi.order_id = po.order_id
    GROUP BY 1,2,3
)

SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(DISTINCT order_id)              AS orders,
    COUNT(DISTINCT customer_id)           AS active_customers,
    ROUND(SUM(revenue), 2)                AS total_revenue,
    ROUND(AVG(revenue), 2)                AS aov
FROM order_revenue
GROUP BY 1
ORDER BY 1;
