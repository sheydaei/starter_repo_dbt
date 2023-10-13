WITH weekday_avg AS (
    SELECT 
        weekday,
        AVG(avgtemp_c) AS avg_weekday
    FROM {{ref('prep_temp')}} 
    GROUP BY weekday
)

SELECT *
FROM weekday_avg