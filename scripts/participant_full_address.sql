BEGIN;

with stacked as (
  select
    "Case Number" as case_number,
    "Employer Account Name" as participant,
    'Employer' as type,
    'Employer' as subtype,
    "Employer Address1" as address_1,
    "Employer Address2" as address_2,
    "Employer Address City" as city,
    "Employer Address State" as state,
    "Employer Address ZipCode" as zip
  from
    participant_details
  where
    "Employer Account Name" is not null
    or "Employer Address1" is not null
    or "Employer Address2" is not null
    OR "Employer Address City" is not null
    OR "Employer Address ZipCode" is not null
  union
  select
    "Case Number",
    "Petitioner",
    'Petitioner',
    "Petitioner Party Type",
    "Petitioner Address1",
    "Petitioner Address2",
    "Petitioner Address City",
    "Petitioner Address State",
    "Petitioner Address ZipCode"
  from
    participant_details
  where
    "Petitioner" is not null
    or "Petitioner Party Type" is not null
    or "Petitioner Address1" is not null
    or "Petitioner Address2" is not null
    or "Petitioner Address City" is not null
    or "Petitioner Address State" is not null
    or "Petitioner Address ZipCode" is not null
  union
  select
    "Case Number",
    "Union Involved",
    'Union Involved',
    'Union',
    "Union Involved Address1",
    "Union Involved Address2",
    "Union Involved City",
    "Union Involved State",
    "Union Involved Zipcode"
  from
    participant_details
  where
    "Union Involved" is not null
    or "Union Involved Address1" is not null
    or "Union Involved Address2" is not null
    OR "Union Involved City" is not null
    OR "Union Involved State" is not null
    or "Union Involved Zipcode" is not null
  union
  select
    "Case Number",
    "Intervenor Account Name",
    'Intervenor',
    "Intervenor Party Type",
    "Intervenor Address1",
    "Intervenor Address2",
    "Intervenor Address City",
    "Intervenor Address State",
    "Intervenor Address Zipcode"
  from
    participant_details
  where
    "Intervenor Account Name" is not null
    or "Intervenor Party Type" is not null
    or "Intervenor Address1" is not null
    or "Intervenor Address2" is not null
    or "Intervenor Address City" is not null
    or "Intervenor Address State" is not null
    or "Intervenor Address Zipcode"
  union
  select
    "Case Number",
    "Charged Party Account Name",
    'Charged Party',
    "Charged Party Type",
    "Charged Party Address1",
    "Charged Party Address2",
    "Charged Party Address City",
    "Charged Party Address State",
    "Charged Party Address Zip"
  from
    participant_details
  where
    "Charged Party Account Name" is not null
    or "Charged Party Type" is not null
    or "Charged Party Address1" is not null
    or "Charged Party Address2" is not null
    or "Charged Party Address City" is not null
    or "Charged Party Address State" is not null
    or "Charged Party Address Zip"
  union
  select
    "Case Number",
    "Charging Party Account",
    'Charging Party',
    "Charging Party Type",
    "Charging Party Address1",
    "Charging Party Address2",
    "Charging Party City",
    "Charging Party State",
    "Charging Party Zip"
  from
    participant_details
  where
    "Charging Party Account" is not null
    or "Charging Party Type" is not null
    or "Charging Party Address1" is not null
    or "Charging Party Address2" is not null
    or "Charging Party City" is not null
    or "Charging Party State" is not null
    or "Charging Party Zip"
  union
  select
    "Case Number",
    "Involved Party Account Name",
    'Involved Party',
    "Involved Party Type",
    "Involved Party Address1",
    "Involved Party Address2",
    "Involved Party City",
    "Involved Party State",
    "Involved Party Zip"
  from
    participant_details
  where
    "Involved Party Account Name" is not null
    or "Involved Party Type" is not null
    or "Involved Party Address1" is not null
    or "Involved Party Address2" is not null
    or "Involved Party City" is not null
    or "Involved Party State" is not null
    or "Involved Party Zip"
),
unambiguous as (
  select
    case_number,
    participant
  from
    participant
    inner join stacked using (case_number, participant)
  group by
    case_number,
    participant
  having
    count(*) = 1
)
update
  participant
set
  address_1 = t.address_1,
  address_2 = t.address_2,
  city = t.city,
  state = t.state,
  zip = t.zip
from
  (
    select
    *
    from
      stacked
      inner join unambiguous using (case_number, participant)
  ) as t
where
  participant.case_number = t.case_number
  and participant.participant = t.participant;


DROP TABLE IF EXISTS unmatched_participant_details;

CREATE TABLE unmatched_participant_details AS
with stacked as (
  select
    "Case Number" as case_number,
    "Employer Account Name" as participant,
    'Employer' as type,
    'Employer' as subtype,
    "Employer Address1" as address_1,
    "Employer Address2" as address_2,
    "Employer Address City" as city,
    "Employer Address State" as state,
    "Employer Address ZipCode" as zip
  from
    participant_details
  where
    "Employer Account Name" is not null
    or "Employer Address1" is not null
    or "Employer Address2" is not null
    OR "Employer Address City" is not null
    OR "Employer Address ZipCode" is not null
  union
  select
    "Case Number",
    "Petitioner",
    'Petitioner',
    "Petitioner Party Type",
    "Petitioner Address1",
    "Petitioner Address2",
    "Petitioner Address City",
    "Petitioner Address State",
    "Petitioner Address ZipCode"
  from
    participant_details
  where
    "Petitioner" is not null
    or "Petitioner Party Type" is not null
    or "Petitioner Address1" is not null
    or "Petitioner Address2" is not null
    or "Petitioner Address City" is not null
    or "Petitioner Address State" is not null
    or "Petitioner Address ZipCode" is not null
  union
  select
    "Case Number",
    "Union Involved",
    'Union Involved',
    'Union',
    "Union Involved Address1",
    "Union Involved Address2",
    "Union Involved City",
    "Union Involved State",
    "Union Involved Zipcode"
  from
    participant_details
  where
    "Union Involved" is not null
    or "Union Involved Address1" is not null
    or "Union Involved Address2" is not null
    OR "Union Involved City" is not null
    OR "Union Involved State" is not null
    or "Union Involved Zipcode" is not null
  union
  select
    "Case Number",
    "Intervenor Account Name",
    'Intervenor',
    "Intervenor Party Type",
    "Intervenor Address1",
    "Intervenor Address2",
    "Intervenor Address City",
    "Intervenor Address State",
    "Intervenor Address Zipcode"
  from
    participant_details
  where
    "Intervenor Account Name" is not null
    or "Intervenor Party Type" is not null
    or "Intervenor Address1" is not null
    or "Intervenor Address2" is not null
    or "Intervenor Address City" is not null
    or "Intervenor Address State" is not null
    or "Intervenor Address Zipcode"
  union
  select
    "Case Number",
    "Charged Party Account Name",
    'Charged Party',
    "Charged Party Type",
    "Charged Party Address1",
    "Charged Party Address2",
    "Charged Party Address City",
    "Charged Party Address State",
    "Charged Party Address Zip"
  from
    participant_details
  where
    "Charged Party Account Name" is not null
    or "Charged Party Type" is not null
    or "Charged Party Address1" is not null
    or "Charged Party Address2" is not null
    or "Charged Party Address City" is not null
    or "Charged Party Address State" is not null
    or "Charged Party Address Zip"
  union
  select
    "Case Number",
    "Charging Party Account",
    'Charging Party',
    "Charging Party Type",
    "Charging Party Address1",
    "Charging Party Address2",
    "Charging Party City",
    "Charging Party State",
    "Charging Party Zip"
  from
    participant_details
  where
    "Charging Party Account" is not null
    or "Charging Party Type" is not null
    or "Charging Party Address1" is not null
    or "Charging Party Address2" is not null
    or "Charging Party City" is not null
    or "Charging Party State" is not null
    or "Charging Party Zip"
  union
  select
    "Case Number",
    "Involved Party Account Name",
    'Involved Party',
    "Involved Party Type",
    "Involved Party Address1",
    "Involved Party Address2",
    "Involved Party City",
    "Involved Party State",
    "Involved Party Zip"
  from
    participant_details
  where
    "Involved Party Account Name" is not null
    or "Involved Party Type" is not null
    or "Involved Party Address1" is not null
    or "Involved Party Address2" is not null
    or "Involved Party City" is not null
    or "Involved Party State" is not null
    or "Involved Party Zip"
)
select
  stacked.*
from
  stacked
  left join participant using (case_number, participant)
where
  participant.case_number is null
  and stacked.subtype != 'Individual'
  and stacked.participant is not null;
  
DROP TABLE participant_details;

COMMIT;
