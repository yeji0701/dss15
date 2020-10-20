# 1.
SELECT DISTINCT(continent)
FROM country

# 2.
SELECT NAME, population
FROM city
WHERE countrycode="kor" and population >= 1000000

# 3.
SELECT NAME, countrycode, population
FROM city
WHERE population BETWEEN 8000000 AND 10000000
ORDER BY population DESC

# 4. 
SELECT code, continent, population, concat(NAME, "(", indepyear, ")") AS NameIndep
FROM country
WHERE indepyear BETWEEN 1940 AND 1950
ORDER BY indepyear ASC
# 5. 
SELECT countrycode, LANGUAGE, percentage
FROM countrylanguage
WHERE LANGUAGE IN ("spanish", "korean", "english") AND percentage >= 95
ORDER BY percentage DESC

# 6. 
SELECT CODE, governmentform, NAME, population, continent
FROM country
WHERE CODE LIKE "A%" AND governmentform LIKE "%republic%"