FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get upgrade -y && apt-get clean

RUN useradd -m appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

USER appuser

EXPOSE 8080

CMD ["python", "main.py"]