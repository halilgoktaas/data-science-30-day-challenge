# Day 13 – Model Explainability, Error Analysis & Threshold Optimization

## Overview

This stage extends the **Day 12 Credit Risk Prediction project** by focusing on **model interpretability, error analysis, and decision threshold optimization**.
Instead of training a new model, the goal of Day 13 is to **understand, explain, and critically evaluate** an already deployed machine learning model from both **technical and business perspectives**.

The trained model artifacts (`model.joblib`, `model_meta.json`) created on Day 12 are reused without modification.

---

## Objectives

* Explain **why** the model makes certain predictions
* Analyze **where and how** the model makes mistakes
* Evaluate the **business impact** of false positives and false negatives
* Optimize the **decision threshold** based on business priorities
* Reflect all findings in the Streamlit application

---

## 1. Model Explainability

### Coefficient Analysis

* The model is a **Logistic Regression** trained inside a `Pipeline`
* Feature names are extracted from the `ColumnTransformer` and `OneHotEncoder`
* Coefficients are analyzed to determine:

  * Positive coefficients → higher default risk
  * Negative coefficients → lower default risk

This confirms that the model is **linear and fully interpretable**.

---

### SHAP Analysis

SHAP values are used to explain predictions at two levels:

#### Global Explainability

* `shap.summary_plot` shows which features influence predictions the most overall
* Both magnitude and direction of feature impact are analyzed

#### Local Explainability

* Individual predictions are explained using SHAP force / waterfall plots
* This allows answering:

  > “Why was this specific customer classified as risky?”

---

## 2. Error Analysis

Error analysis is performed on a reconstructed **hold-out test set** to avoid optimistic bias.

### Confusion Matrix Interpretation

* **False Positives (FP)**
  Non-risky customers incorrectly classified as risky
  → potential customer loss, reduced approval rates

* **False Negatives (FN)**
  Risky customers incorrectly classified as non-risky
  → potential financial loss due to default

---

### FP / FN Profiling

* Numerical features are compared using mean, median, and standard deviation
* Categorical features are analyzed via value distributions
* This reveals which customer segments are more prone to misclassification

---

## 3. Decision Threshold Optimization

The default threshold (0.50) is not always optimal in real-world business settings.

### Precision–Recall Trade-off

* Precision–Recall curves are used to evaluate different thresholds
* Three strategies are analyzed:

  * **F1-optimal threshold** (balanced precision & recall)
  * **Recall-prioritized threshold** (risk-averse scenario)
  * **Precision-prioritized threshold** (customer-experience-focused scenario)

### Business Insight

In credit risk applications:

* False negatives are typically more costly than false positives
* Therefore, lowering the threshold to improve recall can be justified

---

## 4. Streamlit App Enhancements

The Streamlit application is extended with **multiple threshold strategies**:

* Default (0.50)
* Manual threshold slider
* Cost-sensitive automatic threshold
* Data-driven threshold (F1-optimal)
* Data-driven threshold (Recall ≥ 0.80)

The app now supports **business-aware decision making**, not just raw probability outputs.

---

## Key Takeaways

* Model performance alone is not sufficient; **interpretability and error awareness** are critical
* Threshold selection should reflect **business costs**, not arbitrary defaults
* Separating **training** and **analysis** stages leads to cleaner and more reliable ML workflows


