select 
    track, 
    duration, 
    listen, 
    round (duration / listen)  as length
from songs
where listen > 0
