# 1.
SELECT count(DISTINCT(continent)) AS count
FROM country

#2.
SELECT continent, COUNT(CODE) AS city
FROM country
GROUP BY continent
ORDER BY city DESC

# 3.
SELECT countrycode, sum(Population) AS Population
FROM city
GROUP BY countrycode
HAVING Population >= 50000000
ORDER BY Population DESC

# 4.
SELECT LANGUAGE, COUNT(language) AS count
FROM countrylanguage
GROUP BY LANGUAGE
ORDER BY COUNT desc
LIMIT 4, 6

# 5.
SELECT LANGUAGE, COUNT(countrycode) AS count
FROM countrylanguage
GROUP BY LANGUAGE
HAVING COUNT >= 15
ORDER BY COUNT DESC

# 6.
SELECT continent, sum(surfacearea) AS SFA
FROM country
GROUP BY continent
ORDER BY SFA DESC