from fastapi import FastAPI
import os

app = FastAPI(title="Log Analyzer API")

@app.get("/api/metrics")
def get_log_metrics():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    log_path = os.path.join(base_dir, "access.log")
    
    if not os.path.exists(log_path):
        return {"error": f"access.log not found at expected path: {log_path}"}
    
    total_requests = 0
    status_counts = {}
    
    with open(log_path, "r") as f:
        for line in f:
            total_requests += 1
            parts = line.split()
            
            # Look for a standard 3-digit HTTP status code (e.g., 200, 404, 500)
            for part in parts:
                if part.isdigit() and len(part) == 3 and part.startswith(('1', '2', '3', '4', '5')):
                    status = part
                    status_counts[status] = status_counts.get(status, 0) + 1
                    break  # Found the status code for this line, move to next line

    return {
        "total_requests": total_requests,
        "status_code_breakdown": status_counts
    }