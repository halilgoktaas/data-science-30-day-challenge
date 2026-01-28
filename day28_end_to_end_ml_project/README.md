## Results

**Final Model:** Logistic Regression (class_weight=balanced)
**Validation Set Size:** 294
**Positive Rate (Attrition):** 15.99%

**Performance (Validation):**

* **ROC-AUC:** 0.8032
* **PR-AUC:** 0.5612
* **Decision Threshold:** 0.60 (tuned)

At the default threshold (0.50), the model demonstrated strong ranking ability but produced a higher number of false positives. By tuning the decision threshold to **0.60**, we improved the precision–recall trade-off for the positive class (attrition) while preserving robust discrimination performance.

---

## Business Impact

Employee attrition prediction is primarily used to **trigger proactive retention actions**, where both missed leavers (false negatives) and unnecessary interventions (false positives) carry costs.

* **Why threshold = 0.60?**
  Increasing the threshold reduces unnecessary retention actions while maintaining acceptable recall for high-risk employees.
* **Operational Benefit:**
  HR teams can focus interventions on a smaller, higher-confidence group of at-risk employees, improving cost efficiency.
* **Decision Support:**
  The model is designed to **support**, not replace, HR decision-making. Outputs should be combined with managerial judgment and qualitative insights.

---

## Model Artifacts

* **Preprocessor:** `models/preprocessor.joblib`
* **Model:** `models/model.joblib`
* **Metrics:** `reports/metrics.json`

Artifacts are serialized to ensure reproducibility and straightforward deployment in downstream applications.

---

## Limitations & Next Steps

* The dataset is relatively small and may not generalize across all organizations.
* The model captures correlations rather than causation.
* **Next Step:** Deploy an interactive Streamlit application to visualize risk scores and allow business users to explore threshold sensitivity (planned for Day 29).
