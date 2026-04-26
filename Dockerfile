FROM python:3.12-alpine

RUN adduser -D appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

USER appuser

EXPOSE 8080

CMD ["python", "main.py"]