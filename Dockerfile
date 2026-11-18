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
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]