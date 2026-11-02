
# Use a lightweght officials Python Images
FROM python:3.9-slim

# Set the working directory inside teh contanier 
WORKDIR /app

#Copy your scripts and logs file from you host machine into the container

COPY log_analyzer.py .
COPY logs/ logs/

CMD ["python3", "log_analyzer.py"]


