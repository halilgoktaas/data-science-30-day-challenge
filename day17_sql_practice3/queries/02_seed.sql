-- 02_seed.sql

INSERT INTO users (user_id, full_name, city, signup_date) VALUES
(1, 'Ayse Demir',   'Istanbul', '2025-10-10'),
(2, 'Mehmet Kaya',  'Ankara',   '2025-11-03'),
(3, 'Zeynep Arslan','Izmir',    '2025-11-20'),
(4, 'Ali Yilmaz',   'Bursa',    '2025-12-05'),
(5, 'Elif Cetin',   'Antalya',  '2025-12-20'),
(6, 'Can Oz',       'Istanbul', '2025-12-28'),
(7, 'Deniz Sari',   'Izmir',    '2026-01-02'),
(8, 'Mert Aydin',   'Ankara',   '2026-01-05');

INSERT INTO products (product_id, product_name, category, price) VALUES
(101, 'Laptop Stand',     'accessories',  450.00),
(102, 'Wireless Mouse',   'accessories',  320.00),
(103, 'Mechanical Keyboard','accessories',850.00),
(104, 'USB-C Hub',        'accessories',  380.00),
(201, 'Python Book',      'books',        280.00),
(202, 'SQL Book',         'books',        260.00),
(301, 'Coffee Beans 1kg', 'grocery',      500.00),
(302, 'Protein Bar Box',  'grocery',      360.00);

INSERT INTO campaigns (campaign_id, campaign_name, start_date, end_date, discount_rate) VALUES
(1, 'Black Friday', '2025-11-25', '2025-11-30', 0.20),
(2, 'New Year',     '2025-12-29', '2026-01-03', 0.15),
(3, 'Jan Sale',     '2026-01-10', '2026-01-20', 0.10);

-- Orders (farklı kanallar + bazı günler aynı kullanıcıya birden fazla sipariş)
INSERT INTO orders (order_id, user_id, order_date, channel, campaign_id) VALUES
(1001, 1, '2025-11-26', 'web',    1),
(1002, 1, '2025-12-10', 'mobile', NULL),
(1003, 2, '2025-11-28', 'web',    1),
(1004, 2, '2025-12-30', 'mobile', 2),
(1005, 3, '2025-12-02', 'store',  NULL),
(1006, 3, '2026-01-12', 'web',    3),
(1007, 4, '2025-12-15', 'web',    NULL),
(1008, 4, '2026-01-15', 'mobile', 3),
(1009, 5, '2026-01-02', 'mobile', 2),
(1010, 6, '2026-01-02', 'web',    2),
(1011, 6, '2026-01-02', 'web',    2), -- aynı gün 2 sipariş
(1012, 7, '2026-01-10', 'store',  3),
(1013, 8, '2026-01-11', 'web',    3);

-- Order items (sipariş tutarları item'lar üzerinden hesaplanacak)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 102, 1, 320.00),
(2, 1001, 201, 1, 280.00),

(3, 1002, 103, 1, 850.00),

(4, 1003, 104, 1, 380.00),
(5, 1003, 202, 1, 260.00),

(6, 1004, 101, 1, 450.00),
(7, 1004, 301, 1, 500.00),

(8, 1005, 302, 1, 360.00),

(9, 1006, 201, 2, 280.00), -- 2 adet
(10,1006, 102, 1, 320.00),

(11,1007, 104, 2, 380.00), -- 2 adet

(12,1008, 103, 1, 850.00),
(13,1008, 301, 1, 500.00),

(14,1009, 301, 1, 500.00),

(15,1010, 202, 1, 260.00),
(16,1010, 102, 1, 320.00),

(17,1011, 302, 2, 360.00), -- 2 adet

(18,1012, 201, 1, 280.00),
(19,1012, 104, 1, 380.00),

(20,1013, 101, 1, 450.00),
(21,1013, 103, 1, 850.00);
