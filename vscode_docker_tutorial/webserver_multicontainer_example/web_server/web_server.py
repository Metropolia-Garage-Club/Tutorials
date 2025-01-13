import time
import redis
from flask import Flask

app = Flask(__name__)
# 'redis' hostname comes from the service name in docker-compose.yml
cache = redis.Redis(host='localhost', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def hello():
    count = get_hit_count()
    return f'Hello from Ubuntu Container! I have been seen {count} times.\n'

@app.route('/info')
def info():
    return 'This response is from a Flask server running on Ubuntu with Redis caching'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)