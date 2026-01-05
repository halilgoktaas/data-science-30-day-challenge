import joblib
import pandas as pd

MODEL_PATH = "C:/Users/user\Desktop/30-days-data-scientist-challenge/day6_ml_projects/models/model.joblib"

def main():
    model = joblib.load(MODEL_PATH)

    sample = {
        "gender": "Male",
        "age": 67,
        "hypertension": 0,
        "heart_disease": 1,
        "ever_married": "Yes",
        "work_type": "Private",
        "Residence_type": "Urban",
        "avg_glucose_level": 228.69,
        "bmi": 36.6,
        "smoking_status": "formerly smoked"
    }

    X = pd.DataFrame([sample])
    prob = model.predict_proba(X)[:,1][0]
    print(f"Predicted stroke probability: {prob:.4f}")

if __name__ == "__main__":
    main()

