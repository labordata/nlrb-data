UPDATE
    filing
SET
    updated_at = u.updated_at
FROM (
    SELECT
        case_number,
        MAX(filing.updated_at,
	    COALESCE(sought_unit.created_at, ''),
	    coalesce(docket.created_at, ''),
	    COALESCE(participant.created_at, ''),
	    coalesce(document.created_at, ''),
	    COALESCE(allegation.created_at, ''),
	    coalesce(filing_group.updated_at, ''),
	    COALESCE(election.created_at, ''),
	    coalesce(voting_unit.created_at, '')) updated_at
    FROM
        filing
    LEFT JOIN sought_unit USING (case_number)
    LEFT JOIN docket USING (case_number)
    LEFT JOIN participant USING (case_number)
    LEFT JOIN document USING (case_number)
    LEFT JOIN allegation USING (case_number)
    LEFT JOIN filing_group USING (case_number)
    LEFT JOIN election USING (case_number)
    LEFT JOIN voting_unit USING (case_number)) AS u
WHERE
    filing.case_number = u.case_number;

UPDATE filing
SET last_checked_at = updated_at
WHERE updated_at > last_checked_at;
