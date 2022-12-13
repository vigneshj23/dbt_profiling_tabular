
# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
chmod +x value.sh
./value.sh
echo ${SNOWFLAKE_ACCOUNT}
cp ./profiles.yml profiles.yml
export DBT_PROFILES_DIR=.

# Show the location of the profiles directory and test the connection
dbt debug

dbt deps 
dbt seed --full-refresh
dbt run
dbt test