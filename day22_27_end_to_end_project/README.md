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



## Day 25 — Modeling

### Objective
Build and compare baseline and advanced machine learning models to identify the most suitable approach for predicting user purchase intent.

---

### What Was Done

- Prepared SAFE feature sets generated during feature engineering
- Established a consistent evaluation strategy using:
  - Stratified cross-validation on the training set
  - A holdout validation set for model comparison
- Trained and evaluated the following models:
  - Logistic Regression (baseline)
  - Random Forest
  - XGBoost
- Compared models using ROC-AUC, Precision, Recall, and F1-score

---

### Modeling Approach

**Baseline Model — Logistic Regression**

The baseline model provided a transparent reference point for understanding the predictive signal in the engineered features.  
It achieved relatively high recall, indicating strong ability to capture potential buyers, but suffered from low precision, leading to a high number of false positives.

**Tree-Based Models — Random Forest and XGBoost**

Tree-based models demonstrated stronger ranking capability, reflected in higher ROC-AUC scores.  
Random Forest showed conservative behavior at the default decision threshold, resulting in low recall despite reasonable precision.

XGBoost achieved the best overall discrimination performance and emerged as the strongest candidate model.  
While its default threshold favored precision over recall, the predicted probabilities offered a reliable basis for ranking users by purchase likelihood.

---

### Model Comparison Summary

- Logistic Regression prioritized recall but generated many false positives
- Random Forest improved ranking performance but remained overly conservative
- XGBoost delivered the highest ROC-AUC and the most informative probability estimates

This comparison highlights that model performance should be evaluated not only by accuracy metrics, but also by how prediction behavior aligns with business objectives.

---

### Outcome

- XGBoost selected as the candidate model for further evaluation
- Model comparison completed without using the test set
- Clear foundation established for threshold tuning and business-focused evaluation

---

### Next Step (Day 26)

- Analyze confusion matrix and classification errors
- Perform threshold tuning based on business priorities
- Evaluate cost-sensitive trade-offs to translate predictions into actionable decisions


## Day 26 — Evaluation & Business Interpretation

### Objective
Translate model performance into actionable business decisions by evaluating prediction errors, decision thresholds, and cost-sensitive trade-offs.

### Work Done
- Evaluated the selected XGBoost model on the validation set using confusion matrix analysis.
- Analyzed model behavior at the default threshold (0.50) and identified a strong precision–recall imbalance.
- Performed threshold tuning across a range of values to understand performance trade-offs.
- Introduced a cost-sensitive evaluation framework where false negatives were treated as more expensive than false positives.
- Selected an optimal decision threshold based on minimizing expected business cost rather than maximizing accuracy.
- Interpreted model errors (FP vs FN) in an e-commerce business context.
- Defined a realistic deployment strategy focused on user prioritization instead of hard classification.

### Key Findings
- At the default threshold (0.50), the model achieves strong ranking performance (ROC-AUC ≈ 0.78) but misses a large portion of potential buyers due to low recall.
- Lowering the decision threshold significantly increases recall, reducing missed revenue opportunities at the cost of higher marketing exposure.
- Under a cost-sensitive assumption where missing a potential buyer is more expensive than showing an unnecessary campaign, a lower threshold provides better business outcomes.
- The model is best suited as a scoring and prioritization tool rather than a binary decision system.

### Business Impact
- The model enables marketing teams to identify high-intent users and allocate campaign budgets more effectively.
- By prioritizing recall, the approach supports conversion maximization strategies common in e-commerce environments.
- Decision thresholds can be adjusted dynamically based on campaign budget, seasonality, and risk tolerance.

### Outputs
- `05_evaluation_and_business.ipynb`
- Cost-sensitive threshold decision artifact
- Business-oriented model interpretation ready for stakeholder communication


---

## Day 27 — Final Project Summary & Business Decision

### Executive Overview

This project delivers an end-to-end, production-oriented machine learning solution for **predicting purchase intent in e-commerce user sessions**.  
Beyond model accuracy, the primary focus was on **data leakage prevention, decision threshold strategy, and business-aligned evaluation**.

Rather than treating the problem as a pure classification task, the solution frames purchase prediction as a **ranking and prioritization problem**, enabling more effective downstream marketing and conversion strategies.

> **If you are short on time:**  
> This section summarizes the full project outcome. Detailed methodology and daily progress are documented in Days 22–26 above.

---

### End-to-End Pipeline Recap

The project followed a structured and reproducible workflow:

1. **Data Preparation & Preprocessing (Day 22)**
   - Leakage-safe train / validation / test split
   - Production-ready preprocessing pipeline
   - Reusable artifacts for inference

2. **Exploratory Data Analysis (Day 23)**
   - Identification of strong behavioral signals
   - Recognition of class imbalance and seasonality effects
   - Early detection of potential leakage sources (e.g. `PageValues`)

3. **Feature Engineering (Day 24)**
   - Translation of behavioral insights into model-ready features
   - SAFE vs FULL feature set design to explicitly manage leakage risk
   - Feature rationale documentation for transparency

4. **Modeling & Selection (Day 25)**
   - Baseline and advanced model comparison
   - Validation-driven model selection
   - XGBoost chosen for superior ranking performance (ROC-AUC)

5. **Evaluation & Business Interpretation (Day 26)**
   - Threshold tuning beyond the default 0.50
   - Cost-sensitive decision framework
   - Business-oriented error analysis (FP vs FN trade-offs)

---

### Final Model & Threshold Decision

**Selected Model:**  
- XGBoost trained on the **SAFE feature set** (leakage-aware)

**Why SAFE features?**  
Although `PageValues` demonstrated strong predictive power, it may encode post-conversion information depending on dataset definitions.  
To ensure real-world deployability and avoid overly optimistic performance estimates, the SAFE configuration was chosen as the final solution.

---

### Threshold Strategy: From Accuracy to Business Value

At the default decision threshold (0.50), the model achieved strong discrimination performance (ROC-AUC ≈ 0.78) but suffered from **very low recall**, missing a large proportion of potential buyers.

To address this, decision thresholds were evaluated across a wide range and assessed using a **cost-sensitive framework**:

- False Negatives (missed buyers) assumed to be more costly than False Positives
- Expected business cost calculated for each threshold

**Final Decision:**
- **Cost-sensitive optimal threshold:** ~0.15
- Recall increased to approximately **72%**
- Overall expected business cost minimized

This confirms that **threshold selection is a business decision, not a purely technical one**.

---

### Business Impact

The final model is best used as a **scoring and prioritization tool**, not as a hard binary classifier.

**Practical applications include:**
- Prioritizing high-intent users for remarketing campaigns
- Allocating marketing budgets more efficiently
- Reducing missed revenue opportunities by favoring recall
- Dynamically adjusting thresholds based on campaign goals and cost assumptions

This approach aligns closely with how machine learning models are deployed in real e-commerce environments.

---

### Limitations & Future Improvements

- Cost assumptions (FP vs FN) are scenario-dependent and should be calibrated with real business data
- Model performance may drift over time due to seasonality or user behavior changes
- Future iterations could include:
  - Probability calibration
  - Monitoring and retraining strategies
  - A/B testing of threshold policies
  - Integration with real-time decision systems

---

### Final Notes

This project demonstrates not only the ability to build accurate machine learning models, but also the ability to:
- Prevent data leakage
- Make validation-driven decisions
- Translate model outputs into actionable business strategies

The complete development process, from raw data to business decision, is fully documented and reproducible.



```