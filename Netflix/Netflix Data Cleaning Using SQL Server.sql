-- View Dataset
SELECT *
FROM netflix;


-- Checking duplicates in the unique key (show_id)
SELECT 
	show_id,
	COUNT(show_id) AS id_count
FROM netflix
GROUP BY show_id
ORDER by id_count ;
-- No duplicates


-- Check null values in every columns
SELECT
	SUM(CASE WHEN show_id IS NULL THEN 1 ELSE 0 END) AS showid_nulls,
	SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_nulls,
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
	SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_nulls,
	SUM(CASE WHEN cast IS NULL THEN 1 ELSE 0 END) AS cast_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
	SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS dateadded_nulls,
	SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS releaseyear_nulls,
	SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
	SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listedid_nulls,
	SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description_nulls
FROM netflix;
/*
Columns with NULL values
director = 2634
cast = 825
country = 831
date_added = 98
rating = 4
duration = 3
*/


-- directors columns has 2634 null values or 30% of the total records so I can't just delete it. I will find another columnn to populate it.

-- There are relationship between director and cast, some directors are likely to work with particular cast.
UPDATE netflix  
SET director = nf2.director
FROM netflix
JOIN netflix nf2
ON netflix.cast = nf2.cast
WHERE netflix.cast = nf2.cast AND netflix.show_id <> nf2.show_id AND netflix.director IS NULL;
-- 131 records are populated
-- Populate the rest null values as 'Not Given'
UPDATE netflix
SET director = 'Not Given'
WHERE director IS NULL;
-- 2582 rows are now updated


-- I will do the same to the country column because country column are related to director column.
UPDATE netflix  
SET country = nf2.country
FROM netflix
JOIN netflix nf2
ON netflix.director = nf2.director
WHERE netflix.director = nf2.director AND netflix.show_id <> nf2.show_id AND netflix.country IS NULL;
-- 611 rows are now populated
-- Populate the rest null values as 'Not Given'
UPDATE netflix
SET country = 'Not Given'
WHERE country IS NULL;
-- 256 rows are now updated


-- Since date_added column only have 98 null values, I will just delete them since it will not affect my analysis and visualization later.
SELECT show_id, date_added
FROM netflix
WHERE date_added IS NULL;

DELETE FROM netflix
WHERE date_added IS NULL;
-- The 98 null records are now deleted.


-- I will also just delete the 4 null values in rating column and 3 null values in duration column.
DELETE FROM netflix
WHERE rating IS NULL;

DELETE FROM netflix
WHERE duration IS NULL;
-- The 7 null records are now deleted.



-- Checking if ther are still null values in all the columns.
SELECT
	SUM(CASE WHEN show_id IS NULL THEN 1 ELSE 0 END) AS showid_nulls,
	SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_nulls,
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
	SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_nulls,
	SUM(CASE WHEN cast IS NULL THEN 1 ELSE 0 END) AS cast_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
	SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS dateadded_nulls,
	SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS releaseyear_nulls,
	SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
	SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listedid_nulls,
	SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description_nulls
FROM netflix;


-- I will now drop the cast and description column since it wont be needed for the analysis.
ALTER TABLE netflix
DROP COLUMN cast, description;


/* 
Some of the records in country column has multiple countries, since I only need one for visualization purposes. 
I will only get the first country in the country column assuming that's the original country of the movie.
*/
SELECT 
    CASE
        WHEN CHARINDEX(',', country) > 0 THEN LEFT(country, CHARINDEX(',', country) - 1)
        ELSE country
    END AS og_country
FROM netflix;


-- I will now add another column to the table where I will insert the og_country
ALTER TABLE netflix
ADD og_country varchar(100);

UPDATE netflix
SET og_country =CASE
			WHEN CHARINDEX(',', country) > 0 THEN LEFT(country, CHARINDEX(',', country) - 1)
			ELSE country
		END;

-- 3 records returned blanks becuase there is no entries after the delimiter in those records. Therefore, I will update them manually.
SELECT *
FROM netflix_og
WHERE show_id IN ('s194', 's366', 's372');

UPDATE netflix
SET country =CASE
		WHEN show_id = 's194' THEN 'South Korea'
		WHEN show_id = 's366' THEN 'France'
		WHEN show_id = 's372' THEN 'France'
		ELSE country
	     END;


-- Deleting the country column that has multiple entries
ALTER TABLE netflix
DROP COLUMN country;

-- Renaming 'og_country' column to 'country'
EXEC sp_rename 'netflix.og_country', 'country';

-- It is now ready for visualization
SELECT *
FROM netflix;
