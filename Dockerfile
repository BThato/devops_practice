
# #Use an official lightweight Python base Images 
# FROM python:3.11-slim

# #Set the working Directory inside teh container
# WORKDIR /app


# # Install system dependencies including curl for healthchecks
# RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# #Copy requirements first to leverage Docker layers caching
# COPY requirements.txt .

# #Install Python dependencies without caching pip package to keep image small
# RUN pip install --no-cache-dir -r requirements.txt

# #Copy the rest of your project files (app.py and access.log) into the container

# COPY . .

# EXPOSE 8000

# CMD ["uvicorn", "app:app", "--host", "0.0.0.0","--port", "8000"]


# Stage 1: Build dependencies and wheels
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system build dependencies if any Python packages require compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies into a local user/target directory
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Final lightweight production image
FROM python:3.11-slim AS runner

WORKDIR /app

# Create a non-root user for security best practices
RUN useradd --create-home appuser
USER appuser

# Copy installed python packages from the builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY . /app

# Expose FastAPI port
EXPOSE 8000

# Run Uvicorn server via FastAPI entrypoint
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

