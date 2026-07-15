/*
===============================================================================
Script: Load Silver Layer (Bronze -> Silver)
===============================================================================

Purpose:
    Load cleaned and standardized data from Bronze into Silver.

Actions:
    - Truncate Silver tables
    - Remove duplicates
    - Trim unwanted spaces
    - Standardize values
    - Handle NULL values
    - Load cleaned data

===============================================================================
*/

BEGIN;

-- ============================================================
-- Load CRM Customer Information
-- ============================================================

TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info
(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_material_status,
    cst_gender,
    cst_create_date
)

SELECT
    cst_id,
    TRIM(cst_key),
    TRIM(cst_firstname),
    TRIM(cst_lastname),

    CASE
        WHEN UPPER(TRIM(cst_material_status))='S' THEN 'Single'
        WHEN UPPER(TRIM(cst_material_status))='M' THEN 'Married'
        ELSE 'Unknown'
    END,

    CASE
        WHEN UPPER(TRIM(cst_gender)) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(TRIM(cst_gender)) IN ('F','FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END,

    cst_create_date

FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
             PARTITION BY cst_id
             ORDER BY cst_create_date DESC
           ) rn
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t

WHERE rn=1;

-- ============================================================
-- Load Product Information
-- ============================================================

TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info
SELECT
    prd_id,
    TRIM(prd_key),
    TRIM(prd_nm),
    COALESCE(prd_cost,0),
    UPPER(TRIM(prd_line)),
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_id IS NOT NULL;

-- ============================================================
-- Load Sales Information
-- ============================================================

TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    GREATEST(sls_sales,0),
    GREATEST(sls_quantity,0),
    GREATEST(sls_price,0)
FROM bronze.crm_sales_details;

-- ============================================================
-- Load ERP Customer
-- ============================================================

TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12
SELECT
    cid,
    bdate,
    CASE
        WHEN UPPER(gen) IN ('M','MALE') THEN 'Male'
        WHEN UPPER(gen) IN ('F','FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END
FROM bronze.erp_cust_az12;

-- ============================================================
-- Load ERP Location
-- ============================================================

TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101
SELECT
    cid,
    TRIM(cntry)
FROM bronze.erp_loc_a101;

-- ============================================================
-- Load ERP Product Category
-- ============================================================

TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2
SELECT
    id,
    TRIM(cat),
    TRIM(subcat),
    TRIM(maintenance)
FROM bronze.erp_px_cat_g1v2;

COMMIT;
