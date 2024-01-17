CREATE TABLE subject (
    subject_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    birth_date date   NOT NULL,
    sex        text   NOT NULL
);

CREATE TABLE assessment1 (
    assessment_id bigint                   PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id    bigint                   NOT NULL REFERENCES subject,
    created_at    timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    height        numeric,
    weight        numeric,
    sodium_level  numeric
);

CREATE TABLE condition (
    condition_id bigint                   PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id   bigint                   NOT NULL REFERENCES subject,
    created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_system  text                     NOT NULL,
    code         text                     NOT NULL
);

CREATE TABLE medication (
    medication_id bigint                   PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id    bigint                   NOT NULL REFERENCES subject,
    created_at    timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_system   text                     NOT NULL,
    code          text                     NOT NULL,
    amount        numeric                  NOT NULL
);

CREATE TABLE procedure (
    procedure_id bigint                   PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id   bigint                   NOT NULL REFERENCES subject,
    created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_system  text                     NOT NULL,
    code         text                     NOT NULL
);

CREATE TABLE phenotype (
    phenotype_id    bigint                       PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id      bigint                       NOT NULL REFERENCES subject,
    created_at      timestamp with time zone     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code_system     text                         NOT NULL,
    code            text                         NOT NULL,
    number_value    numeric,
    unit            text,
    text_value      text,
    date_time_value timestamp without time zone,
    boolean_value   boolean
);

COPY subject (subject_id, birth_date, sex) FROM '/docker-entrypoint-initdb.d/subject.csv' DELIMITER ',' CSV HEADER;
COPY assessment1 (subject_id, created_at, height, weight, sodium_level) FROM '/docker-entrypoint-initdb.d/assessment1.csv' DELIMITER ',' CSV HEADER;
COPY condition (subject_id, created_at, code_system, code) FROM '/docker-entrypoint-initdb.d/condition.csv' DELIMITER ',' CSV HEADER;
COPY medication (subject_id, created_at, code_system, code, amount) FROM '/docker-entrypoint-initdb.d/medication.csv' DELIMITER ',' CSV HEADER;
COPY procedure (subject_id, created_at, code_system, code) FROM '/docker-entrypoint-initdb.d/procedure.csv' DELIMITER ',' CSV HEADER;
COPY phenotype (subject_id, created_at, code_system, code, number_value, unit, text_value, date_time_value, boolean_value) FROM '/docker-entrypoint-initdb.d/phenotype.csv' DELIMITER ',' CSV HEADER;
