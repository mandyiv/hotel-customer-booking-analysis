CREATE DATABASE hotel;
##imported table from csv 
SELECT * FROM bookings LIMIT 10;

-- check the data type of the columns if they are accurate
USE hotel; 
DESCRIBE bookings;

-- modify the data types
ALTER TABLE bookings 
    MODIFY COLUMN hotel VARCHAR(50),
    MODIFY COLUMN arrival_date_month VARCHAR(20),
    MODIFY COLUMN meal VARCHAR(20),
    MODIFY COLUMN country VARCHAR(3),
    MODIFY COLUMN market_segment VARCHAR(20),
    MODIFY COLUMN distribution_channel VARCHAR(20),
    MODIFY COLUMN reserved_room_type CHAR(1),
    MODIFY COLUMN assigned_room_type CHAR(1),
    MODIFY COLUMN deposit_type VARCHAR(20),
    MODIFY COLUMN customer_type VARCHAR(20),
    MODIFY COLUMN reservation_status VARCHAR(20),
    MODIFY COLUMN reservation_status_date DATE,
    MODIFY COLUMN agent INT,
    MODIFY COLUMN company INT,
    MODIFY COLUMN adr FLOAT;

-- check the data type of the columns if they are accurate
USE hotel; 
DESCRIBE bookings;
-- data type successfully changed

-- checking for total null values
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN hotel IS NULL THEN 1 ELSE 0 END) AS hotel_missing,
    SUM(CASE WHEN is_canceled IS NULL THEN 1 ELSE 0 END) AS is_canceled_missing,
    SUM(CASE WHEN lead_time IS NULL THEN 1 ELSE 0 END) AS lead_time_missing,
    SUM(CASE WHEN arrival_date_year IS NULL THEN 1 ELSE 0 END) AS arrival_date_year_missing,
    SUM(CASE WHEN arrival_date_month IS NULL THEN 1 ELSE 0 END) AS arrival_date_month_missing,
    SUM(CASE WHEN arrival_date_week_number IS NULL THEN 1 ELSE 0 END) AS arrival_date_week_number_missing,
    SUM(CASE WHEN arrival_date_day_of_month IS NULL THEN 1 ELSE 0 END) AS arrival_date_day_of_month_missing,
    SUM(CASE WHEN stays_in_weekend_nights IS NULL THEN 1 ELSE 0 END) AS stays_in_weekend_nights_missing,
    SUM(CASE WHEN stays_in_week_nights IS NULL THEN 1 ELSE 0 END) AS stays_in_week_nights_missing,
    SUM(CASE WHEN adults IS NULL THEN 1 ELSE 0 END) AS adults_missing,
    SUM(CASE WHEN children IS NULL THEN 1 ELSE 0 END) AS children_missing,
    SUM(CASE WHEN babies IS NULL THEN 1 ELSE 0 END) AS babies_missing,
    SUM(CASE WHEN meal IS NULL THEN 1 ELSE 0 END) AS meal_missing,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_missing,
    SUM(CASE WHEN market_segment IS NULL THEN 1 ELSE 0 END) AS market_segment_missing,
    SUM(CASE WHEN distribution_channel IS NULL THEN 1 ELSE 0 END) AS distribution_channel_missing,
    SUM(CASE WHEN is_repeated_guest IS NULL THEN 1 ELSE 0 END) AS is_repeated_guest_missing,
    SUM(CASE WHEN previous_cancellations IS NULL THEN 1 ELSE 0 END) AS previous_cancellations_missing,
    SUM(CASE WHEN previous_bookings_not_canceled IS NULL THEN 1 ELSE 0 END) AS previous_bookings_not_canceled_missing,
    SUM(CASE WHEN reserved_room_type IS NULL THEN 1 ELSE 0 END) AS reserved_room_type_missing,
    SUM(CASE WHEN assigned_room_type IS NULL THEN 1 ELSE 0 END) AS assigned_room_type_missing,
    SUM(CASE WHEN booking_changes IS NULL THEN 1 ELSE 0 END) AS booking_changes_missing,
    SUM(CASE WHEN deposit_type IS NULL THEN 1 ELSE 0 END) AS deposit_type_missing,
    SUM(CASE WHEN agent IS NULL THEN 1 ELSE 0 END) AS agent_missing,
    SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS company_missing,
    SUM(CASE WHEN days_in_waiting_list IS NULL THEN 1 ELSE 0 END) AS days_in_waiting_list_missing,
    SUM(CASE WHEN customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_missing,
    SUM(CASE WHEN adr IS NULL THEN 1 ELSE 0 END) AS adr_missing,
    SUM(CASE WHEN required_car_parking_spaces IS NULL THEN 1 ELSE 0 END) AS required_car_parking_spaces_missing,
    SUM(CASE WHEN total_of_special_requests IS NULL THEN 1 ELSE 0 END) AS total_of_special_requests_missing,
    SUM(CASE WHEN reservation_status IS NULL THEN 1 ELSE 0 END) AS reservation_status_missing,
    SUM(CASE WHEN reservation_status_date IS NULL THEN 1 ELSE 0 END) AS reservation_status_date_missing
FROM bookings;


# TREATING MSSING VALUES
### comany has 112,589 null values, agent has 16338 null values and country has 488 null values

### in some categorical variables like Agent or Company, “NULL” is presented as one of the categories. 
-- This should not be considered a missing value, but rather as “not applicable”. 
-- For example, if a booking “Agent” is defined as “NULL” it means that the booking did not came from a travel agent same with company 

## COMPANY

-- Checking the unique values in company
SELECT company, COUNT(*) AS frequency
FROM bookings
GROUP BY company
ORDER BY frequency DESC;

-- checking if 0 exists in company
SELECT COUNT(*) AS count_of_zero 
FROM bookings
WHERE company = '0';

-- since 0 dosent exist we will fill  company with 0 to represent someone that didn't use a comany to book or pay for the booking
UPDATE bookings
SET company = '0'
WHERE company IS NULL;

-- checking if the update worked
SELECT COUNT(*) AS null_count
FROM bookings
WHERE company IS NULL;

## AGENT
-- checking if 0 exists in agent
SELECT COUNT(*) AS count_of_zero 
FROM bookings
WHERE agent = '0';

-- since 0 dosent exist we will fill agent with 0 to represent someone that didn't use a travel agency to book 
UPDATE bookings
SET agent = '0'
WHERE agent IS NULL;

-- checking if the update worked
SELECT COUNT(*) AS null_count
FROM bookings
WHERE agent IS NULL;

## COUNTRY
SELECT DISTINCT country
FROM bookings
ORDER BY country;

-- update the country to unknown (unk)
UPDATE bookings
SET country = 'UNK'
WHERE country IS NULL;

-- check if all the country codes in the country column are in the correct 3-letter format
SELECT distinct country
FROM bookings
WHERE LENGTH(country) != 3;

-- there is one country code that isnt in the correct format
-- The 2-letter country code CN represents China according to ISO 3166 standards. 
-- The corresponding 3-letter country code is CHN, lets check if it exists in the DB
SELECT distinct country
FROM bookings
WHERE country = 'CHN';

-- CHN exists, so we will update CN TO CHN to unify tehm
UPDATE bookings
SET country = 'CHN'
WHERE country = 'CN';


 # value count for each categorical column in your bookings table

-- For hotel column
SELECT hotel, COUNT(*) AS hotel_count
FROM bookings
GROUP BY hotel;

-- For meal column
SELECT meal, COUNT(*) AS meal_count
FROM bookings
GROUP BY meal;

## sc and undefined are the same since sc stands for self catering, so we will add undefined to SC(self catering)
UPDATE bookings
SET meal = 'SC'
WHERE meal = 'Undefined';

-- For market_segment column
SELECT market_segment, COUNT(*) AS market_segment_count
FROM bookings
GROUP BY market_segment;

-- For distribution_channel column
SELECT distribution_channel, COUNT(*) AS distribution_channel_count
FROM bookings
GROUP BY distribution_channel;

## ONLY ONE ROW IS UNDEFINED, LETS VIEW IT
SELECT *
FROM bookings
WHERE distribution_channel = "Undefined";

## update undefined to direct, since it means not going through a distribution channel
UPDATE bookings
SET distribution_channel = "Direct"
WHERE distribution_channel = "Undefined";

-- For deposit_type column
SELECT deposit_type, COUNT(*) AS deposit_type_count
FROM bookings
GROUP BY deposit_type;

-- For customer_type column
SELECT customer_type, COUNT(*) AS customer_type_count
FROM bookings
GROUP BY customer_type;

-- For reservation_status column
SELECT reservation_status, COUNT(*) AS reservation_status_count
FROM bookings
GROUP BY reservation_status;

-- to check for negative values 
-- For lead_time column
SELECT COUNT(*) AS negative_lead_time
FROM bookings
WHERE lead_time < 0;

-- For arrival_date_year column (you likely expect positive values here, so checking for negatives)
SELECT COUNT(*) AS negative_arrival_date_year
FROM bookings
WHERE arrival_date_year < 0;

-- For arrival_date_week_number column
SELECT COUNT(*) AS negative_arrival_date_week_number
FROM bookings
WHERE arrival_date_week_number < 0;

-- For arrival_date_day_of_month column
SELECT COUNT(*) AS negative_arrival_date_day_of_month
FROM bookings
WHERE arrival_date_day_of_month < 0;

-- For stays_in_weekend_nights column
SELECT COUNT(*) AS negative_stays_in_weekend_nights
FROM bookings
WHERE stays_in_weekend_nights < 0;

-- For stays_in_week_nights column
SELECT COUNT(*) AS negative_stays_in_week_nights
FROM bookings
WHERE stays_in_week_nights < 0;

-- For adults column
SELECT COUNT(*) AS negative_adults
FROM bookings
WHERE adults < 0;

-- For children column
SELECT COUNT(*) AS negative_children
FROM bookings
WHERE children < 0;

-- For babies column
SELECT COUNT(*) AS negative_babies
FROM bookings
WHERE babies < 0;

-- For previous_cancellations column
SELECT COUNT(*) AS negative_previous_cancellations
FROM bookings
WHERE previous_cancellations < 0;

-- For previous_bookings_not_canceled column
SELECT COUNT(*) AS negative_previous_bookings_not_canceled
FROM bookings
WHERE previous_bookings_not_canceled < 0;

-- For booking_changes column
SELECT COUNT(*) AS negative_booking_changes
FROM bookings
WHERE booking_changes < 0;

-- For days_in_waiting_list column
SELECT COUNT(*) AS negative_days_in_waiting_list
FROM bookings
WHERE days_in_waiting_list < 0;

-- For adr (Average Daily Rate) column
SELECT COUNT(*) AS negative_adr
FROM bookings
WHERE adr < 0;

-- For required_car_parking_spaces column
SELECT COUNT(*) AS negative_required_car_parking_spaces
FROM bookings
WHERE required_car_parking_spaces < 0;

-- For total_of_special_requests column
SELECT COUNT(*) AS negative_total_of_special_requests
FROM bookings
WHERE total_of_special_requests < 0;

-- adr has one negative value 
SELECT *
FROM bookings
WHERE adr < 0;

-- delete the row
DELETE FROM bookings
WHERE adr < 0;

## create a new column arrival date by combining the arrivial year, month and year
ALTER TABLE bookings
ADD COLUMN arrival_date DATE;

UPDATE bookings
SET arrival_date = STR_TO_DATE(CONCAT(arrival_date_year, '-', arrival_date_month, '-', arrival_date_day_of_month), '%Y-%M-%d');

SELECT *
FROM bookings
LIMIT 10;

##CHECKING FOR CONFLICTING DATA
-- To identify how many rows where there are no adults and 0 or more  children or babies 
SELECT COUNT(*)
FROM bookings
WHERE adults = 0 AND (children >= 0 OR babies >= 0);
-- there are 403 rows where there are no adults and 0 or more children or babies, lets view them
SELECT *
FROM bookings
WHERE adults = 0 AND (children >= 0 OR babies >= 0);
-- delete the affected rows
DELETE
FROM bookings
WHERE adults = 0 AND (children >= 0 AND babies >= 0);

-- If the agent is 0 (no agent) but the booking is not "Direct" or "corporate" it may indicate inconsistency.
SELECT COUNT(*)
FROM bookings
WHERE agent = '0' AND (market_segment NOT IN ('Direct', 'Corporate') AND distribution_channel NOT IN ('Direct', 'Corporate'));

SELECT *
FROM bookings
WHERE agent = '0' AND (market_segment NOT IN ('Direct', 'Corporate') AND distribution_channel NOT IN ('Direct', 'Corporate'));
-- 2671 apply but i noticed some rows had value in the company column indicating they used a company not just an agent so it wasn't direct

-- to view rows where agent is 0 and company is not 0 and the booking is not "Direct" or "corporate"
SELECT *
FROM bookings
WHERE agent = '0'
  AND company != '0'
  AND market_segment NOT IN ('Direct', 'Corporate')
  AND distribution_channel NOT IN ('Direct', 'Corporate');
  
  -- TO VIEW ROWS WHERE BOTH AGENT AND COMPANY ARE 0 AND the booking is not "Direct" or "corporate"
SELECT COUNT(*)
FROM bookings
WHERE agent = '0'
  AND company = '0'
  AND market_segment NOT IN ('Direct', 'Corporate')
  AND distribution_channel NOT IN ('Direct', 'Corporate');

-- 2129 ROWS HAVE BOTH AGENT AND COMPANY AS 0 AND the booking is not "Direct" or "corporate"
  -- delete the rows
DELETE FROM bookings
WHERE agent = '0'
  AND company = '0'
  AND market_segment NOT IN ('Direct', 'Corporate')
  AND distribution_channel NOT IN ('Direct', 'Corporate');

-- check for rows where the required_car_parking_spaces is greater than the no of adults
SELECT count(*)
FROM bookings
WHERE required_car_parking_spaces > adults;
-- 7 rows apply
SELECT *
FROM bookings
WHERE required_car_parking_spaces > adults;
### Since the rows with 'required_car_parking_spaces' greater than the number of adults do not have reservations for children or babies, 
-- it may indicate an error or inconsistency in the data where parking spaces were overestimated relative to the number of adults.

### update the required_car_parking_spaces value to be equal to the number of adults, 
-- assuming that the number of adults should reasonably correspond to the parking spaces needed.
UPDATE bookings
SET required_car_parking_spaces = adults
WHERE required_car_parking_spaces > adults AND children = 0 AND babies = 0;

SELECT *
FROM bookings
LIMIT 10;

## CHECKING FOR INCONSISTENCY IN is_repeated_guest, previous_bookings_not_canceled AND previous_cancellations
-- for none repeated guest (0), they might cancel bookings (>=0), but they wont have previous bookings not cancelled (0)
-- for repeated guests (1), they might cancel bookings (>=0), but they will have previous bookings not cancelled (>=1)

SELECT *
FROM bookings
WHERE (is_repeated_guest = 0 AND previous_bookings_not_canceled > 0) OR (is_repeated_guest = 1 AND previous_bookings_not_canceled = 0);

-- For inconsistency 1: I updated rows where is_repeated_guest = 0 but previous_bookings_not_canceled > 0. 
       -- These rows were corrected by setting is_repeated_guest = 1, as the guest had a history of non-canceled bookings, indicating they are a returning customer.
-- For inconsistency 2: I updated rows where is_repeated_guest = 1 but previous_bookings_not_canceled = 0. 
        -- These rows were corrected by setting is_repeated_guest = 0, as the guest had no prior non-canceled bookings, suggesting they are not a returning customer.

-- Update rows where is_repeated_guest = 0 but previous_bookings_not_canceled > 0
UPDATE bookings
SET is_repeated_guest = 1
WHERE is_repeated_guest = 0 AND previous_bookings_not_canceled > 0;

-- Update rows where is_repeated_guest = 1 but previous_bookings_not_canceled = 0
UPDATE bookings
SET is_repeated_guest = 0
WHERE is_repeated_guest = 1 AND previous_bookings_not_canceled = 0;


## INCONSISTENCY CHECK FOR any rows where is_canceled = 1 but the reservation_status is not "Check-Out
SELECT COUNT(*)
FROM bookings
WHERE (is_canceled = 1) AND (reservation_status = "Check-Out");
-- # No conflicting data in the results


-- check for rows where both stays_in_weekend_nights and stays_in_week_nights are 0
SELECT COUNT(*)
FROM bookings
WHERE (stays_in_weekend_nights = 0) AND (stays_in_week_nights = 0);
-- 639 rows, lets wiew them

SELECT *
FROM bookings
WHERE (stays_in_weekend_nights = 0) AND (stays_in_week_nights = 0);

-- checking if all of them have adr = 0
SELECT COUNT(*)
FROM bookings
WHERE stays_in_weekend_nights = 0 AND stays_in_week_nights = 0 AND adr = 0;
-- result : 639 rows
-- it seems all have adr = 0 and their arrivial date is the same as the reservation status date, 
     -- meaning they didnt stay 
     -- so we will delete them since they wont be useful to this project
DELETE
FROM bookings
WHERE stays_in_weekend_nights = 0 AND stays_in_week_nights = 0;

SELECT COUNT(*) 
FROM bookings;

SELECT * 
FROM bookings;




