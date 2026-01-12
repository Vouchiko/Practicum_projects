select (select count(*)
    from telecom.calls
    where duration = 0) / (count(*)::real)
from telecom.calls 