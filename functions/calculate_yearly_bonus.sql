DELIMITER $$
drop function if exists calculate_bonus$$

create function calculate_bonus(
doctor_id int unsigned,
since_datetime datetime,
expected_number_appointments int unsigned,
expected_number_services int unsigned
)
returns int unsigned
deterministic

/* Calculate yearly bonus for each doctor. */
BEGIN
    declare number_of_appointments int unsigned;
    declare number_of_services int unsigned;
    declare maximal_bonus int unsigned;
    declare bonus int unsigned;

    -- Number of appointments taken by doctor, since datetime.
    set number_of_appointments = (
        select count(a.appointment_id)
        from appointment a
        where a.assigned_to = doctor_id
        and a.due_datetime >= since_datetime
    );

    -- Number of services performed by doctor, since datetime.
    set number_of_services = (
        select count(msp.service_patient_id)
        from medical_service_patient msp
        where msp.performed_by = doctor_id
        and msp.datetime >= since_datetime
    );

    -- Maximum bonus is one monthly wage.
    select (s.salary / 12)
    into maximal_bonus
    from doctor d join staff s
    on d.staff_id = s.staff_id
    where d.staff_id = doctor_id;

    -- 1/3 of bonus determined by appointments, 2/3 of bonus determined by number of services
    if number_of_appointments > expected_number_appointments then
        set number_of_appointments = expected_number_appointments;
    end if ;
    if number_of_services > expected_number_services then
        set number_of_services = expected_number_services;
    end if ;
    set bonus = (
        (maximal_bonus / 3) * (number_of_appointments / expected_number_appointments) + (maximal_bonus * 2 / 3) * (number_of_services / expected_number_services)
    );

    -- return bonus
    return bonus;
END $$

select s.staff_id, d.title_id, s.first_name, s.second_name, d.grade,
       calculate_bonus(d.staff_id,"2022-01-01", 5, 5)
        as bonus
from doctor d join staff s
    on d.staff_id = s.staff_id;