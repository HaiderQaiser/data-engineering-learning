# 🚗 Classic Vehicle Sales Analysis (SQL Portfolio Project)

## 📌 Project Overview
This project performs an end-to-end analytical breakdown of historical vehicle sales, customer behavior, product line performance, and sales representative output using Microsoft SQL Server Management Studio (SSMS) on the **ClassicModels** database.

The objective is to translate transactional database records into actionable business intelligence to support decision-making across inventory management, high-value customer retentions, and revenue optimizations.

---

## 🛠️ Tech Stack & Concepts Used
* **Database Management:** SQL Server Management Studio (SSMS) / T-SQL
* **SQL Core Concepts:**
  * Baseline Aggregations (`COUNT`, `SUM`, `AVG`)
  * Data Filtering & Grouping (`GROUP BY`, `HAVING`)
  * Table Relationships & Joins (`INNER JOIN`, `LEFT JOIN`)
  * Common Table Expressions (`WITH` CTEs)
  * Advanced Window Functions (`DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)`)

---

## 📁 Repository Structure
```text
01-Classic-Vehicle-Sales-Analysis/
│
├── README.md                           <-- Project Documentation
│
├── sql/                                 <-- Analytical SQL Query Scripts
│   ├── 01-data-exploration.sql          <-- Baseline counts, sample records, order statuses
│   ├── 02-sales-analytics.sql           <-- Revenue metrics, top products, AOV, product line sales
│   └── 03-customer-employee-cte.sql     <-- Rep-customer mapping, CTEs, ranking analysis
│
└── screenshots/                        <-- Execution outputs & visual proof
    ├── 01-order-status-breakdown.png
    ├── 02-top-revenue-products.png
    ├── 02-product-line-performance.png
    ├── 03-top-customers-cte.png
    └── 03-customer-ranking-per-sales-rep.png