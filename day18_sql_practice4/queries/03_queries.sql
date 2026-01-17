-- Q1) Hiç sipariş vermemiş kullanıcılar
SELECT
    u.user_id,
    u.full_name
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
WHERE o.order_id IS NULL;

-- Q2) Kanal bazında sipariş sayısı ve net gelir

WITH order_totals AS (
    SELECT
        oi.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM order_items oi
    GROUP BY oi.order_id
)

SELECT
    o.channel,
    COUNT(o.order_id) AS total_order,
    ROUND(SUM(
        CASE
            WHEN o.campaign_id IS NULL THEN ot.order_total
            ELSE ot.order_total * (1 - c.discount_rate)
        END
    ), 2) AS total_net_revenue
FROM orders o
JOIN order_totals ot ON ot.order_id = o.order_id
LEFT JOIN campaigns c ON c.campaign_id = o.campaign_id
GROUP BY o.channel;

-- Q3) Son 30 gündeki siparişler
SELECT
    *
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';

--Q4) Ürün  bazında toplam adet ve ciro

SELECT
    p.product_name,
    SUM(oi.quantity) as total_qty,
    SUM(oi.quantity * oi.unit_price) AS gross_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- Q5) Kategori bazında ciro

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category;

-- Q6) Sipariş başına ürün çeşitliliği
SELECT
    order_id,
    COUNT(DISTINCT product_id) AS distinct_products,
    SUM(quantity) AS total_qty
FROM order_items
GROUP BY order_id;

-- Q7) Kampanyalı siparişlerde ortalama indirim
WITH totals AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total,
        c.discount_rate
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    LEFT JOIN campaigns c ON c.campaign_id = o.campaign_id
    GROUP BY o.order_id, c.discount_rate
)

SELECT
    AVG(order_total * discount_rate) AS avg_discount_amount
FROM totals;

-- Q8) Kullanıcıların Son Siparişi ve Gün Farkı
SELECT
    u.user_id,
    u.full_name,
    MAX(o.order_date) AS last_order_date,
    CURRENT_DATE - MAX(o.order_date) AS days_since_last_order
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
GROUP BY u.user_id, u.full_name;

-- Q9) Toplam net harcaması 1000+ olan kullanıılar

WITH order_totals AS (
    SELECT
        o.user_id,
        SUM(oi.quantity * oi.unit_price *
            CASE
                WHEN o.campaign_id IS NULL THEN 1
                ELSE (1- c.discount_rate)
            END
        ) AS total_spend

    FROM orders o 
    JOIN order_items oi ON oi.order_id = o.order_id
    LEFT JOIN campaigns c ON c.campaign_id = o.campaign_id
    GROUP BY o.user_id
)
SELECT
    u.user_id,
    u.full_name,
    total_spend
FROM order_totals ot
JOIN users u ON u.user_id = ot.user_id
WHERE total_spend >=1000;

-- Q10) Sipariş sayısına göre kullancı segmenti

SELECT
    u.user_id,
    u.full_name,
    COUNT(o.order_id) AS total_orders,
    CASE
        WHEN COUNT(o.order_id ) = 0 THEN 'No Order'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 2 THEN 'Low'
        WHEN count(o.order_id) BETWEEN 3 AND 5 THEN 'Mid'
        ELSE 'High'
    END AS segment
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id
GROUP BY u.user_id, u.full_name;