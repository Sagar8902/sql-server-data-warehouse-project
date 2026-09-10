/*
================================================================================
  SILVER LAYER - DATA CLEANING & TRANSFORMATION STORED PROCEDURE
================================================================================

  Project     : Data Warehouse and Analytics
  Layer       : Silver
  Procedure   : silver.load_silver

  Overview:
      This stored procedure cleans, transforms, standardizes, and loads
      data from the Bronze layer into the Silver layer.

  Purpose:
      - Truncate existing Silver layer data.
      - Clean and standardize CRM and ERP data.
      - Handle duplicate and NULL customer records.
      - Standardize names, gender, marital status, country, and product lines.
      - Validate and transform dates.
      - Calculate product end dates using LEAD().
      - Validate and correct sales and price values.
      - Load transformed data into Silver tables.

  Source Systems:
      CRM : Customer, Product, and Sales data
      ERP : Customer, Location, and Product Category data

  Loading Strategy:
      Full Load / Full Refresh
      - Existing Silver data is removed using TRUNCATE TABLE.
      - Cleaned data is loaded again from the Bronze layer.

  Transformation:
      Data is cleaned and transformed from the Bronze layer before
      being loaded into the Silver layer.

  Target Tables:
      CRM
        - silver.crm_cust_info
        - silver.crm_prd_info
        - silver.crm_sales_details

      ERP
        - silver.erp_cust_az12
        - silver.erp_loc_a101
        - silver.erp_px_cat_g1v2

  Execution:
      EXEC silver.load_silver;

================================================================================
*/


/*
================================================================================
  CREATE SILVER LOAD STORED PROCEDURE
================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    BEGIN TRY


    /*
    ============================================================================
      CRM SYSTEM
    ============================================================================
    */

    -- =========================================================================
    -- 01. CRM CUSTOMER DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.crm_cust_info
      Source Table : bronze.crm_cust_info

      Purpose:
          Clean and standardize customer information.

      Transformations:
          - Clean customer names.
          - Standardize marital status.
          - Standardize gender.
          - Remove duplicate customer IDs.
          - Remove NULL customer IDs.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver customer data
    TRUNCATE TABLE silver.crm_cust_info;


    -- Load cleaned customer data
    INSERT INTO silver.crm_cust_info
    (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )

    SELECT
        cst_id,
        cst_key,

        -- Clean customer names
        UPPER(TRIM(cst_firstname)),
        UPPER(TRIM(cst_lastname)),

        -- Standardize marital status
        CASE
            WHEN cst_marital_status = 'S' THEN 'Single'
            WHEN cst_marital_status = 'M' THEN 'Married'
            ELSE 'n/a'
        END AS cst_marital_status,

        -- Standardize gender
        CASE
            WHEN cst_gndr = 'M' THEN 'Male'
            WHEN cst_gndr = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS cst_gndr,

        cst_create_date

    FROM
    (
        -- Identify duplicate customer IDs
        SELECT *,
            ROW_NUMBER() OVER
            (
                PARTITION BY cst_id
                ORDER BY cst_create_date
            ) AS flag_column

        FROM bronze.crm_cust_info

    ) AS t

    -- Keep first record and remove NULL customer IDs
    WHERE t.flag_column = 1
        AND t.cst_id IS NOT NULL;


    /*
    ============================================================================
      CRM PRODUCT DATA
    ============================================================================
    */

    -- =========================================================================
    -- 02. CRM PRODUCT DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.crm_prd_info
      Source Table : bronze.crm_prd_info

      Purpose:
          Clean and transform product information.

      Transformations:
          - Extract product ID and product key.
          - Clean product names.
          - Replace NULL product costs.
          - Standardize product line.
          - Convert start dates to DATE.
          - Calculate product end dates.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver product data
    TRUNCATE TABLE silver.crm_prd_info;


    -- Load cleaned product data
    INSERT INTO silver.crm_prd_info(
        prd_id,
        prd_key,
        _id,
        _key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )

    SELECT
        prd_id,
        prd_key,

        -- Extract product ID and key
        REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS _id,
        SUBSTRING(prd_key,7,LEN(prd_key)) AS _key,

        -- Clean product name
        TRIM(prd_nm) AS prd_nm,

        -- Replace NULL cost with 0
        ISNULL(prd_cost,0) AS prd_cost,

        -- Standardize product line
        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,

        -- Convert start date to DATE
        CAST(prd_start_dt AS DATE) AS prd_start_dt,

        -- Calculate end date from next start date
        DATEADD(DAY,-1,
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            )
        ) AS prd_end_date

    FROM bronze.crm_prd_info;


    /*
    ============================================================================
      CRM SALES DATA
    ============================================================================
    */

    -- =========================================================================
    -- 03. CRM SALES DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.crm_sales_details
      Source Table : bronze.crm_sales_details

      Purpose:
          Clean and validate sales transaction data.

      Transformations:
          - Validate order, ship, and due dates.
          - Validate sales amounts.
          - Validate product prices.
          - Handle invalid values.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver sales data
    TRUNCATE TABLE silver.crm_sales_details;


    -- Load cleaned sales data
    INSERT INTO silver.crm_sales_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )

    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        -- Validate and convert order date
        CASE
            WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt,

        -- Validate and convert ship date
        CASE
            WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt,

        -- Validate and convert due date
        CASE
            WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt,

        -- Validate and correct sales amount
        CASE
            WHEN sls_sales IS NULL
                 OR sls_sales <= 0
                 OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,

        sls_quantity,

        -- Validate and correct product price
        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity,0)
            ELSE sls_price
        END AS sls_price

    FROM bronze.crm_sales_details;


    /*
    ============================================================================
      ERP SYSTEM
    ============================================================================
    */


    -- =========================================================================
    -- 04. ERP CUSTOMER DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.erp_cust_az12
      Source Table : bronze.erp_cust_az12

      Purpose:
          Clean and standardize ERP customer information.

      Transformations:
          - Remove NAS prefix from customer ID.
          - Remove future birth dates.
          - Standardize gender values.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver ERP customer data
    TRUNCATE TABLE silver.erp_cust_az12;


    -- Load cleaned ERP customer data
    INSERT INTO silver.erp_cust_az12(cid,bdate,gen)

    SELECT

        -- Remove NAS prefix from customer ID
        CASE
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
            ELSE cid
        END AS cid,

        -- Remove future birth dates
        CASE
            WHEN bdate > GETDATE() THEN NULL
            ELSE bdate
        END AS bdate,

        -- Standardize gender
        CASE
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a'
        END AS gen

    FROM bronze.erp_cust_az12;


    -- =========================================================================
    -- 05. ERP LOCATION DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.erp_loc_a101
      Source Table : bronze.erp_loc_a101

      Purpose:
          Clean and standardize customer location information.

      Transformations:
          - Remove '-' from customer ID.
          - Standardize country codes.
          - Handle blank and NULL country values.
          - Convert country values to uppercase.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver location data
    TRUNCATE TABLE silver.erp_loc_a101;


    -- Load cleaned ERP location data
    INSERT INTO silver.erp_loc_a101(cid,cntry)

    SELECT

        -- Remove '-' from customer ID
        REPLACE(cid,'-','') AS cid,

        -- Standardize country values
        CASE
            WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'GERMANY'
            WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'UNITED STATES'
            WHEN UPPER(TRIM(cntry)) = ''
                 OR UPPER(TRIM(cntry)) IS NULL THEN 'N/A'
            ELSE UPPER(TRIM(cntry))
        END AS cntry

    FROM bronze.erp_loc_a101;


    -- =========================================================================
    -- 06. ERP PRODUCT CATEGORY DATA
    -- =========================================================================

    /*
    ---------------------------------------------------------------------------
      Target Table : silver.erp_px_cat_g1v2
      Source Table : bronze.erp_px_cat_g1v2

      Purpose:
          Load ERP product category information into the Silver layer.

      Transformations:
          No major transformation is performed.
          Data is transferred from Bronze to Silver.
    ---------------------------------------------------------------------------
    */


    -- Clear existing Silver product category data
    TRUNCATE TABLE silver.erp_px_cat_g1v2;


    -- Load ERP product category data
    INSERT INTO silver.erp_px_cat_g1v2(
        id,
        cat,
        subcat,
        maintenance
    )

    SELECT
        id,
        cat,
        subcat,
        maintenance

    FROM bronze.erp_px_cat_g1v2;


    /*
    ============================================================================
      COMPLETED
    ============================================================================
    */

    END TRY

    BEGIN CATCH

        -- Error handling
        -- Add error handling logic here if required.

    END CATCH

END;
GO


-- ============================================================================
-- EXECUTION
-- ============================================================================
-- Run the stored procedure to load the Silver layer.

EXEC silver.load_silver;
