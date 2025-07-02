-- WORLD LIFE EXPECTANCY PROJECT (EXPLORATORY DATA ANALYSIS)
-- Using Group by, Having, Case statement, Over(), Partition by().

SELECT *
FROM world_life_expectancy
;

-- FILTER OUR DATA BY THE MIN AND MAX LIFE EXPENTANCY

SELECT country, 
MIN(`life expectancy`),
MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS life_increase_over_15_year
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
ORDER BY life_increase_over_15_year 
;

-- TAKING THE AVG PER YEAR

SELECT Year, ROUND(AVG(`life expectancy`),2)
FROM world_life_expectancy
WHERE `life expectancy` <> 0
AND `life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT *
FROM world_life_expectancy
;

-- AVG LIFE EXPECTANCY BY COUNTRY INCLUDING GDP

SELECT country, ROUND(AVG(`life expectancy`),1) AS life_exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

-- HIGHEST AND LOWEST GDP INCLUDING AVG

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) high_gdp_count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `life expectancy` ELSE NULL END),2) avg_gdp_count,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) low_gdp_count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `life expectancy` ELSE NULL END),2) low_gdp_count
FROM world_life_expectancy
;

SELECT *
FROM world_life_expectancy
;

-- AVG STATUS BY LIFE EXPECTANCY 

SELECT status, ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status
;

SELECT status, COUNT(DISTINCT country),ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status
;


-- BMI BY COUNTRY

SELECT country, ROUND(AVG(`life expectancy`),1) AS life_exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0
AND BMI > 0
ORDER BY BMI 
;

-- TAKING OUT ADULT MORTALITY AND COMPARING IT TO THE LIFE EXPECTANCY BY COUNTRY 

SELECT country,
Year, 
`life expectancy`, 
`Adult Mortality`, 
SUM( `Adult Mortality`) OVER(PARTITION BY country ORDER BY Year) AS rolling_total
FROM world_life_expectancy
WHERE country LIKE '%United%'
;









