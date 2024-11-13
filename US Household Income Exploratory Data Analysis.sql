# US Household Data Exploration
SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;

# Identifying the state with the largest land and water area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
order by 3 desc;

# top 10 largest state by land 
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
order by 2 desc
LIMIT 10;

# top 10 largest state by WATER  
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
order by 3 desc
LIMIT 10;



SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
;


SELECT *
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0;


SELECT u.state_name,county,type,`primary`,mean,median
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0;

# checking for average household income 
#the lowest average income
SELECT u.state_name, round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by u.state_name
order by 2
limit 5
;

# checking for highest average income 
SELECT u.state_name, round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by u.state_name
order by 2 desc 
limit 10
;

# checking for highest median incomes
SELECT u.state_name, round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by u.state_name
order by 3 desc 
limit 10
;

# checking for lowest median income
SELECT u.state_name, round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by u.state_name
order by 3 asc
limit 10
;

# based on type i.e the place of area the person lives in
#municipaloty has only 1 hence their average is so high comparatively 
SELECT type,count(type),round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by 1
order by 3 desc 
limit 20
;

#lets take a look at the median 
SELECT type,count(type),round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by 1
order by 4 desc 
limit 20
;

#checking what state has community 
select*
from us_household_income
where type='Community';

# we don't want the one's which have a smaller count so we'll filter them out 
SELECT type,count(type),round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
inner JOIN us_project.us_household_income_statistics us
    ON u.id= us.id
where mean <> 0
group by 1
having count(type) >100
order by 4 desc 
limit 20
;

#avg household income cities
SELECT u.state_name,city,round(avg(mean),1),round(avg(median),1)
FROM us_project.us_household_income u
LEFT JOIN us_project.us_household_income_statistics us
    ON u.id = us.id
    group  by u.state_name,city
    order by round(avg(mean),1) desc;
    
# what did we look at?
#First, we analyzed the land and water areas.
#Next, we combined tables using an inner join and also explored the left join. When performing the join, we identified some missing data, so we filtered them out.
#We then examined the state level, focusing on which states had the highest and lowest averages, as well as the highest and lowest medians.
#After that, we analyzed the different types of areas, such as municipalities, tracks, cities, etc. Finally, we reviewed state and city names and identified some cities with unusually high earnings.
    
    
