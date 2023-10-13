WITH temp_daily AS (
    SELECT * 
    FROM {{ref('prep_temp')}}
),avg_maxwind AS (
    SELECT
        city,
        season,
        AVG(maxwind_kph) AS avg_maxwind_kph
    FROM temp_daily
    GROUP BY city, season
)
SELECT avg_maxwind.*, avg_maxwind_kph
FROM avg_maxwind