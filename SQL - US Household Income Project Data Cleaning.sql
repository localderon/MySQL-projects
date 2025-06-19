-- US Houshold Income Project Data Cleaning

SELECT * 
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

-- ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`; 

-- CHECK FOR ANY DUPLICATES

SELECT  COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

-- CLEANING DUPLICATES
SELECT *
FROM(
SELECT row_id, 
id,
row_number() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_household_income
) duplicates
WHERE row_num > 1
;


DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM(
		SELECT row_id, 
		id,
		row_number() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income
		) duplicates
WHERE row_num > 1)
;


SELECT state_name, COUNT(State_Name)
FROM us_household_income_statistics
GROUP BY state_name
;

-- STANDARDIZING DIFFERENT COLUMNS

UPDATE us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia'
;
UPDATE us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama'
;

-- POPULATE MISSING DATA 

SELECT *
FROM us_household_income
WHERE county = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE county = 'Autauga County'
AND city = 'Vinemont'
;


SELECT type, COUNT(type)
FROM us_household_income
GROUP BY type
;

-- STANDARDIZING OUR DATA

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs'
;

SELECT aland, awater
FROM us_household_income
WHERE (aland = 0 OR aland = '' OR aland IS NULL)
;


