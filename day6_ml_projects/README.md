# Day 6 – Stroke Prediction (Mini Machine Learning Project)

## Overview
This project is part of the **30 Days Data Scientist Challenge** and focuses on building a clean, reproducible **end-to-end machine learning pipeline** for stroke prediction using a structured healthcare dataset.

The goal of this mini project is not only to achieve reasonable predictive performance, but also to demonstrate correct problem framing, proper preprocessing, and metric-driven evaluation in an imbalanced classification setting.

---

## Problem Definition
Stroke prediction is formulated as a **binary classification** problem:

- **Target variable:** `stroke` (0 = No Stroke, 1 = Stroke)
- **Challenge:** Highly imbalanced target distribution
- **Primary objective:** Maximize recall for the positive class while maintaining strong overall discrimination

---

## Dataset
- Source: Kaggle – Stroke Prediction Dataset
- Data type: Tabular (numerical + categorical features)
- Preprocessing considerations:
  - Missing values
  - Categorical encoding
  - Feature scaling
  - Removal of non-informative identifier columns (e.g. `id`)

---

## Methodology

### Data Preprocessing
- Missing values:
  - Numerical features: Median imputation
  - Categorical features: Most frequent category
- Feature transformation:
  - Numerical features scaled using `StandardScaler`
  - Categorical features encoded using `OneHotEncoder`
- Preprocessing and modeling combined using `Pipeline` and `ColumnTransformer` to avoid data leakage

### Model
- Algorithm: **Logistic Regression**
- Key parameters:
  - `max_iter=2000` to ensure convergence
  - `class_weight='balanced'` to address class imbalance

### Train / Test Split
- 80% training, 20% testing
- Stratified split to preserve class distribution

---

## Evaluation Metrics
The model is evaluated using multiple metrics to reflect real-world decision making:

- **ROC-AUC:** Measures overall discriminative ability
- **PR-AUC:** More informative under class imbalance
- **Confusion Matrix**
- **Precision, Recall, F1-score**

Special emphasis is placed on **recall for the positive class**, as false negatives are more costly in a healthcare context.

---

## Results (Test Set)

- ROC-AUC: ~0.84
- PR-AUC: ~0.26
- Positive class recall: ~0.80

The results indicate that the model successfully captures the majority of stroke cases while maintaining strong overall discrimination, at the cost of increased false positives — an acceptable trade-off in medical screening scenarios.

---

## Project Structure

```

day_6_mini_ml_projects/
└── stroke_prediction/
├── data/
│   └── stroke.csv
├── src/
│   ├── train.py
│   └── predict.py
└── models/
└── metrics.json

````

---

## How to Run

### Train the model
```bash
python src/train.py
````

### Run inference on a sample

```bash
python src/predict.py
```

---

## Key Takeaways

* Demonstrates a production-style ML pipeline with strict schema consistency
* Highlights correct handling of imbalanced datasets
* Focuses on metric interpretation rather than accuracy alone
* Emphasizes explainability and decision-oriented evaluation

---

## Author

This project was developed as part of a structured daily learning challenge to strengthen applied machine learning skills and build a professional data science portfolio.

````
