cd integration_tests
python profiles_yml_creator.py
cat profiles.yml
dbt debug --target $1
dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1