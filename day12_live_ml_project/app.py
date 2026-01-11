import os 
import json
import joblib 
import numpy as np 
import pandas as pd
import streamlit as st

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, 'model', 'model.joblib')
META_PATH = os.path.join(BASE_DIR, 'model', 'model_meta.json')

@st.cache_resource
def load_artifacts():
    model = joblib.load(MODEL_PATH)
    with open(META_PATH, 'r', encoding='utf-8') as f:
        meta = json.load(f)
    return model, meta

def risk_label(p:float) -> str:
    if p < 0.30:
        return 'Low'
    
    if p < 0.60:
        return 'Medium'
    
    return 'High'

def main():
    st.set_page_config(page_title = 'Credit Risk - Live ML DEMO', layout='wide')
    st.title('Credit Risk / Loan Defaul Prediction (Live Demo)')
    st.caption('Educational demo: enter applicant & loan info to estimate default risk probability ')

    try:
        model,meta = load_artifacts()
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
            ['Manuel (slider)', 'Cost-sensitive (auto)']
        )
        if threshold_mode == 'Manuel (slider)':
            threshold = st.slider(
                'Decision Threshold',
                min_value = 0.05,
                max_value = 0.95,
                value = 0.50,
                step = 0.01
            )
        else:
            threshold = fp_cost / (fp_cost + fn_cost)
            st.caption(f"Auto threshold based on costs:{threshold:.2f}")

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


                

