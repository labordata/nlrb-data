BEGIN;

CREATE TEMPORARY TABLE raw_election_mode (
    case_number TEXT,
    name TEXT, 
    city TEXT, 
    state TEXT, 
    status TEXT, 
    date_filed TEXT, 
    date_closed TEXT,
    reason_closed TEXT, 
    election_mode TEXT,
    date_ballot_mailed TEXT,
    date_ballot_counted TEXT,
    date_election_scheduled TEXT,
    date_tally_scheduled TEXT,
    date_tallied TEXT,
    tally_type TEXT, 
    ballot_type TEXT, 
    unit_id TEXT, 
    ballots_impounded TEXT,
    number_of_eligible_voters INTEGER, 
    number_of_void_ballots INTEGER,
    labor_organization_1_name TEXT,
    votes_for_labor_organization_1 INTEGER,
    labor_organization_2_name TEXT,
    votes_for_labor_organization_2 INTEGER,
    labor_organization_3_name TEXT,
    votes_for_labor_organization_3 INTEGER,
    votes_cast_against_labor_org INTEGER,
    number_of_valid_votes_counted INTEGER, 
    number_of_challenged_ballots INTEGER, 
    challenges_are_determinative TEXT, 
    runoff_required TEXT, 
    union_to_certify TEXT,
    unit_involved_in_petition TEXT, 
    bargaining_unit_determined TEXT
  );

.mode csv
.import /dev/stdin raw_election_mode


INSERT INTO election_mode
with election_full as (
  select
    *
  from
    election
    inner join voting_unit using (voting_unit_id)
)
select
  ef.election_id,
  rem.*
from
  raw_election_mode rem
  left join election_full ef on rem.case_number = ef.case_number
  and rem.unit_id = ef.unit_id
  and (
    rem.ballot_type = ef.ballot_type
    or rem.ballot_type = 'Self Determination'
  )
  and rem.date_tallied = date
  and rem.tally_type = coalesce(ef.tally_type, 'Initial');

END;
