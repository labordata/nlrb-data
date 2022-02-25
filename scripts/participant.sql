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
       ON raw_participant.case_number = participant.case_number AND
          nullif(raw_participant.participant, '') IS participant.participant AND
	  nullif(raw_participant.type, '') IS participant.type AND
	  nullif(raw_participant.address, '')  IS participant.address AND
	  nullif(raw_participant.phone_number, '') IS participant.phone_number
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
WHERE participant.case_number IS NULL
AND (raw_participant.participant is not null OR
     raw_participant.type IS NOT NULL OR
     raw_participant.address IS NOT NULL OR
     raw_participant.phone_number IS NOT NULL);

select changes() || ' rows added to participant';

END;
