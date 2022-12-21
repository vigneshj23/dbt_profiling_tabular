FROM cimg/postgres:9.6
ENV POSTGRES_USER=root
ENV POSTGRES_DB=profiling_test
COPY  . .
RUN apt-get update && apt-get install -y python3-pip
RUN pip install -r ./requirements.txt
RUN ./run_test.sh postgres