-- Seed data (small, realistic) for analytics
-- Note: We keep multiple months for MoM + cohort + retention.

INSERT INTO customers (customer_id, signup_date, country) VALUES
(1,'2025-01-05','TR'), (2,'2025-01-12','TR'), (3,'2025-01-20','DE'),
(4,'2025-02-03','TR'), (5,'2025-02-10','NL'), (6,'2025-02-18','TR'),
(7,'2025-03-02','DE'), (8,'2025-03-08','TR'), (9,'2025-03-18','UK'),
(10,'2025-04-01','TR'), (11,'2025-04-11','NL'), (12,'2025-04-20','TR');

INSERT INTO products (product_id, product_name, category) VALUES
(101,'Starter Plan','Subscription'),
(102,'Pro Plan','Subscription'),
(103,'Enterprise Plan','Subscription'),
(201,'Onboarding','Service'),
(202,'Priority Support','Service'),
(301,'Analytics Add-on','AddOn'),
(302,'Team Add-on','AddOn');

-- Orders: paid dominates, some refunded/cancelled to show filtering.
INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1001,1,'2025-01-07','paid'),
(1002,2,'2025-01-15','paid'),
(1003,3,'2025-01-25','paid'),
(1004,1,'2025-02-08','paid'),
(1005,4,'2025-02-12','paid'),
(1006,5,'2025-02-20','paid'),
(1007,2,'2025-03-05','paid'),
(1008,6,'2025-03-10','paid'),
(1009,7,'2025-03-20','paid'),
(1010,1,'2025-03-22','refunded'),
(1011,8,'2025-04-02','paid'),
(1012,9,'2025-04-06','paid'),
(1013,10,'2025-04-15','paid'),
(1014,2,'2025-04-18','paid'),
(1015,11,'2025-05-03','paid'),
(1016,12,'2025-05-12','paid'),
(1017,1,'2025-05-20','paid'),
(1018,3,'2025-05-22','cancelled'),
(1019,6,'2025-06-04','paid'),
(1020,2,'2025-06-10','paid'),
(1021,7,'2025-06-18','paid');

-- Order items (mix of subscription + add-ons)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1001,101,1, 19.99),
(1001,201,1, 49.00),

(1002,101,1, 19.99),
(1002,301,1,  9.99),

(1003,102,1, 49.99),

(1004,101,1, 19.99),
(1004,302,1, 14.99),

(1005,101,1, 19.99),
(1005,202,1, 19.00),

(1006,102,1, 49.99),
(1006,301,1,  9.99),

(1007,102,1, 49.99),

(1008,101,1, 19.99),

(1009,103,1,149.99),
(1009,202,1, 19.00),

-- refunded order (should be excluded in paid-only analysis)
(1010,101,1, 19.99),

(1011,101,1, 19.99),
(1011,301,1,  9.99),

(1012,102,1, 49.99),

(1013,101,1, 19.99),
(1013,201,1, 49.00),

(1014,102,1, 49.99),
(1014,302,1, 14.99),

(1015,101,1, 19.99),

(1016,102,1, 49.99),
(1016,301,1,  9.99),

(1017,102,1, 49.99),

-- cancelled order (should be excluded)
(1018,101,1, 19.99),

(1019,101,1, 19.99),
(1019,302,1, 14.99),

(1020,102,1, 49.99),

(1021,103,1,149.99);
