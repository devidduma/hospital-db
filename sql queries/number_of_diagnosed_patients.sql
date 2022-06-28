/* How many patients were diagnosed by each of the doctors? */

select distinct count(patient.patient_id) as patient_num, diagnosed_by, first_name, second_name
       from diagnosis_patient
			 join patient
			 on patient.patient_id = diagnosis_patient.patient_id
			 join staff
			 on staff_id = diagnosed_by
group by diagnosed_by, first_name, second_name
having patient_num > 0
order by diagnosed_by;