# Northwind Sales Analysis — Ad Hoc SQL Project

## Project Overview
An ad hoc SQL analysis of the Northwind dataset using PostgreSQL and pgAdmin4.
The goal was to answer 15 real business questions around revenue, customers,
products, employees and churn risk using advanced SQL techniques.

**Dataset:** 2 tables — `orders` and `order_details`
**Tool:** PostgreSQL (pgAdmin4)
**Type:** Ad Hoc SQL Analysis
**Total Records:** 830 orders across 21 countries

---

## Database Schema
```
orders
├── order_id (PRIMARY KEY)
├── customer_id
├── employee_id
├── order_date
├── ship_country
└── freight

order_details
├── order_id (FOREIGN KEY → orders.order_id)
├── product_id
├── unit_price
├── quantity
└── discount
```

---

## Core Revenue Formula
```sql
unit_price * quantity * (1 - discount)
```

---

## Business Questions & Key Findings

### Q1 — Which countries generate the most revenue after discounts?

| Country | Total Revenue |
|---------|--------------|
| USA | $245,584.61 |
| Germany | $230,284.63 |
| Austria | $128,003.84 |
| Brazil | $106,925.78 |
| France | $81,358.32 |

**Insight:** USA and Germany together contribute 37.59% of total revenue,
making them the two most critical markets for the business.

---

### Q2 — What is the monthly revenue trend?

| Month | Revenue |
|-------|---------|
| 1998-04 | $123,798.68 |
| 1998-03 | $104,854.16 |
| 1998-02 | $99,415.29 |
| 1998-01 | $94,222.11 |
| 1997-12 | $71,398.43 |

**Insight:** Revenue shows a strong upward trend from mid-1997 into 1998,
with April 1998 being the highest revenue month at $123,798.68.
The drop in May 1998 ($18,333.63) is due to incomplete data for that month.

---

### Q3 — Which top 10 customers generate the most revenue?

| Customer | Total Revenue |
|----------|--------------|
| QUICK | $110,277.31 |
| ERNSH | $104,874.98 |
| SAVEA | $104,361.95 |
| RATTC | $51,097.80 |
| HUNGO | $49,979.91 |

**Insight:** The top 3 customers (QUICK, ERNSH, SAVEA) alone generate
$319,514.24 — which is 25.25% of total revenue. Classic 80/20 rule in action.

---

### Q4 — What percentage of total revenue does each country contribute?

| Country | Revenue | Contribution |
|---------|---------|-------------|
| USA | $245,584.61 | 19.40% |
| Germany | $230,284.63 | 18.19% |
| Austria | $128,003.84 | 10.11% |
| Brazil | $106,925.78 | 8.45% |
| France | $81,358.32 | 6.43% |

**Insight:** Top 5 countries contribute 62.58% of total revenue,
showing high revenue concentration in a few key markets.

---

### Q5 — Top 10 most sold products by quantity and revenue?

| Product ID | Total Quantity | Total Revenue |
|------------|---------------|--------------|
| 38 | 623 | $141,396.74 |
| 29 | 746 | $80,368.67 |
| 59 | 1,496 | $71,155.70 |
| 62 | 1,083 | $47,234.97 |
| 60 | 1,577 | $46,825.48 |

**Insight:** Product 38 generates the highest revenue ($141,396.74) despite
not having the highest quantity sold. Product 60 sells the most units (1,577)
but ranks 5th in revenue — proving volume alone does not drive business value.

---

### Q6 — What is the average order value per customer?

| Customer | Total Orders | Avg Order Value |
|----------|-------------|----------------|
| QUICK | 28 | $3,938.48 |
| ERNSH | 30 | $3,495.83 |
| SAVEA | 31 | $3,366.51 |
| RATTC | 18 | $2,838.77 |
| HUNGO | 19 | $2,630.52 |

**Insight:** QUICK has the highest average order value at $3,938.48
while also being the top revenue generating customer.

---

### Q7 — Which orders had the highest discount applied?

| Order ID | Full Price | Discounted Price | Revenue Lost |
|----------|-----------|-----------------|-------------|
| 11030 | $16,321.90 | $12,615.10 | $3,706.80 |
| 10372 | $12,281.20 | $9,210.90 | $3,070.30 |
| 10424 | $11,493.20 | $9,194.60 | $2,298.60 |
| 10353 | $10,741.60 | $8,593.30 | $2,148.30 |
| 10912 | $8,267.40 | $6,200.60 | $2,066.80 |

**Insight:** Order 11030 alone lost $3,706.80 to discounts —
the highest single order revenue loss in the dataset.

---

### Q8 — What is the total revenue impact of discounts?

| Full Revenue | Discounted Revenue | Total Revenue Lost |
|-------------|-------------------|-------------------|
| $1,354,458.60 | $1,265,793.04 | $88,665.60 |

**Insight:** The business lost $88,665.60 — which is 6.54% of potential
revenue due to discounts. This represents a significant opportunity
to review discount strategy.

---

### Q9 — Which employees handle the most orders and revenue?

| Employee ID | Total Orders | Total Revenue |
|-------------|-------------|--------------|
| 4 | 156 | $232,890.85 |
| 3 | 127 | $202,812.84 |
| 1 | 123 | $192,107.60 |
| 2 | 96 | $166,537.76 |
| 8 | 104 | $126,862.28 |

**Insight:** Employee 4 leads in both order count (156 orders) and
total revenue ($232,890.85), making them the top performer by both metrics.

---

### Q10 — Average order value per employee?

| Employee ID | Avg Order Value |
|-------------|----------------|
| 9 | $1,797.86 |
| 2 | $1,734.77 |
| 7 | $1,730.11 |
| 5 | $1,637.91 |
| 3 | $1,596.95 |

**Insight:** Employee 9 has the highest average order value ($1,797.86)
despite not having the most total orders — showing quality over quantity.

---

### Q11 — Which customers are at churn risk?

Customers with no orders in the last 6 months of the dataset:

| Customer ID | Last Order Date |
|-------------|----------------|
| CENTC | 18/07/1996 |
| LAZYK | 22/05/1997 |
| FAMIA | 31/10/1997 |
| MEREP | 30/10/1997 |
| HUNGC | 08/09/1997 |

**Insight:** 5 customers have not placed an order in the last 6 months.
CENTC has been inactive since July 1996 — the longest period of inactivity.
These customers should be prioritized for re-engagement campaigns.

---

### Q12 — Month over month revenue growth rate using LAG()

| Month | Revenue | Growth Rate |
|-------|---------|------------|
| 1996-10 | $37,515.73 | +42.21% |
| 1997-12 | $71,398.43 | +64.01% |
| 1998-01 | $94,222.11 | +31.97% |
| 1997-02 | $38,483.64 | -37.18% |
| 1997-06 | $36,362.80 | -32.39% |

**Insight:** December 1997 saw the strongest growth at +64.01% MoM.
The sharpest decline was February 1997 at -37.18% suggesting
seasonal patterns in the business.

---

### Q13 — Customer rankings by revenue within each country

Customers ranked by revenue within their respective countries using
RANK() OVER(PARTITION BY ship_country).

| Customer | Country | Revenue | Rank |
|----------|---------|---------|------|
| ERNSH | Austria | $104,874.98 | 1 |
| QUICK | Germany | $110,277.31 | 1 |
| HANAR | Brazil | $32,841.37 | 1 |
| SAVEA | USA | $104,361.95 | 1 |

**Insight:** QUICK and ERNSH are the top ranked customers
in their respective countries and also the top 2 globally.

---

### Q14 — Cumulative revenue over time

| Month | Monthly Revenue | Cumulative Revenue |
|-------|----------------|-------------------|
| 1996-07 | $27,861.90 | $27,861.90 |
| 1996-12 | $45,239.63 | $208,083.97 |
| 1997-06 | $36,362.80 | $489,549.94 |
| 1997-12 | $71,398.43 | $825,169.17 |
| 1998-04 | $123,798.68 | $1,247,459.41 |
| 1998-05 | $18,333.63 | $1,265,793.04 |

**Insight:** The business crossed $1,000,000 in cumulative revenue
in February 1998 — approximately 19 months after the first order.

---

### Q15 — Customers generating above average revenue

**Average revenue per customer: $32,095.38**

| Customer | Total Revenue | vs Average |
|----------|--------------|-----------|
| QUICK | $110,277.31 | +$78,181.93 |
| ERNSH | $104,874.98 | +$72,779.60 |
| SAVEA | $104,361.95 | +$72,266.57 |
| RATTC | $51,097.80 | +$19,002.42 |
| HUNGO | $49,979.91 | +$17,884.53 |
| HANAR | $32,841.37 | +$745.99 |

**Insight:** Only 6 customers generate above average revenue.
QUICK generates 3.4x the average customer revenue.

---

## SQL Techniques Used

| Technique | Used In |
|-----------|---------|
| CTE (Common Table Expressions) | All queries |
| INNER JOIN | Q1, Q2, Q3, Q6, Q9 |
| CROSS JOIN | Q11 |
| Window Functions — SUM() OVER() | Q4, Q15 |
| Window Functions — LAG() OVER() | Q12 |
| Window Functions — RANK() OVER() | Q13 |
| Window Functions — SUM() OVER(ORDER BY) | Q14 |
| DATE_TRUNC | Q2, Q12, Q14 |
| INTERVAL | Q11 |
| COUNT(DISTINCT) | Q9 |
| ROUND with ::NUMERIC cast | All queries |

---

## Key Business Insights Summary

1. **USA and Germany** are the top 2 markets contributing 37.59% of revenue
2. **Top 3 customers** (QUICK, ERNSH, SAVEA) generate 25.25% of total revenue
3. **$88,665.60** was lost to discounts — 6.54% of potential revenue
4. **Product volume ≠ revenue** — highest selling product by quantity
   is not the highest by revenue
5. **5 customers** are at churn risk with no orders in last 6 months
6. **Business crossed $1M** in cumulative revenue in February 1998
7. **December 1997** was the strongest growth month at +64.01% MoM
8. **Only 6 customers** generate above average revenue of $32,095.38

---

## Tools Used
- PostgreSQL
- pgAdmin4

---

