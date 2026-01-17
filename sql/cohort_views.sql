CREATE OR REPLACE VIEW customer_first_order AS
SELECT
    customer_id,
    MIN(order_date::date) AS first_order_date
FROM project2_orders
WHERE order_status = 'paid'
GROUP BY customer_id;

