BEGIN;

CREATE TEMPORARY TABLE raw_participant (case_number text not null,
                     	                participant text,
		     	                type text,
		     	                address text,
			                phone_number text);

.mode csv
.import /dev/stdin raw_participant

DELETE FROM participant WHERE case_number IN (
       SELECT raw_participant.case_number
       FROM raw_participant
       LEFT JOIN
       participant
       USING (case_number, participant, type, address, phone_number)
       WHERE participant.case_number IS NULL);

select changes() || ' rows deleted from participant';

INSERT INTO participant(case_number,
                     	participant,
		     	type,
		     	address,
			phone_number)
SELECT raw_participant.*
FROM raw_participant
LEFT JOIN
participant
USING (case_number)
WHERE participant.case_number IS NULL;

select changes() || ' rows added to participant';

END;
