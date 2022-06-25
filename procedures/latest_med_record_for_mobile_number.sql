DELIMITER $$
drop procedure if exists latest_medical_record_for_mobile_number$$

create procedure latest_medical_record_for_mobile_number(
mobile_number varchar(13)
)

/* Find latest medical record for mobile phone number. */
BEGIN
    declare patient_id int unsigned;
    set patient_id = (
            select pi.patient_id
            from patient_info pi
            where pi.mobile = mobile_number
        );

    select mr.*
    from medical_record mr join medical_service_patient msp
    on mr.service_patient_id = msp.service_patient_id
    where msp.patient_id = patient_id
    order by mr.datetime desc
    limit 1;

END $$

call latest_medical_record_for_mobile_number("+355575774623");
