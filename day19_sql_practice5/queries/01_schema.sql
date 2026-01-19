DROP TABLE IF EXISTS usage_events;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS plans;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    country TEXT NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE plans (
    plan_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plan_name TEXT NULL NULL UNIQUE,
    monthly_price NUMERIC(10,2) NOT NULL CHECK (monthly_price >=0),
    max_seats INT NOT NULL CHECK (max_seats > 0)
);

CREATE TABLE subscriptions (
    subscription_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    plan_id INT NOT NULL REFERENCES plans(plan_id),
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT NOT NULL CHECK (status IN('active', 'canceled','paused')),
    seats INT NOT NULL CHECK (seats > 0)
);

CREATE TABLE invoices (
    invoice_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subscription_id INT NOT NULL REFERENCES subscriptions(subscription_id),
    invoice_month DATE NOT NULL,
    amount_due NUMERIC(10,2) NOT NULL CHECK (amount_due >= 0),
    issued_at DATE NOT NULL,
    due_date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN('open', 'paid','void'))
);

CREATE TABLE payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_id INT NOT NULL REFERENCES invoices(invoice_id),
    paid_at DATE NOT NULL,
    amount_paid NUMERIC(10,2) NOT NULL CHECK (amount_paid >=0),
    method TEXT NOT NULL CHECK (method IN('card','bank_transfer','paypal'))
);

CREATE TABLE usage_events (
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    event_date DATE NOT NULL,
    event_type TEXT NOT NULL CHECK (event_type IN ('login', 'api_call', 'export')),
    quantity INT NOT NULL CHECK (quantity >= 0 )
);

CREATE INDEX idx_subscriptions_customer ON subscriptions(customer_id);
CREATE INDEX idx_invoices_sub ON invoices(subscription_id);
CREATE INDEX idx_payments_invoice ON payments(invoice_id);
CREATE INDEX idx_usage_customer_date ON usage_events(customer_id, event_date);