WITH season_avgtem_cntry AS (
    SELECT 
        season,
        country,
        AVG(avgtemp_c) AS season_avgtemp
    FROM {{ref('prep_temp')}} 
    GROUP BY season, country
    ORDER BY country
)

SELECT *
FROM season_avgtem_cntry