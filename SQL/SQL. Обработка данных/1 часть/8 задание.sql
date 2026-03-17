select user_id, call_date, sum(duration)/60 as total_day_duration
from telecom.calls
group by user_id, call_date
order by total_day_duration desc
limit 10