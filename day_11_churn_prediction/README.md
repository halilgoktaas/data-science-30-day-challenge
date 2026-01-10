# Day 11 – Telco Customer Churn  
## Model Comparison, Threshold Tuning & Business Decision

This work is a **direct continuation of Day 10**
(`day10_telco_churn_eda_baseline.ipynb`).

The same dataset, feature set, and preprocessing pipeline are preserved.
The focus of Day 11 is to **compare models fairly**, evaluate them with
business-oriented metrics, and make a deployment-oriented decision.

---

## Objective

- Compare a baseline Logistic Regression model with a more powerful tree-based model (XGBoost)
- Go beyond accuracy and focus on churn-relevant metrics
- Align model selection with **business costs** and decision thresholds

---

## Models Compared

### Baseline Model
- Logistic Regression
- Class-weighted to address class imbalance
- Used as a transparent and interpretable reference model

### Advanced Model
- XGBoost Classifier
- Same preprocessing pipeline as the baseline model
- Evaluated under different decision thresholds

---

## Evaluation Strategy

The models are evaluated using:
- Precision, Recall, and F1-score
- ROC-AUC
- Confusion Matrix
- Precision–Recall Curve

Special emphasis is placed on **False Negatives**, since missing a churned
customer is usually more costly than unnecessary retention actions.

---

## Threshold Tuning

The default classification threshold (0.50) was not assumed to be optimal.

Two threshold selection strategies were applied:
1. **Recall-targeted thresholding** (target recall ≥ 0.75)
2. **Cost-based thresholding**, assuming False Negatives are more expensive than False Positives

This demonstrated how decision thresholds can significantly change business outcomes,
even when the underlying model remains the same.

---

## Key Findings

- Logistic Regression achieved strong recall but generated a high number of false positives
- XGBoost reduced false positives at the default threshold but increased false negatives
- After threshold tuning, XGBoost achieved a more business-aligned trade-off
- Feature importance analysis showed that contract type, tenure, internet service,
  and payment method are strong churn indicators

---

## Final Decision

When the business cost of missing a churned customer is high:

**Chosen approach:**  
**XGBoost with a tuned decision threshold (≈ 0.30)**

This configuration balances churn recall and unnecessary retention actions more effectively
than using the default threshold or relying solely on the baseline model.

---

## Continuation

- Day 10: EDA, preprocessing, and baseline model
- Day 11: Model comparison, threshold tuning, and deployment-oriented decision making
