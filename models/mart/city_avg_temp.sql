WITH city_avg AS (
    SELECT 
        city,
        date,
        AVG(avgtemp_c) AS avg_weekday
    FROM {{ref('prep_temp')}} 
    GROUP BY city, date
)

SELECT *
FROM city_avg
