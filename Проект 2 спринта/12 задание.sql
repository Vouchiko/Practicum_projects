select city, genre, track, artist, duration, listen
from songs
where genre in ('pop', 'rock')
order by city, genre, listen desc
limit 20