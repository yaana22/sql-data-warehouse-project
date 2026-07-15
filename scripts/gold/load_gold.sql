/*
===========================================================
Load Gold Layer
===========================================================
*/

-- ===========================================
-- Customer Dimension
-- ===========================================

CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.cst_id) AS customer_key,
    c.cst_id AS customer_id,
    c.cst_key AS customer_number,
    c.cst_firstname AS first_name,
    c.cst_lastname AS last_name,
    c.cst_material_status AS marital_status,
    c.cst_gender AS gender,
    e.bdate AS birth_date,
    l.cntry AS country
FROM silver.crm_cust_info c
LEFT JOIN silver.erp_cust_az12 e
    ON c.cst_key = e.cid
LEFT JOIN silver.erp_loc_a101 l
    ON c.cst_key = l.cid;

-- ===========================================
-- Product Dimension
-- ===========================================

CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,
    prd_id AS product_id,
    prd_key AS product_number,
    prd_nm AS product_name,
    prd_cost AS cost,
    prd_line AS product_line,
    prd_start_dt AS start_date
FROM silver.crm_prd_info
WHERE prd_end_dt IS NULL;

-- ===========================================
-- Sales Fact
-- ===========================================

CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    s.sls_ord_num AS order_number,
    c.customer_key,
    p.product_key,
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS shipping_date,
    s.sls_due_dt AS due_date,
    s.sls_sales AS sales_amount,
    s.sls_quantity AS quantity,
    s.sls_price AS price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_customers c
    ON s.sls_cust_id = c.customer_id
LEFT JOIN gold.dim_products p
    ON s.sls_prd_key = p.product_number;
