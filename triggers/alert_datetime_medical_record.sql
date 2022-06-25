DELIMITER $$
drop trigger if exists alert_datetime_medical_record$$

create trigger alert_datetime_medical_record
before insert on medical_record
for each row

BEGIN
    declare medical_service_datetime datetime;
    set medical_service_datetime = (
            select msp.datetime
            from medical_service_patient msp
            where new.service_patient_id = msp.service_patient_id
        );

if medical_service_datetime > new.datetime then
    SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
    SET MESSAGE_TEXT = 'Health record cannot have a datetime previous to the referenced medical service! Please revise your input.';
end if ;

END $$
DELIMITER ;

-- Not allowed: same day, 09:00:00
insert into medical_record(written_by, title, body, datetime, service_patient_id)
values (3, "Lorem Ipsum", "Lorem Ipsum dolor sit amet", "2022-04-01 09:00:00", 3);

-- Allowed: same day, 21:00:00
insert into medical_record(written_by, title, body, datetime, service_patient_id)
values (3, "Lorem Ipsum", "Lorem Ipsum dolor sit amet", "2022-04-01 21:00:00", 3);
