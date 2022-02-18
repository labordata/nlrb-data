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


		   
