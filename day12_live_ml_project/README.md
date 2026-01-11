https://data-science-30-day-challenge-cc8u2xbfoe6yqjrpxgx7m2.streamlit.app/


# Credit Risk / Loan Default Prediction – Live ML Demo

This project demonstrates an end-to-end machine learning workflow for **credit risk (loan default) prediction**, including model training, evaluation, and live deployment via Streamlit.

The goal is to show not only model performance, but also **real-world decision making**, such as threshold selection and cost-sensitive trade-offs between false positives and false negatives.

---

## Problem Definition

Financial institutions need to assess whether a loan applicant is likely to default.  
Misclassifications have different business costs:

- **False Negative**: Risky borrower approved → financial loss  
- **False Positive**: Good borrower rejected → opportunity loss  

This project focuses on predicting default risk while allowing stakeholders to **control decision thresholds** based on business priorities.

---

## Dataset

The dataset contains anonymized applicant and loan information, including:

- Applicant demographics (age, income, employment length)
- Loan details (amount, interest rate, purpose)
- Credit history indicators
- Binary target: `loan_status` (default / non-default)

---

## Modeling Approach

- **Model**: Logistic Regression (baseline, interpretable)
- **Preprocessing**:
  - Numerical features: median imputation + standardization
  - Categorical features: most-frequent imputation + one-hot encoding
- **Evaluation Metrics**:
  - ROC-AUC
  - Precision / Recall
  - Confusion Matrix

**Test ROC-AUC:** ~0.87

Special attention is given to **recall for default cases**, since missing risky borrowers is more costly in practice.

---

## Decision Threshold & Business Logic

Instead of using a fixed threshold (0.50), the application allows:

- **Manual threshold selection**
- **Cost-sensitive automatic threshold**, based on user-defined False Positive / False Negative costs

This reflects how real credit policies are adjusted according to risk appetite.

---

## Live Demo (Streamlit)

The project is deployed as a live Streamlit application where users can:

- Simulate loan applicants
- View predicted default probability
- Adjust decision thresholds
- Observe how risk classification changes

