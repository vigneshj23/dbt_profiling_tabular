FROM python:3.9
RUN apt-get update \
  && apt-get install -y postgresql postgresql-contrib \
  && apt-get install sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y python
COPY  . .
RUN pip install -r ./requirements.txt
RUN cd integration_tests
ADD postgres.env ./env/postgres.env
RUN export $(cat ./env/postgres.env | xargs) && rails c