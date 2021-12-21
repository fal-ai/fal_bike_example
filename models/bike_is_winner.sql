SELECT 
    bike_id, 
    dates AS date, 
    mod(bike_id, extract(week FROM dates)+1) = 0 AS is_winner
FROM unnest(
        generate_date_array('2016-04-01', '2018-05-01', interval 7 day)
    ) AS dates,
    unnest(generate_array(18250, 18270)) AS bike_id
