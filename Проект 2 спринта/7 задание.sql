select genre, count(id), sum(duration), min(duration), max(duration), round(avg(duration), 2) as average
from songs
group by genre
order by average desc