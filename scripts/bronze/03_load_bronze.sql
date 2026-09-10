/*
================================================================================
  BRONZE LAYER - DATA LOADING STORED PROCEDURE
================================================================================

  Project     : Data Warehouse and Analytics
  Layer       : Bronze
  Procedure   : bronze.load_bronze

  Overview:
      This stored procedure loads raw data from CRM and ERP CSV files
      into the Bronze layer of the Data Warehouse.

  Purpose:
      - Truncate existing Bronze layer data.
      - Load fresh data from source CSV files using BULK INSERT.
      - Validate loaded data using SELECT statements and row counts.
      - Handle errors using TRY...CATCH.

  Source Systems:
      CRM : Customer, Product, and Sales data
      ERP : Customer, Location, and Product Category data

  Loading Strategy:
      Full Load / Full Refresh
      - Existing data is removed using TRUNCATE TABLE.
      - Complete source data is loaded again.

  Transformation:
      No transformation is performed in the Bronze layer.
      Data is loaded as close to the source format as possible.

  Grain:
      The grain of each Bronze table remains the same as the
      corresponding source CSV file.

  Target Tables:
      CRM
        - bronze.crm_cust_info
        - bronze.crm_prd_info
        - bronze.crm_sales_details

      ERP
        - bronze.erp_cust_az12
        - bronze.erp_loc_a101
        - bronze.erp_px_cat_g1v2

================================================================================
*/


/*
================================================================================
  CREATE BRONZE LOAD STORED PROCEDURE
================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
	

	/*
	========================================================================
	  CRM SYSTEM
	========================================================================
	*/

	PRINT'=============================';
	PRINT'--INSERTING DATA OF CRM SYSTEM--';
	PRINT'=============================';


	/*
	------------------------------------------------------------------------
	  1. CRM CUSTOMER
	------------------------------------------------------------------------
	  Target Table : bronze.crm_cust_info
	  Grain        : One row per customer
	  Source File  : cust_info.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info

	PRINT'INSERTING INTO >> bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.crm_cust_info;

	SELECT COUNT(*) FROM bronze.crm_cust_info;


	/*
	------------------------------------------------------------------------
	  2. CRM PRODUCT
	------------------------------------------------------------------------
	  Target Table : bronze.crm_prd_info
	  Grain        : One row per product record
	  Source File  : prd_info.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info

	PRINT'INSERTING INTO >> bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.crm_prd_info;

	SELECT COUNT(*) FROM bronze.crm_prd_info;


	/*
	------------------------------------------------------------------------
	  3. CRM SALES
	------------------------------------------------------------------------
	  Target Table : bronze.crm_sales_details
	  Grain        : One row per sales transaction / order line
	  Source File  : sales_details.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details

	PRINT'INSERTING INTO >> bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.crm_sales_details;

	SELECT COUNT(*) FROM bronze.crm_sales_details;


	/*
	========================================================================
	  ERP SYSTEM
	========================================================================
	*/

	PRINT'=============================';
	PRINT'--INSERTING DATA OF ERP SYSTEM--';
	PRINT'=============================';


	/*
	------------------------------------------------------------------------
	  4. ERP CUSTOMER
	------------------------------------------------------------------------
	  Target Table : bronze.erp_cust_az12
	  Grain        : One row per customer
	  Source File  : cust_az12.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12

	PRINT'INSERTING INTO >> bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.erp_cust_az12;

	SELECT COUNT(*) FROM bronze.erp_cust_az12;


	/*
	------------------------------------------------------------------------
	  5. ERP LOCATION
	------------------------------------------------------------------------
	  Target Table : bronze.erp_loc_a101
	  Grain        : One row per customer location record
	  Source File  : loc_a101.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101

	PRINT'INSERTING INTO >> bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.erp_loc_a101;

	SELECT COUNT(*) FROM bronze.erp_loc_a101;


	/*
	------------------------------------------------------------------------
	  6. ERP PRODUCT CATEGORY
	------------------------------------------------------------------------
	  Target Table : bronze.erp_px_cat_g1v2
	  Grain        : One row per product category / subcategory record
	  Source File  : px_cat_g1v2.csv
	------------------------------------------------------------------------
	*/

	PRINT'TRUNCATING TABLE >> bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2

	PRINT'INSERTING INTO >> bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\# Data Project\# Data Warehouse - Barra\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SELECT * FROM bronze.erp_px_cat_g1v2;

	SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;


	/*
	========================================================================
	  LOAD COMPLETED
	========================================================================
	*/

	PRINT'=============================';
	PRINT'--BRONZE LOAD COMPLETED--';
	PRINT'=============================';


	END TRY


	/*
	========================================================================
	  ERROR HANDLING
	========================================================================
	*/

	BEGIN CATCH

		-- Error handling can be added here.

	END CATCH

END;
GO


/*
================================================================================
  EXECUTE STORED PROCEDURE
================================================================================

  Use the following command to execute the Bronze layer data load:

      EXEC bronze.load_bronze;

================================================================================
*/
