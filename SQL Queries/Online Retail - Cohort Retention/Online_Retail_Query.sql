--Data Cleaning

-- Total Records = 541,909
SELECT *
FROM online_retail;

-- Checking CustomerID if there is null or zero values
-- 135080 records have no customerID
-- 541909 records have customerID
SELECT
	SUM(CASE WHEN CUSTOMERID IS NULL OR CustomerID = 0 THEN 1 ELSE 0 END) AS noID,
	SUM(CASE WHEN CUSTOMERID IS NOT NULL OR CustomerID != 0 THEN 1 ELSE 0 END) AS haveID
FROM online_retail;

WITH cte AS
(
SELECT *
FROM online_retail
WHERE CustomerID != 0
),

quantity_unit_price AS 
(
-- 397882 Records with customerID, quantity and unit price
SELECT *
FROM cte
WHERE Quantity > 0 AND UnitPrice > 0
),
-- Checking duplicate
duplicate_check AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity ORDER BY InvoiceDate) dup_flag
FROM quantity_unit_price
)
-- 392667 clean data
-- 5215 duplicate records
SELECT *
INTO #online_retail_main
FROM duplicate_check
WHERE dup_flag = 1;

-- Clean data 
-- Begin Cohort Analysis
SELECT *
FROM #online_retail_main



-- Unique identifier (CustomerID)
-- Initial start date (First Invoice Date)
-- Revenue data 

SELECT 
	CustomerID,
	MIN(InvoiceDate) AS first_purchase_date,
	DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) cohort_date
INTO #cohort
FROM #online_retail_main
GROUP BY CustomerID;

SELECT *
FROM #cohort

-- Create cohort index
SELECT 
	xxx.*,
	(year_diff * 12) + (month_diff + 1) AS cohort_index
--INTO #cohort_retention
FROM (
		SELECT 
			xx.*,
			invoice_year - cohort_year AS year_diff,
			invoice_month - cohhort_month AS month_diff
		FROM (
				SELECT 
					o.*,
					c.cohort_date,
					YEAR(InvoiceDate) AS invoice_year,
					MONTH(InvoiceDate) AS invoice_month,
					YEAR(c.cohort_date) AS cohort_year,
					MONTH(c.cohort_date) AS cohhort_month
				FROM #online_retail_main AS o
				LEFT JOIN #cohort AS c
					ON o.CustomerID = c.CustomerID 
				) xx
		) xxx

-- Pivot data to see the cohort table
SELECT *
INTO #cohort_pivot
FROM(
	SELECT DISTINCT 
	CustomerID,
	cohort_date,
	cohort_index
FROM #cohort_retention) tbl
PIVOT(
	COUNT(CustomerID)
	FOR cohort_index IN 
			([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
) AS pivot_table
-- ORDER BY cohort_date

-- Covert to percentage
SELECT cohort_date,
	1.0*[1]/[1] * 100 AS [1],
	1.0*[2]/[1] * 100 AS [2],
	1.0*[3]/[1] * 100 AS [3],
	1.0*[4]/[1] * 100 AS [4],
	1.0*[5]/[1] * 100 AS [5],
	1.0*[6]/[1] * 100 AS [6],
	1.0*[7]/[1] * 100 AS [7],
	1.0*[8]/[1] * 100 AS [8],
	1.0*[9]/[1] * 100 AS [9],
	1.0*[10]/[1] * 100 AS [10],
	1.0*[11]/[1] * 100 AS [11],
	1.0*[12]/[1] * 100 AS [12],
	1.0*[13]/[1] * 100 AS [13]
FROM #cohort_pivot
ORDER BY cohort_date

-- Ready for visualization
