CREATE OR REPLACE TABLE kimia_farma.tbl_analisa AS
SELECT
    transaction_id, date, branch_id,branch_name, kota, provinsi, rating_cabang, customer_name, product_id, product_category, actual_price, discount_percentage,
    persentase_gross_laba, nett_sales, (actual_price * persentase_gross_laba) - (actual_price - nett_sales) AS nett_profit, rating_transaksi,year,month
FROM (
    SELECT
        ft.transaction_id, ft.date, kc.branch_id,kc.branch_name, kc.kota, kc.provinsi,
        kc.rating AS rating_cabang, ft.customer_name, p.product_id,
        p.product_name, p.product_category, p.price AS actual_price,ft.discount_percentage,
        (CASE
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            WHEN p.price > 500000 THEN 0.30
        END) AS persentase_gross_laba,
        p.price - (p.price * ft.discount_percentage) AS nett_sales,
        ft.rating AS rating_transaksi,
        EXTRACT(YEAR FROM ft.date) AS year,
        EXTRACT(MONTH FROM ft.date) AS month
    FROM
        kimia_farma.kf_final_transaction AS ft
    JOIN
        kimia_farma.kf_kantor_cabang AS kc ON ft.branch_id = kc.branch_id
    JOIN
        kimia_farma.kf_product AS p ON ft.product_id = p.product_id
) AS subquery;