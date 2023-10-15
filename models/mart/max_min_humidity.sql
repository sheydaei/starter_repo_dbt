WITH max_min_humidity AS (
    SELECT 
        avghumidity,
        country,
        city,    
    FROM {{ref('prep_temp')}} 
    GROUP BY city, country, avghumidity
    ORDER BY city
)

SELECT *
FROM max_min_humidity