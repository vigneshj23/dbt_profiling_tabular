# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
export $(cat .env/$1.env | xargs) && rails c
# mv profiles.yml template.yml
rm -f profiles.yml temp.yml
( echo "cat <<EOF >>profiles.yml";
  cat ci/$1.profiles.yml;
) >temp.yml
. temp.yml
cat profiles.yml
export DBT_PROFILES_DIR=.

# Show the location of the profiles directory and test the connection
dbt debug 

dbt deps 
dbt seed  --full-refresh
dbt run -m profile_multiple_schema
dbt run -m profile_single_schema
dbt run -m profile_exclude_tables
dbt run -m profile_include_tables
dbt run -m test_cases
dbt test 