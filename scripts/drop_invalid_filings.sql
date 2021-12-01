DELETE FROM filing
WHERE case_number NOT LIKE '%-%'
    OR length(case_number) != 12
    OR case_number = '18-RC-286901';





