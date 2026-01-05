import os
import json 
import joblib 
import numpy as np 
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    classification_report,
    confusion_matrix,
    roc_auc_score,
    average_precision_score,
    precision_recall_curve
) 

DATA_PATH = "day_5_mini_ml_projects/data/heart_disease.csv"
MODEL_PATH = "day_5_mini_ml_projects/models/model.joblib"
METRICS_PATH = "day_5_mini_ml_projects/models/metrics.json"

TARGET_COL = "Heart Disease Status"

def best_f1_threshold(y_true, y_prob):
    precision, recall, thresholds = precision_recall_curve(y_true,y_prob)
    f1 = 2 * (precision[-1] * recall[:-1]) / (precision[:-1] + recall[:-1] + 1e-12)
    best_idx = int(np.argmax(f1))
    return float(thresholds[best_idx]), float(f1[best_idx])

def main():
    df = pd.read_csv(DATA_PATH)

    df[TARGET_COL] = df[TARGET_COL].map({"Yes":1, "No":0})

    df = df.dropna(subset = [TARGET_COL])

    X = df.drop(columns =[TARGET_COL])
    y = df[TARGET_COL].astype(int)

    X_train , X_test, y_train, y_test = train_test_split (
        X,y,
        test_size = 0.2,
        random_state= 42,
        stratify=y
    )

    numeric_features = X.select_dtypes(include=["int64", "float64"]).columns.tolist()
    categorical_features = X.select_dtypes(include= ['object','bool']).columns.to_list()
    
    numeric_pipe = Pipeline(steps= [
        ('imputer', SimpleImputer(strategy='median')),
        ('scaler', StandardScaler())
    ])

    categorical_pipe = Pipeline(steps = [
        ('imputer', SimpleImputer(strategy='most_frequent')),
        ('onehot', OneHotEncoder(handle_unknown='ignore'))
    ])

    preprocessor = ColumnTransformer(
        transformers= [
            ('num', numeric_pipe, numeric_features),
            ('cat', categorical_pipe, categorical_features)
        ], remainder='drop'
    )

    clf = LogisticRegression(max_iter=2000, class_weight= None)

    model = Pipeline(steps=[
        ('prep', preprocessor),
        ('clf', clf)
    ])

    model.fit(X_train, y_train)
    y_prob = model.predict_proba(X_test)[:,1]

    roc_auc = roc_auc_score(y_test, y_prob)
    pr_auc = average_precision_score(y_test, y_prob)

    thr, best_f1 = best_f1_threshold(y_test, y_prob)
    y_pred = (y_prob >= thr).astype(int)

    print("\n=== Confusion Matrix ===")
    print(confusion_matrix(y_test, y_pred))

    print("\n=== Classification Report (threshold tuned) ===")
    print(classification_report(y_test, y_pred, digits=3))

    print(f"\nROC-AUC: {roc_auc:.4f}")
    print(f"PR-AUC : {pr_auc:.4f}")
    print(f"Best threshold (F1): {thr:.4f} | F1: {best_f1:.4f}")

    os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)

    joblib.dump(model, MODEL_PATH)

    metrics = {
        "roc_auc": float(roc_auc),
        "pr_auc": float(pr_auc),
        "best_thresholds_f1": float(thr),
        "best_f1": float(best_f1),
        "n_train": int(len(X_train)),
        "n_test": int(len(X_test)),
        "pos_rate" : float(y.mean()),

    }

    with open(METRICS_PATH, "w", encoding="utf-8") as f:
        json.dump(metrics, f, ensure_ascii=False,indent=2)

if __name__ == "__main__":
    main()