-- USERS
INSERT INTO users (full_name, created_at) VALUES
('Ali Yılmaz', '2025-10-01'),
('Ayşe Demir', '2025-10-05'),
('Mehmet Kaya', '2025-10-10'),
('Zeynep Çelik', '2025-11-01'),
('Can Koç', '2025-11-15');

-- CAMPAIGNS
INSERT INTO campaigns (campaign_name, discount_rate) VALUES
('New Year', 0.10),
('Black Friday', 0.25);

-- PRODUCTS
INSERT INTO products (product_name, category, unit_price) VALUES
('Laptop', 'Electronics', 1500),
('Mouse', 'Electronics', 40),
('Desk', 'Furniture', 300),
('Chair', 'Furniture', 180),
('Notebook', 'Stationery', 10);

-- ORDERS
INSERT INTO orders (user_id, order_date, channel, campaign_id) VALUES
(1, '2026-01-01', 'web', NULL),
(1, '2026-01-10', 'mobile', 1),
(2, '2026-01-05', 'web', NULL),
(3, '2026-01-07', 'store', 2),
(3, '2026-01-20', 'web', NULL);

-- ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500),
(1, 2, 2, 40),
(2, 5, 5, 10),
(3, 3, 1, 300),
(3, 4, 2, 180),
(4, 1, 1, 1500),
(5, 2, 1, 40),
(5, 5, 10, 10);
