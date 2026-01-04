# Day 5 – Mini ML Projesi

## Heart Disease Prediction

### Türkçe Açıklamalı Çalışma Notları

---

## 1. Projenin Amacı

Bu projenin amacı, gerçekçi bir veri seti üzerinde uçtan uca bir **Machine Learning pipeline** kurmaktır.
Odak noktası yüksek doğruluk elde etmekten ziyade:

* Doğru veri ön işleme adımlarını uygulamak
* Modelleme sürecinde alınan kararların nedenlerini anlamak
* Class imbalance gibi gerçek hayatta sık görülen problemleri ele almaktır

Bu nedenle **Logistic Regression**, yorumlanabilir ve hızlı bir **baseline model** olarak tercih edilmiştir.

---

## 2. Kütüphanelerin Import Edilmesi

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

### Açıklama:

* `pandas`: Veri okuma ve tablo bazlı veri işlemleri
* `numpy`: Sayısal hesaplamalar
* `matplotlib` ve `seaborn`: Veri keşfi (EDA) ve görselleştirme

---

## 3. Scikit-learn Modülleri

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, roc_auc_score
```

### Açıklama:

* `train_test_split`: Eğitim ve test setlerini ayırmak için
* `LogisticRegression`: Baseline sınıflandırma modeli
* `StandardScaler`: Sayısal değişkenleri ölçeklemek için
* `classification_report`: Precision, recall ve f1-score değerlerini görmek için
* `roc_auc_score`: Threshold bağımsız model değerlendirmesi için

---

## 4. Verinin İncelenmesi (EDA)

```python
df.head()
df.info()
df.describe()
```

### Amaç:

* Veri tiplerini kontrol etmek
* Eksik değerleri tespit etmek
* Sayısal değişkenlerin dağılımlarını incelemek

---

## 5. Eksik Veri Analizi

```python
df.isnull().sum()
```

### Karar Stratejisi:

* Yüzde 25 ve üzeri eksik değer içeren sütunlar modelden çıkarılır
* Yüzde 1’in altında eksik değeri olan sütunlar doldurulur

### Uygulama:

```python
df = df.drop('Alcohol Consumption', axis=1)

numeric_cols = df.select_dtypes(include='float64').columns
df[numeric_cols] = df[numeric_cols].fillna(df[numeric_cols].median())

categorical_cols = df.select_dtypes(include='object').columns
df[categorical_cols] = df[categorical_cols].fillna(df[categorical_cols].mode().iloc[0])
```

#### Median neden kullanıldı?

* Aykırı değerlere (outlier) karşı ortalamaya göre daha dayanıklıdır

#### `mode().iloc[0]` neden kullanıldı?

* `mode()` birden fazla değer döndürebilir
* `iloc[0]` ile tek ve deterministik bir değer seçilir

---

## 6. Encoding (Kategorik Değişkenlerin Sayısallaştırılması)

### Target Encoding

```python
df['Heart Disease Status'] = df['Heart Disease Status'].map({'Yes': 1, 'No': 0})
```

---

### Binary Encoding (Yes / No)

```python
binary_cols = [
    'Smoking',
    'Family Heart Disease',
    'Diabetes',
    'High Blood Pressure',
    'Low HDL Cholesterol',
    'High LDL Cholesterol'
]

for col in binary_cols:
    df[col] = df[col].map({'Yes': 1, 'No': 0})
```

---

### Ordinal Encoding (Low < Medium < High)

```python
ordinal_map = {'Low': 0, 'Medium': 1, 'High': 2}

ordinal_cols = [
    'Exercise Habits',
    'Stress Level',
    'Sugar Consumption'
]

for col in ordinal_cols:
    df[col] = df[col].map(ordinal_map)
```

Bu sütunlarda kategoriler arasında doğal bir sıralama olduğu için one-hot encoding tercih edilmemiştir.

---

### One-Hot Encoding (Nominal Değişkenler)

```python
df = pd.get_dummies(df, columns=['Gender'], drop_first=True)
df['Gender_Male'] = df['Gender_Male'].astype(int)
```

#### `drop_first=True` neden kullanıldı?

* Dummy variable trap’i önlemek için
* Lineer modellerde çoklu doğrusal bağlantıyı engellemek için

---

## 7. Feature ve Target Ayrımı

```python
X = df.drop('Heart Disease Status', axis=1)
y = df['Heart Disease Status']
```

### Amaç:

* Data leakage’i önlemek
* Modelin yalnızca bağımsız değişkenlerden öğrenmesini sağlamak

---

## 8. Train – Test Split

```python
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42,
    stratify=y
)
```

### Açıklamalar:

* Test seti verinin yüzde 20’si olarak ayrılmıştır
* `random_state=42` tekrar üretilebilirlik sağlar
* `stratify=y` class imbalance oranını train ve test setlerinde korur

---

## 9. Feature Scaling

```python
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)
```

### Neden scaling yapıldı?

* Logistic Regression gradyan tabanlı çalışır
* Farklı ölçekler convergence problemlerine yol açabilir
* Test verisi scaler’a fit edilmez (data leakage önlenir)

---

## 10. Logistic Regression Modeli

```python
model = LogisticRegression(
    max_iter=1000,
    class_weight='balanced'
)
```

### `max_iter=1000` neden?

* Varsayılan iterasyon sayısı optimizasyon için yeterli olmayabilir
* ConvergenceWarning almamak ve stabil çözüm elde etmek için artırılmıştır

### `class_weight='balanced'` neden?

* Veri seti dengesizdir (%80 / %20)
* Azınlık sınıfın (hasta) modele daha fazla etki etmesini sağlar

---

## 11. Threshold Tuning

```python
y_prob = model.predict_proba(X_test_scaled)[:, 1]
y_pred_05 = (y_prob >= 0.5).astype(int)
```

### Neden `predict()` kullanılmadı?

* `predict()` sabit threshold (0.5) kullanır
* Risk problemlerinde threshold kontrol edilmelidir

---

## 12. Model Değerlendirme

```python
print(classification_report(y_test, y_pred_05))
```

### Odaklanılan metrikler:

* Recall (özellikle pozitif sınıf için)
* Precision
* Accuracy ikincil önemdedir

---

## 13. ROC–AUC

```python
roc_auc = roc_auc_score(y_test, y_prob)
print(roc_auc)
```

### ROC–AUC neyi ölçer?

* Modelin threshold’tan bağımsız ayırt etme gücünü
* Rastgele tahmine karşı performansını

---

## 14. Genel Değerlendirme

Bu çalışma:

* Doğru ve eksiksiz bir ML pipeline içerir
* Model performansı sınırlıdır
* Ancak bu durum, verinin ve modelin sınırlarının doğru analiz edildiğini gösterir


