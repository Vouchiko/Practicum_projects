select 
    case 
        when duration < 180 then 'Short'
        when duration between 180 and 300 then 'Medium'
        else 'Long'
    end as Length_Category,
    count(*) as listens_count
from songs
group by Length_Category
