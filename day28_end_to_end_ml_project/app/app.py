import streamlit as st
import pandas as pd
import joblib
from pathlib import Path

st.set_page_config(
    page_title = 'Employee Attrition Risk Predictior',
    page_icon = '📉',
    layout = 'wide'
)
THRESHOLD = 0.60

@st.cache_resource
def load_model():
    base_dir = Path(__file__).resolve().parent
    model_path = base_dir.parent / 'models' / 'model.joblib'

    if not model_path.exists():
        raise FileNotFoundError(
            f"model.joblib not found at expected path: {model_path}"
        )
    
    return joblib.load(model_path), model_path

model, model_path = load_model()

st.title('Employee Attrition Risk Predictor')
st.caption(
    "Predicts the probability of employee attrition using an end-to-end ML pipeline "
    "(preprocessing + classification)."
)

with st.expander('Project context & what this app does', expanded = False):
    st.markdown(
        """
- **Business objective:** Identify employees with high attrition risk for proactive retention actions.
- **Modeling approach:** Preprocessing via `ColumnTransformer` + tuned threshold classification.
- **Output:** Attrition probability + risk label using a tuned threshold (**0.60**).
"""
    )
    st.write(f"Loaded model artifact from: '{model_path}'")


st.sidebar.header('Input Empolyee Profile')
# NOTE:
# These are the raw features (before preprocessing).
# The pipeline handles encoding internally
# If you change dataset or drop columns, update these inputs accordingly.

def selectbox(label, options, default = None, help_text = None):
    idx = options.index(default) if (default in options) else 0
    return st.sidebar.selectbox(label,options, index = idx, help = help_text)

def number(label, value, min_value = None, max_value = None, step = None, help_text = None):
    return st.sidebar.number_input(
        label, value = value, min_value = min_value, max_value = max_value, step = step, help = help_text
    )

BusinessTravel = selectbox(
    "BusinessTravel",
    ['Non-Travel', 'Travel_Rarely', 'Travel_Frequently'],
    default='Travel_Rarely'
)
Department = selectbox(
    'Department',
    ['Sales', 'Research & Development', 'Human Resources'],
    default= 'Research & Development'
)
EducationField = selectbox(
    'EducationField',
    ['Life Sciences','Medical','Marketing','Technical Degree','Human Resources','Other'],
    default= 'Life Sciences'
)
Gender = selectbox('Gender', ['Male', 'Female'], default= 'Male')
JobRole = selectbox(
    'JobRole',
    [
        'Sales Executive', 'Research Scientist', 'Laboratory Technician', 'Manufacturing Director', 'Healthcare Representative', 'Manager', 'Sales Representative', 'Research Director', 'Human Resources'
    ],
    default= 'Research Scientist'
)
MaritalStatus = selectbox('MaritalStatus', ['Single', 'Married', 'Divorced'], default= 'Married')
OverTime = selectbox('OverTime', ['Yes', 'No'], default= 'No')
st.sidebar.divider()

##Numerical##

Age = number('Age', value = 35, min_value=18, max_value=60, step = 1)
DailyRate = number('DailyRate', value=800, min_value=100, max_value=1600, step=10)
DistanceFromHome = number("DistanceFromHome", value=10, min_value=1, max_value=30, step=1)
Education = number("Education (1-5)", value=3, min_value=1, max_value=5, step=1)
EnvironmentSatisfaction = number("EnvironmentSatisfaction (1-4)", value=3, min_value=1, max_value=4, step=1)
HourlyRate = number("HourlyRate", value=65, min_value=30, max_value=100, step=1)
JobInvolvement = number("JobInvolvement (1-4)", value=3, min_value=1, max_value=4, step=1)
JobLevel = number("JobLevel (1-5)", value=2, min_value=1, max_value=5, step=1)
JobSatisfaction = number("JobSatisfaction (1-4)", value=3, min_value=1, max_value=4, step=1)
MonthlyIncome = number("MonthlyIncome", value=5000, min_value=1000, max_value=20000, step=100)
MonthlyRate = number("MonthlyRate", value=14000, min_value=2000, max_value=27000, step=100)
NumCompaniesWorked = number("NumCompaniesWorked", value=2, min_value=0, max_value=10, step=1)
PercentSalaryHike = number("PercentSalaryHike", value=13, min_value=11, max_value=25, step=1)
PerformanceRating = number("PerformanceRating (1-4)", value=3, min_value=1, max_value=4, step=1)
RelationshipSatisfaction = number("RelationshipSatisfaction (1-4)", value=3, min_value=1, max_value=4, step=1)
StockOptionLevel = number("StockOptionLevel (0-3)", value=1, min_value=0, max_value=3, step=1)
TotalWorkingYears = number("TotalWorkingYears", value=10, min_value=0, max_value=40, step=1)
TrainingTimesLastYear = number("TrainingTimesLastYear", value=3, min_value=0, max_value=10, step=1)
WorkLifeBalance = number("WorkLifeBalance (1-4)", value=3, min_value=1, max_value=4, step=1)
YearsAtCompany = number("YearsAtCompany", value=5, min_value=0, max_value=40, step=1)
YearsInCurrentRole = number("YearsInCurrentRole", value=3, min_value=0, max_value=20, step=1)
YearsSinceLastPromotion = number("YearsSinceLastPromotion", value=1, min_value=0, max_value=15, step=1)
YearsWithCurrManager = number("YearsWithCurrManager", value=3, min_value=0, max_value=20, step=1)

input_row = {
    "Age": Age,
    "BusinessTravel": BusinessTravel,
    "DailyRate": DailyRate,
    "Department": Department,
    "DistanceFromHome": DistanceFromHome,
    "Education": Education,
    "EducationField": EducationField,
    "EnvironmentSatisfaction": EnvironmentSatisfaction,
    "Gender": Gender,
    "HourlyRate": HourlyRate,
    "JobInvolvement": JobInvolvement,
    "JobLevel": JobLevel,
    "JobRole": JobRole,
    "JobSatisfaction": JobSatisfaction,
    "MaritalStatus": MaritalStatus,
    "MonthlyIncome": MonthlyIncome,
    "MonthlyRate": MonthlyRate,
    "NumCompaniesWorked": NumCompaniesWorked,
    "OverTime": OverTime,
    "PercentSalaryHike": PercentSalaryHike,
    "PerformanceRating": PerformanceRating,
    "RelationshipSatisfaction": RelationshipSatisfaction,
    "StockOptionLevel": StockOptionLevel,
    "TotalWorkingYears": TotalWorkingYears,
    "TrainingTimesLastYear": TrainingTimesLastYear,
    "WorkLifeBalance": WorkLifeBalance,
    "YearsAtCompany": YearsAtCompany,
    "YearsInCurrentRole": YearsInCurrentRole,
    "YearsSinceLastPromotion": YearsSinceLastPromotion,
    "YearsWithCurrManager": YearsWithCurrManager,
}
X_input = pd.DataFrame([input_row])
col1, col2 = st.columns([1.2,1])

with col1:
    st.subheader('Selected İnput')
    st.dataframe(X_input, use_container_width=True)

with col2:
    st.subheader('Prediction')
    predict_btn = st.button('Predict attrition risk', type = 'primary', use_container_width=True)

    if predict_btn:
        try:
            proba = model.predict_proba(X_input)[:, 1][0]
            label = int(proba >= THRESHOLD)
            st.metric('Attrition Probability', f"{proba:.1%}")
            st.caption(f"Decision threshold: {THRESHOLD:.2f}")
            
            if label == 1:
                st.error('High Risk: Employee is likely  to attrite (based on threshold) ')
                st.markdown(
                     """
**Suggested action:** consider retention outreach (manager check-in, workload review, career path discussion).
"""
                )
            else:
                st.success('Low Risk: Employee is unlikely to attrite (based on threshold)')
                st.markdown(
                    """
**Suggested action:** continue monitoring; no immediate retention action required.
"""
                )
        except Exception as e:
            st.exception(e)
st.divider()

with st.expander("Model performance (from validation)", expanded=False):
    st.markdown(
        """
From the Day 28 modeling notebook (Validation set):
- **Logistic Regression ROC-AUC:** ~0.803  
- **PR-AUC:** ~0.561  
- Tuned threshold (best F1): **0.60**
"""
    )

