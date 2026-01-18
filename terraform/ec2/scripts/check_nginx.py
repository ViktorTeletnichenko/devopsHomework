#!/usr/bin/env python3
import json
import sys
import time
import urllib.request
import urllib.error

query = json.load(sys.stdin)
url = query["url"]

status = 0
for _ in range(30):  # ~60s total
    try:
        with urllib.request.urlopen(url, timeout=3) as r:
            status = r.getcode()
            if status == 200:
                break
    except Exception:
        status = 0
    time.sleep(2)

print(json.dumps({"status_code": str(status)}))
