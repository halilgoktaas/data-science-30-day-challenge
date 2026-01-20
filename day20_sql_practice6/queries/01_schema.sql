CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    created_at DATE NOT NULL
);

CREATE TABLE plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name TEXT NOT NULL,
    monthly_price NUMERIC(10,2) NOT NULL
);

CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    plan_id INT REFERENCES plans(plan_id),
    status TEXT CHECK (status IN ('active','canceled','paused')),
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE usage_events (
    event_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    event_date DATE NOT NULL,
    event_type TEXT,
    quantity INT
);

CREATE TABLE model_predictions (
    prediction_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    model_version TEXT,
    predicted_probability NUMERIC(5,4),
    prediction_date DATE
);

CREATE TABLE actual_outcomes (
    customer_id INT REFERENCES customers(customer_id),
    churned BOOLEAN,
    outcome_date DATE
);
