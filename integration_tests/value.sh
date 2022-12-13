export SNOWFLAKE_ACCOUNT="ig08392.ap-southeast-1"
export SNOWFLAKE_USER="vigneshj"
export SNOWFLAKE_PASSWORD="Vicky@2306"
export SNOWFLAKE_ROLE="ACCOUNTADMIN"
export SNOWFLAKE_DATABASE="GOVERNANCE"
export SNOWFLAKE_SCHEMA="elementary"
export SNOWFLAKE_WAREHOUSE="USER_ENGINEER_WAREHOUSE"


mv profiles.yml template.yml
rm -f profiles.yml temp.yml
( echo "cat <<EOF >profiles.yml";
  cat template.yml;
  echo "EOF";
) >temp.yml
. temp.yml
cat profiles.yml