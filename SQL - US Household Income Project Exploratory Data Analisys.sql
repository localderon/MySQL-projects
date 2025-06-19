-- US Houshold Income Project Exploratory Data Analisys


SELECT * 
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

-- TOTAL LAND AND WATER BY STATE

SELECT state_name, SUM(aland), SUM(awater)
FROM us_household_income
GROUP BY state_name
ORDER BY 2 DESC
LIMIT 10
;
SELECT state_name, SUM(aland), SUM(awater)
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC
LIMIT 10
;

-- JOINING OUR DIFFERENT TABLES

SELECT * 
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
;

SELECT * 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0;

-- BREAKING THINGS DOWN BY MEAN AND MEDIAN

SELECT u.state_name, county, type, `primary`, mean, median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0;

-- TAKING AVG BY MEAN AND MEDIAN

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 3 DESC
LIMIT 10
;

-- SELECTING DATA BY TYPE OF HOUSEHOLD

SELECT type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY 1
HAVING COUNT(type) > 100
ORDER BY 4 DESC
LIMIT 20
;

-- SELECT THE DATA ABOUT THE COUNTRY WITH LESS LAND AND WATER

SELECT * 
FROM us_household_income
WHERE type = 'Community';

-- AVG BETWEEN ONLY US MEAN AND MEDIAN

SELECT u.state_name, city, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.state_name, city
ORDER BY ROUND(AVG(mean),1) DESC
;












