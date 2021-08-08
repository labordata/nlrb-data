delete from filing where case_number not like '%-%' or length(case_number) != 12;
