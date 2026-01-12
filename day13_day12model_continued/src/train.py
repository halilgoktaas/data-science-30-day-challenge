import os
import json 
import joblib 
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, classification_report, confusion_matrix
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_PATH = os.path.join(BASE_DIR, 'data', 'credit_risk_dataset.csv')
MODEL_DIR = os.path.join(BASE_DIR,'model')
os.makedirs(MODEL_DIR, exist_ok = True)
ARTIFACT_PATH = os.path.join(MODEL_DIR,'model.joblib')
META_PATH =os.path.join(MODEL_DIR,'model_meta.json')

def detect_target_column(df: pd.DataFrame) -> str:
    candidates = [
        'loan_status', 'default', 'is_default', 'target', 'y', 'Risk_Flag', 'risk_flag', 'Default', 'default', 'Class', 'class'    
    ]
    for c in candidates:
        if c in df.columns:
            return c
    raise ValueError(
        f"Target column could not be auto-detected. Columns : {list(df.columns)}\n"
        "Set TARGET_COL env var or edit detect_tarfet_column()"
    )

def make_binary_targe(y: pd.Series) -> pd.Series:
    if y.dtype.kind in 'biufc': 
        uniq = pd.unique(y.dropna())
        if set(uniq).issubset({0,1}):
            return y.astype(int)
        return (pd.to_numeric(y, errors='coerce') > 0).astype(int)

    
    y_str = y.astype(str).str.lower().str.strip()

    positive_tokens = {'1','yes','true','default','bad','risk','high', 'charged off'}
    negative_tokens = {'0', 'no','false','non-default', 'good', 'low','paid','fully paid'}

    def to_bin(val:str) -> int:
        if any(tok in val for tok in positive_tokens):
            return 1
        if any(tok in val for tok in negative_tokens):
            return 0
        return 0
    
    return y_str.map(to_bin).astype(int)

def build_pipeline(num_cols,cat_cols) -> Pipeline:
    numeric_transformer = Pipeline(steps = [
        ('imputer', SimpleImputer(strategy='median')),
        ('scaler', StandardScaler())
    ])

    categorical_transformer = Pipeline(steps = [
        ('imputer', SimpleImputer(strategy='most_frequent')),
        ('onehot', OneHotEncoder(handle_unknown='ignore'))
    ])

    preprocess = ColumnTransformer(
        transformers = [
            ('num', numeric_transformer,num_cols),
            ('cat', categorical_transformer, cat_cols),
        ],
        remainder='drop',
        sparse_threshold=0.3
    )

    clf = LogisticRegression(
        max_iter = 2000,
        solver = 'liblinear',
        class_weight='balanced'
    )

    return Pipeline(steps=[
        ('preprocess', preprocess),
        ('clf', clf)
    ])

def main():
    if not os.path.exists(DATA_PATH):
        raise FileNotFoundError(
            f"Dataset not found at: {DATA_PATH}\n"
            'Put your CSV at data/credit_risk_dataset.csv or COPY relative path'
        )
    df = pd.read_csv(DATA_PATH)

    id_like = [c for c in df.columns if 'id' in c.lower() or 'customer' in c.lower()]
    id_like = [c for c in id_like if c not in ('loan_status', 'default', 'target', 'y')]

    target_col = os.getenv('TARGET_COL')
    if target_col is None:
        target_col = detect_target_column(df)

    df = df.drop(columns = id_like, errors='ignore').copy()
    y_raw = df[target_col]
    X =df.drop(columns=[target_col]).copy()
    y = make_binary_targe(y_raw)

    num_cols = X.select_dtypes(include = [np.number]).columns.tolist()
    cat_cols = [c for c in X.columns if c not in num_cols]

    X_train, X_test, y_train, y_test = train_test_split(
        X,y,test_size=0.2, random_state=42, stratify=y
    )

    pipe = build_pipeline(num_cols,cat_cols)
    pipe.fit(X_train,y_train)

    proba = pipe.predict_proba(X_test)[:,1]
    pred = (proba >= 0.5).astype(int)

    auc = roc_auc_score(y_test, proba)
    cm = confusion_matrix(y_test,pred)
    report = classification_report(y_test, pred, digits=4)

    print('AUC:',  round(auc,4))
    print('Confusion Matrix :\n', report)

    joblib.dump(pipe, ARTIFACT_PATH)

    meta = {
        'data_path': DATA_PATH,
        'target_col': target_col,
        'num_cols': num_cols,
        'cat_cols': cat_cols,
        'cat_unique_values': {
            c: sorted(df[c].dropna().astype(str).unique().tolist())
            for c in cat_cols
        },
        'auc_test': float(auc),
        'threshold_default': 0.5
    }

    with open(META_PATH, 'w', encoding='utf-8') as f:
        json.dump(meta,f, ensure_ascii=False,indent=2)

    print(f"\nSaved: {ARTIFACT_PATH}")
    print(f"\nSaved: {META_PATH}")

if __name__ == "__main__":
    main()