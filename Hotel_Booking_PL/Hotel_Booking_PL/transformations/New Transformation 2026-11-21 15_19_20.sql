CREATE OR REFRESH MATERIALIZED VIEW gold_hotel_summary AS
SELECT
  b.region,
  s.city,
  b.hotel_name,
  COUNT(*) AS bookings,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.nights ELSE 0 END) AS room_nights,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.total_amount - s.discount_amount ELSE 0 END) AS net_revenue,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.total_amount - s.discount_amount ELSE 0 END)
    / SUM(CASE WHEN s.booking_status = 'Completed' THEN s.nights ELSE 0 END) AS avg_daily_rate
FROM silver_bookings_clean AS s
JOIN (
  SELECT booking_id, MAX(region) AS region, MAX(city) AS city, MAX(hotel_name) AS hotel_name
  FROM hotel_booking_sdp.default.bronze_hotel_bookings
  GROUP BY booking_id
) AS b
  ON s.booking_id = b.booking_id
GROUP BY ALL;

