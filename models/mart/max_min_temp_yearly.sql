WITH max_min_yearly AS (
    SELECT 
        country,
        city,
        MAX(maxtemp_c) AS max_maxtemp,
        MIN(mintemp_c) AS min_mintemp
    FROM {{ref('prep_temp')}} 
    GROUP BY country, city
    ORDER BY country
)

SELECT *
FROM max_min_yearly