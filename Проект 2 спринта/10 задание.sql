select count(id), ceiling(avg(duration)/60) as average
from songs
where listen < 0.5