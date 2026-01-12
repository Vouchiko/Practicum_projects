select (select count(*)
    from telecom.users
    where churn_date is NULL
    ) / (count(*) :: real)
    from telecom.users