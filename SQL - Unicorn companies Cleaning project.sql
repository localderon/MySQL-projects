-- Unicorn companies Cleaning project 

SELECT *
FROM unicorn_companies_dataset
;

-- LOOKING FOR DUPLICATES

SELECT DISTINCT (company), COUNT(company)
FROM unicorn_companies_dataset
GROUP BY company
HAVING COUNT(company) > 1
;

SELECT *
FROM unicorn_companies_dataset
WHERE company = 'Bolt'
;

SELECT DISTINCT (country), COUNT(country)
FROM unicorn_companies_dataset
GROUP BY country
ORDER BY country DESC
;

-- STANDARDIZE OUR DATA 

UPDATE unicorn_companies_dataset
SET country = 'United States'
WHERE country = 'United States,'
;

UPDATE unicorn_companies_dataset
SET country = 'Indonesia'
WHERE country = 'Indonesia,'
;

-- CHECKING OUR CHANGES 

SELECT *
FROM unicorn_companies_dataset
;

-- STANDARDIZE OUR DATA 

SELECT `Date Added`, STR_TO_DATE(`Date Added`,'%m/%d/%Y') AS date
FROM unicorn_companies_dataset
;

UPDATE unicorn_companies_dataset 
SET `Date Added` = STR_TO_DATE(`Date Added`,'%m/%d/%Y')
;

-- DATE ON THE SAME FORMAT

SELECT *
FROM unicorn_companies_dataset
;

-- CHECKING IF WE NEED TO UPDATE MORE DATA

SELECT DISTINCT(category), COUNT(category)
FROM unicorn_companies_dataset
GROUP BY category
HAVING COUNT(category) = 1
ORDER BY category
;

-- CORRECTING FINTECH 

SELECT *
FROM unicorn_companies_dataset
WHERE category = 'Fintech'
;

UPDATE unicorn_companies_dataset
SET category = 'Fintech'
WHERE category = 'Finttech'
;

-- CHECKING OUR CHANGES

SELECT *
FROM unicorn_companies_dataset
WHERE category = 'Finttech'
;

-- WE ARE GONNA TRY TO SEPARATE INVESTOR 

SELECT `select investors`, 
SUBSTRING_INDEX(`select investors`, ',',1) AS inv1,
SUBSTRING_INDEX(SUBSTRING_INDEX(`select investors`, ',',2),',',-1) AS inv2,
SUBSTRING_INDEX(SUBSTRING_INDEX(`select investors`, ',',-2),',',1) AS inv3,
SUBSTRING_INDEX(`select investors`, ',',-1) AS inv4
FROM unicorn_companies_dataset
;

-- INCLUDING OUR INVESTORS ON OUR TABLE

ALTER TABLE unicorn_companies_dataset
ADD column inv1 VARCHAR(50) AFTER `select investors`,
ADD column inv2 VARCHAR(50) AFTER inv1,
ADD column inv3 VARCHAR(50) AFTER inv2,
ADD column inv4 VARCHAR(50) AFTER inv3
;

SELECT *
FROM unicorn_companies_dataset
;

UPDATE unicorn_companies_dataset
SET inv1 = SUBSTRING_INDEX(`select investors`, ',',1)
;

UPDATE unicorn_companies_dataset
SET inv2 = SUBSTRING_INDEX(SUBSTRING_INDEX(`select investors`, ',',2),',',-1)
;

UPDATE unicorn_companies_dataset
SET inv3 = SUBSTRING_INDEX(SUBSTRING_INDEX(`select investors`, ',',-2),',',1)
;

UPDATE unicorn_companies_dataset
SET inv4 = SUBSTRING_INDEX(`select investors`, ',',-1)
;

SELECT *
FROM unicorn_companies_dataset
;

ALTER TABLE unicorn_companies_dataset
DROP COLUMN `Select Investors`
;

SELECT *
FROM unicorn_companies_dataset
;
