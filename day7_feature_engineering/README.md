# Heart Failure Risk Analysis  
## Exploratory Data Analysis, Feature Engineering and Model Interpretability

This project analyzes mortality risk in patients with heart failure using a structured and explainable data science workflow.  
The focus is not only on predictive performance, but also on understanding the data, engineering meaningful features, and interpreting model behavior in a transparent manner.

---

## Dataset

- **Source:** Kaggle – Heart Failure Clinical Records Dataset  
- **Observations:** 299 patients  
- **Features:** Clinical and demographic measurements (age, serum creatinine, ejection fraction, sodium, etc.)  
- **Target Variable:** `DEATH_EVENT` (binary classification)

The dataset contains no missing values, allowing direct focus on exploratory analysis and feature engineering.

---

## Project Workflow

### 1. Exploratory Data Analysis (EDA)
- Inspection of data types and value ranges
- Analysis of target class distribution and class imbalance
- Feature distribution analysis and scale differences
- Target-based statistical comparisons
- Correlation analysis and identification of potential data leakage

### 2. Feature Engineering
- Age binning to capture non-linear age effects
- Clinically motivated binary risk indicators
- Interaction features to model compound risk effects
- One-hot encoding with multicollinearity control

### 3. Modeling
- Baseline Logistic Regression model
- Feature-engineered Logistic Regression model
- Handling class imbalance using `class_weight='balanced'`
- Standardization applied via a scikit-learn Pipeline

### 4. Evaluation
- Precision, Recall, and F1-score
- ROC-AUC and Precision-Recall AUC
- Confusion matrix analysis
- Probability threshold tuning for different decision scenarios

### 5. Interpretability
- Logistic Regression coefficient analysis
- Odds ratio interpretation of key risk factors
- Comparison of baseline vs feature-engineered models

---

## Key Takeaways

- Feature engineering based on domain knowledge significantly improves recall and PR-AUC.
- Probability threshold selection has a direct impact on clinical decision trade-offs.
- Logistic Regression provides both competitive performance and strong interpretability.
- Potential leakage-prone features should be evaluated separately depending on deployment context.

---

## Tools & Libraries

- Python
- Pandas, NumPy
- scikit-learn
- Matplotlib

---

## Notes

This project is designed to demonstrate an end-to-end data science workflow suitable for real-world and interview scenarios, with emphasis on reasoning, interpretability, and decision-aware modeling.
