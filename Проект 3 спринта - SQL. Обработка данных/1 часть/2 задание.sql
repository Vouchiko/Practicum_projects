select *
from telecom.users
where age IS NULL or churn_date is NULL or city is NULL or first_name is NULL or last_name is NULL or reg_date is NULL or tariff is NULL
limit 10