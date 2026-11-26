# Hotel Booking Data Engineering Project – Databricks

## Project Overview

This project demonstrates an end-to-end data engineering workflow using **Databricks SQL** and the Medallion Architecture (Bronze, Silver, and Gold layers).

The project processes raw hotel booking data, performs data cleaning and validation, and generates business-level aggregated insights to support hotel booking and revenue analysis.

## Architecture – Medallion Architecture

The project follows three data processing layers:

1. **Bronze Layer – Raw Data Ingestion**
2. **Silver Layer – Data Cleaning and Transformation**
3. **Gold Layer – Business-Level Aggregation and Analytics**

## Technology Stack

- Databricks
- Databricks SQL
- SQL
- Unity Catalog
- Delta Lake
- Medallion Architecture

## Project Structure

```text
Hotel-Booking-Data-Engineering/
│
├── README.md
│
├── bronze/
│   └── my_transformation_bronze.sql
│
├── silver/
│   └── my_transformation_silver.sql
│
└── gold/
    └── my_transformation_gold.sql
```

## 1. Bronze Layer – Data Ingestion

The Bronze layer is responsible for ingesting raw hotel booking data from CSV files stored in a Databricks Unity Catalog Volume.

**Implementation:**
- Created a streaming table using `CREATE OR REFRESH STREAMING TABLE`.
  
- Ingested CSV data using the `read_files()` function.
  
- Captured source file information using `_metadata.file_name`.
  
- Added ingestion timestamps using `current_timestamp()`.

**Target Table:** `bronze_hotel_bookings`

## 2. Silver Layer – Data Cleaning and Transformation

The Silver layer focuses on improving data quality and preparing clean data for analytics.

**Transformations performed:**
- Removed duplicate records using `SELECT DISTINCT`.
  
- Handled missing values using `COALESCE()`.
  
- Standardized city, room type, booking channel, and meal plan using `TRIM()` and `INITCAP()`.
  
- Calculated missing nights using `DATEDIFF()`.
  
- Calculated missing total booking amounts.
  
- Implemented data quality constraints for valid stay dates and non-negative room rates.
  
- Dropped records that violated the defined constraints.

**Target Views:**
- `silver_bookings_clean`
- `silver_bookings_rejected`

The rejected records are maintained separately with rejection reasons for invalid stay dates or negative room rates.

## 3. Gold Layer – Business Analytics

The Gold layer provides business-ready aggregated data for reporting and decision-making.

### A. Monthly Booking Analysis

**Target View:** `gold_monthly_booking`

Key metrics:
- Total bookings
- Cancelled bookings
- Completed room nights
- Net revenue

Data is aggregated based on the month of the check-in date.

### B. Hotel Performance Summary

**Target View:** `gold_hotel_summary`

Key metrics:
- Hotel region
- City
- Hotel name
- Total bookings
- Completed room nights
- Net revenue
- Average Daily Rate (ADR)

The hotel-level summary combines cleaned Silver data with hotel details from the Bronze layer.

## Data Flow

```text
       Raw CSV Files
             |
             ▼
       BRONZE LAYER
    Raw Data Ingestion
             |
             ▼
       SILVER LAYER
  Data Cleaning & Validation
             |
       ┌─────┴─────┐
       ▼           ▼
 Clean Records  Rejected Records
       |
       ▼
        GOLD LAYER
   Business Aggregation
       |
   ┌───┴──────────────┐
   ▼                  ▼
Monthly Booking   Hotel Summary
   Analysis        Analytics
```

## Business Outcomes

This project helps to:
- Monitor monthly hotel booking trends.
  
- Identify cancelled bookings.
  
- Analyze completed room nights.
  
- Calculate net booking revenue.
  
- Compare hotel performance across regions and cities.
  
- Evaluate hotel revenue efficiency using Average Daily Rate (ADR).
  
- Improve data quality through validation and rejection handling.

## How to Run the Project

1. Create a Databricks workspace.
2. Configure Unity Catalog.
3. Create the catalog and schema.
4. Upload the hotel booking CSV files into a Unity Catalog Volume.
5. Execute the Bronze SQL transformation.
6. Execute the Silver SQL transformation.
7. Execute the Gold SQL transformation.
8. Verify the output tables and materialized views.
9. Use the Gold layer for reporting and dashboard development.

## Learning Outcomes

Through this project, I gained practical experience in:

- Implementing Medallion Architecture.
  
- Building streaming tables in Databricks.
  
- Performing SQL-based ETL transformations.
  
- Handling missing and duplicate data.
  
- Implementing data quality constraints.
  
- Creating materialized views.
  
- Developing business-level KPIs and analytics.

## Conclusion

This project demonstrates how raw hotel booking data can be transformed into structured, clean, and business-ready information using Databricks and SQL.

The Bronze, Silver, and Gold architecture provides a structured approach to data ingestion, data quality management, and analytical reporting.

---

**Project Domain:** Hospitality / Hotel Booking Analytics

**Platform:** Databricks

**Architecture:** Medallion Architecture (Bronze → Silver → Gold)
