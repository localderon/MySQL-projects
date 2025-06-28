-- SQL Credit Card Fraud project LIMIT BY 20000 BC MY COMPUTER CANT HANDLE TOO MUCH DATA :(
-- Data Exploration Project using:
-- REGEXP, CASE, RANK(), DENSE_RANK(), OVER PARTITION BY, Subqueries, Joins, Date/Time filtering

SELECT *
FROM fraud_test
LIMIT 1000
;

SELECT *
FROM fraud_train
LIMIT 1000
;

-- LOOKING FOR ANY DUPLUCATE VALUES

SELECT state, COUNT(state)
FROM fraud_test
GROUP BY state
ORDER BY state 
;

SELECT state, COUNT(state)
FROM fraud_train
GROUP BY state
ORDER BY state 
;

-- JOINING OUR TABLES TO START OUR ANALYSIS 

SELECT *
FROM fraud_test fte
JOIN fraud_train ftr
	ON fte.cc_num = ftr.cc_num
LIMIT 20000
;

-- START OUR ANALYSIS PER YEAR (FRAUD TEST 2020 - FRAUD TRAIN 2019)

-- Top 100 highest transactions that occurred during early morning hours (7–9 AM)?

-- ALL 2020 
SELECT *
FROM fraud_test
WHERE trans_date_trans_time >= '2020-01-01' AND trans_date_trans_time < '2020-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
ORDER BY amt
LIMIT 100
;

-- BY NAME 2020
SELECT DISTINCT (first), count(first)
FROM fraud_test
WHERE trans_date_trans_time >= '2020-01-01' AND trans_date_trans_time < '2020-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
GROUP BY first
ORDER BY first
LIMIT 100
;

-- BY CATEGORY 2020 
SELECT category, max(amt)
FROM fraud_test
WHERE trans_date_trans_time >= '2020-01-01' AND trans_date_trans_time < '2020-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
GROUP BY category
ORDER BY category
LIMIT 100
;

-- ALL 2019
SELECT *
FROM fraud_train
WHERE trans_date_trans_time >= '2019-01-01' AND trans_date_trans_time < '2019-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
ORDER BY amt
LIMIT 100
;

-- BY NAME 2019
SELECT DISTINCT (first), count(first)
FROM fraud_train
WHERE trans_date_trans_time >= '2019-01-01' AND trans_date_trans_time < '2019-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
GROUP BY first
ORDER BY first
LIMIT 100
;

-- BY CATEGORY 2019
SELECT category, max(amt)
FROM fraud_train
WHERE trans_date_trans_time >= '2019-01-01' AND trans_date_trans_time < '2019-12-31'
AND CAST(trans_date_trans_time AS TIME) BETWEEN '07:00' AND '09:00'
GROUP BY category
ORDER BY category
LIMIT 100
;

-- Which city has the most frauds? 2019 & 2020

-- 2019
SELECT state, city, amt
FROM fraud_test
ORDER BY amt DESC
LIMIT 10
;

-- 2020
SELECT state, city, amt
FROM fraud_train
ORDER BY amt DESC
LIMIT 10
;

-- Merchants that appear most frequently in suspiciously small transactions? <2 dollars

-- 2019
SELECT DISTINCT merchant, category
FROM fraud_test
WHERE amt < 2
ORDER BY merchant 
;

-- 2020
SELECT DISTINCT merchant, category
FROM fraud_train
WHERE amt < 2
ORDER BY merchant 
;

-- TRYING TO FIND OUT IF THERE IS A SUSPICIOUS CUSTOMER WITH A SUSPICIOUS NAME USING REGEXP CLAUSE

-- 2019
SELECT DISTINCT merchant
FROM fraud_test
WHERE merchant REGEXP '@[a-z]+'
;

-- 2020
SELECT DISTINCT first
FROM fraud_train
WHERE first REGEXP '@[a-z]+'
;

-- SELECTING CUSTOMER THAT STARTS WITH LETTER A USING REGEXP CLAUSE

-- 2019
SELECT first, COUNT(first)
FROM fraud_test
WHERE first REGEXP '^a'
group by first
;

-- 2019 and 2020
SELECT fte.first, ftr.first
FROM fraud_test fte
JOIN fraud_train ftr
	ON fte.cc_num = ftr.cc_num
HAVING fte.first REGEXP '^a' AND ftr.first REGEXP '^a'
;
 
-- CLASSIFYING RISK BASED ON AMOUNT WITH CASE STATEMENT

-- 2019 
SELECT first, last, merchant, category, amt,
  CASE 
    WHEN amt < 10 THEN 'Low Risk'
    WHEN amt BETWEEN 10 AND 100 THEN 'Medium Risk'
    ELSE 'High Risk'
  END AS risk_level
FROM fraud_test
LIMIT 100
;

-- TOP 3 BIGGEST TRANSACTIONS PER STATE

-- 2019
SELECT *
FROM (
  SELECT state, ROUND(SUM(amt),2) AS total_spent,
         RANK() OVER(PARTITION BY state ORDER BY SUM(amt) DESC) AS spend_rank
  FROM fraud_test
  GROUP BY cc_num, state
) spend_rank
WHERE spend_rank <= 3
;

-- 2020
SELECT *
FROM (
  SELECT state, ROUND(SUM(amt),2) AS total_spent,
         RANK() OVER(PARTITION BY state ORDER BY SUM(amt) DESC) AS spend_rank
  FROM fraud_train
  GROUP BY cc_num, state
) spend_rank
WHERE spend_rank <= 3
;

-- SPEND AVERAGE BETWEEN 2019-2020 USING SUBQUERIES + JOIN

SELECT ftr2020.cc_num, ftr2020.avg_2020, fte2019.avg_2019,
       ROUND((ftr2020.avg_2020 - fte2019.avg_2019),2) AS diff
FROM (
  SELECT cc_num, ROUND(AVG(amt),2) AS avg_2020
  FROM fraud_test
  GROUP BY cc_num
) ftr2020
JOIN (
  SELECT cc_num, ROUND(AVG(amt),2) AS avg_2019
  FROM fraud_train
  GROUP BY cc_num
) fte2019
ON ftr2020.cc_num = fte2019.cc_num
ORDER BY diff DESC
LIMIT 100
;

