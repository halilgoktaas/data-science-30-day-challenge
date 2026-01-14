DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name TEXT NOT NULL,
    signup_date DATE NOT NULL
);

CREATE TABLE orders (
    order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    order_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount >=0)
);

CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
CREATE INDEX idx_orders_date ON orders(order_date);
