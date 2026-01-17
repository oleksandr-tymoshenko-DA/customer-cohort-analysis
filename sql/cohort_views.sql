CREATE OR REPLACE VIEW customer_first_order AS
SELECT
  customer_id
, MIN(order_date::date) AS first_order_date
FROM project2_orders
WHERE order_status = 'paid'
GROUP BY customer_id
;

CREATE OR REPLACE VIEW customer_cohorts AS
SELECT
  c.customer_id
, DATE_TRUNC('month', f.first_order_date)::date AS cohort_month
, f.first_order_date
FROM project2_customers c
JOIN customer_first_order f
  ON c.customer_id = f.customer_id
;

CREATE OR REPLACE VIEW cohort_activity AS
SELECT
  o.customer_id
, DATE_TRUNC('month', c.cohort_month)::date AS cohort_month
, DATE_TRUNC('month', o.order_date::date)::date AS order_month
, (
    (EXTRACT(YEAR  FROM DATE_TRUNC('month', o.order_date::date)) * 12 + EXTRACT(MONTH FROM DATE_TRUNC('month', o.order_date::date)))
  - (EXTRACT(YEAR  FROM DATE_TRUNC('month', c.cohort_month))      * 12 + EXTRACT(MONTH FROM DATE_TRUNC('month', c.cohort_month)))
  ) AS cohort_index
FROM project2_orders o
JOIN customer_cohorts c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'paid'
;

CREATE OR REPLACE VIEW cohort_sizes AS
SELECT
  cohort_month
, COUNT(DISTINCT customer_id) AS cohort_size
FROM customer_cohorts
GROUP BY cohort_month
;

CREATE OR REPLACE VIEW cohort_retention AS
SELECT
  a.cohort_month
, a.cohort_index
, COUNT(DISTINCT a.customer_id) AS retained_customers
, s.cohort_size
, ROUND(
    COUNT(DISTINCT a.customer_id)::numeric / NULLIF(s.cohort_size, 0)
  , 4
  ) AS retention_rate
FROM cohort_activity a
JOIN cohort_sizes s
  ON a.cohort_month = s.cohort_month
GROUP BY
  a.cohort_month
, a.cohort_index
, s.cohort_size
ORDER BY
  a.cohort_month
, a.cohort_index
;

CREATE OR REPLACE VIEW cohort_retention_matrix AS
SELECT
  cohort_month
, MAX(CASE WHEN cohort_index = 0 THEN retention_rate END) AS m0
, MAX(CASE WHEN cohort_index = 1 THEN retention_rate END) AS m1
, MAX(CASE WHEN cohort_index = 2 THEN retention_rate END) AS m2
, MAX(CASE WHEN cohort_index = 3 THEN retention_rate END) AS m3
, MAX(CASE WHEN cohort_index = 4 THEN retention_rate END) AS m4
, MAX(CASE WHEN cohort_index = 5 THEN retention_rate END) AS m5
FROM cohort_retention
GROUP BY cohort_month
ORDER BY cohort_month
;

CREATE OR REPLACE VIEW cohort_revenue AS
SELECT
  a.cohort_month
, a.cohort_index
, SUM(oi.revenue) AS revenue
FROM cohort_activity a
JOIN project2_orders o
    ON o.customer_id = a.customer_id
   AND DATE_TRUNC('month', o.order_date::date) = a.order_month
JOIN project2_order_items oi
    ON oi.order_id = o.order_id
WHERE o.order_status = 'paid'
GROUP BY
  a.cohort_month
, a.cohort_index
ORDER BY
  a.cohort_month
, a.cohort_index
;

CREATE OR REPLACE VIEW cohort_ltv AS
SELECT
  cohort_month
, cohort_index
, SUM(revenue) OVER (
        PARTITION BY cohort_month
        ORDER BY cohort_index
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ltv
FROM cohort_revenue
ORDER BY
  cohort_month
, cohort_index
;

CREATE OR REPLACE VIEW cohort_arpu AS
SELECT
  r.cohort_month
, r.cohort_index
, r.revenue
, t.retained_customers AS active_customers
, ROUND(
      (r.revenue / NULLIF(t.retained_customers, 0))::numeric
  , 2) AS arpu
FROM cohort_revenue r
JOIN cohort_retention t
  ON r.cohort_month = t.cohort_month
 AND r.cohort_index = t.cohort_index
ORDER BY
  r.cohort_month
, r.cohort_index
;

CREATE OR REPLACE VIEW cohort_ltv_per_customer AS
SELECT
  l.cohort_month
, l.cohort_index
, l.ltv AS cumulative_revenue
, s.cohort_size
, ROUND((l.ltv::numeric / NULLIF(s.cohort_size, 0)), 2) AS ltv_per_customer
FROM cohort_ltv l
JOIN cohort_sizes s
  ON s.cohort_month = l.cohort_month
ORDER BY
  l.cohort_month
, l.cohort_index
;

