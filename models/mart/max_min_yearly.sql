WITH max_min_yearly AS (
    SELECT 
        maxtemp_c,
        mintemp_c,
        country,
        city,
        EXTRACT(YEAR FROM date) AS year
    FROM {{ref('prep_temp')}} 
    GROUP BY year, country, maxtemp_c, mintemp_c
    ORDER BY country
)

SELECT *
FROM max_min_yearly