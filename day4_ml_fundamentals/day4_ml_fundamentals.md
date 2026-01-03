
# Day 4 – ML Fundamental Concepts (TR + EN)
```md

Bu notlar, makine öğrenmesi temel kavramlarını
hem Türkçe hem İngilizce olarak,
mülakatlarda anlatabilecek seviyede özetlemek için hazırlanmıştır.
```

---

## Supervised vs Unsupervised Learning

### 🇹🇷 Türkçe

**Supervised Learning**, etiketli (label’lı) veriyle çalışır.
Yani her veri noktasının doğru cevabı bellidir (örneğin: ev fiyatı, spam / not spam).

**Unsupervised Learning** ise etiketsiz veriyle çalışır.
Amaç, verideki gizli yapıları, grupları veya ilişkileri keşfetmektir.

Örnek:

* Supervised → ev fiyatı tahmini
* Unsupervised → müşteri segmentasyonu

---

### 🇬🇧 English

**Supervised learning** works with labeled data,
where the correct output is already known.

**Unsupervised learning** works with unlabeled data,
and the goal is to discover hidden patterns or structures in the data.

Example:

* Supervised → house price prediction
* Unsupervised → customer segmentation

---

## Regression vs Classification

### 🇹🇷 Türkçe

**Regression**, sayısal (continuous) bir değer tahmin eder.
Örneğin: fiyat, maaş, sıcaklık.

**Classification**, kategorik bir sınıf tahmin eder.
Örneğin: evet / hayır, spam / not spam, hasta / sağlıklı.

Temel fark:

* Regression → sayı
* Classification → sınıf

---

### 🇬🇧 English

**Regression** predicts a continuous numerical value,
such as price, salary, or temperature.

**Classification** predicts a categorical class,
such as yes/no, spam/not spam, or healthy/sick.

Main difference:

* Regression → number
* Classification → class

---

## Overfitting & Underfitting

### 🇹🇷 Türkçe

**Overfitting**, modelin eğitim verisini aşırı iyi öğrenmesi
ama yeni, görülmemiş verilerde kötü performans göstermesidir.

**Underfitting**, modelin hem eğitim verisini
hem de test verisini iyi öğrenememesidir.

Amaç:

* Ne çok basit
* Ne çok karmaşık
  → dengeli bir model kurmak

---

### 🇬🇧 English

**Overfitting** happens when a model learns the training data too well
but performs poorly on unseen data.

**Underfitting** happens when a model is too simple
and cannot capture the underlying patterns in the data.

The goal is to find a balanced model.

---

## Bias – Variance Tradeoff

### 🇹🇷 Türkçe

**Bias**, modelin veriyi fazla basitleştirmesinden kaynaklanan hatadır.
Genelde underfitting ile ilişkilidir.

**Variance**, modelin veriye aşırı duyarlı olmasından kaynaklanan hatadır.
Genelde overfitting ile ilişkilidir.

İyi bir model:

* Düşük bias
* Düşük variance
  dengesini kurmalıdır.

---

### 🇬🇧 English

**Bias** is the error caused by overly simplistic assumptions in the model
and is often related to underfitting.

**Variance** is the error caused by the model being too sensitive to the training data
and is often related to overfitting.

A good model balances bias and variance.

---

## Train / Validation / Test Split

### 🇹🇷 Türkçe

Veri genellikle üçe bölünür:

* **Train set**: Modelin öğrenmesi için
* **Validation set**: Model ayarlarını (hyperparameter) seçmek için
* **Test set**: Modelin gerçek performansını ölçmek için

Test set, eğitim sırasında **asla** kullanılmamalıdır.

---

### 🇬🇧 English

Data is usually split into three parts:

* **Training set**: used to train the model
* **Validation set**: used for tuning hyperparameters
* **Test set**: used to evaluate final performance

The test set must never be used during training.

---

## Feature & Label

### 🇹🇷 Türkçe

**Feature**, modele verilen girdilerdir (bağımsız değişkenler).
Örneğin: yaş, gelir, evin metrekaresi.

**Label**, modelin tahmin etmeye çalıştığı çıktıdır (bağımlı değişken).
Örneğin: ev fiyatı, hastalık durumu.

Basitçe:

* Feature → soru
* Label → cevap

---

### 🇬🇧 English

A **feature** is an input variable given to the model,
such as age, income, or house size.

A **label** is the output the model is trying to predict,
such as house price or disease status.

Simply:

* Feature → input
* Label → output

---





