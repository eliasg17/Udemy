with daily_weather as (
    select *
    from {{ source('demo', 'weather') }}
),

daily_agg as (
    select 
        date(time) as daily_weather,
        cityname,
        weather,
        count(weather) as cnt 
    from daily_weather
    group by 1, 2, 3
),

daily_groups as (
    select 
        date(a.time) as daily_weather,
        a.cityname,
        round(avg(clouds), 3) as avg_clouds,
        round(avg(humidity), 3) as avg_humidity,
        round(avg(pressure), 3) as avg_pressure,
        round(avg(temp), 3) as avg_temp
    from daily_weather as a 
    group by all
),

joins as (
    select 
        a.daily_weather,
        a.cityname,
        a.avg_clouds,
        a.avg_humidity,
        a.avg_pressure,
        a.avg_temp,
        b.weather
    from daily_groups as a 
    join daily_agg as b 
        on a.daily_weather = b.daily_weather
        and a.cityname = b.cityname
    qualify 1 = row_number() over (partition by b.daily_weather, b.cityname order by b.cnt desc)
)

select *
from joins