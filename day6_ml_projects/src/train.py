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
    confusion_matrix,
    classification_report,
    roc_auc_score,
    average_precision_score
)

DATA_PATH = "C:/Users/user\Desktop/30-days-data-scientist-challenge/day6_ml_projects/data/healthcare-dataset-stroke-data.csv"
MODEL_PATH = "C:/Users/user\Desktop/30-days-data-scientist-challenge/day6_ml_projects/models/model.joblib"
METRICS_PATH = "C:/Users/user\Desktop/30-days-data-scientist-challenge/day6_ml_projects/models/metrics.json"

TARGET_COL = "stroke"

def main():
    
    df = pd.read_csv(DATA_PATH)

    if "id" in df.columns :
        df = df.drop(columns = ['id'])

    df= df.dropna(subset=[TARGET_COL])

    X = df.drop(columns=[TARGET_COL])
    y = df[TARGET_COL].astype(int)

    X_train, X_test, y_train, y_test = train_test_split(
        X,y,
        test_size= 0.2,
        random_state=42,
        stratify=y
    )

    numeric_features = X.select_dtypes(include=['int64','float64']).columns.tolist()
    categorical_features = X.select_dtypes(include=['object']).columns.tolist()

    numeric_pipe = Pipeline(steps=[
        ('imputer', SimpleImputer(strategy='median')),
        ('scaler', StandardScaler())
    ])

    categorical_pipe = Pipeline(steps=[
        ('imputer', SimpleImputer(strategy= 'most_frequent')),
        ('onehot', OneHotEncoder(handle_unknown='ignore'))
    ])

    preprocessor = ColumnTransformer(
        transformers= [
            ('num', numeric_pipe, numeric_features),
            ('cat', categorical_pipe, categorical_features)
        ]
    )


    model = Pipeline(steps= [
        ('prep', preprocessor),
        ('clf', LogisticRegression(
            max_iter=2000,
            class_weight='balanced'
        ))
    ])

    model.fit(X_train, y_train)
    y_prob = model.predict_proba(X_test)[:,1]
    y_pred = (y_prob >= 0.5).astype(int)

    roc_auc = roc_auc_score(y_test, y_prob)
    pr_auc = average_precision_score(y_test,y_prob)

    print("/n=== Confusion Matrix ===")
    print(confusion_matrix(y_test,y_pred))

    print("/n=== Classification Report ===")
    print(classification_report(y_test, y_pred, digits = 3))

    print(f"/nROC-AUC: {roc_auc:.4f}")
    print(f"/PR-AUC: {pr_auc:.4f}")

    os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
    joblib.dump(model, MODEL_PATH)

    metrics = {
        "roc_auc": float(roc_auc),
        "pr_auc": float(pr_auc),
        "n_train": int(len(X_train)),
        "n_test": int(len(X_test)),
        "possitive_Rate": float(y.mean())
    }

    with open (METRICS_PATH,"w", encoding="utf-8") as f:
        json.dump(metrics,f,indent = 2)

if __name__ == "__main__":
    main()

