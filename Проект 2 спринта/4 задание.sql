select genre,  count(genre) as count
from songs
group by genre
order by count desc
limit 5