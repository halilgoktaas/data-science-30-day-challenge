# Analytical Insights – Heart Failure Risk Modeling

This document summarizes the key analytical findings and modeling decisions derived from the project.

---

## 1. Data Understanding

- The dataset contains 299 observations with no missing values.
- All features are numeric, enabling direct use in classical machine learning models.
- The target variable (`DEATH_EVENT`) is imbalanced, with non-death cases being the majority.

**Implication:**  
Accuracy alone is not a reliable evaluation metric. Precision, recall, and PR-AUC are more appropriate for this problem.

---

## 2. Exploratory Findings

- Patients who experienced a death event tend to have:
  - Lower ejection fraction
  - Higher serum creatinine
  - Lower serum sodium
- Several features exhibit strong scale differences, motivating feature standardization.
- The `time` variable shows strong correlation with the target and may introduce leakage depending on the prediction scenario.

**Implication:**  
Modeling decisions must consider both class imbalance and potential leakage.

---

## 3. Feature Engineering Impact

Feature engineering was guided by clinical intuition rather than purely statistical transformations.

Key engineered features include:
- Age group binning to capture non-linear age effects
- Binary risk indicators based on clinically meaningful thresholds
- Interaction features combining age and kidney function

**Result:**  
Compared to the baseline model, the feature-engineered model shows improved recall and higher Precision-Recall AUC, indicating better detection of high-risk patients.

---

## 4. Model Evaluation Strategy

- Logistic Regression was selected for its interpretability and robustness on small datasets.
- Class imbalance was addressed using `class_weight='balanced'`.
- Evaluation focused on:
  - Recall for high-risk patient detection
  - PR-AUC for imbalanced classification performance
  - Confusion matrix analysis to assess false negative risk

---

## 5. Threshold Analysis

Default probability thresholds (0.5) were not assumed to be optimal.

Threshold tuning demonstrated:
- Lower thresholds increase recall at the cost of precision
- Higher thresholds improve precision but risk missing high-risk cases

**Decision Context:**  
In healthcare scenarios, prioritizing recall may be preferable to avoid missing critical cases.

---

## 6. Model Interpretability

Logistic Regression coefficients were transformed into odds ratios to interpret risk impact:

- Odds ratio > 1 indicates increased mortality risk
- Odds ratio < 1 indicates protective effect

This enables clear communication of model behavior to non-technical stakeholders.

---

## 7. Conclusion

This project demonstrates that:
- Thoughtful EDA informs better modeling decisions
- Feature engineering grounded in domain knowledge materially improves outcomes
- Interpretability and evaluation strategy are as important as raw predictive performance

The resulting model balances performance, transparency, and practical decision-making considerations.
