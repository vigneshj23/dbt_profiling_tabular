cd integration_tests
echo $ENV_FILE| sed 's/./&/g' | sed 's/ /\n/g' > .env
python profiles_yml_creator.py
dbt debug --target $1
dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1