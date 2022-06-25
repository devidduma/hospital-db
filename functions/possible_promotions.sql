DELIMITER $$
drop function if exists possible_promotion$$

create function possible_promotion(
date_employed date,
curr_date date,
curr_rank int unsigned,
promotion_every_x_days int unsigned
)
returns boolean
deterministic

/* Calculate if there is any possible new ranking possible. */
BEGIN
    declare date_difference int unsigned;
    declare possible_curr_rank smallint unsigned;

    if(curr_rank > 5 or curr_rank < 0) then
        SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
        SET MESSAGE_TEXT = 'Grade has an illegitimate value.';
    end if;

    set date_difference = datediff(curr_date, date_employed);
    set possible_curr_rank = date_difference / promotion_every_x_days;

    if(possible_curr_rank > 5) then
        set possible_curr_rank = 5;
    end if;

    if(possible_curr_rank > curr_rank) then
        return true;
    else
        return false;
    end if;
END $$

select s.*,
   possible_promotion(s.employed_since, "2022-07-23", d.grade, 365)
    as possible_promotion
from doctor d join staff s
on d.staff_id = s.staff_id;

-- Test illegitimate values:
-- select possible_promotion("2014-07-01", "2022-07-23", 8, 365)
-- select possible_promotion("2014-07-01", "2022-07-23", -2, 365)
