select group_concat(
  'update filing set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('filing');

select group_concat(
  'update allegation set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('allegation');

select group_concat(
  'update election set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('election');

select group_concat(
  'update tally set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('tally');

select group_concat(
  'update docket set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('docket');

select group_concat(
  'update election_result set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('election_result');

select group_concat(
  'update participant set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('participant');

select group_concat(
  'update voting_unit set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('voting_unit');

select group_concat(
  'update document set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('document');

select group_concat(
  'update sought_unit set '||name
    ||'= null where '||name||' = ''''', ';
') || ';' as sql_to_run
from
  pragma_table_info('sought_unit');
