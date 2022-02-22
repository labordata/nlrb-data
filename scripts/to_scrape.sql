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

WITH overall_rate AS (
    SELECT
        count(*) / sum(julianday (last_checked_at) - julianday (updated_at)) AS rate,
        3 AS prior_weight
    FROM
        filing
    WHERE
        status != 'Closed'
)
    SELECT case_number FROM (
    SELECT
        case_number
    FROM
        filing
        INNER JOIN overall_rate ON 1 = 1
    WHERE
        status != 'Closed'
    ORDER BY
        - ((prior_weight + 1) / (prior_weight / rate + julianday (last_checked_at) - julianday (updated_at))) * (julianday ('now') - julianday (last_checked_at)) DESC
    LIMIT 400) t
    UNION
    SELECT
        raw_filing.case_number
    FROM
        raw_filing
    LEFT JOIN filing USING (case_number)
WHERE
    filing.case_number IS NULL

