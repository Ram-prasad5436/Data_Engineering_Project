CREATE OR REFRESH MATERIALIZED VIEW gold_room_type_summary AS
SELECT
  s.room_type,
  COUNT(*) AS bookings,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.nights ELSE 0 END) AS room_nights,
  SUM(CASE WHEN s.booking_status = 'Completed' THEN s.total_amount - s.discount_amount ELSE 0 END) AS net_revenue,
  AVG(b.guest_rating) AS avg_rating
FROM silver_bookings_clean AS s
JOIN (
  SELECT booking_id, AVG(guest_rating) AS guest_rating
  FROM hotel_booking_sdp.default.bronze_hotel_bookings
  GROUP BY booking_id
) AS b
  ON s.booking_id = b.booking_id
GROUP BY ALL;