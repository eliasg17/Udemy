with CTE as (

    select 
        to_timestamp(started_at) as started_at,
        date(to_timestamp(started_at)) as date_started_at,
        hour(to_timestamp(started_at)) as hour_started_at,
        dayname(to_timestamp(started_at)) as day_name,
        {{day_type('started_at')}} as day_type,
        month(to_timestamp(started_at)) as month,
        {{get_season('started_at')}} as season,
        year(to_timestamp(started_at)) as year

    from {{ source('demo', 'bike') }}

)

select * from CTE