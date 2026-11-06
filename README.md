# FastAPI Log Analyzer & Nginx Proxy Stack

A containerized application that parses server access logs, computes HTTP status code metrics, and serves them behind an Nginx reverse proxy with built-in health checks and resource guardrails.

---

## 🏗️ Architecture & Services

The stack runs two containerized services orchestrated via Docker Compose:

1. **`api` (FastAPI):** Python 3.11 backend application that parses `access.log` and exposes status code metrics.
2. **`frontend` (Nginx):** Lightweight Alpine web server acting as a reverse proxy on port `8080`.

---

## 🛠️ Prerequisites

Make sure you have the following installed on your Ubuntu environment:
- [Docker](https://docs.docker.com/engine/install/) (v20+ recommended)
- [Docker Compose](https://docs.docker.com/compose/) (v2+ plugin)

---

## 🚀 Getting Started (Quickstart)

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
   cd your-repo-name



mkdir -p logs
echo '127.0.0.1 - - [05/Nov/2026:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1024' > logs/access.log

docker compose up --build -d
docker ps