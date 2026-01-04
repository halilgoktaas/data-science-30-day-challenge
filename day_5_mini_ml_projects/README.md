# Day 5 – Mini Machine Learning Project

## Heart Disease Prediction (Logistic Regression Baseline)

This project is part of the **30 Days Data Scientist Challenge**.
The goal of Day 5 is to build a **complete, end-to-end machine learning pipeline** on a real-world style dataset and to focus on **process, decision-making, and evaluation**, rather than chasing high accuracy.

---

## Project Objective

The main objective of this project is to:

* Perform proper data preprocessing and feature engineering
* Handle missing values in a principled way
* Address class imbalance in a binary classification problem
* Build and evaluate a baseline Logistic Regression model
* Understand model limitations through metric-based analysis

This project prioritizes **interpretability and correctness of the ML workflow** over raw performance.

---

## Dataset Overview

* Binary classification problem: **Heart Disease (Yes / No)**
* Approximately **10,000 samples**
* Mixed feature types:

  * Numerical (Age, BMI, Blood Pressure, etc.)
  * Binary categorical (Yes / No)
  * Ordinal categorical (Low / Medium / High)
* Target distribution is imbalanced (~80% No, ~20% Yes)

---

## Data Preprocessing Steps

### 1. Exploratory Data Analysis (EDA)

* `head()`, `info()`, and `describe()` used to understand structure and data types
* Missing value ratios analyzed per feature

### 2. Missing Value Handling

* Features with **high missing ratios (~25%+)** were dropped
* Remaining missing values:

  * Numerical features filled with **median**
  * Categorical features filled with **mode**

This strategy avoids unnecessary data loss while keeping imputations simple and explainable.

---

## Feature Engineering

### Encoding Strategy

Different encoding techniques were applied based on feature nature:

* **Target Encoding**

  * Yes / No → 1 / 0

* **Binary Encoding**

  * Smoking, Diabetes, Family History, etc.

* **Ordinal Encoding**

  * Exercise Habits, Stress Level, Sugar Consumption
  * Encoded as: Low = 0, Medium = 1, High = 2

* **One-Hot Encoding**

  * Applied to nominal features (e.g. Gender)
  * `drop_first=True` used to avoid dummy variable trap

All features were converted to numeric format before modeling.

---

## Train–Test Split

* Data split into **80% training** and **20% test**
* `stratify=y` used to preserve class distribution
* `random_state=42` for reproducibility

---

## Feature Scaling

* **StandardScaler** applied to numerical features
* Scaler fitted only on training data to prevent data leakage
* Scaling is required because Logistic Regression is gradient-based

---

## Model Selection

### Logistic Regression (Baseline)

Logistic Regression was chosen because:

* It is simple and interpretable
* It provides a strong baseline for binary classification
* Coefficients can be analyzed if needed

Model configuration:

* `max_iter=1000` to ensure convergence
* `class_weight='balanced'` to address class imbalance

---

## Model Evaluation

### Metrics Used

* Precision
* Recall
* F1-score
* ROC–AUC

Accuracy was not treated as the primary metric due to class imbalance.

### Threshold Analysis

Instead of relying only on `model.predict()` (default threshold = 0.5):

* Prediction probabilities were extracted using `predict_proba`
* Multiple thresholds (0.4, 0.5, 0.6) were evaluated
* Trade-offs between recall and false positives were analyzed

This approach reflects real-world risk-sensitive decision making.

---

## Results and Interpretation

* Class weighting significantly improved **recall for the positive class**
* Accuracy decreased, which is expected in imbalanced problems
* ROC–AUC score was below 0.5, indicating weak separability

Rather than being treated as a failure, this result was analyzed as:

* A limitation of available features
* A limitation of linear model assumptions
* A realistic outcome in many real-world datasets

---

## Key Takeaways

* A correct ML pipeline is more important than a high score
* Class imbalance must be handled explicitly
* Accuracy alone is misleading in risk-based problems
* Threshold tuning is a powerful and often overlooked tool
* Understanding model limitations is a core Data Scientist skill

---

## Project Status

This project represents a **completed baseline ML case study**.
Future improvements (planned for later days in the challenge):

* Non-linear models (Random Forest, Gradient Boosting)
* Feature interaction analysis
* Cross-validation and model comparison


