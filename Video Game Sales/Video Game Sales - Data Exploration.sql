-- View dataset
SELECT *
FROM vgsales;

-- Counting total rows, count of unique games, and unique platforms
SELECT 
	COUNT(*) AS Total_rows, 
	COUNT(DISTINCT Name) AS Unique_games, 
	COUNT(DISTINCT Platform) AS Unique_platforms
FROM vgsales;

-- TOP 10 Games that generated the most sales
SELECT TOP(10) Name, Global_Sales
FROM vgsales
ORDER BY Global_Sales DESC;

-- Checking the min and max global sales, and average and total global sales
SELECT 
	MIN(Global_Sales) AS Min_global_sales,
	MAX(Global_Sales) AS Max_global_sales,
	AVG(Global_Sales) AS Avg_global_sales, 
	SUM(Global_Sales) AS Total_global_sales
FROM vgsales;

-- Counting the number of games released in every year
SELECT 
	Year_of_Release, COUNT(Name)
FROM vgsales
GROUP BY Year_of_Release
ORDER BY Count(Name);

-- Analyzing video game sales trends over the years
SELECT
	Year_of_Release,
	SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Year_of_Release
ORDER BY Year_of_Release;


-- Analyzing the distribution of games across different platforms and genres.
SELECT 
	Platform, 
	COUNT(*) AS Num_games
FROM vgsales
GROUP BY Platform
ORDER BY num_games DESC;

SELECT 
	Genre, 
	COUNT(*) AS Num_games
FROM vgsales
GROUP BY Genre
ORDER BY num_games DESC;

-- Checking the Platform Life Cycle
SELECT 
	Platform, 
	MIN(Year_of_Release) AS Release_year, 
	MAX(Year_of_Release) AS Discontinuation_year
FROM vgsales
GROUP BY Platform
ORDER BY Release_Year;

-- Analyzing the inlfuence of Console Generations
SELECT Year_of_Release, Platform, SUM(Global_Sales) AS Total_Sales
FROM vgsales
GROUP BY Year_of_Release, Platform
ORDER BY Year_of_Release;


-- Global Sales By Genre
SELECT
	Genre,
	ROUND(SUM(Global_Sales),2) AS Global_Sales
FROM vgsales
GROUP BY Genre
ORDER BY Global_Sales DESC;

-- Global Sales By Publisher
SELECT
	Publisher,
	COUNT(*) AS Total_Games,
	ROUND(SUM(Global_Sales),2) AS Global_Sales
FROM vgsales
GROUP BY Publisher
ORDER BY Global_Sales DESC;


-- Analyzing regional sales data.
SELECT 
		SUM(NA_Sales) AS Total_NA_Sales, 
		SUM(EU_Sales) AS Total_EU_Sales,
		SUM(JP_Sales) AS Total_JP_Sales, 
		SUM(Other_Sales) AS Total_Other_Sales
FROM vgsales;

-- Analyzing the average sales of NA, JP, EU and other regions/countries
SELECT
	ROUND(AVG(NA_Sales),2) AS Avg_NA_Sales,
	ROUND(AVG(JP_Sales),2) AS Avg_JP_Sales,
	ROUND(AVG(EU_Sales),2) AS Avg_EU_Sales,
	ROUND(AVG(Other_Sales),2) AS Avg_Other_Sales
FROM vgsales;

-- Geting the sales percentage
SELECT
	ROUND(SUM(NA_Sales) / SUM(Global_Sales),4) AS 'NA_Sales %',
	ROUND(SUM(JP_Sales) / SUM(Global_Sales),4) AS 'JP_Sales %',
	ROUND(SUM(EU_Sales) / SUM(Global_Sales),4) AS 'EU_Sales %',
	ROUND(SUM(Other_Sales) / SUM(Global_Sales),4) AS 'Other_Sales %'
FROM vgsales;
