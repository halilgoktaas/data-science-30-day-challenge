-- 02_seed.sql
TRUNCATE TABLE orders RESTART IDENTITY;
TRUNCATE TABLE users CASCADE;

INSERT INTO users (user_id, full_name, signup_date) VALUES
(1, 'Ayse Demir',  CURRENT_DATE - INTERVAL '200 days'),
(2, 'Mehmet Kaya', CURRENT_DATE - INTERVAL '180 days'),
(3, 'Elif Yilmaz', CURRENT_DATE - INTERVAL '120 days'),
(4, 'Can Oz',      CURRENT_DATE - INTERVAL '90 days'),
(5, 'Zeynep Arslan', CURRENT_DATE - INTERVAL '60 days');

-- user 1: düzenli alışveriş (aktif)
INSERT INTO orders (user_id, order_date, amount) VALUES
(1, CURRENT_DATE - INTERVAL '45 days', 120.50),
(1, CURRENT_DATE - INTERVAL '30 days', 80.00),
(1, CURRENT_DATE - INTERVAL '15 days', 210.00),
(1, CURRENT_DATE - INTERVAL '3 days',  60.00);

-- user 2: eskiden aktif, son 40 günde yok (churn adayı)
INSERT INTO orders (user_id, order_date, amount) VALUES
(2, CURRENT_DATE - INTERVAL '150 days', 50.00),
(2, CURRENT_DATE - INTERVAL '110 days', 70.00),
(2, CURRENT_DATE - INTERVAL '70 days',  35.00),
(2, CURRENT_DATE - INTERVAL '41 days',  90.00);

-- user 3: tek tük (aktif sayılabilir)
INSERT INTO orders (user_id, order_date, amount) VALUES
(3, CURRENT_DATE - INTERVAL '20 days', 300.00),
(3, CURRENT_DATE - INTERVAL '10 days', 20.00);

-- user 4: yüksek harcama, aktif
INSERT INTO orders (user_id, order_date, amount) VALUES
(4, CURRENT_DATE - INTERVAL '25 days', 500.00),
(4, CURRENT_DATE - INTERVAL '5 days',  450.00);

-- user 5: hiç sipariş yok (ayrı edge case)
;
