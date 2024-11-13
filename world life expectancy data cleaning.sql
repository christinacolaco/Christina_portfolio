SELECT * 
FROM world_life_expectancy;


# Identifying duplicate entries

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

#Steps to Remove Duplicates
#Locating duplicates by obtaining their row IDs

SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_table
	WHERE Row_Num > 1
;

# Removing duplicate entries
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_table
WHERE Row_Num > 1
)
;

# Handling missing values in the status column
SELECT * 
FROM world_life_expectancy
where status = '';

#We're verifying where the status entries are not blank and find that "developed" or "developing" values are present in the status column.
SELECT DISTINCT(Status)
FROM world_life_expectancy
where status <> ''
;

select DISTINCT(Country)
FROM world_life_expectancy
where Status= 'Developing';

# This query isn’t functioning as expected and returns an error, so we'll approach it differently. The issue arises because the conditions conflict and cancel each other out.

update world_life_expectancy
set Status= 'Developing'
where country in (select DISTINCT(Country)
FROM world_life_expectancy
where Status= 'Developing');

# This is the right way to do it.

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

# Verifying the developed section, updating as needed
SELECT * 
FROM world_life_expectancy
where Country = 'United States of America';

#Updating the developed section
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
; 

# Execute this to verify that everything has been updated correctly.
SELECT * 
FROM world_life_expectancy
where status = '';

# Verifying for null values to address them.
SELECT * 
FROM world_life_expectancy
where status is NULL;

SELECT * 
FROM world_life_expectancy;

# Handling the blank values in the life expectancy column.
SELECT * 
FROM world_life_expectancy
where `Life expectancy` = '';

# We’ll fill in the value by averaging the previous and next entries, and that will be our result.
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3. `Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3. `Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

# Verifying if the update was applied.
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
;

# Verifying for any blanks; since there are none, the life expectancy column has been populated correctly.
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
where `Life expectancy` = ''
;

# The table after data cleaning is complete
SELECT *
FROM world_life_expectancy;
