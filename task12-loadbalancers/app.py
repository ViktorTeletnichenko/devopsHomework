import os
import socket
import time

import redis
from flask import Flask, jsonify

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))


def _redis_client():
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


@app.route("/")
def index():
    hostname = socket.gethostname()
    now = time.strftime("%Y-%m-%d %H:%M:%S")
    hits = None
    error = None
    try:
        hits = _redis_client().incr("hits")
    except Exception as exc:
        error = str(exc)

    payload = {
        "service": "python-app",
        "hostname": hostname,
        "time": now,
        "hits": hits,
        "redis_error": error,
    }
    return jsonify(payload)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
