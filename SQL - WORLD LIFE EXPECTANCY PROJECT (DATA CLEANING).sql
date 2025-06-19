-- WORLD LIFE EXPECTANCY PROJECT (DATA CLEANING)

-- SELECT ALL OUR DATA

SELECT *
FROM world_life_expectancy
;

-- LOOKING FOR DUPLICATES

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT *
FROM (
SELECT row_id, 
CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
FROM world_life_expectancy
) AS row_table
WHERE row_num >1 
;

-- DELETING OUR DUPLICATES

DELETE FROM world_life_expectancy
WHERE Row_ID IN (
	SELECT Row_ID
	FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM world_life_expectancy
	) AS row_table
	WHERE row_num >1 
)
;






-- CHECKING FOR MISSING INFORMATION THAT WE CAN POPULATE 

SELECT *
FROM world_life_expectancy
WHERE status = ''
;

SELECT DISTINCT (status)
FROM world_life_expectancy
WHERE status <> ''
;

-- POPULATING OUR MISSING DATA

SELECT DISTINCT (country)
FROM world_life_expectancy
WHERE status = 'Developing'
;

-- IT DIDN'T WORK WITH OUR SUBQUERIE

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE country IN (SELECT DISTINCT (country)
					FROM world_life_expectancy
					WHERE status = 'Developing')
;

-- POPULATING THE DATA USING A SELF JOIN

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing'
;

SELECT *
FROM world_life_expectancy
WHERE country = 'United States of America'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed'
;

-- CHECKING IF THIS TIME IT WORKED OR NOT (DISCLAMER: IT WORKED) 

SELECT *
FROM world_life_expectancy
WHERE `life expectancy` = ''
;


-- PUPULATING OUR MISSING DATA ON LIFE EXPECTANCY

SELECT country, Year, `life expectancy`
FROM world_life_expectancy
;

-- USING AN AVERAGE BETWEEN THE NEXT AND PREVIOUS YEAR FOR OUR MISSING DATA

SELECT t1.country, t1.Year, t1.`life expectancy`, 
t2.country, t2.Year, t2.`life expectancy`,
t3.country, t3.Year, t3.`life expectancy`,
ROUND((t2.`life expectancy` + t3.`life expectancy`)/ 2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.Year = t3.Year + 1
WHERE t1.`life expectancy` = ''
;


UPDATE world_life_expectancy t1 
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.Year = t3.Year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/ 2,1)
WHERE t1.`life expectancy` = ''
;

-- REVIEWING OUR CLEANING PROCESS 

SELECT *
FROM world_life_expectancy
;

