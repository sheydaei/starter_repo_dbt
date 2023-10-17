WITH city_avg AS (
    SELECT 
        city,
        country,
        date,
        AVG(avgtemp_c) AS avg_weekday
    FROM {{ref('prep_temp')}} 
    GROUP BY city, country,date
)

SELECT *
FROM city_avg
