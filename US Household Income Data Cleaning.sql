SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;
 ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;
 
 #Verifying the count
SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;

#Detecting duplicates in household_income
SELECT id,COUNT(id)
FROM us_project.us_household_income
GROUP BY id
having COUNT(id)>1;

#To remove duplicates, we first identify the row IDs with duplicate entries and then delete them.
select*
from(
select row_id,
id,
row_number() over( partition by id order by id) row_num
FROM us_project.us_household_income) duplicates
where row_num>1
;
 
 #Eliminating the duplicates
 delete from us_household_income
 where row_id in (
	select row_id
    from(
          select row_id,
		  id,
          row_number() over( partition by id order by id) row_num
          FROM us_project.us_household_income
          ) duplicates
    where row_num>1)
;

#Detecting duplicates in household income statistics
#No duplicates are present in this data
SELECT id,COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
having COUNT(id)>1;

SELECT *
FROM us_project.us_household_income;

#The state name is incorrect here, so we need to correct it.
#Alabama is incorrect, but when we run this query, it doesn't show up, so we'll try to approach it from the other direction.
select state_name, count(state_name)
FROM us_project.us_household_income
group by state_name;

#An alternative approach
#It still doesn't appear, but since Georgia is showing up, we'll proceed to correct that.
select distinct state_name
from  us_project.us_household_income
order by 1;

UPDATE us_project.us_household_income
set state_name ='Georgia'
where state_name='georia';

UPDATE us_project.us_household_income
set state_name ='Alabama'
where state_name='alabama'
;

#Verifying state abbreviations
select distinct state_ab
from  us_project.us_household_income
order by 1;

#We are checking for missing locations; 'Autauga County' has a missing place, so we'll update it.
select *
from  us_project.us_household_income
where County='Autauga County'
order by 1;

# filling in the missing value 
update us_household_income
set place ='Autaugaville'
where county='Autauga County'
and city= 'Vinemont';

#We’re checking the type; 'boroughs' should be listed as 'borough', but it's showing differently, so we’ll update it and standardize it.
select type, count(type)
from  us_project.us_household_income
group by type 
#order by 1
;

update us_household_income
set type ='Borough'
where type ='Boroughs';

#Checking for null, zero, or blank values. To check for zeros, use distinct.
#There are no cases where both values are zero, but individually, some values are zero, as shown below.
SELECT ALand,AWater
FROM us_project.us_household_income
where (AWater =0 OR AWater ='' OR AWater is NULL)
AND (ALand =0 OR ALand ='' OR ALand is NULL);

# checking for Awater
SELECT ALand,AWater
FROM us_project.us_household_income
where (AWater =0 OR AWater ='' OR AWater is NULL);

# checkinf for aland 
SELECT ALand,AWater
FROM us_project.us_household_income
where (ALand =0 OR ALand ='' OR ALand is NULL);

# Since both values are not zero at the same time, no changes are needed.

# What have we accomplished so far? 1: We corrected the name. 2: We identified and removed duplicates. 3: We found an issue with the state name, which we corrected manually. 4: We noticed a missing value in the county, which we updated. 5: Finally, we addressed the issue with the boroughs by correcting the type.