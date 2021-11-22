import csv
import sys
import json
import os

from nlrb import NLRB
from scrapelib.cache import FileCache
import scrapelib
import tqdm
import time

max_elapsed = int(os.environ.get('MAX_ELAPSED', 5.5 * 60 * 60))
begin_run = int(os.environ.get('BEGIN_NLRB_RUN', 0))
s = NLRB(retry_attempts=5, requests_per_minute=int(os.environ['SCRAPER_RPM']))

s.cache_storage = FileCache('cache-directory')
s.cache_write_only = False

cases = list(csv.reader(sys.stdin))

pbar = tqdm.tqdm(cases)
for case_number, in pbar:
    if begin_run:
        elapsed_time = time.time() - begin_run
        if elapsed_time >= max_elapsed:
            break

    pbar.set_description(case_number)

    try:
        case_details = s.case_details(case_number)
    except scrapelib.HTTPError as e:
        if e.response.status_code == 404:
            continue
        else:
            raise

    print(json.dumps(case_details, default=str))
