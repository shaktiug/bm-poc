FROM python:3.8-slim-buster

WORKDIR /app/

ENV FLASK_APP bm
RUN apt-get update && apt-get -y install libpq-dev gcc
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
