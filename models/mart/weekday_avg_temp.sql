WITH weekday_avg AS (
    SELECT 
        weekday,
        avgtemp_c
    FROM {{ref('prep_temp')}}
    GROUP BY weekday
),

SELECT *
FROM weekday_avg