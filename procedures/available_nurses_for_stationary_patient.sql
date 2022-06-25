DELIMITER $$
drop procedure if exists available_nurses_for_stationary_patient$$

create procedure available_nurses_for_stationary_patient(
patient_id int unsigned
)

/* Find available nurses for a stationary patient. */
BEGIN
    declare department_id int unsigned;

    set department_id = (
            select r.department_id
            from patient_room_stationary prs join room r
            on prs.room_id = r.room_id and prs.branch_id = r.branch_id
            where prs.patient_id = patient_id
        );

    select s.*, n.grade
    from nurse n join staff s on n.staff_id = s.staff_id
    where n.department_id = department_id;

END $$

call available_nurses_for_stationary_patient(30);
