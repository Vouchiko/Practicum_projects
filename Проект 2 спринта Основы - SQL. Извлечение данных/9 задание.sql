select city, genre, count(id), sum(duration)
from songs
group by city, genre
order by city