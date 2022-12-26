# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
export $(cat .env | xargs) && rails c

rm -f profiles.yml temp.yml
( echo "cat <<EOF >>profiles.yml";
  cat ci/sample.profiles.yml;
) >temp.yml
. temp.yml
cat profiles.yml
export DBT_PROFILES_DIR=.