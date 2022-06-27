/* Show patient information on patient receiving the priciest Stenting service. */

select patient.patient_id, id_personal_number, name, surname
from patient_info, patient
where patient.patient_id = patient_info.patient_id
    and patient.patient_id in
      (select patient_id from medical_service_patient
                          where service_type in
                                (select service_type_id from medical_service_type
                                                        where service_price =
                                                              (select max(service_price) from medical_service_type where service_name like '%Stenting%' )
                                                          )
        );
