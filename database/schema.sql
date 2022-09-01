CREATE TABLE subject (
    subject_id bigint       NOT NULL GENERATED ALWAYS AS IDENTITY,
    birth_date date         NOT NULL,
    sex        character(1) NOT NULL,
    PRIMARY KEY (subject_id)
);

CREATE TABLE assessment1 (
    assessment_id bigint                  NOT NULL GENERATED ALWAYS AS IDENTITY,
    subject_id    bigint                  NOT NULL REFERENCES subject,
    created_at    timestamp with timezone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    height        numeric,
    weight        numeric,
    PRIMARY KEY (assessment_id)
);

COPY subject (subject_id, birth_date, sex) FROM '/var/lib/postgresql/subject.csv' DELIMITER ',' CSV HEADER;
COPY assessment1 (subject_id, created_at, height, weight) FROM '/var/lib/postgresql/assessment1.csv' DELIMITER ',' CSV HEADER;
