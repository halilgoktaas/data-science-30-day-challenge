# Telco Customer Churn Prediction – Baseline Model

## Project Overview
This project focuses on predicting customer churn for a telecom company using the **Telco Customer Churn** dataset.  
The goal is to build a **clean, interpretable baseline model** and understand churn behavior before moving to advanced modeling.

This notebook represents **Day 10** of the *30 Days Data Scientist Challenge* and emphasizes:
- Data understanding
- Proper preprocessing
- Baseline modeling
- Business-aware evaluation

---

## Dataset
- Source: Kaggle – *Telco Customer Churn*
- Observations: 7,043 customers
- Target variable: `Churn` (Yes / No)

### Feature Types
- Numerical: `tenure`, `MonthlyCharges`, `TotalCharges`
- Categorical: Contract type, payment method, internet services, support features, etc.

---

## Key Data Insights
- The target distribution is imbalanced (~73% non-churn, ~26% churn), which is expected in real-world churn problems.
- `TotalCharges` was provided as an object column and converted to numeric.
- After conversion, 11 missing values appeared, corresponding to customers with `tenure = 0`.
  - These rows were **not dropped**, as they represent valid new customers.
  - Missing values were handled using median imputation within the pipeline.

---

## Preprocessing Strategy
A production-ready preprocessing pipeline was built using `ColumnTransformer`:

- Numerical features:
  - Median imputation
  - Standard scaling
- Categorical features:
  - Most frequent imputation
  - One-hot encoding (`handle_unknown="ignore"`)

This approach prevents data leakage and ensures consistent preprocessing for train and test sets.

---

## Modeling Approach
- Model: **Logistic Regression**
- Configuration:
  - `class_weight="balanced"` to handle class imbalance
  - Integrated into a single pipeline with preprocessing

Logistic Regression was chosen as a **baseline model** due to its interpretability and suitability for binary classification.

---

## Evaluation Metrics
Accuracy was not used as the primary metric due to class imbalance.  
Instead, the model was evaluated using:

- ROC-AUC
- Precision, Recall, F1-score
- Confusion Matrix

### Baseline Performance
- ROC-AUC: **0.84**
- Churn Recall (Class 1): **~0.78**

These results indicate strong separation capability and good recall for churned customers, which is critical from a business perspective.

---

## Business Interpretation
- The model successfully identifies a large portion of customers likely to churn.
- False positives are acceptable at this stage, as retaining a customer is typically less costly than losing one.
- The baseline confirms that the dataset contains strong predictive signals.

---

## Next Steps (Day 11+)
- Decision threshold tuning based on business costs
- Precision–Recall trade-off analysis
- Comparison with tree-based models
- Feature importance and advanced feature engineering

---


