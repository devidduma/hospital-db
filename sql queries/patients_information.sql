/* Show most important information on patient. */

select distinct patient.patient_id,
       name,
       surname,
       middle_name,
       id_personal_number,
       mobile,
       email,
       date_of_birth,
       appointment_id,
       booking_datetime,
       assigned_to,
       booked_by,
       due_datetime,
       diagnosis_id,
       patient_specific_description,
       diagnosed_by,
       diagnosis_since
from patient, patient_info, appointment, diagnosis_patient
         where patient.patient_id = patient_info.patient_id
            and diagnosis_patient.patient_id = patient.patient_id
and appointment_id = patient.patient_id
order by id_personal_number;