BEGIN;

CREATE TEMPORARY TABLE t_raw_filing (name text,
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

CREATE TEMPORARY TABLE t_new (case_number text);

.mode csv
.import /dev/stdin t_raw_filing

.import new_cases.csv t_new

CREATE TEMPORARY TABLE raw_filing AS
SELECT t_raw_filing.*
FROM t_raw_filing
INNER JOIN t_new
USING(case_number);

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

