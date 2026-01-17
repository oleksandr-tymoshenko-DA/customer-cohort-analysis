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

## Outcome
The results were validated in Google Sheets and visualized in Tableau
to identify retention patterns and revenue dynamics across cohorts.
