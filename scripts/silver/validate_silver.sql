/*
===============================================================================
Script: Validate Silver Layer
===============================================================================

Purpose:
This script validates the quality and integrity of data in the Silver layer
after the ETL process (Bronze -> Silver).

Validation Checks:
    - Row Count
    - Duplicate Primary Keys
    - NULL Primary Keys
    - Invalid Values
    - Negative Numeric Values
    - Standardized Data
    - Date Validation

Source Schema : silver

Execution:
Run this script after executing load_silver.sql

===============================================================================
*/

-- ============================================================================
-- CRM CUSTOMER INFORMATION
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_customers
FROM silver.crm_cust_info;

-- Duplicate Customer IDs
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- NULL Customer IDs
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

-- Check Gender Values
SELECT DISTINCT cst_gender
FROM silver.crm_cust_info
ORDER BY cst_gender;

-- Check Marital Status
SELECT DISTINCT cst_material_status
FROM silver.crm_cust_info
ORDER BY cst_material_status;

-- Check Leading / Trailing Spaces
SELECT *
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname)
   OR cst_lastname <> TRIM(cst_lastname);



-- ============================================================================
-- CRM PRODUCT INFORMATION
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_products
FROM silver.crm_prd_info;

-- Duplicate Product IDs
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- NULL Product IDs
SELECT *
FROM silver.crm_prd_info
WHERE prd_id IS NULL;

-- Negative Product Cost
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- Product Line Values
SELECT DISTINCT prd_line
FROM silver.crm_prd_info
ORDER BY prd_line;

-- Check Product Name Spaces
SELECT *
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);



-- ============================================================================
-- CRM SALES DETAILS
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_sales
FROM silver.crm_sales_details;

-- NULL Customer IDs
SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL;

-- Negative Sales Amount
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales < 0;

-- Negative Quantity
SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity < 0;

-- Negative Price
SELECT *
FROM silver.crm_sales_details
WHERE sls_price < 0;



-- ============================================================================
-- ERP CUSTOMER
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_customers
FROM silver.erp_cust_az12;

-- Gender Values
SELECT DISTINCT gen
FROM silver.erp_cust_az12
ORDER BY gen;

-- NULL Customer IDs
SELECT *
FROM silver.erp_cust_az12
WHERE cid IS NULL;



-- ============================================================================
-- ERP LOCATION
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_locations
FROM silver.erp_loc_a101;

-- Country Values
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- NULL Customer IDs
SELECT *
FROM silver.erp_loc_a101
WHERE cid IS NULL;



-- ============================================================================
-- ERP PRODUCT CATEGORY
-- ============================================================================

-- Row Count
SELECT COUNT(*) AS total_categories
FROM silver.erp_px_cat_g1v2;

-- Category Values
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2
ORDER BY cat;

-- Subcategory Values
SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2
ORDER BY subcat;

-- NULL Category IDs
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;



-- ============================================================================
-- VALIDATION SUMMARY
-- ============================================================================

SELECT 'Silver Layer Validation Completed Successfully' AS status;
