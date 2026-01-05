import joblib
import pandas as pd

MODEL_PATH = "day_5_mini_ml_projects/models/model.joblib"

def main():
    model = joblib.load(MODEL_PATH)

    sample = {
        "Age": 56,
        "Gender": "Male",
        "Blood Pressure": 153,
        "Cholesterol Level": 155,
        "Exercise Habits": "High",
        "Smoking": "Yes",
        "Family Heart Disease": "Yes",
        "Diabetes": "No",
        "BMI": 24.99,
        "High Blood Pressure": "Yes",
        "Low HDL Cholesterol": "Yes",
        "High LDL Cholesterol": "No",
        "Alcohol Consumption": "High",
        "Stress Level": "Medium",
        "Sleep Hours": 7.6,
        "Sugar Consumption": "Medium",
        "Triglyceride Level": 342,
        "Fasting Blood Sugar": 120,
        "CRP Level": 12.9,
        "Homocysteine Level": 12.3,
    }

    X = pd.DataFrame([sample])
    prob = model.predict_proba(X)[:, 1][0]
    print(f"Predicted risk probability: {prob:.4f}")

if __name__ == "__main__":
    main()
