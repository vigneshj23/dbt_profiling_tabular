### Overview
1. Prerequisites
1. Configure credentials
1. Build image
1. Run the image


### Prerequisites
- python3
- Docker

### Configure credentials
Edit the env file for your TARGET in `integration_tests/.env/[TARGET].env`.

### Build image

Docker and `dockerfile` are both used in testing. Specific instructions for your OS can be found [here](https://docs.docker.com/get-docker/).

This tests are the fastest to run, and the no need to set up indiviually. In the dockerfile all test procedures are declared.

```shell
docker build -t <image name> .
```

### Run the image

After creating the docker image, you need run the image using the following command.
```shell
docker run <image name>
```

Next you need to run the following command in docker container CLI or open the another terminal `docker exec -it <container id> bash` and run the following command.

```shell
dbt debug 
dbt deps 
dbt seed  --full-refresh
dbt run
dbt test
```

If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.