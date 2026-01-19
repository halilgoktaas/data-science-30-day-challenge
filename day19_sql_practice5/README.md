# Day 19 – SQL Practice & ML Theory

This day is part of the **30 Days Data Scientist Challenge (Days 15–21: Remote-Focused Sprint)**.  
The focus of Day 19 is to strengthen **advanced SQL skills with a realistic SaaS analytics scenario** and to deepen **machine learning decision-making knowledge** with probability calibration.

---

## Objectives

- Practice intermediate–advanced SQL queries on a real-world SaaS subscription dataset
- Apply CTEs, window functions, aggregation, and business logic
- Understand probability calibration in classification models
- Maintain consistent documentation and GitHub hygiene

---

## SQL Practice – SaaS Subscription Analytics

### Scenario
A fictional **SaaS company** with subscription-based pricing.  
The database includes customers, plans, subscriptions, invoices, payments, and usage events.

### Covered SQL Concepts

- INNER JOIN, LEFT JOIN
- Anti-join patterns (missing relationships)
- Common Table Expressions (CTE)
- Conditional aggregation (`FILTER`, `CASE`)
- Date arithmetic and rolling windows
- Window functions (`ROW_NUMBER`, `DENSE_RANK`)
- Business metrics:
  - Monthly Recurring Revenue (MRR)
  - Lifetime Revenue
  - Churn analysis
  - Usage-based risk segmentation

### Queries
A total of **10 business-oriented SQL questions**, including:
- Active subscription analysis
- Revenue and billing summaries
- Overdue invoices
- Customer lifetime value ranking
- API usage analysis (last 30 days)
- Churn list generation
- Risk segmentation for active customers

All queries are implemented in `03_queries.sql` and documented in `day19_queries.pdf`.

---

## ML Theory – Probability Calibration

### Topic
**Model Calibration (Probability Calibration)**

### Key Points

- Difference between discrimination (ROC-AUC) and calibration
- Why high accuracy or AUC does not guarantee reliable probabilities
- Importance of calibration in risk-based decision systems
- Calibration evaluation methods:
  - Calibration Curve (Reliability Diagram)
  - Brier Score
- Common calibration techniques:
  - Platt Scaling
  - Isotonic Regression
- Relationship between calibration and threshold optimization

This topic builds directly on previous days covering:
- Evaluation metrics
- Decision thresholds
- Cost-sensitive learning

---

## Key Takeaways

- SQL queries should reflect real business questions, not just syntax
- CTEs and window functions are essential for analytical SQL
- Well-calibrated probabilities are critical for reliable ML decisions
- Model evaluation does not end with accuracy or AUC

---