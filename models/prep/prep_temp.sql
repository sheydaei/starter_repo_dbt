WITH temp_daily AS (
    SELECT * 
    FROM {{ref('staging_weather')}}
),
add_columns AS (
    SELECT *,
        date AS weekday,
        date AS day_num,
        CASE
            WHEN country = '"Australia"' THEN
                CASE
                    WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Autumn'
                    WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Winter'
                    WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Spring'
                    WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Summer'
                END
            ELSE
                CASE
                    WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
                    WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
                    WHEN EXTRACT(MONTH FROM date) IN (9, 10, 11) THEN 'Autumn'
                    WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
                END
        END AS season
        REPLACE (city, '"', '') AS city
    FROM temp_daily
)
SELECT add_columns.*
FROM add_columns
