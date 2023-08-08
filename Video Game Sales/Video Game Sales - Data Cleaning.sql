-- View datasets
SELECT *
FROM vgsales2022;

SELECT *
FROM ps4sales;

SELECT *
FROM xboxsales;


-- There are columns in some tables that are not existing in other columns
-- Deleting columns in vgsales2022 and xboxsales that other tables deos not have

ALTER TABLE vgsales2022
DROP COLUMN Critic_Score, Critic_Count, User_Score, Developer, Rating, User_Count;

ALTER TABLE xboxsales
DROP COLUMN Pos;

-- Creating a 'platform' column for xbox and ps4
ALTER TABLE ps4sales
ADD Platform varchar(50);

UPDATE ps4sales
SET Platform = 'PS4';

-- Since there are 3 xbox platform (X360, XB and XOne) I will use the release year of other games to know what xbox platform they belong.
SELECT Platform, MIN(Year_of_Release) as min, MAX(Year_of_Release) as max
FROM vgsales2022
WHERE Platform LIKE 'x%'
GROUP BY Platform;
/* 
X360 = 2005-2016
XB = 2000 - 2008
XOne = 2013 -2016
Games in xbox tables are release from 2013-2022, so I will use 'XOne' 
*/

ALTER TABLE xboxsales
ADD Platform varchar(50);

UPDATE xboxsales
SET Platform = 'XOne';

-- Merging the three tables into one.
SELECT *
FROM vgsales2022
UNION
SELECT *
FROM ps4sales
UNION
SELECT *
FROM xboxsales;

-- Create new table
SELECT *
INTO vgsales
FROM (SELECT *
FROM vgsales2022
UNION
SELECT *
FROM ps4sales
UNION
SELECT *
FROM xboxsales) AS vgmerged

-- Checking
SELECT *
FROM vgsales

-- Identify duplicate rows based on all columns
SELECT *,
       COUNT(*) as duplicate_count
FROM vgsales
GROUP BY 
	Name, Platform, Genre, Publisher, Year_of_Release, Global_Sales, NA_Sales, EU_Sales, JP_Sales, Other_Sales
HAVING COUNT(*) > 1;
-- No duplicate

-- Checking Null values in every the columns 
SELECT 
	SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_Null,
	SUM(CASE WHEN Platform IS NULL THEN 1 ELSE 0 END) AS Platform_Null,
	SUM(CASE WHEN Year_of_Release IS NULL THEN 1 ELSE 0 END) AS Year_Null,
	SUM(CASE WHEN Publisher IS NULL THEN 1 ELSE 0 END) AS Publisher_Null,
	SUM(CASE WHEN Genre IS NULL THEN 1 ELSE 0 END) AS Genre_Null,
	SUM(CASE WHEN NA_Sales IS NULL THEN 1 ELSE 0 END) AS NA_Null,
	SUM(CASE WHEN EU_Sales IS NULL THEN 1 ELSE 0 END) AS EU_Null,
	SUM(CASE WHEN JP_Sales IS NULL THEN 1 ELSE 0 END) AS JP_Null,
	SUM(CASE WHEN Other_Sales IS NULL THEN 1 ELSE 0 END) AS Other_Null,
	SUM(CASE WHEN Global_Sales IS NULL THEN 1 ELSE 0 END) AS Global_Null
FROM vgsales;
-- Name_Null =2
-- Year_Null = 586
-- Genre_Null = 2
-- Publisher_Null = 317


-- Deleting records with null values but I will make a back up table of the vgsales data.
SELECT *
INTO vgsales_bckup
FROM vgsales;

DELETE FROM vgsales
WHERE 
	'Name' IS NULL 
	OR Year_of_Release IS NULL
	OR Genre IS NULL
	OR Publisher IS NULL

-- Detecting outliers in global sales. Calculate to determine the treshold for outliers.
-- Data points with sales greater than this threshold are considered outliers.
SELECT Name, Global_Sales
FROM vgsales
WHERE Global_Sales > (SELECT AVG(Global_Sales) + (3 * STDEV(Global_Sales)) FROM vgsales); -- Three standard deviation above the mean.

-- Converting year of release from float to integer data type
ALTER TABLE vgsales ALTER COLUMN Year_of_Release INTEGER;
-- All sales related from float to decimal
ALTER TABLE vgsales ALTER COLUMN NA_Sales DECIMAL(10,2);
ALTER TABLE vgsales ALTER COLUMN EU_Sales DECIMAL(10,2);
ALTER TABLE vgsales ALTER COLUMN JP_Sales DECIMAL(10,2);
ALTER TABLE vgsales ALTER COLUMN Other_Sales DECIMAL(10,2);
ALTER TABLE vgsales ALTER COLUMN Global_Sales DECIMAL(10,2);


-- Checking if sales values add up to global sales
SELECT 
	Name, 
	Global_Sales,
    (NA_Sales + EU_Sales + JP_Sales + Other_Sales) AS total_region_sales
FROM vgsales
WHERE (NA_Sales + EU_Sales + JP_Sales + Other_Sales) <> Global_Sales;

-- Many records where the regional sales do not add up to the global sales. I will recalculate the regional sales.
UPDATE vgsales
SET Global_Sales = (NA_Sales + EU_Sales + JP_Sales + Other_Sales)
WHERE(NA_Sales + EU_Sales + JP_Sales + Other_Sales) <> Global_Sales;

-- All the sales related should be in million so I standardize the data by multiplying the sales to 1,000,000
UPDATE vgsales
SET NA_Sales = NA_Sales * 1000000,
	EU_Sales = EU_Sales * 1000000,
	JP_Sales = JP_Sales * 1000000,
	Other_Sales = Other_Sales * 1000000,
	Global_Sales = Global_Sales * 1000000

-- The data is now ready for visualization
SELECT *
FROM vgsales





