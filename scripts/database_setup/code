/*
================================================================================
  DATA WAREHOUSE DATABASE SETUP
================================================================================
  Project : Data Warehouse and Analytics
  Purpose : Create the DataWarehouse database and define the Medallion
            Architecture using Bronze, Silver, and Gold schemas.

  Architecture:
      Bronze  →  Raw / Staging Data
      Silver  →  Cleaned / Transformed Data
      Gold    →  Business-Ready / Analytics Data

  Grain:
      Database-level setup. No fact or dimension tables are created in
      this script.

================================================================================
*/


/*
================================================================================
  1. CREATE DATABASE
================================================================================
*/

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO


/*
================================================================================
  2. CREATE SCHEMAS
================================================================================
*/

-- Bronze Layer
-- Purpose: Store raw data as received from source systems.
CREATE SCHEMA bronze;
GO


-- Silver Layer
-- Purpose: Store cleaned, standardized, and transformed data.
CREATE SCHEMA silver;
GO


-- Gold Layer
-- Purpose: Store business-ready dimensional and fact models
--          used for reporting and analytics.
CREATE SCHEMA gold;
GO


/*
================================================================================
  3. VERIFY SCHEMAS
================================================================================
*/

SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name IN ('bronze', 'silver', 'gold')
ORDER BY name;
GO
