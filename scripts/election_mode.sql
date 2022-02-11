--My failed attempt to assign a unique election_id to each row in election_mode table; case numbers like 06-RC-257937 make uniqueness hard
SELECT c.election_id, a.*
FROM election_mode a
LEFT JOIN voting_unit b
ON a.case_number = b.case_number
AND a.unit_id  = b.unit_id
LEFT JOIN election c
ON b.voting_unit_id = c.voting_unit_id
AND a.tally_type = c.tally_type
AND a.tally_category = c. ballot_type
INNER JOIN election_result d
ON c.election_id = d.election_id
AND CASE WHEN a.challenges_are_determinative = 'Y' THEN a.challenges_are_determinative = d.challenges_are_determinative ELSE 1 END