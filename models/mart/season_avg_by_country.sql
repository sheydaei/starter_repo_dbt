WITH season_avgtem_cntry AS (
    SELECT 
        season,
        country,
        city,
        AVG(avgtemp_c) AS season_avgtemp
    FROM {{ref('prep_temp')}} 
    GROUP BY season, country,city
    ORDER BY country
)

SELECT *
FROM season_avgtem_cntry