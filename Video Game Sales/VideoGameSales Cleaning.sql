-- The rank colum is the unique id for the dataset, so we are going to check for duplicates
SELECT Rank, COUNT(*)
FROM vgsales
GROUP BY Rank
ORDER BY Rank DESC;
-- No duplicates


-- Checking Null values in every the columns 
SELECT 
	SUM(CASE WHEN Rank IS NULL THEN 1 ELSE 0 END) AS Rank_Null,
	SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_Null,
	SUM(CASE WHEN Platform IS NULL THEN 1 ELSE 0 END) AS Platform_Null,
	SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS Year_Null,
	SUM(CASE WHEN Publisher IS NULL THEN 1 ELSE 0 END) AS Publisher_Null
FROM vgsales;
/*
	Rank_Null = 0 
	Name_Null = 0
	Platform_Null = 0
	Year_Null = 271
	Publisher_Null = 0
*/


/*Since the year column with null values has only 1.6% of the data and manualy searching for the release date of every game will take too long
I decided to just delete the records with null year. But I will first make a back up table of the raw data. */
SELECT *
INTO vgsales_bckup
FROM vgsales;

DELETE FROM vgsales
WHERE Year IS NULL;

SELECT Year
FROM vgsales
WHERE Year IS NULL;



-- All the sales related column are in decimal format but it should be in million so I standardize the data by multiplying the sales to 1,000,000
SELECT 
	Rank,
	Name,
	Platform,
	Year,
	Genre,
	Publisher,
	NA_Sales * 1000000 AS NA_Sales,
	EU_Sales * 1000000 AS EU_Sales,
	JP_Sales * 1000000 AS JP_Sales,
	Other_Sales * 1000000 AS Other_Sales,
	Global_Sales * 1000000 AS Global_Sales
FROM vgsales;



-- I then created a table to put the cleaned and standardized data 
SELECT 
	Rank,
	Name,
	Platform,
	Year,
	Genre,
	Publisher,
	NA_Sales * 1000000 AS NA_Sales,
	EU_Sales * 1000000 AS EU_Sales,
	JP_Sales * 1000000 AS JP_Sales,
	Other_Sales * 1000000 AS Other_Sales,
	Global_Sales * 1000000 AS Global_Sales
INTO vgsalescleaned
FROM vgsales;

SELECT *
FROM vgsalescleaned;
