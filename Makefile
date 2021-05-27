export NLRB_START_DATE=1950-01-01
export SCRAPER_RPM=0

.PHONY: update_db
update_db : filing.csv docket.csv participant.csv tally.csv | nlrb.db
	tail -n +2 filing.csv | /usr/local/Cellar/sqlite/3.34.0/bin/sqlite3 nlrb.db -init scripts/filing.sql
	cat docket.csv | sqlite3 nlrb.db -init scripts/docket.sql
	cat participant.csv | sqlite3 nlrb.db -init scripts/participant.sql
	tail -n +2 tally.csv | sqlite3 nlrb.db -init scripts/tally.sql

tally.csv :
	python scripts/tallies.py | wget -i - -O - | tr -d '\000' > $@

docket.csv : case_detail.json.stream
	cat $< | jq '.docket[] +  {case_number} | [.case_number, .date, .document, ."issued_by/filed_by", .url] | @csv' -r > $@

participant.csv : case_detail.json.stream
	cat $< | jq '.participants[] +  {case_number} | [.case_number, .participant, .type, .address, .phone_number] | @csv' -r > $@

related_document.csv : case_detail.json.stream
	cat $< | jq '.participants[] +  {case_number} | [.case_number, .participant, .type, .address, .phone_number] | @csv' -r > $@

case_detail.json.stream : certification.csv
	cat $< | python scripts/case_details.py | tr -d '\000' > $@

certification.csv : new_open_or_updated_cases.csv
	cat $< | grep 'RC' > $@

new_open_or_updated_cases.csv : filing.csv | nlrb.db
	tail -n +2 filing.csv | sqlite3 nlrb.db -init scripts/to_scrape.sql > $@

filing.csv :
	python scripts/filings.py | wget -i - -O - | tr -d '\000' > $@

nlrb.db : 
	sqlite3 $@ < scripts/initialize.sql

