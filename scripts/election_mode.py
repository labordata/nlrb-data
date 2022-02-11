import pandas as pd
import sqlite3


con = sqlite3.connect('nlrb.db')

cur = con.cursor()

cur.execute(
  """
  SELECT name FROM sqlite_master WHERE type='table' AND name='election_mode';
  """
)

#if election_mode table is not in nlrb.db, create and populate it
if cur.fetchone() is None:
  election_mode_df = pd.read_excel(
    'raw/NLRB-2022-000194_final-Election_results_with_election_mode_Jan_2017-Nov_2021.xlsx',
    sheet_name = 'Sheet1',
    header = 4
  )

  cur.execute(
    """
    CREATE TABLE IF NOT EXISTS election_mode (
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
    """
  )

  #get column names from election_mode table
  cur.execute('SELECT * FROM election_mode LIMIT 5')

  col_names = [description[0] for description in cur.description]

  election_mode_df.rename(columns = dict(zip(election_mode_df.columns, col_names))) \
                  .to_sql('election_mode',
                          con,
                          if_exists = 'replace',
                          index = False)

con.commit()

con.close()