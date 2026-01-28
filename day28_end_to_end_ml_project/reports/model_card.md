# Model Card — Employee Attrition Predictor

## Model Overview
- **Model Type:** Logistic Regression
- **Configuration:** class_weight = balanced
- **Objective:** Predict the probability of employee attrition to support proactive retention strategies.

---

## Intended Use
This model is intended to assist HR and people analytics teams in identifying employees who are at higher risk of attrition.  
Predictions are designed to **support decision-making**, not to be used as the sole basis for HR actions.

**Primary use cases:**
- Prioritizing retention interventions
- Supporting workforce planning and risk assessment
- Scenario analysis via threshold tuning

---

## Data
- **Dataset:** IBM HR Analytics Employee Attrition dataset
- **Rows:** 1,470 employees
- **Features:** Demographic, job-related, compensation, and satisfaction metrics
- **Target Variable:** `Attrition` (binary: Yes / No)
- **Validation Positive Rate:** 15.99%

---

## Preprocessing
- Constant and identifier features removed
- Stratified train/validation split
- Numeric features: median imputation + standard scaling
- Categorical features: most-frequent imputation + one-hot encoding
- Preprocessing implemented using `ColumnTransformer` for reproducibility

---

## Evaluation Metrics (Validation Set)
- **Validation Size:** 294 samples
- **ROC-AUC:** 0.8032
- **PR-AUC:** 0.5612
- **Decision Threshold:** 0.60 (tuned)

The threshold was increased from the default 0.50 to 0.60 to improve the precision–recall trade-off for attrition predictions, reducing unnecessary retention actions while maintaining acceptable recall for at-risk employees.

---

## Performance Summary
- The model demonstrates strong discriminative ability for ranking attrition risk.
- Threshold tuning enables alignment with business constraints, particularly intervention cost management.
- Logistic Regression outperformed more complex tree-based models in this dataset, offering better generalization and interpretability.

---

## Limitations
- The dataset is relatively small and may not represent all organizational contexts.
- Predictions reflect correlations in historical data and do not imply causation.
- Model performance may degrade if data distributions shift over time.

---

## Ethical Considerations
- The model should not be used to make automated employment decisions.
- Predictions must be reviewed alongside human judgment and organizational context.
- Potential bias across sensitive attributes (e.g., age, gender) should be monitored regularly.

---

## Artifacts
- **Preprocessor:** `models/preprocessor.joblib`
- **Model:** `models/model.joblib`
- **Metrics:** `reports/metrics.json`

---

## Maintenance & Next Steps
- Monitor model performance and data drift periodically.
- Re-train with updated data when available.
- Deploy an interactive Streamlit application to enable business users to explore risk scores and threshold sensitivity (planned for Day 29).
