# Customer Segmentation with RFM and KMeans

## Project Overview
This project aims to segment customers based on their purchasing behavior using **RFM (Recency, Frequency, Monetary)** analysis combined with **KMeans clustering**.  
The goal is to help businesses better understand their customer base and design targeted marketing and retention strategies.

The project follows a real-world, business-oriented approach rather than focusing solely on model performance.

---

## Dataset
The dataset contains transactional retail data with the following key fields:
- Invoice
- InvoiceDate
- Quantity
- Price
- Customer ID
- Country

Each row represents a single transaction. Customers may appear multiple times across different invoices.

---

## Methodology

### 1. Data Cleaning
- Removed transactions with missing Customer ID
- Filtered out negative or zero Quantity and Price values
- Converted date fields to datetime format
- Created a new feature: `TotalPrice = Quantity × Price`

### 2. RFM Feature Engineering
For each customer:
- **Recency**: Days since the most recent purchase
- **Frequency**: Number of unique invoices
- **Monetary**: Total spending amount

A snapshot date was defined as one day after the last transaction in the dataset.

### 3. Outlier Handling
To stabilize clustering results, extreme values in RFM features were clipped using percentile-based thresholds.

### 4. Scaling
RFM features were standardized using `StandardScaler` to ensure equal contribution to the clustering algorithm.

### 5. Clustering
- Applied **KMeans clustering**
- Optimal number of clusters was determined using Elbow and Silhouette methods
- Final model was trained with **4 clusters**

---

## Customer Segments & Business Interpretation

### Segment 2 – Champions
- Lowest Recency
- Highest Frequency and Monetary value
- Smallest group but highest revenue contribution

**Business action**: Prioritize retention, VIP campaigns, loyalty programs.

---

### Segment 1 – Loyal Customers
- High Frequency and Monetary value
- Regular purchasers with strong engagement

**Business action**: Upselling, cross-selling, reward-based incentives.

---

### Segment 0 – Occasional Customers
- Moderate Recency
- Low Frequency and Monetary value
- Largest customer group

**Business action**: Targeted promotions to increase repeat purchases.

---

### Segment 3 – Hibernating / At-Risk Customers
- Very high Recency
- Low Frequency and Monetary value

**Business action**: Cost-effective reactivation campaigns or deprioritization.

---

## Key Insights
- A small group of customers generates a disproportionate share of total revenue.
- Loyal customers offer the highest return on marketing investment.
- A large portion of customers represents untapped growth potential.
- Reactivation strategies should be selectively applied to avoid unnecessary costs.

---

## Tools & Technologies
- Python
- Pandas, NumPy
- Scikit-learn
- Matplotlib

---

## Conclusion
This project demonstrates how combining RFM analysis with clustering techniques can produce actionable customer insights.  
The results can directly support data-driven marketing, retention, and customer lifetime value optimization strategies.
