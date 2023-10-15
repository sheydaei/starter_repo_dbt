WITH temp_daily AS (
    SELECT * 
    FROM {{ref('staging_weather')}}
),
add_columns AS (
    SELECT *,
        date AS weekday,
        date AS day_num,
        CASE
            WHEN country = 'Australia' AND EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Autumn'
            WHEN country = 'Australia' AND EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Winter'
            WHEN country = 'Australia' AND EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Spring'
            WHEN country = 'Australia' AND EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Summer'
            WHEN country != 'Australia' AND EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
            WHEN country != 'Australia' AND EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
            WHEN country != 'Australia' AND EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Autumn'
            WHEN country != 'Australia' AND EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
        END AS season
    FROM temp_daily
)
SELECT add_columns.*
FROM add_columns