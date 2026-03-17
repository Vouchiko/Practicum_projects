select user_id, count(tariff_name) as count
from telecom.users u
    left join telecom.tariffs t on u.tariff = t.tariff_name
where churn_date IS NULL
group by user_id
having count(tariff_name) > 1


