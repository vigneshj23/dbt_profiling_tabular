
# Show location of local install of dbt
echo $(which dbt)
echo "$1"

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
export $(cat $1.env | xargs) && rails c
# mv profiles.yml template.yml
rm -f profiles.yml temp.yml
( echo "cat <<EOF >>profiles.yml";
  cat ci/$1.profiles.yml;
) >temp.yml
. temp.yml
cat profiles.yml
export DBT_PROFILES_DIR=.

# Show the location of the profiles directory and test the connection
dbt debug --target $1

dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1