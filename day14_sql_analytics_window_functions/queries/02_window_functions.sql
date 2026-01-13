WITH paid_orders AS (
    SELECT o.order_id, o.customer_id, o.order_date
    FROM orders o
    WHERE o.status = 'paid'
),
order_revenue AS (
    SELECT
        DATE_TRUNC('month', po.order_date)::date AS month,
        po.order_id,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM paid_orders po
    JOIN order_items oi ON oi.order_id = po.order_id
    GROUP BY 1,2
),

monthly AS (
    SELECT
        month,
        SUM(revenue) AS monthly_revenue
    FROM order_revenue
    GROUP BY 1
)

SELECT
    month,
    ROUND(monthly_revenue,2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (ORDER BY month),
        2
    ) AS running_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(monthly_revenue) OVER(ORDER BY month), 0) *100,
        2
    ) AS mom_growth_pct
FROM monthly
ORDER BY month;

WITH paid_orders AS (
    SELECT o.order_id, o.order_date
    FROM orders o
    WHERE o.status = 'paid'
),

product_monthly AS (
    SELECT
        DATE_TRUNC('month', po.order_date)::date AS month,
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM paid_orders po
    JOIN order_items oi ON oi.order_id = po.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY 1,2,3
),

ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY month ORDER BY revenue DESC) AS rnk
    FROM product_monthly
)

SELECT
    month, product_name, category, ROUND(revenue,2) AS revenue, rnk
FROM ranked
WHERE rnk <= 3
ORDER BY month, rnk, revenue DESC;