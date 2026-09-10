/*
================================================================================
  SILVER LAYER - TABLE DEFINITIONS
================================================================================
  Project : Data Warehouse and Analytics
  Layer   : Silver

  Purpose:
      Create the Silver layer tables used to store raw data from CRM and ERP
      source systems.

  Silver Layer Principle:
      - Store data as close to the source as possible.
      - Minimal transformation is performed at this stage.
      - Preserve source-level columns and data structure.
      - Tables are used as the starting point for Silver layer transformations.

  Source Systems:
      CRM : Customer, Product, and Sales data
      ERP : Customer demographic, Location, and Product category data

  Grain:
      Each table represents one row from its corresponding source system.
      Detailed grain is documented before each table definition.

================================================================================
*/


/*
================================================================================
  1. CRM CUSTOMER
================================================================================
  Table : silver.crm_cust_info

  Source : CRM
  Grain  : One row per customer.

  Description:
      Stores raw customer master data received from the CRM source system.
================================================================================
*/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info
(
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


/*
================================================================================
  2. CRM PRODUCT
================================================================================
  Table : silver.crm_prd_info

  Source : CRM
  Grain  : One row per product record.

  Description:
      Stores raw product master data received from the CRM source system.
================================================================================
*/

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info
(
    prd_id          INT,
    prd_key         NVARCHAR(50),
    _id         NVARCHAR(50),
    _key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


/*
================================================================================
  3. CRM SALES
================================================================================
  Table : silver.crm_sales_details

  Source : CRM
  Grain  : One row per sales transaction / order line.

  Description:
      Stores raw sales transaction data received from the CRM source system.

  Measures:
      sls_sales
      sls_quantity
      sls_price
================================================================================
*/

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


/*
================================================================================
  4. ERP CUSTOMER
================================================================================
  Table : silver.erp_cust_az12

  Source : ERP
  Grain  : One row per customer.

  Description:
      Stores raw customer demographic information received from the ERP
      source system.
================================================================================
*/

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12
(
    cid     NVARCHAR(20),
    bdate   DATE,
    gen     NVARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


/*
================================================================================
  5. ERP LOCATION
================================================================================
  Table : silver.erp_loc_a101

  Source : ERP
  Grain  : One row per customer location record.

  Description:
      Stores raw customer country/location information received from the
      ERP source system.
================================================================================
*/

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101
(
    cid     NVARCHAR(20),
    cntry   NVARCHAR(20),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


/*
================================================================================
  6. ERP PRODUCT CATEGORY
================================================================================
  Table : silver.erp_px_cat_g1v2

  Source : ERP
  Grain  : One row per product category/subcategory record.

  Description:
      Stores raw product category, subcategory, and maintenance information
      received from the ERP source system.
================================================================================
*/

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2
(
    id          NVARCHAR(10),
    cat         NVARCHAR(20),
    subcat      NVARCHAR(20),
    maintenance NVARCHAR(5),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
