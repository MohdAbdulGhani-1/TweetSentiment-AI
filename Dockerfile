FROM python:3.10-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Create models directory if it doesn't exist
RUN mkdir -p models

# Run the app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:10000", "app:app"]
