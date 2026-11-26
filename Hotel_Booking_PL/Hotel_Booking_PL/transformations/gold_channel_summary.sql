CREATE OR REFRESH MATERIALIZED VIEW gold_channel_summary AS
SELECT
  s.booking_channel,
  COUNT(*) AS bookings,
  SUM(CASE WHEN s.booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
  SUM(CASE WHEN s.booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS cancellation_rate_pct,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.total_amount - s.discount_amount ELSE 0 END) AS net_revenue
FROM silver_bookings_clean AS s
GROUP BY ALL;