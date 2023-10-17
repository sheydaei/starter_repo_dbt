WITH city_avg AS (
    SELECT 
        city,
        AVG(avgtemp_c) AS avg_weekday
    FROM {{ref('prep_temp')}} 
    GROUP BY city
)

SELECT *
FROM city_avg