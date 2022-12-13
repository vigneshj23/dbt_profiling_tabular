export SNOWFLAKE_ACCOUNT="ig08392.ap-southeast-1"
export SNOWFLAKE_USER="vigneshj"
export SNOWFLAKE_PASSWORD="Vicky@2306"
export SNOWFLAKE_ROLE="ACCOUNTADMIN"
export SNOWFLAKE_DATABASE="GOVERNANCE"
export SNOWFLAKE_SCHEMA="elementary"
export SNOWFLAKE_WAREHOUSE="USER_ENGINEER_WAREHOUSE"

( echo "cat <<EOF >final.yml";
  cat profiles.yml;
) > profiles.yml
. profiles.yml
cat profiles.yml