# 1.
SELECT NAME, population
FROM country
WHERE population >
(SELECT population
 FROM country
 WHERE NAME="Mexico")
ORDER BY population DESC

# 2.
SELECT country.name, count(country.name) AS count
FROM country
JOIN city
ON country.code=city.countrycode
GROUP BY country.code
ORDER BY COUNT DESC
LIMIT 10

# 3.
SELECT LANGUAGE, SUM(sub1.count) AS count
FROM (
	SELECT cl.countrycode, cl.language,	cl.percentage, c.population,
	ROUND(c.population * cl.percentage * 0.01) AS COUNT
	FROM country AS c
	RIGHT JOIN countrylanguage AS cl
	ON c.code=cl.CountryCode
) AS sub1
GROUP BY LANGUAGE
HAVING COUNT > 0
ORDER BY COUNT DESC

# 4.
SELECT city.NAME, city.countrycode, country.name,
	ROUND(city.population / country.population * 100, 2) AS percentage
FROM (
	SELECT *
	FROM city
	WHERE population > 5000000) AS city
JOIN country
where city.countrycode=country.code
HAVING percentage > 10
ORDER BY percentage DESC

# 5.
SELECT NAME, COUNT(LANGUAGE) AS language_count
FROM (
	SELECT CODE, NAME, round(population/surfacearea) AS density
	FROM country
	WHERE surfacearea > 10000
	HAVING density > 200
	ORDER BY density DESC
) AS country
JOIN countrylanguage
ON countrylanguage.countrycode=country.code
GROUP BY NAME
HAVING language_count > 5
ORDER BY language_count DESC

# 6.
CREATE VIEW cl AS
(
SELECT city.countrycode, city.name, city.population, cl.lang_count, cl.languages
FROM
(SELECT countrycode, group_concat(LANGUAGE) as languages,
	COUNT(LANGUAGE) AS lang_count
 FROM countrylanguage
 GROUP BY countrycode
 HAVING lang_count <= 3)  AS cl
JOIN
(SELECT *
 FROM city
 WHERE population > 3000000) AS city
 ON city.countrycode=cl.countrycode
 )

SELECT city.CountryCode, city.name AS city_name, city.population,
	country.name, city.lang_count, languages
FROM cl AS city
JOIN country
ON country.code=city.countrycode
ORDER BY population desc