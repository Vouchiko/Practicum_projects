select track, artist, (duration :: float) / 60 as duration
from songs
--group by artist, track;
