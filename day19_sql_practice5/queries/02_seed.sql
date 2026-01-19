-- Customers
INSERT INTO customers (full_name, email, country, created_at) VALUES
('Ayse Demir',  'ayse@example.com',  'TR', '2025-10-02'),
('Mehmet Kaya', 'mehmet@example.com','TR', '2025-11-15'),
('Elif Yilmaz', 'elif@example.com',  'DE', '2025-08-20'),
('John Smith',  'john@example.com',  'US', '2025-12-01'),
('Sara Lee',    'sara@example.com',  'UK', '2025-09-10'),
('Omar Ali',    'omar@example.com',  'AE', '2025-07-05');

-- Plans
INSERT INTO plans (plan_name, monthly_price, max_seats) VALUES
('Starter', 19.00, 3),
('Pro',     49.00, 10),
('Business',99.00, 50);

-- Subscriptions
-- (customer_id, plan_id, start_date, end_date, status, seats)
INSERT INTO subscriptions (customer_id, plan_id, start_date, end_date, status, seats) VALUES
(1, 2, '2025-10-05', NULL,        'active',   5),  -- Ayse Pro
(2, 1, '2025-11-20', '2026-01-10', 'canceled', 2),  -- Mehmet Starter canceled
(3, 3, '2025-08-25', NULL,        'active',   20), -- Elif Business
(4, 2, '2025-12-05', NULL,        'active',   8),  -- John Pro
(5, 1, '2025-09-15', NULL,        'paused',   1),  -- Sara paused
(6, 2, '2025-07-10', '2025-12-31', 'canceled', 6);  -- Omar canceled

-- Invoices (invoice_month = first day of month)
-- subscription_id, invoice_month, amount_due, issued_at, due_date, status
INSERT INTO invoices (subscription_id, invoice_month, amount_due, issued_at, due_date, status) VALUES
(1, '2025-11-01', 49.00, '2025-11-01', '2025-11-10', 'paid'),
(1, '2025-12-01', 49.00, '2025-12-01', '2025-12-10', 'paid'),
(1, '2026-01-01', 49.00, '2026-01-01', '2026-01-10', 'open'),

(2, '2025-12-01', 19.00, '2025-12-01', '2025-12-10', 'paid'),
(2, '2026-01-01', 19.00, '2026-01-01', '2026-01-10', 'open'),

(3, '2025-12-01', 99.00, '2025-12-01', '2025-12-10', 'paid'),
(3, '2026-01-01', 99.00, '2026-01-01', '2026-01-10', 'paid'),

(4, '2026-01-01', 49.00, '2026-01-01', '2026-01-10', 'paid'),

(5, '2025-12-01', 19.00, '2025-12-01', '2025-12-10', 'void'),

(6, '2025-11-01', 49.00, '2025-11-01', '2025-11-10', 'paid'),
(6, '2025-12-01', 49.00, '2025-12-01', '2025-12-10', 'paid');

-- Payments
INSERT INTO payments (invoice_id, paid_at, amount_paid, method) VALUES
(1, '2025-11-03', 49.00, 'card'),
(2, '2025-12-04', 49.00, 'card'),
(4, '2025-12-08', 19.00, 'paypal'),
(6, '2025-12-06', 99.00, 'bank_transfer'),
(7, '2026-01-04', 99.00, 'bank_transfer'),
(8, '2026-01-05', 49.00, 'card'),
(10,'2025-11-06', 49.00, 'paypal'),
(11,'2025-12-06', 49.00, 'paypal');

-- Usage events (son 60 gün gibi bir dağılım)
INSERT INTO usage_events (customer_id, event_date, event_type, quantity) VALUES
(1, '2025-12-20', 'login', 1),
(1, '2025-12-21', 'api_call', 120),
(1, '2026-01-05', 'export', 2),
(1, '2026-01-06', 'api_call', 80),

(2, '2025-12-15', 'login', 1),
(2, '2026-01-03', 'api_call', 20),

(3, '2025-12-18', 'api_call', 600),
(3, '2025-12-22', 'export', 5),
(3, '2026-01-07', 'api_call', 900),

(4, '2025-12-28', 'login', 1),
(4, '2026-01-08', 'api_call', 150),

(5, '2025-12-12', 'login', 1),

(6, '2025-12-20', 'api_call', 50);
