# Use official Python image with Python 3.11
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the application code
COPY web_client.py .

# Command to run the client
CMD ["python", "web_client.py"]