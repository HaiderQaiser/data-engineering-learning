# Food Delivery Database Analysis

A comprehensive SQL-based analytical project built on Microsoft SQL Server to model, query, and derive business insights from an end-to-end food delivery platform database.

---

## 1. Project Overview
This project models an operational food delivery platform ecosystem. It covers database schema setup, relational constraint enforcement, transactional data insertion, and deep analytical querying across revenue metrics, branch performance, category trends, customer behavior, and delivery operations.

The objective is to translate raw transactional data into actionable business intelligence using structured SQL techniques.

---

## 2. Business Scenario
The platform operates as a multi-restaurant food ordering aggregator. Key operational flows include:
- **Customers** place orders containing multiple items from specific restaurant **Branches**.
- **Orders** transition through lifecycle states (`Pending`, `Preparing`, `Out for Delivery`, `Delivered`, `Cancelled`).
- **Deliveries** are assigned to **Riders** tracking dispatch and completion timestamps.
- **Revenue** is evaluated strictly on `Delivered` orders using flat discount structures: `(quantity * price) - discount`.

---

## 3. Entity Relationship Diagram (ERD)

![Food Delivery ERD](assets/Food%20Delivery%20Database%20%28ERD%29.png)

---

## 4. Database Schema
The database (`food_delivery_db`) consists of **12 core relational tables**:

- **Core Entities**: `customers`, `restaurants`, `branches`, `riders`, `categories`
- **Catalog Entities**: `menu_items`, `branch_menu_items`
- **Transactional Entities**: `orders`, `order_items`, `payments`, `deliveries`
- **Feedback Entities**: `reviews`

---

## 5. Key Schema & Design Decisions
1. **Historical Item Pricing in Line Items**: `order_items` stores historical item unit prices and flat item-level discounts directly to preserve snapshot integrity against future menu price updates.
2. **Branch-Menu Availability**: `branch_menu_items` acts as a junction table defining localized item availability across branches, decoupling global catalog definitions from branch inventory.
3. **Strict Revenue Recognition**: Net platform revenue is calculated exclusively for completed orders (`order_status = 'Delivered'`). Unfulfilled or cancelled orders are excluded from total financial metrics.
4. **Primary Key - Foreign Key Integrity**: Explicit foreign key cascades and constraints are defined to prevent orphan transactional records (e.g., line items without valid parent orders).

---

## 6. Project Structure

```text
02-Food-Delivery-Database/
├── assets/
│   ├── Food Delivery Database (ERD).png
│   └── Food Delivery Database (ERD).pdf
├── database/
│   ├── 01-schema.sql
│   ├── 02-constraints.sql
│   └── 03-seed-data.sql
├── analysis/
│   ├── 01-data-exploration.sql
│   ├── 02-order-and-revenue-analysis.sql
│   ├── 03-restaurant-and-branch-performance.sql
│   ├── 04-menu-and-category-performance.sql
│   ├── 05-customer-analysis.sql
│   └── 06-delivery-and-fulfillment-analysis.sql
└── README.md


## 7. Analysis Coverage & Module Summary

The analytical phase comprises **14 core queries** structured across 6 dedicated domain modules:

| Module File | Business Domain Covered | Key SQL Techniques Used |
| :--- | :--- | :--- |
| `01-data-exploration.sql` | Record counts, table inspection, null checks | Basic Aggregations, Table Joins |
| `02-order-and-revenue-analysis.sql` | Gross/Net Revenue, AOV, Monthly Growth & Cancellation Rates | Conditional Aggregations (`CASE WHEN`), Division Safeguards (`NULLIF`) |
| `03-restaurant-and-branch-performance.sql` | Branch Revenue Leaderboards & Branch Cancellation Metrics | Multi-Table Joins, Grouped Aggregations, `COALESCE` |
| `04-menu-and-category-performance.sql` | Category Revenue Share & Top-Selling Items Ranking | CTEs, Window Functions (`DENSE_RANK`, `SUM() OVER()`) |
| `05-customer-analysis.sql` | Top Spending Customers & Repeat Customer Rate (%) | Subqueries/CTEs, Customer Segmentation Aggregations |
| `06-delivery-and-fulfillment-analysis.sql` | Rider Speed Performance & Platform Late Delivery Rate (%) | Date Functions (`DATEDIFF`), Conditional Ratios |

---

## 8. Key Analytical Insights
- **Revenue Recognition**: Net platform revenue reflects flat discounts subtracted per item line (`(quantity * price) - discount`) on confirmed deliveries.
- **Repeat Order Engagement**: Customer retention metrics evaluate distinct customer repeat purchase velocity (`orders > 1`).
- **Fulfillment Operations**: Delivery durations measure time deltas (`DATEDIFF`) between rider pickup (`picked_up_at`) and final arrival (`delivered_at`) against target fulfillment windows.

---

## 9. How to Run & Execute

### Prerequisites
- Microsoft SQL Server Management Studio (SSMS) or Azure Data Studio.

### Step 1: Initialize Database & Schema
Open and execute the database scripts in sequence:
1. Execute `database/01-schema.sql` (Creates `food_delivery_db` and core tables).
2. Execute `database/02-constraints.sql` (Applies Primary/Foreign keys and index constraints).
3. Execute `database/03-seed-data.sql` (Populates transactional sample data).

### Step 2: Run Analytical Modules
Execute any analytical script from the `analysis/` folder independently:
```sql
USE food_delivery_db;
GO

-- Example: Execute Analysis File
-- Run scripts inside analysis/01 through analysis/06

## 10. Technical Skills Demonstrated
- **DDL & DML Control**: Schema design, data type selection, relational constraints, primary/foreign key cascading.
- **Advanced Querying**: Window Functions (`DENSE_RANK`, `SUM() OVER()`), Common Table Expressions (CTEs), Subqueries.
- **Business Logic Integration**: Conditional aggregation (`CASE WHEN`), Division-by-Zero handling (`NULLIF`), Handling missing data (`COALESCE`).
- **Data Engineering Practices**: Modular project layout, Git version control, structured milestone commits.

---

## 11. Future Scope & Improvements
- Add automated ETL pipelines (using Python/Pandas) to ingest raw CSV order data directly into SQL Server.
- Implement Stored Procedures and Views for frequently executed executive dashboard metrics.
- Extend schema to support dynamic percentage-based promotional coupon codes alongside flat item discounts.