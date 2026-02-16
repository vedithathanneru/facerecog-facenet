# Use Python 3.12
FROM python:3.12-slim

# Prevent python from buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies required for:
# mysqlclient, mediapipe, opencv, tensorflow
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (Docker layer optimization)
COPY requirements.txt .

RUN pip install --upgrade pip setuptools==69.5.1 wheel \
    && pip install -r requirements.txt

# Copy project
COPY . .

# Expose port
EXPOSE 8080

# Run using Gunicorn
CMD ["gunicorn", "facerecog.wsgi:application", "--bind", "0.0.0.0:8080"]
