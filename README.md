# Customer Cohort Analysis

This project demonstrates customer cohort analysis using SQL.
It focuses on retention, ARPU, and LTV metrics to analyze customer behavior over time.

## Tech Stack
- SQL (PostgreSQL-style)
- Google Sheets (validation)
- Tableau (visualization)

## Metrics
- Retention
- ARPU (Average Revenue Per User)
- LTV (Lifetime Value)

## SQL
All cohort-related SQL logic is stored in a single file:

- `sql/cohort_views.sql` — views for:
  - first customer order
  - cohort assignment
  - cohort activity
  - retention
  - revenue
  - ARPU
  - LTV

## Tableau Dashboard

The final cohort analysis is visualized in an interactive Tableau dashboard.

The dashboard includes:
- Customer retention by cohort month
- ARPU dynamics over time
- LTV by cohort
- Revenue trends by cohort and period

🔗 **Tableau Public Dashboard:**  
[View dashboard on Tableau Public](https://public.tableau.com/app/profile/oleksandr.tymoshenko2775/viz/E-commerceCohortPerformanceDasboard/CohortKPIs?publish=yes)

## Outcome
The results were validated in Google Sheets and visualized in Tableau
to identify retention patterns and revenue dynamics across cohorts.
