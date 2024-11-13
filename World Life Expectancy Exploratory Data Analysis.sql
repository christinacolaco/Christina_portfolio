# World Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM world_life_expectancy
;

# Verifying the minimum and maximum life expectancy
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;

# Life expectancy by year
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT * 
FROM world_life_expectancy
;

#Checking if GDP correlates with life expectancy
#Assessing whether countries with higher GDP tend to generate more wealth
#What is the average GDP and life expectancy for each country?
#We need to filter out the rows where these two columns have zero values.
#From this, we observe that lower GDP is associated with lower life expectancy, and vice versa, indicating a positive correlation.

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP ASC
;

#Next, we’ll categorize the data into buckets.
#We’re using a case statement for this.
#If the GDP exceeds a certain threshold, we’ll classify it as high GDP.
#We can filter the data to identify countries with both high GDP and high life expectancy, and vice versa, and then apply further filtering.
#If your GDP is below 1500, you fall into the bottom half; if it’s above 1500, you’re in the top half.

SELECT
SUM(CASE
    WHEN GDP >=1500 THEN 1
    ELSE 0
END )High_GDP_Count
FROM world_life_expectancy;
#From this, we obtained 1,326 rows with a GDP higher than 1500.
#The average life expectancy for countries with high GDP.
#The average life expectancy for those with a lower GDP.

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;
#From this, we can determine that there are 1,326 rows with a GDP higher than 1500, and their average life expectancy is 74.20. In contrast, there are 1,612 rows with a GDP lower than 1500, and their average life expectancy is 64.69.

SELECT * 
FROM world_life_expectancy
;

# In developing countries, the average life expectancy is 66.8, while in developed countries, it is 79.2.
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;
#Comparing BMI across countries
#A lower BMI correlates with a lower life expectancy
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

#Examining adult mortality rates
#Determining the number of deaths each year in a country and comparing it to their life expectancy
#We are calculating a rolling total

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;
# The rolling total is calculated by adding 17 and 14 from adult mortality, which gives a total of 31, and this process is applied consistently throughout.


