# 🚀 Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository!

This project demonstrates an **end-to-end data warehousing and analytics solution using SQL Server**, covering data ingestion, data cleansing, transformation, dimensional modeling, and analytical reporting.

The project follows the **Medallion Architecture** approach with **Bronze, Silver, and Gold layers** and is designed as a portfolio project to demonstrate practical **Data Engineering, SQL Development, ETL, Data Modeling, and Data Analytics** skills.

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**, consisting of three layers:

![Data Architecture](docs/data_architecture.png)

### 🥉 Bronze Layer

The Bronze layer stores **raw data exactly as received from the source systems**.

* Data is loaded from CSV files.
* Minimal transformations are applied.
* Acts as the initial landing/staging area.
* Source systems include **ERP and CRM datasets**.

### 🥈 Silver Layer

The Silver layer contains **cleaned, standardized, and transformed data**.

Key activities include:

* Data cleansing
* Handling missing and invalid values
* Data type standardization
* Removing duplicates
* Data validation
* Integrating ERP and CRM data

### 🥇 Gold Layer

The Gold layer contains **business-ready data** optimized for analytics and reporting.

* Dimensional modeling
* Fact and dimension tables
* Star schema
* Business-friendly data structures
* Analytics-ready datasets

---

## 🔄 Data Flow

The following diagram shows how data moves through the different stages of the warehouse.

![Data Flow](docs/data_flow.png)
![Data Model](docs/data_model.png)


![Data Catelog](data_catelog.md)



```text
ERP CSV Files ──┐
                ├──> Bronze ──> Silver ──> Gold ──> Analytics
CRM CSV Files ──┘
