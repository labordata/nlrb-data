# National Labor Relations Board Cases
Daily refreshed data on representation certification cases from nlrb.gov. Data is updated nightly at about 10:00 pm Eastern.

- [sqlite database](https://labordata.github.io/nlrb-data/nlrb.db.zip)
- CSVs TK

This repo contains code to build and update a database of representation certification cases published on the National Labor Relations Board's website. This diagram shows the different tables and variables contained in the database.

![ERD Diagram](docs/erd.png)

## Data Limitations
1. This database only contains representation certification cases, i.e. cases with a "RC" in their case numbers. This is just one of many types of cases available on the National Labor Relations Board website. We may extend the database to cover more types of cases in the future.
2. The data starts around 2010. See https://github.com/labordata/nlrb-cats/ for data from the previous system
3. The update process starts by downloading a CSV of all the cases within a specified time period from the nlrb.gov website. However, repeatingly requesting the same information from nlrb.gov results in spreadsheets with slightly different contents. We might be a bit out of date if the last CSV we downloaded missed a recent case.
