# 📊 Retail Sales & Inventory Analytics

An end-to-end **Data Analyst portfolio project** that analyzes retail sales, customers, products, and inventory using **Python, Pandas, SQL Server, SQL, Power BI, and DAX**.

---

## 📌 Project Overview

This project demonstrates a complete real-world Data Analyst workflow:

**Raw Data → Data Cleaning → SQL Server → SQL Analysis → Power BI → Business Insights**

The objective is to transform raw retail data into meaningful business insights that can help management understand:

- Overall sales performance
- Revenue and profitability
- Regional performance
- Product and category performance
- Customer behavior
- Monthly sales trends
- City-level performance
- Inventory health
- Low-stock products requiring replenishment

---

# 🎯 Business Objective

The main objective of this project is to analyze retail business data and answer important business questions such as:

1. What are the total sales, cost, and profit?
2. What is the overall profit margin?
3. Which region generates the most sales?
4. Which region generates the most profit?
5. Which product category performs best?
6. Which products generate the highest sales?
7. Which products generate the highest profit?
8. Which customers generate the most revenue?
9. Which customers place the most orders?
10. Which cities generate the most sales?
11. How do sales and profit change month by month?
12. Which products are currently low in stock?
13. How many inventory records require replenishment?
14. Which regions have the highest inventory levels?

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** | Data cleaning and preprocessing |
| **Pandas** | Data manipulation and validation |
| **Google Colab** | Python development environment |
| **SQL Server** | Database creation and data storage |
| **SQL** | Data analysis and business queries |
| **Power BI** | Interactive dashboards |
| **DAX** | KPI and business calculations |

---

# 📂 Dataset

The project uses four related retail datasets:

1. **Customers**
2. **Products**
3. **Sales**
4. **Inventory**

After cleaning and loading the data into SQL Server, the database contains:

| Table | Records |
|---|---:|
| Customers | 1,000 |
| Products | 100 |
| Sales | 9,990 |
| Inventory | 400 |

---

# 🔄 End-to-End Project Workflow

```text
                 RAW RETAIL DATA
                       │
                       ▼
               Python / Pandas
                       │
                       ▼
                DATA CLEANING
                       │
                       ▼
                 CLEANED CSV
                       │
                       ▼
                  SQL SERVER
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
   Customers       Products         Sales
                                      │
                                      ▼
                                  Inventory
                       │
                       ▼
                  SQL ANALYSIS
                       │
                       ▼
                    POWER BI
                       │
                       ▼
             INTERACTIVE DASHBOARD
                       │
                       ▼
               BUSINESS INSIGHTS


## 📁 Project Structure

```text
Retail-Sales-Analytics/
│
├── 📄 README.md
│
├── 📁 data/
│   ├── cleaned_customers.csv
│   ├── cleaned_products.csv
│   ├── cleaned_sales.csv
│   └── cleaned_inventory.csv
│
├── 📁 python/
│   └── Retail_Sales_Data_Cleaning.ipynb
│
├── 📁 sql/
│   └── Retail_Sales_Analytics_Complete.sql
│
├── 📁 powerbi/
│   └── Retail_Sales_Analytics_Dashboard.pbix
│
└── 📁 screenshots/
    ├── executive_dashboard.png
    └── inventory_dashboard.png
