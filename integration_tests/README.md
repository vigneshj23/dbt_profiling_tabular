# Overview
* [Prerequisites](#Prerequisites)
* [Configure](#Configure)
* [Build](#Build)
* [Run](#Run)


## Prerequisites
- python3
- Docker

## Configure
Edit the env file for your TARGET in `integration_tests/.env/[TARGET].env`.

## Build

Docker and `dockerfile` are both used in testing. Specific instructions for your OS can be found [here](https://docs.docker.com/get-docker/).

There is no need to set up this test separately. All test procedures are declared in the docker file. Use the command below to create a docker image.

```shell
docker build -t <image name> .
```

## Run

Use the following command to launch the docker image after it has been created.
```shell
docker run <image name>
```

Run the following command in the Docker container CLI after that, or open a new terminal and type "docker exec -it container id bash" before doing so.

```shell
dbt debug 
dbt deps 
dbt seed  --full-refresh
dbt run
dbt test
```

If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.
