CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality AS
WITH bronze AS (
  SELECT COUNT(*) AS bronze_rows,
         COUNT(DISTINCT booking_id) AS distinct_bronze_bookings
  FROM hotel_booking_sdp.default.bronze_hotel_bookings
), clean AS (
  SELECT COUNT(*) AS clean_bookings FROM silver_bookings_clean
), rejected AS (
  SELECT COUNT(*) AS rejected_rows FROM silver_bookings_rejected
)
SELECT
  bronze_rows,
  clean_bookings,
  rejected_rows,
  bronze_rows - distinct_bronze_bookings AS duplicate_rows,
  CASE WHEN clean_bookings + rejected_rows = distinct_bronze_bookings
       THEN 'Yes' ELSE 'No' END AS reconciliation_passed
FROM bronze, clean, rejected;