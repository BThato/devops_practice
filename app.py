from fastapi import FastAPI, HTTPException
import os
import re
from collections import Counter

app = FastAPI(title="Log Analyzer API", version="1.0")

# Path to the access log file inside the container
LOG_FILE_PATH = os.getenv("LOG_FILE_PATH", "/app/logs/access.log")

@app.get("/")
def read_root():
    return {"message": "Log Analyzer API is running successfully"}

@app.get("/api/status-codes")
def get_status_codes():
    if not os.path.exists(LOG_FILE_PATH):
        # Graceful fallback for testing when log file isn't mounted yet
        return {
            "status": "warning",
            "message": f"Log file not found at {LOG_FILE_PATH}. Using sample metrics.",
            "status_code_counts": {"200": 120, "404": 15, "500": 2}
        }
    
    status_counts = Counter()
    # Regex to match HTTP status codes in standard Nginx/Apache log formats
    pattern = re.compile(r'"\s([1-5][0-9]{2})\s')

    try:
        with open(LOG_FILE_PATH, "r") as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    status_code = match.group(1)
                    status_counts[status_code] += 1
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error reading log file: {str(e)}")

    return {
        "status_code_counts": dict(status_counts)
    }