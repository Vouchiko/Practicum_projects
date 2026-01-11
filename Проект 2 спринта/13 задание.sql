select artist, genre
from songs
where artist not in ('неизвестный исполнитель')
group by artist, genre
having count(id) > 1
order by genre, artist