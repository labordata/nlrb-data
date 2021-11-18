import sys
import subprocess
import time

url = sys.stdin.read().strip()

for _ in range(20):
    command_string = f"wget --max-redirect=0 --retry-connrefused --tries=100 {url} -O -"
    result = subprocess.run(command_string, shell=True, stderr=subprocess.PIPE)
    print(result.stderr.decode(), file=sys.stderr)
    if result.returncode == 0:
        break
    elif b'0 redirections exceeded' not in result.stderr:
        raise RuntimeError(result.stderr)
    time.sleep(5)
else:
    raise RuntimeError("Not able to download file")
