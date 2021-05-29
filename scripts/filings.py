import datetime
import os
import time

from nlrb import NLRB


DATE_START_STR = os.environ['NLRB_START_DATE']

if DATE_START_STR == '0':
    DATE_START = datetime.datetime.now() - datetime.timedelta(days=365)
else:
    DATE_START = datetime.datetime.strptime(DATE_START_STR,
                                            '%Y-%m-%d')

s = NLRB()

filing_csv = s.filings(case_types=['R'], date_start=DATE_START)

time.sleep(2)
print(filing_csv)
