/* Show nurses that can help patient with patient_id. */

select staff.*
from patient_room_stationary
join room
on patient_room_stationary.room_id = room.room_id and patient_room_stationary.branch_id = room.branch_id
join nurse
on nurse.department_id = room.department_id
join staff
on staff.staff_id = nurse.staff_id
where patient_room_stationary.patient_id = 1
