with target (building, occurances) as (
    select building, count(*) from (
        select building from section
        group by building, room_number, course_id
        having count(*) >= 3
    )
    group by building
)
select *
from target
where occurances = (select max(occurances) from target)