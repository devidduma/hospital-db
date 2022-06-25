DELIMITER $$
drop function if exists number_nurses_under_doctor_supervision$$

create function number_nurses_under_doctor_supervision(
doctor_id int unsigned
)
returns int unsigned
deterministic

/* Find out number of nurses a doctor can supervise. */
BEGIN
    declare rank_doctor smallint unsigned;
    declare counter int unsigned;

    set rank_doctor = (
            select d.grade
            from doctor d
            where d.staff_id = doctor_id
        );

    set counter = (
            select count(n.staff_id)
            from nurse n
            where n.grade <= rank_doctor
        );

    return counter;
END $$

-- doctor_id=4 has grade=3:
select number_nurses_under_doctor_supervision(4);
-- Compare with doctor_id=3, which has grade=5:
-- select number_nurses_under_doctor_supervision(3);
