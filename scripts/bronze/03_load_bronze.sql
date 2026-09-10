/*
================================================================================
  BRONZE LAYER - DATA LOADING
================================================================================
  Project     : Data Warehouse and Analytics
  Layer       : Bronze
  Script      : Load Bronze Tables
  Procedure   : bronze.load_bronze

  Purpose:
      Load raw data from CRM and ERP CSV source files into the Bronze layer.

  ETL Process:
      1. Truncate existing Bronze table data.
      2. Bulk load fresh data from CSV files.
      3. Display loaded data for validation.
      4. Display row counts for basic load verification.
      5. Handle and report errors using TRY...CATCH.

  Data Sources:
      CRM
        - cust_info.csv
        - prd_info.csv
        - sales_details.csv

      ERP
        - cust_az12.csv
        - loc_a101.csv
        - px_cat_g1v2.csv

  Grain:
      The procedure loads data at the same grain as the source CSV files.
      No transformation or aggregation is performed in the Bronze layer.

  Loading Strategy:
      Full Refresh
        - Existing data is truncated.
        - Complete source data is loaded again.

  Execution:
      EXEC bronze.load_bronze;

================================================================================
*/


/*
================================================================================
  CREATE STORED PROCEDURE
================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    BEGIN TRY

        /*
        ============================================================================
          CRM SYSTEM
        ============================================================================
        */

        PRINT '=============================================';
        PRINT '        LOADING CRM DATA INTO BRONZE        ';
        PRINT '=============================================';


        /*
        ------------------------------------------------------------------------
          1. CRM CUSTOMER
        ------------------------------------------------------------------------
          Target : bronze.crm_cust_info
          Grain  : One row per customer
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;


        PRINT 'INSERTING DATA >> bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.crm_cust_info';

        SELECT COUNT(*) AS RowCount
        FROM bronze.crm_cust_info;


        /*
        ------------------------------------------------------------------------
          2. CRM PRODUCT
        ------------------------------------------------------------------------
          Target : bronze.crm_prd_info
          Grain  : One row per product record
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;


        PRINT 'INSERTING DATA >> bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.crm_prd_info';

        SELECT COUNT(*) AS RowCount
        FROM bronze.crm_prd_info;


        /*
        ------------------------------------------------------------------------
          3. CRM SALES
        ------------------------------------------------------------------------
          Target : bronze.crm_sales_details
          Grain  : One row per sales transaction / order line
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;


        PRINT 'INSERTING DATA >> bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.crm_sales_details';

        SELECT COUNT(*) AS RowCount
        FROM bronze.crm_sales_details;


        /*
        ============================================================================
          ERP SYSTEM
        ============================================================================
        */

        PRINT '=============================================';
        PRINT '        LOADING ERP DATA INTO BRONZE        ';
        PRINT '=============================================';


        /*
        ------------------------------------------------------------------------
          4. ERP CUSTOMER
        ------------------------------------------------------------------------
          Target : bronze.erp_cust_az12
          Grain  : One row per customer
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.erp_cust_az12';

        TRUNCATE TABLE bronze.erp_cust_az12;


        PRINT 'INSERTING DATA >> bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\cust_az12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.erp_cust_az12';

        SELECT COUNT(*) AS RowCount
        FROM bronze.erp_cust_az12;


        /*
        ------------------------------------------------------------------------
          5. ERP LOCATION
        ------------------------------------------------------------------------
          Target : bronze.erp_loc_a101
          Grain  : One row per customer location record
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.erp_loc_a101';

        TRUNCATE TABLE bronze.erp_loc_a101;


        PRINT 'INSERTING DATA >> bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\loc_a101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.erp_loc_a101';

        SELECT COUNT(*) AS RowCount
        FROM bronze.erp_loc_a101;


        /*
        ------------------------------------------------------------------------
          6. ERP PRODUCT CATEGORY
        ------------------------------------------------------------------------
          Target : bronze.erp_px_cat_g1v2
          Grain  : One row per product category/subcategory record
        ------------------------------------------------------------------------
        */

        PRINT 'TRUNCATING TABLE >> bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;


        PRINT 'INSERTING DATA >> bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\px_cat_g1v2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );


        PRINT 'ROWS LOADED >> bronze.erp_px_cat_g1v2';

        SELECT COUNT(*) AS RowCount
        FROM bronze.erp_px_cat_g1v2;


        /*
        ============================================================================
          LOAD COMPLETED
        ============================================================================
        */

        PRINT '=============================================';
        PRINT '       BRONZE LOAD COMPLETED SUCCESSFULLY   ';
        PRINT '=============================================';


    END TRY


    /*
    ============================================================================
      ERROR HANDLING
    ============================================================================
    */

    BEGIN CATCH

        PRINT '=============================================';
        PRINT '              BRONZE LOAD FAILED            ';
        PRINT '=============================================';

        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'ERROR LINE   : ' + CAST(ERROR_LINE() AS NVARCHAR(10));

        THROW;

    END CATCH

END;
GO


/*
================================================================================
  EXECUTE STORED PROCEDURE
================================================================================

  Run the following command to load all CRM and ERP source data
  into the Bronze layer.

================================================================================
*/

EXEC bronze.load_bronze;
