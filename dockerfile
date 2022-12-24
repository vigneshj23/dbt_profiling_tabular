FROM postgres:14-bullseye
ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=test
ENV POSTGRES_DB=profiling_test
RUN apt-get update && apt-get install -y python3-pip && apt-get install -y git
COPY  . .
WORKDIR /integration_tests
RUN pip install dbt-postgres