-- ============================================
-- Row Count
-- ============================================

SELECT COUNT(*) FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;

-- ============================================
-- Preview Data
-- ============================================

SELECT *
FROM bronze.crm_prd_info
LIMIT 10;

-- ============================================
-- Check Primary Key
-- ============================================

SELECT
    prd_id,
    COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- ============================================
-- Extract Category
-- ============================================

SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info;

-- ============================================
-- Validate Category
-- ============================================

SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_')
NOT IN
(
    SELECT DISTINCT id
    FROM bronze.erp_px_cat_g1v2
);

-- ============================================
-- Check Spaces
-- ============================================

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- ============================================
-- Check NULL or Negative Cost
-- ============================================

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0
   OR prd_cost IS NULL;
