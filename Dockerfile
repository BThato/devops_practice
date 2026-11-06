
#Use an official lightweight Python base Images 
FROM python:3.11-slim

#Set the working Directory inside teh container
WORKDIR /app


# Install system dependencies including curl for healthchecks
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

#Copy requirements first to leverage Docker layers caching
COPY requirements.txt .

#Install Python dependencies without caching pip package to keep image small
RUN pip install --no-cache-dir -r requirements.txt

#Copy the rest of your project files (app.py and access.log) into the container

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0","--port", "8000"]


