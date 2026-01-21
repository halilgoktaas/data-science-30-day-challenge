# Day 21 – SQL Case Study

## End-to-End SaaS & E-Commerce Analytics

### 📌 Business Context

Bu case study, **abonelik tabanlı bir SaaS ürününün** ve ona bağlı **e-commerce işlemlerinin** SQL ile analiz edilmesini kapsar.
Amaç:

* Kullanıcı davranışlarını anlamak
* Gelir ve kullanım metriklerini üretmek
* Churn & risk sinyallerini tespit etmek
* Analitik sorgularla **iş kararlarını desteklemek**

Çalışma boyunca **window functions, CTE’ler, LEFT vs INNER JOIN kararları** ve **analitik metrikler** yoğun şekilde kullanılmıştır.

---

## 📂 Core Tables (Özet)

* `users / customers`
* `orders / order_items / products`
* `subscriptions / plans`
* `invoices / payments`
* `usage_events`
* `model_predictions / actual_outcomes`

---

## 1️⃣ Revenue & Order Analytics (E-Commerce)

### Q1 — Sipariş Toplamı ve Kampanya Sonrası Net Gelir

**Problem:**
Her siparişin gerçek gelirini hesaplamak (kampanyalı / kampanyasız).

**Neden JOIN + CTE?**

* `order_items` → sipariş seviyesine indirgenir
* Kampanya varsa `discount_rate` uygulanır
* Kampanyası olmayan siparişler **dışlanmamalı**

**JOIN Kararı:**
`LEFT JOIN campaigns`
→ Kampanyası olmayan siparişleri kaybetmemek için

**Business Insight:**
Net revenue, brüt cirodan farklıdır. Kampanyaların gelir üzerindeki gerçek etkisi bu şekilde ölçülür.

---

### Q2 — Günlük Net Gelir & Moving Average

**Problem:**
Gelirdeki kısa vadeli dalgalanmaları yumuşatmak.

**Teknik:**

* Günlük agregasyon
* `AVG(...) OVER (ROWS BETWEEN n PRECEDING AND CURRENT ROW)`

**Business Insight:**
Moving average, gerçek trendi görmeyi sağlar. Tek günlük spike’lar yanıltıcıdır.

---

## 2️⃣ User Behavior & Segmentation

### Q3 — Kullanıcı Bazlı AOV & Total Spend

**Problem:**
En değerli kullanıcıları belirlemek.

**JOIN Kararı:**
`LEFT JOIN orders`
→ Hiç sipariş vermemiş kullanıcılar **0 harcama ile dahil edilir**

**Business Insight:**

* AOV: pricing ve upsell kararları
* Total spend: VIP / loyal user tespiti

---

### Q4 — İlk Siparişten Sonra 14 Gün İçinde 2. Sipariş

**Problem:**
Early retention ölçümü.

**Teknik:**

* `ROW_NUMBER()` ile sipariş sırası
* Tarih farkı ile erken tekrar sipariş

**Business Insight:**
İlk 14 gün, churn ihtimalinin en güçlü göstergelerinden biridir.

---

## 3️⃣ Time-Based & Window Analytics

### Q5 — Siparişler Arası Gün Farkı (LAG)

**Problem:**
Kullanıcıların sipariş sıklığını ölçmek.

**Teknik:**
`LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date)`

**Business Insight:**
Sipariş aralıkları uzuyorsa churn sinyali oluşur.

---

### Q6 — Kümülatif Harcama (Running Total)

**Problem:**
Kullanıcının zaman içindeki değerini görmek.

**Business Insight:**
CLV (Customer Lifetime Value) için temel yapı taşıdır.

---

## 4️⃣ SaaS Subscription & Revenue Analytics

### Q7 — Plan Bazlı Aktif Abone, Seat ve MRR

**Problem:**
Plan performanslarını karşılaştırmak.

**JOIN Kararı:**
`LEFT JOIN subscriptions`
→ Abonesi olmayan planlar da raporda görünür

**Business Insight:**

* Hangi plan daha kârlı?
* Seat artışı mı, müşteri artışı mı etkili?

---

### Q8 — Invoice & Payment Reconciliation

**Problem:**
Fatura kesilen tutar ile ödenen tutarın farkı.

**Teknik:**

* Ayrı CTE’ler: invoices & payments
* `LEFT JOIN` → ödeme yapılmayan faturalar korunur

**Business Insight:**
Cash flow ve tahsilat riski analizi.

---

## 5️⃣ Churn, Risk & Usage Analytics

### Q9 — Son 30 Gün API Kullanımı

**Problem:**
Aktif müşterilerin ürünü gerçekten kullanıp kullanmadığını görmek.

**Teknik:**

* Tarih parametresi (`as_of_date`)
* `COALESCE` ile 0 usage

**Business Insight:**
Kullanmayan ama aktif görünen müşteri → **yüksek churn riski**

---

### Q10 — Risk Segmentation (ML + SQL)

**Problem:**
Tahmin + davranış birleşimiyle risk sınıflaması.

**Mantık:**

* High churn probability
* Son 30 günde 0 usage

**Segmentler:**

* High Risk
* Medium Risk
* Low Risk

**Business Insight:**
Bu çıktı direkt:

* Retention campaign
* Account manager aksiyonu
* Proaktif churn önleme
  için kullanılır.

---

## 🔑 Neden Bu Case Study Güçlü?

* Sadece **SELECT yazmıyor**, **neden yazdığını** gösteriyor
* LEFT JOIN bilinçli kullanılmış
* Window functions gerçek iş problemine bağlanmış
* SQL → ML → Business hattı kurulmuş

---

### 📌 Sonuç

Bu çalışma, SQL’in yalnızca veri çekmek için değil;
**ürün, gelir ve müşteri kararlarını yönlendirmek için** nasıl kullanıldığını göstermektedir.

