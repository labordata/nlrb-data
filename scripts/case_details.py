import csv
import sys
import json
import os

from nlrb import NLRB
from scrapelib.cache import FileCache
import scrapelib
import tqdm


s = NLRB(retry_attempts=5, requests_per_minute=int(os.environ['SCRAPER_RPM']))

s.cache_storage = FileCache('cache-directory')
s.cache_write_only = False

reader = csv.reader(sys.stdin)

pbar = tqdm.tqdm(reader)
for case_number, in pbar:
    pbar.set_description(case_number)

    try:
        case_details = s.case_details(case_number)
    except scrapelib.HTTPError as e:
        if e.response.status_code == 404:
            continue
        else:
            raise

    print(json.dumps(case_details, default=str))
