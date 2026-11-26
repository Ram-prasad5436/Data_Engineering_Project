CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_clean ( 
  CONSTRAINT valid_stay_dates EXPECT (check_out_date > check_in_date) ON VIOLATION DROP ROW, 
  CONSTRAINT valid_room_rate  EXPECT (room_rate >= 0)                 ON VIOLATION DROP ROW 
) AS 
SELECT DISTINCT 
  booking_id, guest_id, check_in_date, check_out_date, 
  COALESCE(nights, DATEDIFF(check_out_date, check_in_date))      AS nights, 
  COALESCE(INITCAP(TRIM(city)), 'Unknown')                        AS city, 
  INITCAP(TRIM(room_type))                                        AS room_type, 
  room_rate, 
  discount_amount, 
  COALESCE(total_amount, 
           DATEDIFF(check_out_date, check_in_date) * room_rate)   AS total_amount, 
  booking_status, 
coalesce(initcap(trim(booking_channel)),'Unknown') as booking_channel,
coalesce(initcap(trim(meal_plan)),'Unknown') as meal_plan 
FROM bronze_hotel_bookings; 
  
CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_rejected AS 
SELECT *, 
  CASE WHEN check_out_date <= check_in_date THEN 'Check-out is not after check-in' 
       ELSE 'Room rate is negative' END AS reject_reason 
FROM bronze_hotel_bookings 
WHERE check_out_date <= check_in_date OR room_rate < 0; 