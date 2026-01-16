# Day 17 – SQL Practice & ML Theory

## Overview

Day 17 focuses on strengthening **advanced SQL analytics skills** through a realistic business dataset and reinforcing **machine learning evaluation theory** for classification problems.
The goal is to combine **data manipulation**, **business logic**, and **model evaluation thinking** in a way that reflects real-world data science tasks and technical interviews.

---

## SQL Practice

### Dataset Description

A simplified e-commerce schema was created to simulate real business scenarios:

* **users**: customer information and signup dates
* **products**: product catalog with categories and prices
* **campaigns**: discount campaigns with date ranges
* **orders**: customer orders with sales channels
* **order_items**: item-level order details

This structure enables:

* Order-level and item-level aggregation
* Revenue and campaign impact analysis
* Retention and churn logic
* Window function usage

---

### SQL Topics Covered

The 10 SQL questions in `day17_queries.pdf` cover:

* Common Table Expressions (CTEs)
* Advanced JOIN operations
* Window functions (`ROW_NUMBER`, `DENSE_RANK`, `LAG`, moving averages)
* Date arithmetic and interval logic
* Business metrics:

  * Order totals and net revenue
  * Average order value (AOV)
  * Top customers by spend
  * Retention within time windows
  * Channel revenue share
  * Churn labeling

These queries reflect **mid-to-advanced SQL interview level** expectations for data analyst and data scientist roles.

---

## Machine Learning Theory

### Topic: Model Evaluation Metrics (Classification)

The ML theory section focuses on selecting and interpreting the **correct evaluation metrics** for classification models, especially in imbalanced datasets.

### Concepts Covered

* Confusion Matrix (TP, FP, FN, TN)
* Accuracy and its limitations
* Precision, Recall, and trade-offs
* F1-score for balanced evaluation
* ROC Curve and AUC
* Metric selection based on business cost

This topic builds directly on **Day 16 (Cross-Validation & Data Leakage)** and prepares for real-world model evaluation and technical interviews.

---

## Key Takeaways

* SQL analytics must reflect business logic, not just syntax
* Item-level data should be aggregated carefully to avoid incorrect metrics
* Evaluation metrics must be chosen based on problem context, not convenience
* High model accuracy does not necessarily mean a good model

---

## Status

* SQL Practice: Completed (10/10)
* ML Theory: Completed
* Day 17: Closed

