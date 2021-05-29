BEGIN;

CREATE TEMPORARY TABLE raw_allegation (case_number text not null,
                     	               allegation text);

.mode csv
.import /dev/stdin raw_allegation

DELETE
FROM allegation
WHERE case_number IN
    (SELECT raw_allegation.case_number
     FROM raw_allegation
     LEFT JOIN allegation USING (case_number,
			         allegation)
     WHERE allegation.case_number IS NULL);

select changes() || ' rows deleted from allegation';

INSERT INTO allegation(case_number, allegation)
SELECT raw_allegation.*
FROM raw_allegation
LEFT JOIN allegation USING (case_number)
WHERE allegation.case_number IS NULL;

select changes() || ' rows added to allegation';

END;
