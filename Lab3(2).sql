use world;


-- AGGREGATIONS
-- 1.	What is the total population for all cities in the USA?
select sum(population)
from city
where countrycode = "USA";
-- 78625774

-- 2.	What is the aggregate city population for the USA with a grand total at the bottom?
select city.name, city.population, sum(city.population)
from city
where countrycode = 'USA'
group by city.name, city.population
with rollup;
-- 78625774

-- 3.	What are the cities with the same name as another city but beginning with an M or N? Note:Only list each city once. May use Count(1) or Count(*).
select city.name, count(1)
from city
where city.name like 'M%' or city.name like 'N%'
group by city.name 
having count(1)>1;
-- Manchester, Manzillo, Matamoros, Merida, Newcastle;

-- 6.	What is the aggregate city population values per group (e.g., country) for Mexico and Italy, along with a grand total at the end? Include SUM, AVG, COUNT, MIN, and MAX.
select name, countrycode,
sum(population) as totalPopulation,
avg(population) as avgPopulation,
count(population) as countPopulation,
min(population) as minPopulation,
max(population) as maxPopulation
from city
where countrycode in ('MEX', 'ITA')
group by countrycode, name
with rollup;
-- Alessandria, ITA, 90289

-- 7.	Display all detail city population values AND aggregate population values per group (e.g., country) for Mexico and Italy. Use Partitioning to display both the detail and summary values.
select name, countrycode,
sum(population) over(partition by countrycode) as 'Total',
avg(population) over(partition by countrycode) as 'Avg',
count(population) over(partition by countrycode) as 'Count',
min(population) over(partition by countrycode) as 'Min',
max(population) over(partition by countrycode) as 'Max'
from city
where countrycode in ('MEX', 'ITA');
-- Roma, ITA, 15087019, ...

-- JOINS
-- 1.	What is the country name, city name, GNP, and total city population with more than 10 million individuals? Use an Inner Join Style. 
select country.name, city.name, gnp, city.population
from city inner join country
on city.countrycode = country.Code
group by country.name, city.name, gnp, city.population
having city.population > 10000000
order by country.name, city.name;
-- India, Mumbai, GNP: 447114, Population: 10500000

-- 2.	What is the country name, GNP, and total city population of all cities with more than 10,000,000 people? Use an Old School Join Style. Format the population sum results with commas for easier readability.
select country.name, gnp, sum(city.population)
from country, city
where country.code = city.countrycode
and city.population > 10000000
group by country.name, gnp;
-- India, GNP: 447114, population: 10500000

-- 3.	What is the city name, country name, district (state), and official language of each city in the USA? Use a 3-way Inner Join Style. See the example below.
-- select city.name, country.name, district, language
-- from city
-- inner join country on city.countrycode = country.code
-- inner join countrylanguage on country.code = countrylanguage.CountryCode
-- where city. countrycode = 'USA'
-- && IsOfficial = "T";

select city.name, country.name, district, countrylanguage.language
from city
inner join country on city.countrycode = country.code
inner join countrylanguage on country.code = countrylanguage.CountryCode
where city.countrycode = 'USA'
&& IsOfficial = "T";
-- New York, US, New York, English

-- 4.	What is the city name, country name, district (state), and unofficial language of each city in the USA?
select city.name, country.name, district, countrylanguage.language
from city
inner join country on city.countrycode = country.code
inner join countrylanguage on country.code = countrylanguage.CountryCode
where city.countrycode = 'USA'
&& IsOfficial = "F";
-- New York, US, New York, Chinese

-- 5.	What are the columns of data captured in the Country table that have country codes also represented in the City table? Use a Left Join, starting with country (the first/left one)(Returns 4086 rows).
select *
from country left join city
on country.code = city.countrycode;
-- ABW, Aruba, NA, Caribbean

-- 6.	What are the columns of data in the Country table that first have the country codes represented in the City table? Use a Right Join, starting with city (the second/right one)(Returns 4079 rows)
select *
from country right join city
on country.code = city.countrycode;
-- AFG, Afghanistan, Asia, Southern and Central Asia

-- 7.	What is the reason that these two numbers differ in the above two SQL programs? Run some additional SQL to see if you can determine the reason, including the country names that have no cities represented in the City table.
-- The left join includes the countries in the country table, which there is more of than in the city table, since some coutries have no city representation.
select *
from country left join city
on country.code = city.countrycode
where city.name is null;

-- ATA, Antarctica, ...

-- 8.	What are all rows in both the city and country table? Use a Full Outer Join, which, in MySQL, employs a UNION clause connecting a Left join with a Right join of the two tables. See the example below.
-- SELECT * FROM country
-- LEFT JOIN city ON country.code = city.countrycode
-- UNION
-- SELECT * FROM country
-- RIGHT JOIN city ON country.code = city.countrycode;

SELECT * FROM country
LEFT JOIN city ON country.code = city.countrycode
UNION
SELECT * FROM country
RIGHT JOIN city ON country.code = city.countrycode;
-- ABW, Aruba, NA, Caribbean

-- CALCULATIONS AND SUBQUERIES
-- 1.	What are the countries with the highest average city population?
select country.name, avg(city.Population)
from city, country
where country.code = city.countrycode
group by country.name, country.population
order by avg(city.population) desc;
-- Singapore. Hong Kong, Uruguay


-- 2.	How many years has it been since each country gained its independence?
select country.name, 2025 - indepyear
from country;
-- Angola 50

-- 3.	Which countries have a population greater than Canada's? Use a subquery in the WHERE statement.
select name, population	
from country
where population > (
select population
from country
where code = 'CAN');
-- Argentina, Brazil, Bangladesh

-- 4.	What is the count of cities per country and per world? Use a subquery in the SELECT statement.
select country.code, count(city.name),
	(select count(city.name) as CountPerWorld from city)
from city, country 
where country.code = city.countrycode 
group by country.code;
-- ABW, 1, 4079



