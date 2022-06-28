/* Show which receptionist(s) to go to for which appointment. */

select appointment.*, room.room_id, room.branch_id, staff.*
from appointment
join doctor
    on appointment.assigned_to = doctor.staff_id
join room
    on doctor.department_id = room.department_id
join receptionist
    on room.room_id = receptionist.room_id
           and room.branch_id = receptionist.branch_id
join staff
    on receptionist.staff_id = staff.staff_id
where appointment.booked_by = 8