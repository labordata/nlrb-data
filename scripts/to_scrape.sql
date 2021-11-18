-- add trigger for updated_at

CREATE TEMPORARY TABLE raw_filing (name text,
                                   case_number text,
	                           city text,
	                           state text,
	                           date_filed text,
	                           region_assigned text,
	                           status text,
	                           date_closed text,
	                           reason_closed text,
	                           number_of_eligible_voters int,
	                           number_of_voters_on_petition_or_charge int,
	                           certified_representative text,
	                           unit_sought text);

.mode csv
.import /dev/stdin raw_filing

SELECT DISTINCT * FROM (
SELECT raw_filing.case_number
FROM raw_filing
LEFT JOIN
filing
USING (case_number)
WHERE filing.case_number IS NULL
) t
ORDER BY case_number;
