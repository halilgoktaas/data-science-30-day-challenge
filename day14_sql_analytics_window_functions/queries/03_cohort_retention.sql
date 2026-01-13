WITH paid_orders AS (
    SELECT o.customer_id, o.order_date
    FROM orders o
    WHERE o.status = 'paid'
),

first_paid AS (
    SELECT
        customer_id,
        MIN(DATE_TRUNC('month', order_date)) AS cohort_month
    FROM paid_orders
    GROUP BY 1
),

activity AS (
    SELECT
        po.customer_id,
        DATE_TRUNC('month', po.order_date) AS activity_month
    FROM paid_orders po
    GROUP BY 1,2
),

cohort_activity AS (
    SELECT
        fp.cohort_month,
        a.activity_month,
        (DATE_PART('year', a.activity_month) - DATE_PART('year', fp.cohort_month)) * 12
        + (DATE_PART('month', a.activity_month) - DATE_PART('month', fp.cohort_month)) AS month_index,
        COUNT(DISTINCT a.customer_id) AS active_customers
    FROM first_paid fp
    JOIN activity a ON a.customer_id = fp.customer_id
    GROUP BY 1,2,3
),

cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM first_paid
    GROUP BY 1
)

SELECT
    ca.cohort_month ::date,
    ca.activity_month::date,
    ca.month_index::int,
    ca.active_customers,
    cs.cohort_size,
    ROUND(ca.active_customers::numeric / NULLIF(cs.cohort_size,0),4) AS retention_rate
FROM cohort_activity ca
JOIN cohort_size cs USING (cohort_month)
ORDER BY cohort_month, month_index;