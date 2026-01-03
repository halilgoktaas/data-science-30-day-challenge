# Day 3 – SQL Window Functions Practice (PostgreSQL)

> This document contains hands-on SQL window function practices.
> Tables such as `employees`, `sales`, and `orders` are assumed to be
> simplified demo tables for learning purposes.

# Day 3 – SQL Window Functions Practice Notes (PostgreSQL)

> Amaç: Python’da `groupby`, `rank`, `shift`, `cumsum` gibi yaptıklarımızı SQL’de **window functions** ile yapmak.
> Window function = satırları **silmeden** (GROUP BY gibi küçültmeden) satırlar üzerinde hesap yapmak.

---

## 0) Window Function Temeli

### Genel Şablon
```sql
<AGG_OR_WINDOW_FUNCTION>() OVER (
  PARTITION BY <group_column>
  ORDER BY <sort_column>
)
````

### En küçük parçalar ne işe yarar?

* `OVER(...)`

  * Bu fonksiyonun **window function** olarak çalışacağını söyler.
  * `OVER` yoksa, `SUM()` gibi fonksiyonlar tüm tabloyu tek değere indirger.

* `PARTITION BY <kolon>`

  * Veriyi gruplara ayırır (Python `groupby` gibi).
  * Ama **GROUP BY’dan farkı**: satırlar **kaybolmaz**, sadece hesap gruba göre yapılır.
  * Örn: `PARTITION BY department` → her departman ayrı hesaplanır.

* `ORDER BY <kolon>`

  * Window içindeki satırların sırasını belirler.
  * Ranking (ROW_NUMBER/RANK) ve zaman serisi (LAG/LEAD) için kritiktir.
  * Running total gibi kümülatif hesapları mümkün kılar.

* `ORDER BY ... DESC`

  * Büyükten küçüğe sıralar (maaş gibi “en yüksek” ararken genelde DESC).

> Not: Window içindeki `ORDER BY` ile sorgunun en altındaki `ORDER BY` farklıdır.
>
> * `OVER( ... ORDER BY ...)` = hesaplamanın sırasını belirler
> * Sorgu sonundaki `ORDER BY` = sonuç tablosunun ekranda nasıl görüneceğini belirler

---

## 1) SORU 1 — Her çalışana departman içi maaş sırası ver (ROW_NUMBER)

### Problem

Her çalışana, **kendi departmanı içinde** maaşına göre bir sıra numarası ver.

### Çözüm

```sql
SELECT
  *,
  ROW_NUMBER() OVER (
    PARTITION BY department
    ORDER BY salary DESC
  ) AS rn
FROM employees
ORDER BY department, rn;
```

### Buradaki her şeyin anlamı

* `ROW_NUMBER()`

  * Her grupta 1’den başlayarak **benzersiz sıra** verir.
  * Eşit maaş olsa bile biri 1, diğeri 2 olur (tie’larda “benzersiz”).
* `PARTITION BY department`

  * Sıralamayı departman bazında yapar (IT ayrı, HR ayrı…).
* `ORDER BY salary DESC`

  * Departman içinde maaşı yüksek olanın `rn` değeri küçük olur (1 en yüksek).
* `AS rn`

  * Üretilen sıralama kolonunun adını `rn` yapar.
* En alttaki `ORDER BY department, rn`

  * Sonuçları okuması kolay şekilde departman departman, sıra sıra gösterir.

### Python karşılığı

* `df["rn"] = df.sort_values("salary", ascending=False).groupby("department").cumcount()+1`

---

## 2) SORU 2 — Her departmandan en yüksek maaşlı 2 çalışanı getir (Top-N per Group)

### Problem

Her departmandan **en yüksek maaşlı 2 kişi** gelsin.

### Çözüm

```sql
SELECT *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY department
      ORDER BY salary DESC
    ) AS rn
  FROM employees
) t
WHERE rn <= 2
ORDER BY department, rn;
```

### Buradaki parçalar

* İç sorgu `( ... ) t`

  * Önce herkesin departman içi sırasını hesaplarız (rn).
  * Sonra dışarıda filtreleyebiliriz.
* `WHERE rn <= 2`

  * Her departmanda rn 1 ve 2 olanları alır → “Top 2”.
* Neden direkt `WHERE` içinde window yazmıyoruz?

  * SQL’de window fonksiyonları genelde `SELECT` aşamasında üretilir,
    sonra dış sorguda filtrelenir (okunaklı ve standart yöntem).

### Not (Önemli)

* `ROW_NUMBER()` tie’larda (eşit maaş) yine 2 kişi seçer ama
  eşit maaşlılarda “hangisi önce” bazen kararsız olabilir.
* İstersen stabil yapmak için:
  `ORDER BY salary DESC, name ASC`

---

## 3) SORU 3 — Eşit maaşlılar aynı sırada olsun (DENSE_RANK)

### Problem

Bir departmanda aynı maaşı alanlar varsa, **aynı rank** değerini alsınlar.
Ve ilk 2 rank grubunu getir.

### Çözüm

```sql
SELECT *
FROM (
  SELECT
    *,
    DENSE_RANK() OVER (
      PARTITION BY department
      ORDER BY salary DESC
    ) AS rnk
  FROM employees
) t
WHERE rnk <= 2
ORDER BY department, rnk, salary DESC;
```

### DENSE_RANK ne yapar?

* `DENSE_RANK()`

  * Eşit maaşlılara aynı rank verir.
  * Rank numaraları “atlamaz”.
  * Örn: 9000, 9000, 8000 → rnk: 1, 1, 2

### RANK vs DENSE_RANK vs ROW_NUMBER

* `ROW_NUMBER()` → 1,2,3 (tie olsa bile benzersiz)
* `RANK()` → 1,1,3 (tie sonrası sayı atlar)
* `DENSE_RANK()` → 1,1,2 (tie sonrası atlamaz)

### Neden sonuç bazen 2 kişiden fazla gelir?

* Çünkü `rnk <= 2` “ilk 2 kişiyi” değil, “ilk 2 rank grubunu” getirir.
* 2. rank’ta 3 kişi varsa, 3’ü de gelir (bu istenen davranış).

---

## 4) SORU 4 — Günlük gelirin bir önceki güne göre farkını bul (LAG)

### Problem

Her günün `revenue` değerini, bir önceki günün geliriyle karşılaştır:
`diff = today - yesterday`

### Çözüm

```sql
SELECT
  date,
  revenue,
  revenue - LAG(revenue) OVER (ORDER BY date) AS diff
FROM sales
ORDER BY date;
```

### LAG ne yapar?

* `LAG(revenue)`

  * Mevcut satırın **bir önceki satırındaki** `revenue` değerini getirir.
* `OVER (ORDER BY date)`

  * “Önce tarihe göre sırala, sonra bir önceki satırı getir.”

### Neden ilk gün diff NULL?

* İlk günün “bir önceki günü” yok → `LAG` NULL döner → `diff` NULL olur.
* İstersen NULL yerine 0:

```sql
revenue - COALESCE(LAG(revenue) OVER (ORDER BY date), 0) AS diff
```

### Python karşılığı

* `df["diff"] = df["revenue"] - df["revenue"].shift(1)`

---

## 5) SORU 5 — Müşteri bazlı birikimli toplam (Running Total)

### Problem

Her müşteri için, tarih sırasına göre harcamaları biriktir:
`running_total = cumulative sum`

### Çözüm (Mülakat-ready)

```sql
SELECT
  customer_id,
  order_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
  ) AS running_total
FROM orders
ORDER BY customer_id, order_date;
```

### SUM(...) OVER(...) ne yapar?

* `SUM(amount)` normalde GROUP BY’sız kullanılırsa tek değer döndürür.
* `SUM(amount) OVER (...)`

  * Satırları korur, her satır için “o ana kadar toplam” üretir.

### PARTITION BY customer_id

* Her müşteri için ayrı kümülatif toplam tutulur.
* Müşteri 1’in toplamı, müşteri 2 ile karışmaz.

### ORDER BY order_date

* Toplamın hangi sırayla birikeceğini belirler.
* ORDER BY olmazsa “kümülatif” mantık bozulur.

### Python karşılığı

* `df["running_total"] = df.sort_values("order_date").groupby("customer_id")["amount"].cumsum()`

---


## “Hızlı Ezber” (tek satır)

* ROW_NUMBER: **her grupta benzersiz sıra**
* DENSE_RANK: **eşitler aynı sıra, boşluk yok**
* LAG: **bir önceki satır**
* SUM OVER: **satırları bozmadan kümülatif toplam**
* PARTITION BY: **groupby**
* ORDER BY (window): **hesaplama sırası**

```

