FROM python:3.9

WORKDIR /app

COPY ./api /app/api

RUN pip install -r "/app/api/requirements.txt"

CMD ["python", "api/main.py"]
