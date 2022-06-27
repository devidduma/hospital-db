/* How many patients were diagnosed by each of the doctors? */

select count(patient.patient_id) as patient_num, diagnosed_by, first_name, second_name
       from diagnosis_patient, patient, staff
where  patient.patient_id = diagnosis_patient.patient_id
and staff_id = diagnosed_by
group by diagnosed_by, first_name, second_name
having count(patient.patient_id) > 0
order by diagnosed_by;
