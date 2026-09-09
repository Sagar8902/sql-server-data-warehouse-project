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

## 📖 Project Overview

This project covers the following key areas:

### 1. 🏛️ Data Architecture

Design and implementation of a modern data warehouse using the **Bronze, Silver, and Gold Medallion Architecture**.

### 2. 🔄 ETL / ELT Pipelines

Build SQL-based data pipelines to:

* Extract data from source CSV files
* Load raw data into the Bronze layer
* Clean and transform data in the Silver layer
* Create business-ready datasets in the Gold layer

### 3. 🧩 Data Modeling

Design analytical data models using:

* Fact tables
* Dimension tables
* Surrogate keys
* Star schema
* Appropriate measures and dimension attributes

### 4. 📊 Analytics & Reporting

Develop SQL-based analytical queries to generate insights into:

* Customer behavior
* Product performance
* Sales trends
* Revenue and sales metrics

---

## 🎯 Skills Demonstrated

This project demonstrates practical experience in:

* **SQL Server**
* **SQL Development**
* **Data Engineering**
* **ETL / ELT**
* **Data Warehousing**
* **Medallion Architecture**
* **Data Cleaning & Transformation**
* **Dimensional Modeling**
* **Star Schema**
* **Fact & Dimension Tables**
* **Stored Procedures**
* **Data Quality & Validation**
* **Data Analytics**

---

# 🚀 Project Requirements

## 🏗️ Building the Data Warehouse

### Objective

Develop a modern **SQL Server data warehouse** to consolidate sales-related data from multiple source systems and provide a reliable foundation for analytical reporting and business decision-making.

### Specifications

#### 📂 Data Sources

Import data from two source systems:

* **ERP**
* **CRM**

The source data is provided as **CSV files**.

#### 🧹 Data Quality

Identify and resolve data quality issues before the data is used for analytics.

This includes:

* Missing values
* Invalid values
* Duplicate records
* Inconsistent formats
* Incorrect data types
* Data standardization

#### 🔗 Data Integration

Integrate data from the ERP and CRM systems into a **single, user-friendly analytical data model**.

#### 📅 Data Scope

The project focuses on the **latest available dataset**.

Historical data tracking and historization are **not required** for this project.

#### 📚 Documentation

Provide clear documentation covering:

* Data architecture
* Data flow
* Data models
* Data catalog
* Naming conventions
* ETL processes

This documentation helps both **business stakeholders and analytics teams** understand and use the data warehouse effectively.

---

# 📊 BI: Analytics & Reporting

## Objective

Develop SQL-based analytical queries and reports to provide meaningful business insights into:

### 👥 Customer Behavior

Analyze customer activity, purchasing behavior, and sales contribution.

### 📦 Product Performance

Evaluate product sales, performance, and revenue contribution.

### 📈 Sales Trends

Analyze sales performance and identify trends across different time periods.

These insights help stakeholders understand business performance and support **data-driven decision-making**.

For detailed requirements, refer to:

`docs/requirements.md`

---

# 📂 Repository Structure

```text
data-warehouse-project/
│
├── datasets/                           # Raw ERP and CRM datasets
│
├── docs/                               # Project documentation
│   ├── etl.drawio                      # ETL process diagram
│   ├── data_architecture.drawio        # Overall data architecture
│   ├── data_catalog.md                 # Dataset and column documentation
│   ├── data_flow.drawio                # Data flow diagram
│   ├── data_models.drawio              # Data models and star schema
│   ├── naming-conventions.md           # Naming conventions
│   └── requirements.md                 # Project requirements
│
├── scripts/                            # SQL scripts
│   ├── bronze/                         # Bronze layer ingestion scripts
│   ├── silver/                         # Silver layer transformation scripts
│   └── gold/                           # Gold layer analytical model scripts
│
├── tests/                              # Data quality and validation tests
│
├── README.md                           # Project documentation
├── LICENSE                             # MIT License
├── .gitignore                          # Git ignore configuration
└── requirements.txt                    # Project dependencies
```

---

# 🔄 Data Flow

The overall data flow of the project is:

```text
ERP CSV Files ──┐
                ├──> Bronze ──> Silver ──> Gold ──> Analytics
CRM CSV Files ──┘
```

### Bronze

**Raw → Load**

Source data is loaded into SQL Server with minimal changes.

### Silver

**Clean → Standardize → Transform**

Data quality issues are resolved and the datasets are integrated.

### Gold

**Model → Aggregate → Analyze**

Clean data is transformed into analytical fact and dimension tables using a **star schema**.

---

# 🧪 Data Quality & Testing

Data quality checks are performed to ensure that the warehouse contains reliable and consistent data.

Examples include:

* Null value checks
* Duplicate checks
* Data type validation
* Referential integrity checks
* Invalid value checks
* Business rule validation
* Fact and dimension relationship validation

---

# 🛠️ Technologies Used

| Technology                              | Purpose                                 |
| --------------------------------------- | --------------------------------------- |
| **SQL Server**                          | Data warehouse and database             |
| **T-SQL**                               | Data transformation and analytics       |
| **SQL Server Management Studio (SSMS)** | Database development and management     |
| **CSV**                                 | Source data                             |
| **Draw.io**                             | Architecture and data modeling diagrams |
| **Git & GitHub**                        | Version control and project management  |

---

# 🛡️ License

This project is licensed under the **MIT License**.

You are free to use, modify, and share this project with proper attribution.

---

# 👨‍💻 About Me

Hi there! I'm **Sagar Soni**, an IT professional passionate about **data engineering, data analytics, and working with data**.

I'm continuously learning and building practical projects around:

* SQL
* Data Engineering
* Data Warehousing
* ETL / ELT
* Data Analytics
* Python
* Power BI

Thanks for visiting this project! ⭐

If you find this project useful, feel free to **star ⭐ the repository** and explore the project files.

---

## 🤝 Let's Connect

Feel free to connect with me and follow my journey as I continue learning and building projects in the data field.
