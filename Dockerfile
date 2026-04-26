FROM python:3.12-slim-bookworm

# Patch OS vulnerabilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

COPY requirements.txt .

# Upgrade pip + install deps securely
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY app/ .

USER appuser

EXPOSE 8080

CMD ["python", "main.py"]