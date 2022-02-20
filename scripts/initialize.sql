CREATE TABLE filing (case_number text not null primary key,
		     name text,
		     case_type text,
		     url text,
	             city text,
	             state text,
	             date_filed text,
	             region_assigned text,
	             status text,
	             date_closed text,
	             reason_closed text,
	             number_of_eligible_voters bint,
	             number_of_voters_on_petition_or_charge int,
	             certified_representative text,
		     created_at timestamp default CURRENT_TIMESTAMP,
		     updated_at timestamp default CURRENT_TIMESTAMP,
		     last_checked_at timestamp default CURRENT TIMESTAMP);


CREATE TABLE sought_unit(case_number text,
                         unit_sought text,
			 created_at timestamp default CURRENT_TIMESTAMP,
			 UNIQUE(case_number, unit_sought),
			 FOREIGN KEY(case_number) REFERENCES filing(case_number));


CREATE TABLE docket (case_number text not null,
                     date text,
		     document text,
		     actor text,
		     url text,
		     created_at timestamp default CURRENT_TIMESTAMP,
		     FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE participant (case_number text not null,
                     	  participant text,
		     	  type text,
		     	  address text,
			  phone_number text,
		          created_at timestamp default CURRENT_TIMESTAMP,
		     	  FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE document (case_number text not null,
                       document text,
		       url text,
		       created_at timestamp default CURRENT_TIMESTAMP,
		       FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE allegation (case_number text not null,
                         allegation text,
		         created_at timestamp default CURRENT_TIMESTAMP,			         FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE filing_group(root_case_number TEXT,
                        case_number TEXT NOT NULL PRIMARY KEY,
		        created_at timestamp default CURRENT_TIMESTAMP,
                        updated_at timestamp default CURRENT_TIMESTAMP);
			FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE voting_unit (voting_unit_id INTEGER PRIMARY KEY AUTOINCREMENT,
                          case_number text NOT NULL,
			  unit_id TEXT,
			  description,
		          created_at timestamp default CURRENT_TIMESTAMP,
			  UNIQUE(case_number, unit_id),
			  FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE TABLE election (election_id INTEGER PRIMARY KEY AUTOINCREMENT,
                       case_number text not null,
		       voting_unit_id INT,
                       date text,
		       tally_type text,
		       ballot_type text,
		       unit_size INT,
		       created_at timestamp default CURRENT_TIMESTAMP,
		       UNIQUE(case_number, voting_unit_id, date, ballot_type, tally_type),
		       FOREIGN KEY(voting_unit_id) REFERENCES voting_unit(voting_unit_id),
		       FOREIGN KEY(case_number) REFERENCES filing(case_number));

CREATE table election_result (election_id INTEGER PRIMARY KEY,
                              total_ballots_counted int,
			      void_ballots int,
			      challenged_ballots int,
			      challenges_are_determinative text,
			      runoff_required text,
			      union_to_certify text,
		              created_at timestamp default CURRENT_TIMESTAMP,
			      FOREIGN KEY(election_id) REFERENCES election(election_id));

CREATE table tally(election_id int,
                   option text,
		   votes int,
		   created_at timestamp default CURRENT_TIMESTAMP,
		   FOREIGN KEY(election_id) REFERENCES election(election_id));

  CREATE TABLE election_mode (
    case_number TEXT,
    name TEXT, --identical to [filing.name] after trim and max character limit
    city TEXT, --identical to [filing.city] after trim
    state TEXT, --identical to [filing.state]
    status TEXT, --32 mismatches with [filings.status], which is presumably more recent
    date_filed TEXT, --1 mismatch with [filing.date_filed]: case_number='14-RC-280405'
    date_closed TEXT, --1 mismatch with [filing.date_closed]: case_number='13-RD-281948'
    reason_closed TEXT, --1 mismatch with [filing.date_closed]: case_number in ('13-RD-281948', '21-RC-282430')
    election_mode TEXT,
    date_ballot_mailed TEXT,
    date_ballot_counted TEXT,
    date_election_scheduled TEXT,
    date_tally_scheduled TEXT,
    date_tallied TEXT,
    tally_type TEXT, --need election_id to match with [election.tally_type]
    ballot_type TEXT, --need election_id to match with [election.ballot_type]
    unit_id TEXT, --identical to [voting_unit.unit_id]
    ballots_impounded TEXT,
    number_of_eligible_voters INTEGER, --253 mismatches, when summed by case_number, with [election.unit_size]
    number_of_void_ballots INTEGER, --47 mismatches, when summed by case_number, with [election_result.void_ballots]
    labor_organization_1_name TEXT,
    votes_for_labor_organization_1 INTEGER,
    labor_organization_2_name TEXT,
    votes_for_labor_organization_2 INTEGER,
    labor_organization_3_name TEXT,
    votes_for_labor_organization_3 INTEGER,
    votes_cast_against_labor_org INTEGER,
    number_of_valid_votes_counted INTEGER, --250 mismatches, when summed by case_number, with [election_result.total_ballots_counted]; 905 mismatches with [tally.votes]
    number_of_challenged_ballots INTEGER, --108 mismatches, when summed by case_number, with [election_result.challenged_ballots]
    challenges_are_determinative TEXT, --34 mismatches, when summed by case_number, with [election_result.challenges_are_determinative]
    runoff_required TEXT, --1 mismatch, when summed by case_number, with [election_result.runoff_required]: case_number = '32-RC-210194'
    union_to_certify TEXT, --need election_id to match with [election_result.union_to_certify]
    unit_involved_in_petition TEXT, --need election_id to match with [sought_unit.unit_sought]
    bargaining_unit_determined TEXT,
    FOREIGN KEY(case_number) REFERENCES filings(case_number)
  );


