/* How much money did each patient already pay for services? */

select distinct
    patient.patient_id,
       sum(service_price) as total_payment
from medical_service_type
		join medical_service_patient
		on medical_service_patient.service_type = medical_service_type.service_type_id
		join medical_record
		on medical_record.service_patient_id = medical_service_patient.service_patient_id
		join patient
		on patient.patient_id = medical_service_patient.patient_id
where payment_completed = true
group by patient.patient_id;