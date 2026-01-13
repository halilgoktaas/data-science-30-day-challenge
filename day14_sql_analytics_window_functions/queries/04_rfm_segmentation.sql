WITH params AS (
    SELECT DATE '2025-07-01' AS as_of_date
),

paid_orders AS (
    SELECT o.order_id, o.customer_id, o.order_date
    FROM orders o
    WHERE o.status = 'paid'
),

customer_revenue AS (
    SELECT
        po.customer_id,
        po.order_id,
        po.order_date,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM paid_orders po
    JOIN order_items oi ON oi.order_id = po.order_id
    GROUP BY 1,2,3
),

rfm_raw AS (
    SELECT
        cr.customer_id,
        (SELECT as_of_date FROM params) - MAX(cr.order_date) AS recency_days,
        COUNT(DISTINCT cr.order_id) AS frequency,
        ROUND(SUM(cr.revenue), 2) AS monetary
    FROM customer_revenue cr
    GROUP BY 1
),

scored AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_raw

),
segmented AS (
    SELECT
        *,
        (r_score + f_score + m_score) AS rfm_total,
        CASE
            WHEN (r_score >= 4 AND f_score >= 4 AND m_score >= 4) THEN 'Champions'
            WHEN (f_score >= 4 AND m_score >=4) THEN 'Loyal Big Spenders'
            WHEN (r_score >= 4 AND f_score >= 3) THEN 'Loyal'
            WHEN (r_score <= 2 AND f_score >= 3) THEN 'At Risk'
            WHEN (r_score <= 2 AND f_score <= 2) THEN 'Hibernating'
            ELSE 'Potential'
        END AS segment
    FROM scored 
)
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    r_score, f_score,m_score,
    rfm_total,
    segment
FROM segmented
ORDER BY rfm_total DESC, monetary DESC;