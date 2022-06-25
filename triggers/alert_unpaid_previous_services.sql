DELIMITER $$
drop trigger if exists alert_unpaid_previous_services$$

create trigger alert_unpaid_previous_services
before insert on medical_service_patient
for each row

BEGIN
    declare count_unpaid_previous_services bool;
    set count_unpaid_previous_services = (
            select count(msp.service_patient_id)
            from medical_service_patient msp
            where msp.patient_id = new.patient_id
            and msp.payment_completed = 0
        );

    if count_unpaid_previous_services >= 3 then
        SIGNAL SQLSTATE '02000' -- "Warning"
        SET MESSAGE_TEXT = 'There are at least 3 previously unpaid services. Please pay the previous services, before we can offer our next service to you.';
    end if ;
END $$
DELIMITER ;

insert into medical_service_patient(performed_by, patient_id, service_type, payment_completed)
values (4, 2, 23, 0);
