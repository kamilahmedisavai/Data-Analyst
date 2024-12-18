
USE netflix_data;

CREATE TABLE netflix (
    show_id VARCHAR(255),
    type VARCHAR(50),
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(255),
    date_added VARCHAR(255),
    release_year INT,
    rating VARCHAR(50),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description TEXT
);


SELECT COUNT(*) FROM dbo.netflix;

--1. Count the number of Movies vs TV Shows

SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

--2. Find the most common rating for Movies and TV Shows

SELECT TOP 1 rating, COUNT(*) AS count
FROM netflix
GROUP BY rating
ORDER BY count DESC;

--3. List all Movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
WITH country_split AS (
    SELECT 
        TRIM(value) AS individual_country
    FROM netflix 
    CROSS APPLY STRING_SPLIT(country, ',') -- Split the comma-separated countries
)
SELECT TOP 5 
    individual_country, 
    COUNT(*) AS content_count
FROM country_split
GROUP BY individual_country
ORDER BY content_count DESC;

--5. Identify the longest Movie or TV Show duration
SELECT TOP 1 
    title, 
    duration
FROM netflix
ORDER BY CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;


--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());

--7. Find all the Movies/TV Shows by director 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


--8. List all TV Shows with more than 5 seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;


--9. Count the number of content items in each genre

WITH genre_split AS (
    SELECT 
        TRIM(value) AS genre
    FROM netflix
    CROSS APPLY STRING_SPLIT(listed_in, ',')
)
SELECT genre, COUNT(*) AS content_count
FROM genre_split
GROUP BY genre
ORDER BY content_count DESC;


--10. Find the average release year for content produced in a specific country. Return top 5 year with highest avg content release For india
SELECT TOP 5 
    release_year, 
    AVG(release_year) AS avg_release_year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY avg_release_year DESC;

--11. List all Movies that are Documentaries

SELECT *
FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

--12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';


--13. Find how many Movies actor 'Salman Khan' appeared in the last 10 years
SELECT COUNT(*) AS count
FROM netflix
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies

 WITH actor_split AS (
    SELECT 
        TRIM(value) AS actor
    FROM netflix
    CROSS APPLY STRING_SPLIT(CAST(cast AS VARCHAR(MAX)), ',')
)
SELECT TOP 10
    actor, 
    COUNT(*) AS movie_count
FROM actor_split
GROUP BY actor
ORDER BY movie_count DESC;

--15. Categorize content based on the presence of the keywords 'kill' and 'violence' in the description

SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS count
FROM netflix
GROUP BY 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END;











