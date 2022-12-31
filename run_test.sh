cd integration_tests
echo "$ENV_FILE" | base64 --decode > .env
python profiles_yml_creator.py
cat profiles.yml
dbt debug --target $1
dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1