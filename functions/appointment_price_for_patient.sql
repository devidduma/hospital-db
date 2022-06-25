DELIMITER $$
drop function if exists appointment_price_for_patient$$

create function appointment_price_for_patient(
patient_id int unsigned
)
returns int unsigned
deterministic

/* Find out appointment price for patient with patient_id. */
BEGIN
    declare assigned_to_doctor int unsigned;
    declare appointment_price int unsigned;

    set assigned_to_doctor = (
            select a.assigned_to
            from appointment a
            where a.booked_by = patient_id
        );

    set appointment_price = (
        select d.appointment_price
        from doctor d
        where d.staff_id = assigned_to_doctor
        );

    return appointment_price;
END $$

select appointment_price_for_patient(10);
