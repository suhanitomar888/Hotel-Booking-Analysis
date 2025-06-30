use hotel_bookings;
SELECT * FROM hotel_bookings LIMIT 10;

-- What is the total number of reservations in the dataset?
SELECT COUNT(*) AS Total_Reservations FROM hotel_bookings; 
SELECT COUNT(*) AS Total FROM hotel_bookings WHERE booking_status = "Not_Canceled";

-- Which meal plan is the most popular among guests?
SELECT type_of_meal_plan, COUNT(*) AS Count FROM hotel_bookings
GROUP BY type_of_meal_plan
ORDER BY Count DESC
Limit 1;

-- What is the average price per room for reservations involving children?
SELECT AVG(avg_price_per_room) AS Average FROM hotel_bookings
WHERE no_of_children > 0;

-- How many reservations were made for the year 20XX (replace XX with the desired year)?
SELECT COUNT(*) AS reservations_in_2018 FROM hotel_bookings
WHERE arrival_date like "%2018";

-- What is the most commonly booked room type?
SELECT room_type_reserved, COUNT(*) AS Count FROM hotel_bookings
GROUP BY room_type_reserved
ORDER BY Count DESC
LIMIT 1; 

--  How many reservations fall on a weekend (no_of_weekend_nights > 0)?
SELECT COUNT(*) AS weekend_reservations FROM hotel_bookings
WHERE no_of_weekend_nights > 0;

-- What is the highest and lowest lead time for reservations?
SELECT MAX(lead_time) AS max_lead_time,
 MIN(lead_time) AS min_lead_time FROM hotel_bookings;
 
 --  What is the most common market segment type for reservations?
 SELECT market_segment_type, COUNT(*) AS Count
 FROM hotel_bookings
 GROUP BY market_segment_type
 ORDER BY Count DESC
 LIMIT 1;
 
 -- How many reservations have a booking status of "Confirmed"?
SELECT COUNT(*) AS Confirmed FROM hotel_bookings
WHERE booking_status = "Not_Canceled";

--  What is the total number of adults and children across all reservations?
SELECT SUM(no_of_adults) AS Adults, SUM(no_of_children) AS Children
FROM hotel_bookings;

-- Rank room types by average price within each market segment.
SELECT *
FROM (
    SELECT 
        market_segment_type, 
        room_type_reserved, 
        AVG(avg_price_per_room) AS avg_price,
        RANK() OVER (
            PARTITION BY market_segment_type 
            ORDER BY AVG(avg_price_per_room) DESC
        ) AS price_rank
    FROM hotel_bookings
    GROUP BY market_segment_type, room_type_reserved
) AS ranked_rooms
ORDER BY market_segment_type, price_rank;

-- Find the top 2 most frequently booked room types per market segment
SELECT *
FROM (
    SELECT market_segment_type, room_type_reserved, COUNT(*) AS count,
           RANK() OVER (PARTITION BY market_segment_type ORDER BY COUNT(*) DESC) AS top_2
    FROM hotel_bookings
    GROUP BY market_segment_type, room_type_reserved
) AS ranked_rooms
WHERE top_2 <= 2;

-- What is the average number of nights (both weekend and weekday) spent by guests for each room type?
SELECT room_type_reserved, 
       AVG(no_of_weekend_nights + no_of_week_nights) AS avg_total_nights
FROM hotel_bookings
GROUP BY room_type_reserved;

-- For reservations involving children, what is the most common room type, and what is the average price for that room type?
SELECT room_type_reserved,
       COUNT(*) AS bookings,
       AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY bookings DESC
LIMIT 1;

-- Find the market segment type that generates the highest average price per room.
SELECT market_segment_type, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
GROUP BY market_segment_type
ORDER BY avg_price DESC
LIMIT 1;

