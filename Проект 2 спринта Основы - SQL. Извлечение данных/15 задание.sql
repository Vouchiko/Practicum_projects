select 
    track, 
    genre, 
    case 
        when genre = 'pop' then 'Popular Music'
        when genre = 'rock' then 'Rock Music'
        when genre = 'jazz' then 'Jazz Music'
        else 'Other'
    end as Genre_Category
from songs