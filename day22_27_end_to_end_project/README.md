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


## Day 24 – Feature Engineering

On Day 24, the focus was on transforming insights from exploratory data analysis into **model-ready, leakage-aware features** while preserving the preprocessing pipeline and data split structure established on previous days.

### Objectives
- Translate EDA findings into meaningful numerical features  
- Improve model signal quality without introducing data leakage  
- Maintain reproducibility and a production-oriented workflow  

### Key Steps

#### 1. Feature Engineering on Split Data
Feature generation was applied **after train, validation, and test splits**, ensuring no information leakage during feature creation. All transformations were deterministic and did not require fitting.

#### 2. Engineered Feature Groups
- **Aggregate Features**  
  Total page views and total session duration to capture overall user engagement.

- **Ratio-Based Features**  
  Product-focused page and duration shares, average time per page, and administrative/informational ratios to represent intent distribution.

- **Behavioral Interaction Features**  
  Differences and interactions between bounce rate and exit rate to model abandonment behavior.

- **Distribution Stabilization**  
  Log-transformed duration and count features were introduced to mitigate right-skewed distributions observed during EDA.

All ratio-based features were clipped to reasonable bounds to prevent extreme values caused by sparse interactions.

#### 3. Leakage-Aware Feature Sets
Two parallel feature configurations were created:
- **SAFE Feature Set**  
  Excludes `page_values`, which may contain post-conversion information depending on dataset definitions.
- **FULL Feature Set**  
  Includes `page_values` to evaluate its impact on model performance.

This setup allows transparent comparison between predictive power and leakage risk during modeling.

#### 4. Feature Consistency Validation
Assertions were added to guarantee identical feature schemas across train, validation, and test sets for both SAFE and FULL configurations.

#### 5. Updated Preprocessing Pipeline
A new preprocessing pipeline was fitted on the SAFE feature set:
- Numerical features: median imputation followed by standard scaling  
- Categorical features (`month`, `visitor_type`): most-frequent imputation followed by one-hot encoding  

The updated pipeline was saved as a reusable artifact for downstream modeling.

### Outputs
- Feature-engineered datasets for SAFE and FULL configurations  
- Updated preprocessing artifact (`preprocess_day24_safe.joblib`)  
- Feature rationale documentation describing motivation and expected impact of engineered features  

Day 24 concludes with a clean, reproducible, and leakage-aware feature engineering stage, fully preparing the project for model training and evaluation.



```