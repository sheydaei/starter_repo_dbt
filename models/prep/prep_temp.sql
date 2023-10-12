WITH temp_daily AS (
    SELECT * 
    FROM {{ref('staging_temp')}}
),
add_weekday AS (
    SELECT *,
        DATE_PART ('week', date) AS weekday,
        DATE_PART ('day', date) AS day_num
    FROM temp_daily
)
SELECT *
FROM add_weekday