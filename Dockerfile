# Use a minimal, officially supported base image
FROM python:3.11-slim

# Patch OS vulnerabilities (upgrades OpenSSL and other system libraries)
RUN apt-get update && apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Prevent Python from writing pyc files to disc and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a non-root system user and group
RUN groupadd -r appgroup && useradd -r -g appgroup -s /sbin/nologin appuser

# Set working directory
WORKDIR /home/appuser/app

# Install dependencies securely AND remove build tools to reduce attack surface
COPY requirements.txt .
RUN pip install --upgrade pip --no-cache-dir && \
    pip install -r requirements.txt --no-cache-dir && \
    pip uninstall -y pip setuptools wheel

# Copy application code
COPY app/ ./app/

# Transfer ownership of the application directory to the non-root user
RUN chown -R appuser:appgroup /home/appuser/app

# Switch to the non-root user
USER appuser

EXPOSE 8080

# Execute the application using a production WSGI server
CMD ["gunicorn", "--bin", "0.0.0.0:8080", "--workers", "2", "app.main:app"]