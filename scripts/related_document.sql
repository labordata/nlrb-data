BEGIN;

CREATE TEMPORARY TABLE raw_document (case_number text not null,
                     	             document text,
		     	             url text);

.mode csv
.import /dev/stdin raw_document

DELETE
FROM document
WHERE case_number IN
    (SELECT raw_document.case_number
     FROM raw_document
     LEFT JOIN document USING (case_number,
			       document,
			       url)
     WHERE document.case_number IS NULL);

select changes() || ' rows deleted from document';

INSERT INTO document(case_number, document, url)
SELECT raw_document.*
FROM raw_document
LEFT JOIN document USING (case_number)
WHERE document.case_number IS NULL;

select changes() || ' rows added to document';

END;
