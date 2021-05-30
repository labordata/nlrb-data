BEGIN;

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

INSERT INTO filing (name,
                    case_number,
		    city,
		    state,
		    date_filed,
		    region_assigned,
		    status,
		    date_closed,
		    reason_closed,
		    number_of_eligible_voters,
		    number_of_voters_on_petition_or_charge,
		    certified_representative)
SELECT raw_filing.name,
       raw_filing.case_number,
       raw_filing.city,
       raw_filing.state,
       raw_filing.date_filed,
       raw_filing.region_assigned,
       raw_filing.status,
       raw_filing.date_closed,
       raw_filing.reason_closed,
       raw_filing.number_of_eligible_voters,
       raw_filing.number_of_voters_on_petition_or_charge,
       raw_filing.certified_representative
FROM raw_filing
LEFT JOIN filing USING (case_number)
WHERE filing.case_number IS NULL
GROUP BY raw_filing.case_number;
select changes() || ' rows insert into filing';

UPDATE filing
      set name = raw_filing.name,
          city = raw_filing.city,
          state = raw_filing.state,
          date_filed = raw_filing.date_filed, 
          region_assigned = raw_filing.region_assigned,
          status = raw_filing.status,
          date_closed = raw_filing.date_closed,
          reason_closed = raw_filing.reason_closed,
          number_of_voters_on_petition_or_charge = raw_filing.number_of_voters_on_petition_or_charge,
          updated_at = CURRENT_TIMESTAMP
FROM raw_filing
WHERE raw_filing.case_number = filing.case_number AND (
      raw_filing.name IS NOT filing.name OR
      raw_filing.city IS NOT filing.city OR
      raw_filing.state IS NOT filing.state OR
      raw_filing.date_filed IS NOT filing.date_filed OR 
      raw_filing.region_assigned IS NOT filing.region_assigned OR
      raw_filing.status IS NOT filing.status OR
      raw_filing.date_closed IS NOT filing.date_closed OR
      raw_filing.reason_closed IS NOT filing.reason_closed OR
      raw_filing.number_of_voters_on_petition_or_charge IS NOT filing.number_of_voters_on_petition_or_charge);

select changes() || ' rows updated in filing';

DELETE FROM sought_unit WHERE case_number in (
SELECT raw_filing.case_number
FROM raw_filing
LEFT JOIN sought_unit
USING (case_number, unit_sought)
WHERE sought_unit.case_number is NULL);

select changes() || ' rows deleted from sought_unit';

INSERT INTO sought_unit (case_number, unit_sought)
SELECT DISTINCT raw_filing.case_number, raw_filing.unit_sought
FROM raw_filing
LEFT JOIN sought_unit
USING (case_number)
WHERE sought_unit.case_number is NULL;

select changes() || ' rows inserted into sought_unit';

INSERT INTO filing_group (root_case_number, case_number)
SELECT distinct case_number, case_number
FROM raw_filing
WHERE case_number NOT IN (select case_number from filing_group);

END;

