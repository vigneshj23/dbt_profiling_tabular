cd integration_tests
python test.py
# Show the location of the profiles directory and test the connection
dbt debug --target $1
dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1