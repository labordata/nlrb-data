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
UNION
SELECT case_number
FROM filing
WHERE status != 'Closed'
UNION
SELECT raw_filing.case_number
FROM raw_filing
INNER JOIN
filing
USING (case_number)
WHERE raw_filing.name IS NOT filing.name OR
      raw_filing.city IS NOT filing.city OR
      raw_filing.state IS NOT filing.state OR
      raw_filing.date_filed IS NOT filing.date_filed OR 
      raw_filing.region_assigned IS NOT filing.region_assigned OR
      raw_filing.status IS NOT filing.status OR
      raw_filing.date_closed IS NOT filing.date_closed OR
      raw_filing.reason_closed IS NOT filing.reason_closed OR
      raw_filing.number_of_eligible_voters IS NOT filing.number_of_eligible_voters OR
      raw_filing.number_of_voters_on_petition_or_charge IS NOT filing.number_of_voters_on_petition_or_charge OR
      raw_filing.certified_representative IS NOT filing.certified_representative) t;
