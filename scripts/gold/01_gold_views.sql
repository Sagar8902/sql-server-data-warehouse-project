/*
================================================================================
  GOLD LAYER - DIMENSION & FACT VIEWS
================================================================================

  Architecture : Medallion Architecture
  Layer        : Gold
  Purpose      : Create business-ready views for analytics and reporting.

  Gold Views:
      Dimensions:
        - gold.dim_customers
        - gold.dim_products

      Fact:
        - gold.fact_sales

  Data Flow:
      Silver Layer
          ↓
      Gold Dimension & Fact Views
          ↓
      Analytics / Reporting / Power BI

================================================================================
*/


-- ============================================================================
-- 01. CUSTOMER DIMENSION
-- ============================================================================
-- Combines CRM customer information with ERP customer and location data.

CREATE VIEW gold.dim_customers AS

SELECT 
    ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
    cc.cst_id AS customer_id,
    cc.cst_key AS customer_number,
    cc.cst_firstname AS first_name,
    cc.cst_lastname AS last_name,
    el.cntry AS country,
    cc.cst_marital_status AS marital_status,
    CASE 
        WHEN cc.cst_gndr <> 'n/a' THEN cc.cst_gndr
        ELSE COALESCE(ec.gen,'n/a') 
    END AS gender,
    ec.bdate AS birth_date,
    cc.cst_create_date AS create_date

FROM silver.crm_cust_info AS cc

LEFT JOIN silver.erp_cust_az12 AS ec
    ON cc.cst_key = ec.cid

LEFT JOIN silver.erp_loc_a101 AS el
    ON cc.cst_key = el.cid;


-- ============================================================================
-- 02. PRODUCT DIMENSION
-- ============================================================================
-- Combines CRM product information with ERP product category information.
-- Filters to keep only currently active products.

CREATE VIEW gold.dim_products AS

SELECT
    ROW_NUMBER() OVER(ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key,
    cp.prd_id AS product_id,
    cp.prd_key AS product_number,
    cp.prd_nm AS product_name,
    cp._id AS category_id,
    cp._key AS category_number,
    ep.cat AS category,
    ep.subcat AS subcategory,
    ep.maintenance,
    cp.prd_cost AS product_cost,
    cp.prd_line AS product_line,
    cp.prd_start_dt AS start_date

FROM silver.crm_prd_info AS cp

LEFT JOIN silver.erp_px_cat_g1v2 AS ep
    ON cp._id = ep.id

WHERE cp.prd_end_dt IS NULL;


-- ============================================================================
-- 03. SALES FACT
-- ============================================================================
-- Combines sales transactions with Customer and Product dimensions.
-- Provides the central fact table for sales analysis.

CREATE VIEW gold.fact_sales AS

SELECT 
    sls_ord_num AS order_number,
    dp.product_key AS product_key,
    dc.customer_key AS customer_key,
    sls_order_dt AS order_date,
    sls_ship_dt AS shipping_date,
    sls_due_dt AS due_date,
    sls_sales AS sales_amount,
    sls_quantity AS quantity,
    sls_price AS price

FROM silver.crm_sales_details AS cs

LEFT JOIN gold.dim_customers AS dc
    ON cs.sls_cust_id = dc.customer_id

LEFT JOIN gold.dim_products AS dp
    ON cs.sls_prd_key = dp.category_number;
