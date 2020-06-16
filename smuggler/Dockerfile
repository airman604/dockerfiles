FROM python:3-slim

RUN mkdir /smuggler
COPY . /smuggler

WORKDIR /smuggler
VOLUME /smuggler/payloads

ENTRYPOINT ["python3", "smuggler.py"]
