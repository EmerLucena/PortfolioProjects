/*Since the year column with null values has only 1.6% of the data and manualy searching for the release date of every game will take too long
I decided to just delete the records with null year. But I will first make a back up table of the raw data. */
SELECT *
INTO vgsales_bckup
FROM vgsalesraw;

DELETE FROM vgsalesraw
WHERE Year IS NULL;

SELECT Year
FROM vgsalesraw
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
FROM vgsalesraw;



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
FROM vgsalesraw;

SELECT *
FROM vgsalescleaned;