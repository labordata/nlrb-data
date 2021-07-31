.DELETE_ON_ERROR:
SHELL=bash -e -o pipefail

DB_URL= https://github.com/labordata/nlrb-data/releases/download/nightly/nlrb.db.zip

export NLRB_START_DATE?=1950-01-01
export SCRAPER_RPM?=0

FILING_CHUNK?=head

.PHONY: update_db
update_db : filing.csv docket.csv participant.csv related_case.csv	\
            related_document.csv allegation.csv tally.csv | nlrb.db
	tail -n +2 filing.csv | sqlite3 nlrb.db -init scripts/filing.sql -bail
	cat docket.csv | sqlite3 nlrb.db -init scripts/docket.sql -bail
	cat participant.csv | sqlite3 nlrb.db -init scripts/participant.sql -bail
	cat related_case.csv | sqlite3 nlrb.db -init scripts/related_case.sql -bail
	cat related_document.csv | sqlite3 nlrb.db -init scripts/related_document.sql
	cat allegation.csv | sqlite3 nlrb.db -init scripts/allegation.sql -bail
	tail -n +2 tally.csv | sqlite3 nlrb.db -init scripts/tally.sql -bail

tally.csv :
	python scripts/tallies.py | wget --retry-connrefused --tries=100 -i - -O - | tr -d '\000' > $@

docket.csv : case_detail.json.stream
	cat $< | jq '.docket[] +  {case_number} | [.case_number, .date, .document, ."issued_by/filed_by", .url] | @csv' -r > $@

participant.csv : case_detail.json.stream
	cat $< | jq '.participants[] +  {case_number} | [.case_number, .participant, .type, .address, .phone_number] | @csv' -r > $@

related_document.csv : case_detail.json.stream
	cat $< | jq '.related_documents[] +  {case_number} | [.case_number, .name, .url] | @csv' -r > $@

allegation.csv : case_detail.json.stream
	cat $< | jq '.allegations[] +  {case_number} | [.case_number, .allegation] | @csv' -r > $@

related_case.csv : case_detail.json.stream
	cat $< | jq '.related_cases[] +  {case_number} | [.case_number, .related_case_number] | @csv' -r > $@

case_detail.json.stream : new_open_or_updated_cases.csv
	cat $< | python scripts/case_details.py | tr -d '\000' > $@

new_open_or_updated_cases.csv : filing.csv | nlrb.db
	- tail -n +2 $< | sqlite3 nlrb.db -init scripts/to_scrape.sql -bail | $(FILING_CHUNK) -7000 > $@

filing.csv :
	python scripts/filings.py | wget --retry-connrefused --tries=100 -i - -O - | tr -d '\000' > $@

nlrb.db : 
	(wget -O /tmp/$$.zip $(DB_URL) && unzip /tmp/$$.zip) || sqlite3 $@ < scripts/initialize.sql

