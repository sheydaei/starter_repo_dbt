WITH wind_season AS (
    SELECT 
        maxwind_kph,
        country,
        city,
        EXTRACT(YEAR FROM date) AS year,
        CASE
            WHEN maxwind_kph >= 18 THEN 1
            ELSE 0
        END AS windy_day
    FROM {{ref('prep_temp')}} 
    GROUP BY year, country, city
    ORDER BY country
)

SELECT city, year, SUM(windy_day) AS total_windy_days
FROM wind_season
GROUP BY city, year
