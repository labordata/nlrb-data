import os
import sys
import time

url = sys.stdin.read().strip()

for _ in range(20):
    command_string = f"wget --max-redirect=0 --retry-connrefused --tries=100 {url} -O -"
    exit_code = os.system(command_string)
    if exit_code == 0:
        break
    time.sleep(5)
else:
    raise RuntimeError("Not able to download file")
