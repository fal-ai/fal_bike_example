SELECT
    bike_id,
    start_date,
    sum(total_trip_today) OVER week_window AS trip_count_last_week,
    sum(total_duration_today) OVER week_window AS trip_duration_last_week
FROM
    (
        SELECT
            cast(bikeid AS STRING) AS bike_id,
            timestamp(starttime) AS start_date,
            count(*) AS total_trip_today,
            sum(tripduration) AS total_duration_today,
        FROM `bigquery-public-data.new_york_citibike.citibike_trips`
        WHERE bikeid = 18260 AND '2017-01-01' <= starttime AND starttime < '2018-03-01'
        GROUP BY bikeid, start_date
    )
WINDOW week_window AS (PARTITION BY bike_id ORDER BY start_date ROWS BETWEEN 7 PRECEDING AND CURRENT ROW)
