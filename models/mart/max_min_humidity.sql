WITH total_precip_humidity AS (
    SELECT 
        avghumidity,
        country,
        city,
        EXTRACT(YEAR FROM date) AS year,
        SUM(daily_precipitation) AS yearly_precipitation
    FROM {{ref('prep_temp')}} 
    GROUP BY city, country, avghumidity,sum_total_precipation,year
    ORDER BY city
)

SELECT *
FROM total_precip_humidity