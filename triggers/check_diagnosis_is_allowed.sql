DELIMITER $$
drop trigger if exists check_appointment_price_is_allowed$$

create trigger check_appointment_price_is_allowed
before insert on doctor
for each row

BEGIN

if new.appointment_price / new.title_id >= 4 then
    SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
    SET MESSAGE_TEXT = 'Given the rank, the appointment price is too much! Set a lower price.';
end if ;

END $$
DELIMITER ;

insert into doctor(staff_id, title_id, department_id, grade, appointment_price)
values (52, 3, 4, 4, 1000);
