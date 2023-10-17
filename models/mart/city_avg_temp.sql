WITH city_avg AS (
    SELECT 
        city,
        country,
        AVG(avgtemp_c) AS avg_weekday
    FROM {{ref('prep_temp')}} 
    GROUP BY city, country
)

SELECT *
FROM city_avg
