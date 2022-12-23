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

Postgres offers the easiest way to test most `dbt_profiling_tabular` functionality today. Its tests are the fastest to run, and the easiest to set up. In the dockerfile all test procedures are declared.

```shell
docker build -t <image name> .
```

### Run the image

After creating the docker image, you need run the image using the following command.
```shell
docker run <image name>
```

For your verfication you can check the docker log or you can run the following command in docker image CLI.

```shell
dbt deps --target postgres
dbt seed --target postgres
dbt run --target postgres
dbt test --target postgres
```

If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.