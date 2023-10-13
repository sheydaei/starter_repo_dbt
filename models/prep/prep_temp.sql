WITH temp_daily AS (
    SELECT * 
    FROM {{ref('staging_weather')}}
),
add_columns AS (
    SELECT *,
        date AS weekday,
        date AS day_num,
        CASE
            WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) AND country != 'Australia' THEN 'Spring'
            WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) AND country != 'Australia' THEN 'Summer'
            WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) AND country != 'Australia' THEN 'Autumn'
            WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) AND country != 'Australia' THEN 'Winter'
            WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) AND country = 'Australia' THEN 'Autumn'
            WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) AND country = 'Australia' THEN 'Winter'
            WHEN EXTRACT(MONTH FROM date) IN (9,10,11) AND country = 'Australia' THEN 'Spring'
            WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) AND country = 'Australia' THEN 'Summer'
        END AS season
    FROM temp_daily
),
avg_maxwind AS (
    SELECT
        city,
        date,
        AVG(maxwind_kph) AS avg_maxwind_kph
    FROM temp_daily
    GROUP BY city, date
)
SELECT add_columns.*, avg_maxwind_kph
FROM add_columns
LEFT JOIN avg_maxwind
ON add_columns.city = avg_maxwind.city AND add_columns.date = avg_maxwind.date
