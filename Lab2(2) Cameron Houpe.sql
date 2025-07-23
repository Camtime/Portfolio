use world;

-- 1
select name, population
from country
where population > 1000000;
-- 154

-- 2
select name, CountryCode
from city
limit 2000,3000;
-- Tengzhou CHN, Nanchong CHN, ...

-- 3
SELECT name, continent, region, SurfaceArea, IndepYear, population, LifeExpectancy, GNP
FROM country
WHERE continent = 'South America'
and LifeExpectancy < 70;
-- Bolivia, Brazil, Guyana

-- 4
SELECT name, continent, region, SurfaceArea, IndepYear, population, LifeExpectancy, GNP
FROM country
WHERE continent = "South America"
and LifeExpectancy >= 60
Order BY LifeExpectancy desc
Limit 0,5;
-- French Guiana, Chile, Uruguay, Argentina, Paraguay

-- 5
select name, population
from city
where population > 5000000
order by population desc;
-- Mumbai, Seoul, Sao Paulo

-- 6
select language, countrycode
from countrylanguage
where countrycode in ("ZAF", "CAN");
-- English is spoken in both

-- 7
select name, population
from city
where Population between 2000000 and 5000000;	
-- Alger, Luanda, Buenos Aires, ...

-- 8: Find the Life Expectancies of countries that are not null
select name, LifeExpectancy
from country
where LifeExpectancy is not null;
-- Aruba 78.4, Afghanistan 45.9, Angola 38.3, ...

-- 9
select name
from city
where name like 'Lake%';
-- Lakewood

-- 10
select name
from city
where name like '%town%';
-- Townsville, Bridgetown, ...

-- 11 
select name
from city
where name like 'K__n%';
-- Karnal, Kaunas, ...

-- 12
select name
from country
where name like '%ia';
-- Albania, Armenia, ...

-- 13
select region
from country
where region like "%Australia%"
and region like "%New Zealand%";
-- "Australia and New Zealand"

-- 14
select name
from country
where name regexp '[:punct:]';
-- Cocos (Keeling), Cote d'Ivoire, ...

-- 15
select localname
from country
where localname regexp '[:space:]';
-- Costa Rica, Cabo Verde, ...

-- 16
select name
from city
where name regexp 'city$';
-- Belize City, Benin City, ...


-- 17 
select name
from city
where name regexp 'lake+';
-- Salt Lake City, Lakewood

-- 18
select name
from city
where name regexp 'town *';
-- Townsville, Bridgetown, ...

-- 19
select distinct countrycode, country.code, country.name
from city, country
where city.countrycode = country.code
limit 10;
-- Aruba, Afghanistan, ...

-- 20
select countrycode,
concat (city.name, " ", country.name) as name
from city, country
where city.countrycode = country.code;
-- Cotia Brazil, Liyang China, ...


-- 21
select extract(YEAR_MONTH FROM CURDATE());
-- year is 2025, month is 01

-- 22
select name, code, indepyear,
IF(indepyear is null, "Independence Year is not known", "Independence Year is known") as statement
from country;
-- Aruba "Independence Year is not known", Angola "Independence Year is known", ...

-- 23
select name, code, indepyear,
Case
When indepyear is null then "Independence Year is not known"
when indepyear is not null then "Independence Year is known"
else "Corrupted Data"
END as statement
from country;
-- Andorra "Independence Year is known", Cook Islands "Independence Year is not known", ...

-- 24: What cities start with los?
select name
from city
where name like 'los%';
-- Los Angeles, Los Cabos, Los Teques


-- 25: Write an if statement that states if a country is or is not a republic using GovernmentForm
select name, governmentform,
if(governmentform = "Republic", "Government is a republic", "Government is not a republic") as statement
from country;
-- Angola is a republic, Anguilla is not a republic, ...



