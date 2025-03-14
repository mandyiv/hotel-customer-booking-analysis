-- HOTEL BOOKING EDA
SELECT COUNT(*) AS total_rows
FROM bookings;

-- Summary of Numerical Columns
-- Lead time (numerical summary statistics)
SELECT
    MIN(lead_time) AS min_lead_time,
    MAX(lead_time) AS max_lead_time,
    AVG(lead_time) AS avg_lead_time,
    STDDEV(lead_time) AS stddev_lead_time,
    COUNT(lead_time) AS count_lead_time
FROM bookings;

-- ADR (numerical summary statistics)
SELECT
    MIN(adr) AS min_adr,
    MAX(adr) AS max_adr,
    AVG(adr) AS avg_adr,
    STDDEV(adr) AS stddev_adr,
    COUNT(adr) AS count_adr
FROM bookings;

-- Stays in weekend nights (numerical summary statistics)
SELECT
    MIN(stays_in_weekend_nights) AS min_weekend_nights,
    MAX(stays_in_weekend_nights) AS max_weekend_nights,
    AVG(stays_in_weekend_nights) AS avg_weekend_nights,
    STDDEV(stays_in_weekend_nights) AS stddev_weekend_nights,
    COUNT(stays_in_weekend_nights) AS count_weekend_nights
FROM bookings;

-- Stays in week nights (numerical summary statistics)
SELECT
    MIN(stays_in_week_nights) AS min_week_nights,
    MAX(stays_in_week_nights) AS max_week_nights,
    AVG(stays_in_week_nights) AS avg_week_nights,
    STDDEV(stays_in_week_nights) AS stddev_week_nights,
    COUNT(stays_in_week_nights) AS count_week_nights
FROM bookings;

-- Adults (numerical summary statistics)
SELECT
    MIN(adults) AS min_adults,
    MAX(adults) AS max_adults,
    AVG(adults) AS avg_adults,
    STDDEV(adults) AS stddev_adults,
    COUNT(adults) AS count_adults
FROM bookings;

-- Children (numerical summary statistics)
SELECT
    MIN(children) AS min_children,
    MAX(children) AS max_children,
    AVG(children) AS avg_children,
    STDDEV(children) AS stddev_children,
    COUNT(children) AS count_children
FROM bookings;

-- Babies (numerical summary statistics)
SELECT
    MIN(babies) AS min_babies,
    MAX(babies) AS max_babies,
    AVG(babies) AS avg_babies,
    STDDEV(babies) AS stddev_babies,
    COUNT(babies) AS count_babies
FROM bookings;

-- Previous cancellations (numerical summary statistics)
SELECT
    MIN(previous_cancellations) AS min_previous_cancellations,
    MAX(previous_cancellations) AS max_previous_cancellations,
    AVG(previous_cancellations) AS avg_previous_cancellations,
    STDDEV(previous_cancellations) AS stddev_previous_cancellations,
    COUNT(previous_cancellations) AS count_previous_cancellations
FROM bookings;

-- Previous bookings not canceled (numerical summary statistics)
SELECT
    MIN(previous_bookings_not_canceled) AS min_previous_bookings_not_canceled,
    MAX(previous_bookings_not_canceled) AS max_previous_bookings_not_canceled,
    AVG(previous_bookings_not_canceled) AS avg_previous_bookings_not_canceled,
    STDDEV(previous_bookings_not_canceled) AS stddev_previous_bookings_not_canceled,
    COUNT(previous_bookings_not_canceled) AS count_previous_bookings_not_canceled
FROM bookings;


##  Summary of Categorical Columns 
-- Count occurrences for market_segment
SELECT market_segment, COUNT(*) AS count
FROM bookings
GROUP BY market_segment;

-- Count occurrences for distribution_channel
SELECT distribution_channel, COUNT(*) AS count
FROM bookings
GROUP BY distribution_channel;

-- Count occurrences for hotel
SELECT hotel, COUNT(*) AS count
FROM bookings
GROUP BY hotel;

-- Count occurrences for is_repeated_guest
SELECT is_repeated_guest, COUNT(*) AS count
FROM bookings
GROUP BY is_repeated_guest;

-- Count occurrences for country
SELECT country, COUNT(*) AS count
FROM bookings
GROUP BY country;

-- Count occurrences for reservation_status
SELECT reservation_status, COUNT(*) AS count
FROM bookings
GROUP BY reservation_status;


#Correlation Check:
-- Calculate correlation between lead_time and adr
SELECT 
    AVG(lead_time * adr) - (AVG(lead_time) * AVG(adr)) AS covariance_lead_time_adr,
    SQRT(AVG(POW(lead_time, 2)) - POW(AVG(lead_time), 2)) AS std_dev_lead_time,
    SQRT(AVG(POW(adr, 2)) - POW(AVG(adr), 2)) AS std_dev_adr,
    (AVG(lead_time * adr) - (AVG(lead_time) * AVG(adr))) /
    (SQRT(AVG(POW(lead_time, 2)) - POW(AVG(lead_time), 2)) * 
     SQRT(AVG(POW(adr, 2)) - POW(AVG(adr), 2))) AS correlation_lead_time_adr
FROM bookings;
		-- The correlation coefficient is close to 0 (-0.07), which indicates that there is almost no linear relationship between lead_time and adr.
        -- the length of time a booking is made in advance (lead_time) does not have a strong impact on the average daily rate (adr).

## Distribution of Lead Time by Country:
SELECT country, 
       AVG(lead_time) AS avg_lead_time,
       MIN(lead_time) AS min_lead_time,
       MAX(lead_time) AS max_lead_time,
       STDDEV(lead_time) AS stddev_lead_time
FROM bookings
GROUP BY country;


#Bookings by Hotel and Market Segment:
SELECT hotel, market_segment, COUNT(*) AS bookings_count
FROM bookings
GROUP BY hotel, market_segment;

## Customer Booking Patterns:


--  Booking Lead Times - Analyze how far in advance customers book their stays.
-- Average and median lead time by market segment
SELECT 
    market_segment, 
    AVG(lead_time) AS avg_lead_time
FROM bookings
GROUP BY market_segment
ORDER BY avg_lead_time DESC;

-- Lead time distribution (e.g., grouping lead time into bins)
SELECT 
    CASE 
        WHEN lead_time BETWEEN 0 AND 30 THEN '0-30 days'
        WHEN lead_time BETWEEN 31 AND 60 THEN '31-60 days'
        WHEN lead_time BETWEEN 61 AND 90 THEN '61-90 days'
        WHEN lead_time > 90 THEN '>90 days'
    END AS lead_time_range,
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY lead_time_range
ORDER BY bookings_count DESC;

-- Total stays on weekdays vs. weekends
SELECT 
    SUM(stays_in_week_nights) AS total_weekday_stays, 
    SUM(stays_in_weekend_nights) AS total_weekend_stays
FROM bookings;

-- Average stays on weekdays and weekends by market segment
SELECT 
    market_segment, 
    AVG(stays_in_week_nights) AS avg_weekday_stays, 
    AVG(stays_in_weekend_nights) AS avg_weekend_stays
FROM bookings
GROUP BY market_segment
ORDER BY avg_weekday_stays DESC;


-- Most booked room types
SELECT 
    assigned_room_type, 
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY assigned_room_type
ORDER BY bookings_count DESC;

-- Room type preferences by market segment
SELECT 
    market_segment, 
    assigned_room_type, 
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY market_segment, assigned_room_type
ORDER BY market_segment, bookings_count DESC;


-- Summary of repeated guests
SELECT 
    is_repeated_guest, 
    COUNT(*) AS guest_count, 
    AVG(lead_time) AS avg_lead_time, 
    AVG(previous_bookings_not_canceled) AS avg_prev_bookings_not_canceled
FROM bookings
GROUP BY is_repeated_guest;

-- Special requests by repeated vs. new guests
SELECT 
    is_repeated_guest, 
    AVG(total_of_special_requests) AS avg_special_requests
FROM bookings
GROUP BY is_repeated_guest;

-- Booking count by market segment and distribution channel
SELECT 
    market_segment, 
    distribution_channel, 
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY market_segment, distribution_channel
ORDER BY bookings_count DESC;

-- Percentage of bookings from each market segment
SELECT 
    market_segment, 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings) AS percentage_of_total
FROM bookings
GROUP BY market_segment
ORDER BY percentage_of_total DESC;

-- Online vs. Offline bookings
SELECT 
    SUM(CASE WHEN distribution_channel = 'Online TA' THEN 1 ELSE 0 END) AS online_bookings,
    SUM(CASE WHEN distribution_channel = 'Offline TA/TO' THEN 1 ELSE 0 END) AS offline_bookings
FROM bookings;

-- Top 10 countries by booking count
SELECT 
    country, 
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY country
ORDER BY bookings_count DESC
LIMIT 10;

-- ADR by country (average daily rate)
SELECT 
    country, 
    AVG(adr) AS avg_adr
FROM bookings
GROUP BY country
ORDER BY avg_adr DESC
LIMIT 10;

-- Cancellation rates by country
SELECT 
    country, 
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS cancellation_rate
FROM bookings
GROUP BY country
ORDER BY cancellation_rate DESC
LIMIT 10;


-- Monthly booking trends
SELECT 
    arrival_date_month, 
    COUNT(*) AS bookings_count, 
    AVG(adr) AS avg_adr
FROM bookings
GROUP BY arrival_date_month
ORDER BY FIELD(arrival_date_month, 
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 
    'August', 'September', 'October', 'November', 'December');

-- Weekly booking trends
SELECT 
    WEEKOFYEAR(arrival_date) AS week_number, 
    COUNT(*) AS bookings_count
FROM bookings
GROUP BY week_number
ORDER BY week_number;

