-- PLANS
INSERT INTO plans (plan_name, monthly_price) VALUES
('Basic', 49.99),
('Pro', 99.99),
('Enterprise', 199.99);

-- CUSTOMERS
INSERT INTO customers (full_name, email, created_at) VALUES
('Alice Johnson', 'alice@mail.com', '2025-09-10'),
('Bob Smith', 'bob@mail.com', '2025-10-01'),
('Charlie Brown', 'charlie@mail.com', '2025-10-15'),
('Diana Prince', 'diana@mail.com', '2025-11-01'),
('Ethan Hunt', 'ethan@mail.com', '2025-11-20'),
('Frank Castle', 'frank@mail.com', '2025-12-01');

-- SUBSCRIPTIONS
INSERT INTO subscriptions (customer_id, plan_id, status, start_date, end_date) VALUES
(1, 3, 'active',   '2025-09-10', NULL),
(2, 2, 'active',   '2025-10-01', NULL),
(3, 1, 'canceled', '2025-10-15', '2026-01-05'),
(4, 2, 'active',   '2025-11-01', NULL),
(5, 3, 'active',   '2025-11-20', NULL),
(6, 1, 'canceled', '2025-12-01', '2026-01-10');

-- USAGE EVENTS (API CALLS)
INSERT INTO usage_events (customer_id, event_date, event_type, quantity) VALUES
(1, '2026-01-05', 'api_call', 300),
(1, '2026-01-15', 'api_call', 250),
(2, '2026-01-10', 'api_call', 120),
(2, '2026-01-18', 'api_call', 80),
(4, '2026-01-12', 'api_call', 30),
(5, '2026-01-02', 'api_call', 400),
(5, '2026-01-18', 'api_call', 350);

-- MODEL PREDICTIONS
INSERT INTO model_predictions (customer_id, model_version, predicted_probability, prediction_date) VALUES
(1, 'v1', 0.25, '2026-01-10'),
(2, 'v1', 0.45, '2026-01-10'),
(3, 'v1', 0.85, '2026-01-01'),
(4, 'v1', 0.60, '2026-01-12'),
(5, 'v1', 0.15, '2026-01-10'),
(6, 'v1', 0.75, '2026-01-05'),
(2, 'v2', 0.55, '2026-01-18'),
(4, 'v2', 0.72, '2026-01-18');

-- ACTUAL OUTCOMES (GROUND TRUTH)
INSERT INTO actual_outcomes (customer_id, churned, outcome_date) VALUES
(1, false, '2026-01-31'),
(2, false, '2026-01-31'),
(3, true,  '2026-01-05'),
(4, false, '2026-01-31'),
(5, false, '2026-01-31'),
(6, true,  '2026-01-10');
