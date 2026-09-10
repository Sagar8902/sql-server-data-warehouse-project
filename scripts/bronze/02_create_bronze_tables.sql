/*
================================================================================
  BRONZE LAYER - TABLE DEFINITIONS
================================================================================
  Project : Data Warehouse and Analytics
  Layer   : Bronze

  Purpose:
      Create the Bronze layer tables used to store raw data from CRM and ERP
      source systems.

  Bronze Layer Principle:
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
  Table : bronze.crm_cust_info

  Source : CRM
  Grain  : One row per customer.

  Description:
      Stores raw customer master data received from the CRM source system.
================================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info
(
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
GO


/*
================================================================================
  2. CRM PRODUCT
================================================================================
  Table : bronze.crm_prd_info

  Source : CRM
  Grain  : One row per product record.

  Description:
      Stores raw product master data received from the CRM source system.
================================================================================
*/

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info
(
    prd_id          INT,
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE
);
GO


/*
================================================================================
  3. CRM SALES
================================================================================
  Table : bronze.crm_sales_details

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

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    INT,
    sls_ship_dt     INT,
    sls_due_dt      INT,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT
);
GO


/*
================================================================================
  4. ERP CUSTOMER
================================================================================
  Table : bronze.erp_cust_az12

  Source : ERP
  Grain  : One row per customer.

  Description:
      Stores raw customer demographic information received from the ERP
      source system.
================================================================================
*/

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12
(
    cid     NVARCHAR(20),
    bdate   DATE,
    gen     NVARCHAR(10)
);
GO


/*
================================================================================
  5. ERP LOCATION
================================================================================
  Table : bronze.erp_loc_a101

  Source : ERP
  Grain  : One row per customer location record.

  Description:
      Stores raw customer country/location information received from the
      ERP source system.
================================================================================
*/

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101
(
    cid     NVARCHAR(20),
    cntry   NVARCHAR(20)
);
GO


/*
================================================================================
  6. ERP PRODUCT CATEGORY
================================================================================
  Table : bronze.erp_px_cat_g1v2

  Source : ERP
  Grain  : One row per product category/subcategory record.

  Description:
      Stores raw product category, subcategory, and maintenance information
      received from the ERP source system.
================================================================================
*/

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2
(
    id          NVARCHAR(10),
    cat         NVARCHAR(20),
    subcat      NVARCHAR(20),
    maintenance NVARCHAR(5)
);
GO
