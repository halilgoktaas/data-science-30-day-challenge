````md
# Day 22 – Data Preparation & Preprocessing  
## Customer Behavior / Purchase Prediction

## Overview
Day 22 focuses on transforming raw e-commerce session data into a clean, structured, and production-ready format.
The goal of this stage is to ensure data quality, prevent data leakage, and build a reusable preprocessing pipeline
that can be consistently applied during both training and inference.

At the end of Day 22, the dataset is fully prepared for exploratory data analysis and modeling without requiring
any further cleaning steps.

---

## Business Context
E-commerce platforms generate large volumes of session-level behavioral data.
Before any meaningful analysis or modeling can be performed, this data must be validated, standardized,
and transformed in a reproducible way.

This preprocessing step mirrors how a data scientist would prepare data in a real-world company setting,
where clean data and leakage-safe pipelines are mandatory.

---

## Deliverables
The following artifacts were produced on Day 22:

- **Problem definition document**
  - Clear business objective
  - Target variable definition
  - Dataset scope and assumptions

- **End-to-end preprocessing pipeline**
  - Data validation and cleaning
  - Train / validation / test split
  - Leakage-safe feature transformation
  - Reusable sklearn pipeline

---

## Files and Structure

```text
day22_27_customer_behavior_purchase_prediction/
│
├── data/
│   ├── raw/
│   │   └── online_shoppers_intention.csv
│   ├── processed/
│   │   └── shoppers_clean.csv
│   └── splits/
│       ├── train.csv
│       ├── valid.csv
│       └── test.csv
│
├── artifacts/
│   └── preprocess_pipeline.joblib
│
├── 01_problem_definition.md
├── 01_preprocessing.ipynb
└── README.md
````

---

## Preprocessing Summary

### Data Integrity Checks

* Raw data preserved and processed on a copy
* Column names standardized to `snake_case`
* Boolean fields converted to numeric (0/1)
* Exact duplicate rows identified and removed
* Negative and out-of-range values checked and validated
* Missing values analyzed and handled via pipeline logic

### Categorical Cleaning

* Whitespace trimming
* Invalid string placeholders converted to NaN
* Temporal categories standardized (e.g. month formatting)

### Target Validation

* Target variable verified and converted to binary integer format
* Class distribution examined to inform stratified splitting

---

## Train / Validation / Test Split

The dataset was split using a stratified strategy to preserve class distribution:

* **Training set**: 70%
* **Validation set**: ~21%
* **Test set**: ~9%

All splits were created before fitting any preprocessing steps to prevent data leakage.

---

## Preprocessing Pipeline

A production-ready preprocessing pipeline was implemented using `sklearn`:

* **Numeric features**

  * Median imputation
  * Standard scaling

* **Categorical features**

  * Most frequent value imputation
  * One-hot encoding with unseen-category handling

The pipeline was fitted **only on the training set** and then applied to validation and test sets.
The fitted pipeline was saved as an artifact for reuse during inference.

---

## Outputs

By the end of Day 22:

* Clean, human-readable dataset available for analysis
* Fixed train / validation / test splits saved to disk
* Fully fitted preprocessing pipeline ready for modeling
* All preprocessing decisions documented and reproducible

---

## Next Steps

Day 23 will focus on **Exploratory Data Analysis (EDA)** using the cleaned dataset,
with an emphasis on understanding behavioral patterns that influence purchase decisions
and generating actionable business insights.


## Day 23 – Exploratory Data Analysis (EDA)

Exploratory Data Analysis was conducted on the **raw dataset** to preserve
feature interpretability and enable meaningful business insights.
All preprocessing, scaling, and encoding steps were completed in Day 22
and are applied later during model training via a pipeline.

### Key Findings

- The target variable (`Revenue`) is significantly imbalanced, with approximately
  15% of sessions resulting in a purchase.
- Sessions that generate revenue exhibit substantially higher engagement,
  including longer product-related interaction durations and higher page values.
- Bounce rates and exit rates are notably lower for converting sessions,
  indicating stronger user intent prior to purchase.
- Conversion behavior varies by time, with higher rates observed during
  specific months, suggesting seasonal effects.
- `PageValues` is a highly predictive feature but may partially encode
  post-conversion information and will be treated cautiously to avoid
  potential data leakage.

### EDA Outcome

Insights derived from EDA directly inform feature engineering and modeling
decisions in subsequent stages of the project.


```