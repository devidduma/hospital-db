/* How much money did each patient already pay for services? */

select distinct
    patient.patient_id,
       sum(service_price) over (
           partition by patient.patient_id
           ) as total_payment
from medical_service_type,
            medical_service_patient,
            medical_record,
            patient
where service_type = medical_service_type.service_type_id
and medical_record.service_patient_id = medical_service_patient.service_patient_id
and patient.patient_id = medical_service_patient.patient_id
and payment_completed = 1;
