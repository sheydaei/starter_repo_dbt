WITH total_precip_humidity AS (
    SELECT 
        avghumidity,
        country,
        city,
        date,
        EXTRACT(YEAR FROM date) AS year,
        SUM(totalprecip_mm) AS yearly_precipitation
    FROM {{ref('prep_temp')}} 
    GROUP BY city, country, avghumidity,totalprecip_mm,year,date
    ORDER BY city
)

SELECT *
FROM total_precip_humidity