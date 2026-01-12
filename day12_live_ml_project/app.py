import os 
import json
import joblib 
import numpy as np 
import pandas as pd
import streamlit as st
from sklearn.model_selection import train_test_split
from sklearn.metrics import precision_recall_curve

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, 'model', 'model.joblib')
META_PATH = os.path.join(BASE_DIR, 'model', 'model_meta.json')
DATA_PATH = os.path.join(BASE_DIR, 'data', 'credit_risk_dataset.csv')

@st.cache_resource
def load_artifacts():
    model = joblib.load(MODEL_PATH)
    with open(META_PATH, 'r', encoding = 'utf-8') as f:
        meta = json.load(f)

    df = None
    if os.path.exists(DATA_PATH):
        try:
            df = pd.read_csv(DATA_PATH)
        except Exception:
            df = None
    return model,meta,df


def risk_label(p:float) -> str:
    if p < 0.30:
        return 'Low'
    
    if p < 0.60:
        return 'Medium'
    
    return 'High'

def compute_thresholds_from_data(df: pd.DataFrame, meta:dict, model) -> dict:
    """
    Return thresholds:
    -f1_best: threshold maximizing F1 on a reconstructed test split
    - recall_80: threshold achieving recall >= 0.80 with best possible preicision

    """

    target_col = meta['target_col']
    X = df.drop(columns = [target_col]).copy()
    y_raw = df[target_col].copy()

    def make_binary_target(y: pd.Series) -> pd.Series:
        if y.dtype.kind in 'biufc':
            uniq = pd.unique(y.dropna())
            if set(uniq).issubset({0,1}):
                return y.astype(int)
            return (pd.to_numeric(y, errors = 'coerce') > 0 ).astype(int)
         
        y_str = y.astype(str).str.lower().str.strip()
        pos = {'1','yes','true','default','bad','risk','high','charged off'}
        neg = {'0','no','false','non-default','good','low','paid','fully paid'} 

        def to_bin(val:str) -> int:
            if any(tok in val for tok in pos): return 1
            if any(tok in val for tok in neg): return 0
            return 0

        return y_str.map(to_bin).astype(int)

    y = make_binary_target(y_raw)

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size= 0.2, random_state= 42, stratify= y 
    )

    proba = model.predict_proba(X_test)[:,1]
    prec, rec, thr = precision_recall_curve(y_test, proba)

    prec = prec[:1]
    rec = rec[:1]

    f1 = 2 * (prec * rec) / (prec + rec + 1e-12)
    best_idx = int(np.argmax(f1))       
    f1_best = float(thr[best_idx])

    target_recall = 0.80
    mask = rec >= target_recall
    recall_80 = None
    if mask.any():
        idx = int(np.argmax(prec[mask]))
        recall_80 = float(thr[np.where(mask)[0][idx]])

    return {
        'f1_best': f1_best,
        'recall_80' : recall_80
    }
        


def main():
    st.set_page_config(page_title = 'Credit Risk - Live ML DEMO', layout='wide')
    st.title('Credit Risk / Loan Defaul Prediction (Live Demo)')
    st.caption('Educational demo: enter applicant & loan info to estimate default risk probability ')

    try:
        model,meta,df = load_artifacts()
    except Exception as e:
        st.error('Model artifacts not found. Run tarin.py first to generate model.joblib and model_meta.josn ')
        st.exception(e)
        return
    
    num_cols = meta['num_cols']
    cat_cols = meta['cat_cols']

    st.sidebar.header('Decision Settings')
    fn_cost = st.sidebar.slider('False Negative Cost (missed risk borrower)', 1,20,5)
    fp_cost = st.sidebar.slider('False Positive Cost (rejecting good borrower )', 1,20,1)
    st.sidebar.markdown('---')
    st.sidebar.write('Tip:Higher FN_cost => lower threshold')

    st.subheader('Applicant & Loan Inputs')
    col1,col2,col3 = st.columns(3)

    user_input = {}

    with col1:
        st.markdown('**Numeric**')
        for c in num_cols:
            cl = c.lower()
            if 'age' in cl:
                user_input[c] = st.slider(c, 18,80,30)

            elif c == 'loan_percent_income':
                user_input[c] = st.slider(c, 0.0,1.0,0.25,step = 0.1)
            elif 'income' in cl:
                user_input[c] = st.number_input(c, min_value = 0.0,value = 50000.0, step=1000.0)
            elif c == 'loan_amnt':
                user_input[c] = st.number_input(c, min_value = 0.0, value=5000.0, step = 500.0)
            elif 'int_rate' in cl or c == 'loan_int_rate':
                user_input[c] = st.slider(c,0.0,40.0,12.0, step =0.1)
            
            elif c == 'person_emp_length':
                user_input[c] = st.slider(c, 0.0,40.0,3.0,step = 0.5)
            elif c == 'cb_person_cred_hist_length':
                user_input[c] = st.slider(c,0,30,5, step = 1)

            else:
                user_input[c] = st.number_input(c, value=0.0)

    with col2:
        st.markdown('**Categorical')
        cat_values = meta.get('cat_unique_values', {})
        for c in cat_cols:
            options = cat_values.get(c, [])
            if options:
                user_input[c] = st.selectbox(c, options)
            else:
                user_input[c] = st.text_input(c, value= '')

    with col3:
        st.markdown('**Prediction**')
        threshold_mode = st.selectbox(
            'Threshold Mode',
            [
                'Default (0.50)',
                'Manuel (slider)',
                'Cost-sensitive(auto)',
                'Data-driven (F1 - optimal)',
                'Data-driven (Recall >= 80)'
            ]
        )
        threshold = 0.50
        if threshold_mode == 'Default (0.50)':
            threshold = 0.50
            st.caption('Default threshold 0.50')

        elif threshold_mode == 'Manuel (slider)':
            threshold = st.slider(
                'Decision Threshold',
                min_value=0.05,
                max_value=0.95,
                value=0.50,
                step= 0.01
            )
        elif threshold_mode == 'Cost-sensitive(auto)':
            threshold = fp_cost / (fp_cost + fn_cost)
            st.caption(f"Auto threshold based on cost : {threshold:.2f}")
        elif threshold_mode.startswith('Data-driven'):
            if df is None or ('target_col' not in meta):
                st.warning('Data-driven threshold requires the training dataset')
                threshold = 0.50
            else:
                thr_dict = compute_thresholds_from_data(df,meta,model)
                if threshold_mode == 'Data-driven (F1 - optimal)':
                    threshold = thr_dict['f1_best']
                    st.caption(f"F1-optimal threshold (from hold-out): {threshold:.3f}")
                else:
                    if thr_dict['recall_80'] is None:
                        st.warning('Could not find a threshold')
                        threshold = thr_dict['f1_best']
                    else:
                        threshold = thr_dict['recall_80']
                    st.caption(f"Recall>=0.80 threshold (from hold out): {threshold:.3f}")


    

             

        predict_btn = st.button('Predict Default Risk')

        if predict_btn:
            X_user = pd.DataFrame([user_input])
            proba = float(model.predict_proba(X_user)[:,1][0])
            proba = min(max(proba, 0.001), 0.999)
            pred = 1 if proba >= threshold else 0
            st.metric('Default Probability', f"{proba*100:.1f}%")

            if pred == 1:
                st.error(f"High Default Risk (threshold = {threshold:.2f})")
            else:
                st.success(f"Low Default Risk (threshold= {threshold:.2f})")
            st.caption('Clas 1 = higher default risk (risky).')
            



if __name__ == '__main__':
    main()


                

