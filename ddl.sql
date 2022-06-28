create table asset_type
(
    asset_type_id int unsigned auto_increment
        primary key,
    type_name     varchar(100) not null
);

create table asset_instances
(
    asset_id          int unsigned auto_increment
        primary key,
    purchase_price    int unsigned                  not null,
    upc_number        varchar(12)                   null,
    brand             varchar(60)                   not null,
    model             varchar(60)                   null,
    expected_lifetime int unsigned                  not null,
    warranty          smallint unsigned default '0' not null,
    year              smallint unsigned             not null,
    asset_type_id     int unsigned                  not null,
    constraint asset_instances_FK_asset_type_id
        foreign key (asset_type_id) references asset_type (asset_type_id)
            on update cascade
);

create table branch
(
    branch_id   int unsigned auto_increment
        primary key,
    branch_name varchar(40)  not null,
    description varchar(150) null,
    address     varchar(200) not null
);

create table department
(
    department_id int unsigned auto_increment
        primary key,
    dep_name      varchar(40) not null,
    description   text        null
);

create table diagnosis_type
(
    diagnosis_id   int unsigned auto_increment
        primary key,
    diagnosis_name varchar(150) not null,
    description    text         null,
    department_id  int unsigned not null,
    constraint diagnosis_type_FK_department_id
        foreign key (department_id) references department (department_id)
            on update cascade
);

create table doctor_title
(
    title_id smallint unsigned not null,
    title    varchar(20)       not null,
    constraint doctor_title_doctor_title_id_uindex
        unique (title_id),
    constraint doctor_title_title_uindex
        unique (title)
);

create table employee_role
(
    role_id    int unsigned auto_increment
        primary key,
    profession varchar(100) not null
);

create table medical_service_type
(
    service_type_id         int unsigned auto_increment
        primary key,
    service_name            varchar(100) not null,
    description             text         null,
    service_price           int unsigned not null,
    performed_by_department int unsigned not null
);

create table patient
(
    patient_id int unsigned auto_increment
        primary key,
    name       varchar(100) not null,
    surname    varchar(100) not null
);

create table patient_info
(
    patient_id         int unsigned auto_increment
        primary key,
    middle_name        varchar(100) null,
    id_personal_number varchar(10)  not null,
    mobile             varchar(13)  not null,
    email              varchar(40)  null,
    profession         varchar(100) not null,
    date_of_birth      date         not null,
    constraint patient_info_FK_patient_id
        foreign key (patient_id) references patient (patient_id)
            on update cascade on delete cascade
);

create table room
(
    room_id        int unsigned auto_increment,
    last_renovated date         not null,
    branch_id      int unsigned not null,
    department_id  int unsigned not null,
    primary key (room_id, branch_id),
    constraint room_FK_branch_id
        foreign key (branch_id) references branch (branch_id)
            on update cascade,
    constraint room_FK_department_id
        foreign key (department_id) references department (department_id)
            on update cascade
);

create table asset_room
(
    asset_id  int unsigned auto_increment,
    room_id   int unsigned             not null,
    quantity  int unsigned default '1' not null,
    branch_id int unsigned             not null,
    primary key (asset_id, room_id, branch_id),
    constraint asset_room_FK_branch_id
        foreign key (branch_id) references branch (branch_id)
            on update cascade,
    constraint equipment_FK_asset_id
        foreign key (asset_id) references asset_instances (asset_id)
            on update cascade on delete cascade,
    constraint equipment_FK_room_id
        foreign key (room_id) references room (room_id)
            on update cascade
);

create index equipment_FK_1
    on asset_room (room_id);

create table patient_room_stationary
(
    patient_id int unsigned not null
        primary key,
    room_id    int unsigned not null,
    branch_id  int unsigned not null,
    constraint patient_room_stationary_FK_patient_id
        foreign key (patient_id) references patient (patient_id)
            on delete cascade,
    constraint stationary_patients_room_FK_room_id_branch_id
        foreign key (room_id, branch_id) references room (room_id, branch_id)
            on update cascade
);

create table staff
(
    staff_id       int unsigned auto_increment
        primary key,
    first_name     varchar(100) not null,
    second_name    varchar(100) not null,
    middle_name    varchar(300) null,
    employed_since date         not null,
    salary         int unsigned not null,
    date_of_birth  date         not null
);

create table doctor
(
    staff_id          int unsigned                  not null
        primary key,
    department_id     int unsigned                  not null,
    grade             int unsigned                  not null,
    appointment_price int unsigned                  not null,
    title_id          smallint unsigned default '1' not null,
    constraint doctor_FK_department_id
        foreign key (department_id) references department (department_id)
            on update cascade,
    constraint doctor_FK_staff_id
        foreign key (staff_id) references staff (staff_id)
            on update cascade on delete cascade,
    constraint doctor_FK_title_id
        foreign key (title_id) references doctor_title (title_id)
            on update cascade,
    constraint doctor_check_grade
        check (`grade` between 0 and 5)
);

create table appointment
(
    appointment_id    int unsigned auto_increment
        primary key,
    booking_datetime  datetime             not null,
    assigned_to       int unsigned         not null,
    booked_by         int unsigned         not null,
    due_datetime      datetime             not null,
    payment_completed tinyint(1) default 0 not null,
    constraint appointment_FK_doctor_staff_id
        foreign key (assigned_to) references doctor (staff_id)
            on update cascade,
    constraint appointment_FK_patient_id
        foreign key (booked_by) references patient (patient_id)
            on update cascade
);

create index appointment_FK
    on appointment (assigned_to);

create index appointment_FK_1
    on appointment (booked_by);

create table diagnosis_patient
(
    diagnosis_id                 int unsigned not null,
    patient_id                   int unsigned not null,
    patient_specific_description text         null,
    diagnosed_by                 int unsigned null,
    diagnosis_since              date         not null,
    primary key (diagnosis_id, patient_id),
    constraint diagnosis_patient_FK_diagnosis_type_id
        foreign key (diagnosis_id) references diagnosis_type (diagnosis_id)
            on update cascade,
    constraint diagnosis_patient_FK_doctor_staff_id
        foreign key (diagnosed_by) references doctor (staff_id)
            on update cascade,
    constraint diagnosis_patient_FK_patient_id
        foreign key (patient_id) references patient (patient_id)
            on update cascade on delete cascade
);

create index diagnosis_patient_FK_1
    on diagnosis_patient (patient_id);

create index diagnosis_patient_FK_2
    on diagnosis_patient (diagnosed_by);

create index doctor_FK_1
    on doctor (department_id);

create table employee
(
    staff_id      int unsigned not null
        primary key,
    employee_role int unsigned not null,
    constraint employee_FK_employee_id
        foreign key (employee_role) references employee_role (role_id)
            on update cascade,
    constraint employee_FK_staff_id
        foreign key (staff_id) references staff (staff_id)
            on update cascade on delete cascade
);

create index employee_FK_1
    on employee (employee_role);

create table medical_service_patient
(
    service_patient_id int unsigned auto_increment
        primary key,
    performed_by       int unsigned not null,
    patient_id         int unsigned not null,
    service_type       int unsigned not null,
    payment_completed  bit          not null,
    datetime           datetime     null,
    constraint medical_service_FK_doctor_staff_id
        foreign key (performed_by) references doctor (staff_id)
            on update cascade,
    constraint medical_service_FK_patient_id
        foreign key (patient_id) references patient (patient_id)
            on update cascade,
    constraint medical_service_FK_service_type_id
        foreign key (service_type) references medical_service_type (service_type_id)
            on update cascade
);

create table medical_record
(
    record_id          int unsigned auto_increment
        primary key,
    written_by         int unsigned not null,
    title              varchar(100) not null,
    body               text         not null,
    datetime           datetime     not null,
    service_patient_id int unsigned not null,
    constraint health_record_FK_service_patient_id
        foreign key (service_patient_id) references medical_service_patient (service_patient_id)
            on update cascade,
    constraint health_records_FK_doctor_staff_id
        foreign key (written_by) references doctor (staff_id)
            on update cascade
);

create index health_records_FK
    on medical_record (written_by);

create index medical_service_FK
    on medical_service_patient (performed_by);

create index medical_service_FK_1
    on medical_service_patient (patient_id);

create index medical_service_FK_2
    on medical_service_patient (service_type);

create table nurse
(
    staff_id      int unsigned not null
        primary key,
    department_id int unsigned not null,
    grade         int unsigned not null,
    constraint nurse_FK_department_id
        foreign key (department_id) references department (department_id)
            on update cascade,
    constraint nurse_FK_staff_id
        foreign key (staff_id) references staff (staff_id)
            on update cascade on delete cascade,
    constraint nurse_check_grade
        check (`grade` between 0 and 5)
);

create index nurse_FK_1
    on nurse (department_id);

create table receptionist
(
    staff_id     int unsigned not null
        primary key,
    graduated_in varchar(100) not null,
    room_id      int unsigned not null,
    branch_id    int unsigned not null,
    constraint receptionist_FK_room
        foreign key (room_id, branch_id) references room (room_id, branch_id)
            on delete cascade,
    constraint receptionist_FK_staff_id
        foreign key (staff_id) references staff (staff_id)
            on update cascade on delete cascade
);

