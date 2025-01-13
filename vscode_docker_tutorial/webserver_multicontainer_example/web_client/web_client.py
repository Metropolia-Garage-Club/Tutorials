import requests
import time
from datetime import datetime

def main():
    # Use the service name from docker-compose.yml instead of localhost
    server_url = 'http://web_server:5000'
    
    while True:
        try:
            # Make requests to both endpoints
            response1 = requests.get(f"{server_url}/")
            response2 = requests.get(f"{server_url}/info")
            
            # Print timestamp and responses
            print(f"\n[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}]")
            print(f"Root endpoint response: {response1.text}")
            print(f"Info endpoint response: {response2.text}")
            print("Request made from Python-based container")
            
        except requests.exceptions.RequestException as e:
            print(f"Error connecting to server: {e}")
        
        time.sleep(5)

if __name__ == '__main__':
    # Initial delay to ensure server is fully started
    time.sleep(3)
    main()