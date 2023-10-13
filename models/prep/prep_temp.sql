WITH temp_daily AS (
    SELECT * 
    FROM {{ref('staging_weather')}}
),
add_columns AS (
    SELECT *,
        date AS weekday,
        date AS day_num,
        CASE
            WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Autumn'
            ELSE 'Winter'
        END AS season
    FROM temp_daily
)
SELECT *
FROM add_columns
