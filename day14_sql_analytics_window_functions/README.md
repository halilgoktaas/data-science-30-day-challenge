# Day 14 — SQL Analytics with Window Functions (PostgreSQL)

This project demonstrates practical analytics queries using PostgreSQL, focusing on window functions, cohort retention, and RFM segmentation. The goal is to simulate real-world product analytics tasks (SaaS/e-commerce style) using a small but realistic relational dataset.

## Dataset Schema
- customers(customer_id, signup_date, country)
- products(product_id, product_name, category)
- orders(order_id, customer_id, order_date, status)
- order_items(order_id, product_id, quantity, unit_price)

Paid orders are used for KPI and retention analysis (`status = 'paid'`).

## How to Run
1. Create tables:
   - Run `data/schema.sql`
2. Insert sample data:
   - Run `data/seed.sql`
3. Execute analytics queries:
   - `queries/01_kpis.sql`
   - `queries/02_window_functions.sql`
   - `queries/03_cohort_retention.sql`
   - `queries/04_rfm_segmentation.sql`
   - `queries/05_insights.sql`

## Key Queries
- Monthly KPIs: revenue, orders, active customers, AOV
- Window functions:
  - Running revenue (cumulative)
  - Month-over-month growth (LAG)
  - Top products per month (RANK)
- Cohort retention:
  - First paid month as cohort
  - Month index calculation
  - Retention rate (long format output)
- RFM segmentation:
  - Recency, Frequency, Monetary features
  - NTILE-based scoring and rule-based segments

## Business Insights (examples)
- Identify revenue growth and seasonality with MoM analysis.
- Track retention by cohort to understand product stickiness.
- Segment customers with RFM to prioritize marketing and retention actions.
- Quantify repeat purchase behavior and revenue contribution by category.

## Notes
- The dataset is intentionally small for quick execution and easy review.
- Queries are written for PostgreSQL; minor syntax changes may be required for other databases.
