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
			  subtype text,
		     	  address text,
			  address_1 text,
			  address_2 text,
			  city text,
			  state text,
			  zip text,
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
    election_id INTEGER,
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
    bargaining_unit_determined TEXT,
    FOREIGN KEY(case_number) REFERENCES filings(case_number)
    FOREIGN KEY(election_id) REFERENCES election(election_id)
  );


