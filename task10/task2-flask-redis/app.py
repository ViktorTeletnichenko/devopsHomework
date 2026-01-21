import os

from flask import Flask
from redis import Redis

app = Flask(__name__)

redis_host = os.environ.get("REDIS_HOST", "127.0.0.1")
redis_port = int(os.environ.get("REDIS_PORT", "6379"))

redis_client = Redis(host=redis_host, port=redis_port, decode_responses=True)


@app.get("/")
def index():
    count = redis_client.incr("hits")
    return f"hits: {count}\n"


if __name__ == "__main__":
    port = int(os.environ.get("FLASK_PORT", "5000"))
    app.run(host="0.0.0.0", port=port)
