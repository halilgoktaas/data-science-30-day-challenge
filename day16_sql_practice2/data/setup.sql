DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(80) NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(80) NOT NULL,
    category VARCHAR(40) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    order_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);



INSERT INTO users (user_id, full_name, created_at) VALUES
(1, 'Ayşe Yılmaz', '2025-08-10'),
(2, 'Mehmet Kaya', '2025-09-05'),
(3, 'Elif Demir', '2025-10-01'),
(4, 'Can Arslan', '2025-11-15'),
(5, 'Zeynep Koç', '2025-12-20'),
(6, 'Ahmet Şahin', '2025-12-25'),
(7, 'Deniz Ak', '2025-12-28'),
(8, 'Selin Ateş', '2026-01-02'); -- yeni kullanıcı

-- ---------- INSERT PRODUCTS ----------
INSERT INTO products (product_id, product_name, category) VALUES
(101, 'Wireless Mouse', 'Electronics'),
(102, 'Mechanical Keyboard', 'Electronics'),
(103, 'Notebook A5', 'Stationery'),
(104, 'Pen Set', 'Stationery'),
(105, 'Coffee Beans 1kg', 'Grocery'),
(106, 'Protein Bar', 'Grocery'),
(107, 'Desk Lamp', 'Home'),
(108, 'Water Bottle', 'Home');

-- ---------- INSERT ORDERS ----------
-- Dikkat: bazı kullanıcıların siparişi yok (user_id=8 gibi)
-- Bazılarının aynı gün 2 siparişi var (user_id=2, user_id=6)
INSERT INTO orders (order_id, user_id, order_date, amount) VALUES
(1001, 1, '2025-11-01', 120.50),
(1002, 1, '2025-12-03',  80.00),
(1003, 1, '2026-01-04',  35.00),

(1004, 2, '2025-10-20', 200.00),
(1005, 2, '2025-10-20',  50.00), -- aynı gün 2 sipariş
(1006, 2, '2025-12-15',  90.00),

(1007, 3, '2025-09-10',  40.00),
(1008, 3, '2025-12-01', 300.00),

(1009, 4, '2025-11-25',  15.00),

(1010, 5, '2025-12-22',  70.00),
(1011, 5, '2025-12-30',  25.00),

(1012, 6, '2026-01-05', 150.00),
(1013, 6, '2026-01-05',  60.00), -- aynı gün 2 sipariş
(1014, 6, '2026-01-10',  45.00),

(1015, 7, '2025-08-15',  10.00);

-- ---------- INSERT ORDER ITEMS ----------
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 101, 1, 120.50),
(2, 1002, 103, 2,  20.00),
(3, 1002, 104, 1,  40.00),
(4, 1003, 106, 5,   7.00),

(5, 1004, 102, 1, 200.00),
(6, 1005, 105, 1,  50.00),
(7, 1006, 108, 2,  45.00),

(8, 1007, 103, 2,  20.00),
(9, 1008, 107, 1, 300.00),

(10, 1009, 104, 1, 15.00),

(11, 1010, 105, 1, 70.00),
(12, 1011, 106, 5,  5.00),

(13, 1012, 101, 1, 150.00),
(14, 1013, 106, 6, 10.00),
(15, 1014, 108, 1, 45.00),

(16, 1015, 103, 1, 10.00);