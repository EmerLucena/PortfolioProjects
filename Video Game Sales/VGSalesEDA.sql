USE VideoGameSales;

-- Checking dataset
SELECT *
FROM vgsalesclean;



-- Counting the number of games released in every year
SELECT 
	Year, COUNT(Name)
FROM vgsalesclean
GROUP BY Year
ORDER BY Count(Name);
-- 2017 = Only 3 games are recorded
-- 2020 = Only 1 game is recorded


-- Total Sales Every Year
SELECT
	Year,
	SUM(Global_Sales) AS Global_Sales
FROM vgsalesclean
GROUP BY Year
ORDER BY Year;


-- Average sales of NA, JP, EU and other regions/countries
SELECT
	ROUND(AVG(NA_Sales),2) AS Avg_NA_Sales,
	ROUND(AVG(JP_Sales),2) AS Avg_JP_Sales,
	ROUND(AVG(EU_Sales),2) AS Avg_EU_Sales,
	ROUND(AVG(Other_Sales),2) AS Avg_Other_Sales
FROM vgsalesclean


-- Geting the sales percentage
SELECT
	ROUND(SUM(NA_Sales) / SUM(Global_Sales),4) AS 'NA_Sales %',
	ROUND(SUM(JP_Sales) / SUM(Global_Sales),4) AS 'JP_Sales %',
	ROUND(SUM(EU_Sales) / SUM(Global_Sales),4) AS 'EU_Sales %',
	ROUND(SUM(Other_Sales) / SUM(Global_Sales),4) AS 'Other_Sales %'
FROM vgsalesclean;


-- Global Sales By Genre
SELECT
	Genre,
	ROUND(SUM(Global_Sales),2) AS Global_Sales
FROM vgsales
GROUP BY Genre
ORDER BY Global_Sales DESC;


-- Global Sales By Pulisher
SELECT
	Publisher,
	ROUND(SUM(Global_Sales),2) AS Global_Sales
FROM vgsalesclean
GROUP BY Publisher
ORDER BY Global_Sales DESC;


-- TOP 10 Games that generated the most sales
SELECT TOP(10) Name, Global_Sales
FROM vgsalesclean;
