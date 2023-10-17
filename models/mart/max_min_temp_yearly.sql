WITH max_min_yearly AS (
    SELECT 
        maxtemp_c,
        mintemp_c,
        country,
        city,
        EXTRACT(YEAR FROM date) AS year,
        MAX(maxtemp_c) AS max_maxtemp,
        MIN(mintemp_c) AS min_mintemp
    FROM {{ref('prep_temp')}} 
    GROUP BY year, country, city, maxtemp_c, mintemp_c
    ORDER BY country
)

SELECT *
FROM max_min_yearly