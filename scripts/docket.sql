BEGIN;

CREATE TEMPORARY TABLE raw_docket (case_number text not null,
                                   date text,
		                   document text,
				   actor text,
		                   url text);

.mode csv
.import /dev/stdin raw_docket
.output stderr

DELETE FROM docket WHERE case_number IN (
       SELECT raw_docket.case_number
       FROM raw_docket
       LEFT JOIN
       docket
       ON raw_docket.case_number = docket.case_number AND
           nullif(raw_docket.date, '') IS docket.date AND
	   raw_docket.document = docket.document AND
	   nullif(raw_docket.actor, '') IS docket.actor AND
	   nullif(raw_docket.url, '') IS docket.url
       WHERE docket.case_number IS NULL);

select changes() || ' rows deleted from docket';

INSERT INTO docket(case_number,
                   date,
		   document,
		   actor,
		   url)
SELECT raw_docket.*
FROM raw_docket
LEFT JOIN
docket
USING (case_number)
WHERE docket.case_number IS NULL;

select changes() || ' rows added to docket';

END;

