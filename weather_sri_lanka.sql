CREATE DATABASE weather_sri_lanka;

## 

SELECT city, parameter, year, ROUND(AVG(value)::numeric,2) as avg_monthly_value
FROM weather 
WHERE parameter = 'T2M'
GROUP BY city, year, parameter
ORDER BY city, year;

## Average temperature by city

SELECT city, parameter, ROUND(AVG(value)::numeric,2) as avg_temperature
FROM weather
WHERE parameter = 'T2M'
GROUP BY city,parameter
ORDER BY avg_temperature DESC;

## Rainfall Seasonal Pattern (Monsoon Detection)

SELECT  city,month, ROUND(AVG(value)::numeric,2) as rainfall_avg
FROM weather
WHERE parameter = 'PRECTOTCORR'
GROUP BY city,month
ORDER BY 
    CASE month
        WHEN 'JAN' THEN 1 WHEN 'FEB' THEN 2 WHEN 'MAR' THEN 3
        WHEN 'APR' THEN 4 WHEN 'MAY' THEN 5 WHEN 'JUN' THEN 6 
        WHEN 'JUL' THEN 7 WHEN 'AUG' THEN 8 WHEN 'SEP' THEN 9 
        WHEN 'OCT' THEN 10 WHEN 'NOV' THEN 11 WHEN 'DEC' THEN 12
        END,
        city;

## Year-over-Year Temperature Trend

SELECT city, year, ROUND(AVG(value)::numeric,2) AS avg_tep,
    ROUND(AVG(value)::numeric,2) - LAG(ROUND(AVG(value)::numeric,2))
        OVER (PARTITION BY city ORDER BY year) AS year_change
FROM weather
WHERE parameter  = 'T2M'
GROUP BY city,year
ORDER BY city,year; 

## climate warming trend

SELECT city, 
       CASE 
           WHEN year BETWEEN 2000 AND 2012 THEN '2000-2012'
           ELSE '2013-2025'
       END as period,
       ROUND(AVG(value)::numeric, 2) as avg_temp
FROM weather
WHERE parameter = 'T2M'
GROUP BY city, period
ORDER BY city, period;


## Add nuw column for calculate temperature vs rainfall correlation
ALTER TABLE weather ADD COLUMN month_number INT;

## For sort month by assending order

UPDATE weather SET month_number = CASE month
    WHEN 'JAN' THEN 1 WHEN 'FEB' THEN 2 WHEN 'MAR' THEN 3
    WHEN 'APR' THEN 4 WHEN 'MAY' THEN 5 WHEN 'JUN' THEN 6
    WHEN 'JUL' THEN 7 WHEN 'AUG' THEN 8 WHEN 'SEP' THEN 9
    WHEN 'OCT' THEN 10 WHEN 'NOV' THEN 11 WHEN 'DEC' THEN 12
END;

## convert table for calculate temperature vs rainfall correlation

SELECT
    t.city, 
    t.month,  
    t.year,   
    t.value as temperature,
    r.value as rainfall
FROM weather t 
JOIN weather r 
    ON t.city = r.city 
    AND t.month = r.month 
    AND t.year = r.year 
WHERE t.parameter = 'T2M'
    AND r.parameter = 'PRECTOTCORR';