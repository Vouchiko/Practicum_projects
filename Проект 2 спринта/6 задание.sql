SELECT 
    genre, 
    ROUND(SUM(duration::Numeric) / 60, 2) AS duration_minutes
FROM songs
GROUP BY genre
HAVING SUM(duration::Numeric)/60 > 1600
ORDER BY duration_minutes DESC;
