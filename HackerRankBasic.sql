/*
The following are my solutions to Hacker Rank's SQL (Basic) Practice and Basic SQL Test.
*/

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE mod(ID,2) = 0;

---------------------------------------------------------------

SELECT COUNT(city) - COUNT(DISTINCT(city))
FROM station;

---------------------------------------------------------------

(SELECT CITY, LENGTH(CITY) AS length
 FROM STATION WHERE 1
 ORDER BY length ASC, CITY ASC LIMIT 1)
UNION
(SELECT CITY, LENGTH(CITY) AS length
  FROM STATION WHERE 1
  ORDER BY length DESC, CITY ASC LIMIT 1)

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE city LIKE 'A%'
OR city LIKE 'E%'
OR city LIKE 'I%'
OR city LIKE 'O%'
OR city LIKE 'U%';

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE city LIKE '%A'
OR city LIKE '%E'
OR city LIKE '%I'
OR city LIKE '%O'
OR city LIKE '%U';

---------------------------------------------------------------

SELECT DISTINCT(CITY) FROM STATION
WHERE LEFT(CITY, 1) IN ('a','e','i','o','u')
AND RIGHT(CITY, 1) IN ('a','e','i','o','u');

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE LEFT(city, 1) NOT IN ('a','e','i','o','u');

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE RIGHT(city, 1) NOT IN ('a','e','i','o','u');

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE RIGHT(city, 1) NOT IN ('a','e','i','o','u')
OR LEFT(city, 1) NOT IN ('a','e','i','o','u');

---------------------------------------------------------------

SELECT DISTINCT(city)
FROM station
WHERE RIGHT(city, 1) NOT IN ('a','e','i','o','u')
AND LEFT(city, 1) NOT IN ('a','e','i','o','u');

---------------------------------------------------------------

SELECT name
FROM STUDENTS
WHERE marks > 75
ORDER BY RIGHT(name, 3), ID

---------------------------------------------------------------

SELECT name
FROM Employee
ORDER BY name ASC;

---------------------------------------------------------------

SELECT name
FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id ASC;

---------------------------------------------------------------

SELECT COUNT(name)
FROM CITY
WHERE population > 100000;

---------------------------------------------------------------

SELECT SUM(population)
FROM CITY
WHERE district = "California";

---------------------------------------------------------------

SELECT AVG(population)
FROM CITY
WHERE District = "California";

---------------------------------------------------------------

SELECT CASE 
    WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle' 
    WHEN A = B AND B = C THEN 'Equilateral' 
    WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
    ELSE 'Scalene' 
END tuple
FROM TRIANGLES;


---------------------------------------------------------------

SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')') AS result
FROM OCCUPATIONS
UNION ALL
SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(OCCUPATION), 's.') AS result
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY result ASC;

---------------------------------------------------------------

SELECT FLOOR(AVG(population))
FROM CITY;

---------------------------------------------------------------

SELECT SUM(population)
FROM CITY
WHERE COUNTRYCODE = 'JPN';

---------------------------------------------------------------

SELECT (MAX(population)-MIN(population))
FROM CITY;

---------------------------------------------------------------

SELECT CEIL(AVG(SALARY) - AVG(REPLACE(SALARY, '0', '')))
FROM EMPLOYEES;

---------------------------------------------------------------

SELECT (salary*months), COUNT(*)
FROM Employee
GROUP BY (salary*months)
ORDER BY (salary*months) DESC
LIMIT 1;

---------------------------------------------------------------

SELECT ROUND(SUM(LAT_N), 2), ROUND(SUM(LONG_W), 2)
FROM STATION;

---------------------------------------------------------------

SELECT TRUNCATE(SUM(LAT_N), 4)
FROM STATION
WHERE LAT_N BETWEEN 38.7880 AND 137.2345;

---------------------------------------------------------------

SELECT TRUNCATE(MAX(LAT_N), 4)
FROM STATION
WHERE LAT_N < 137.2345;

---------------------------------------------------------------

SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N IN
    (SELECT MAX(LAT_N)
         FROM STATION
         WHERE LAT_N < 137.2345);

---------------------------------------------------------------

SELECT ROUND(LAT_N, 4)
FROM STATION
WHERE LAT_N IN
    (SELECT MIN(LAT_N)
         FROM STATION
         WHERE LAT_N > 38.7780);

---------------------------------------------------------------

SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N IN
    (SELECT MIN(LAT_N)
         FROM STATION
         WHERE LAT_N > 38.7780);

---------------------------------------------------------------

SELECT SUM(city.population) FROM CITY
INNER JOIN COUNTRY
ON CITY.CountryCode = Country.Code
WHERE Country.Continent = 'Asia';

---------------------------------------------------------------

SELECT city.name FROM CITY
INNER JOIN COUNTRY
ON CITY.CountryCode = Country.Code
WHERE Country.Continent = 'Africa';

---------------------------------------------------------------

SELECT country.continent, FLOOR(AVG(city.population))
FROM CITY INNER JOIN COUNTRY
ON CITY.CountryCode = Country.Code
GROUP BY country.continent;

---------------------------------------------------------------

SELECT ROUND((ABS(MIN(LAT_N)-MAX(LAT_N)))+(ABS(MIN(LONG_W)-MAX(LONG_W))),4)
FROM Station;

---------------------------------------------------------------

SELECT ROUND(SQRT(POWER(MIN(LAT_N)-MAX(LAT_N), 2) + POWER(MIN(LONG_W)-MAX(LONG_W), 2)), 4)
FROM Station;

---------------------------------------------------------------

SELECT std.roll_number, std.name
FROM student_information std, faculty_information fc
WHERE std.advisor = fc.employee_ID AND (fc.gender = 'M' AND fc.salary > 15000 OR fc.gender = 'F' AND fc.salary > 20000);

---------------------------------------------------------------

SELECT customers.customer_id, customers.name, CONCAT('+', country_codes.country_code, customers.phone_number)
FROM customers
INNER JOIN country_codes
ON customers.country = country_codes.country;


