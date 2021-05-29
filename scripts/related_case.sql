CREATE TEMPORARY TABLE raw_related_case (root_case_number text,
                                         case_number text);


.mode csv
.import /dev/stdin raw_related_case

UPDATE filing_group
set root_case_number = root,
    updated_at = CURRENT_TIMESTAMP
FROM
  (select distinct min(root_case_number, case_number) as root,
		   max(root_case_number, case_number) as leaf
   from raw_related_case
   group by leaf
   order by root,
	    leaf) bush
where bush.leaf = case_number
AND filing_group.root_case_number != root;

select changes();
