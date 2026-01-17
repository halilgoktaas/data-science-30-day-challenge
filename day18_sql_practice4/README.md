# Day 18 – SQL Practice & ML Theory (Remote Attack Week)

## Overview
Day 18 is part of the **“Day 15–21: Remote Attack”** phase of the 30 Days Data Scientist Challenge.  
At this stage, the focus shifts from learning new tools to **demonstrating decision-making skills, analytical thinking, and interview-ready competence**.

This day consists of:
- Mid-level, general-purpose SQL practice
- Business-driven machine learning theory
- Application and consistency discipline

---

## Objectives
The main goals of Day 18 were:

- Strengthen **general SQL proficiency** beyond window-function-heavy analytics
- Practice **real-world business SQL queries** commonly asked in interviews
- Understand how **machine learning models turn probabilities into decisions**
- Learn how to evaluate models from a **cost-sensitive business perspective**
- Maintain daily momentum with job applications

---

## Part 1 – SQL Practice (Mid-Level)

### Scope
A total of **10 mid-level SQL questions** were solved using a realistic e-commerce data model.

Key topics covered:
- JOIN logic (INNER / LEFT)
- Aggregations and GROUP BY
- CASE WHEN business rules
- Date filtering and recency analysis
- Customer segmentation logic
- Revenue and spending calculations
- Use of CTEs for readability and maintainability

Window functions were intentionally minimized to avoid redundancy with previous days (15–17) and to focus on **general SQL interview competence**.

### File Structure
```text
01_schema.sql   -> Database schema
02_seed.sql     -> Sample data
03_queries.sql  -> Solutions to 10 SQL questions
````

This structure mirrors real-world database workflows and improves clarity and reproducibility.

---

## Part 2 – ML Theory

### Decision Threshold & Cost-Sensitive Evaluation

While previous days focused on *how to measure model performance*, Day 18 focuses on **how models are used to make decisions**.

Key concepts covered:

* What a decision threshold is and why `0.5` is only a default
* How changing the threshold affects precision and recall
* Trade-offs between False Positives and False Negatives
* Business interpretation of model errors
* Cost-sensitive thinking using real-world scenarios
* Why accuracy alone is often misleading
* When Precision–Recall curves are more informative than ROC curves

The emphasis is on **business impact rather than raw metrics**, which is critical for production-ready machine learning systems.
