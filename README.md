# data_profiler
The data_profiler package is based on the [dbt hub/dbt_profiler](https://hub.getdbt.com/data-mie/dbt_profiler/latest/).
Profiling for a table with more than 150 fields can be done more efficiently with the data_profiler package.

`data_profiler` uses dbt macros to profile database relationships and table schemas (`schema.yml`). 
For each column in a relation, a calculated profile includes the following measures:

* `database`: Database name
* `schema`: Schema name
* `table_name`: Table name
* `row_count`: Column based row count
* `column_name`: Name of the column
* `data_type`: Data type of the column
* `not_null_count`: Count the not_null values based on columns
* `null_count`: Count the null values by column based on columns
* `not_null_percentage`: Percentage of column values that are not `NULL` (e.g., `0.62` means that 62% of the values are populated while 38% are `NULL`)
* `null_percentage`: Percentage of column values that are `NOT_NULL` (e.g., `0.55` means that 55% of the values are populated while 45% are `NOT_NULL`)
* `distinct_percentage`: Percentage of unique column values (e.g., `1` means that 100% of the values are unique)
* `distinct_count`: Count of unique column values
* `is_unique`: True if all column values are unique
* `min`: Minimum column value
* `max`: Maximum column value
* `avg`: Average column value
* `profiled_at`: Date and time (UTC time zone) of the profiling 

## Purpose 

`data_profiler` aims to provide

1. [data_profile](#get_profile-source) macro for generating profiling SQL queries that can be used as dbt models or ad-hoc queries
2. Describe a mechanism to include model profiles in [dbt docs](https://docs.getdbt.com/docs/building-a-dbt-project/documentation)

## Installation
 dbt version required: >=1.1.0.
 Include the following in your packages.yml file:
```sql
packages:
  - git:https://github.com/vigneshj23/dbt_profiling_tabular.git
    revision: v1.1.3
```

## Supported adapters

✅ Snowflake

✅ Postgres


## data_profiler  macro ([source](/macros/profiling.sql))

This macro returns a relation profile as a SQL query that can be used in a dbt model. This is handy for previewing relation profiles in dbt Cloud.

### Arguments
* `destination_database` (required): Mention the destination output databse name.
* `destination_schema` (required): Mention the destination output schema name.
* `destination_table` (required): Mention the destination output table name.
* `source_database` (required): Mention the source table name.
* `source_schema` (required): Mention the source schema name
* `exclude_tables` (optional): List of columns to exclude from the profile (default: `[]`). Only one of `include_tables` and `exclude_tables` can be specified at a time.
* `include_tables` (optional): List of columns to include in the profile (default: `[]` i.e., all). Only one of `include_tables` and `include_table` can be specified at a time.

### Usage
Use this macro in a dbt model, 

```sql

{{ data_quality.data_profiling('destination_database','destination_schema','destination_table', 'source_database',['source_schema1','source_schema2'],['exclude_tables],['include_tables'])}}

```
This above model will create the two tables. First one is temporary table, It doesn't contain any data. Second one is output table,
It had a profiled data.

If we don't want temporary table, we can avoid that table using materialization or hook 
```sql

{{
    config(
        materialized='ephemeral'
    )
}}

```
OR

```sql
    post-hook:
      - "DROP TABLE IF EXISTS <model name / temporay table name>"

```

### Example Output

```
|    DATABASE           | SCHEMA | TABLE_NAME | COLUMN_NAME         | DATA_TYPE | ROW_COUNT | NOT_NULL_COUNT | NULL_COUNT | NOT_NULL_PERCENTAGE| NULL_PERCENTAGE | DISTINCT_COUNT | DISTINCT_PERCENT |IS_UNIQUE | MIN      | MAX 	|    AVG 	   |      PROFILED_AT 		|
| ----------------------| -------| -----------|-------------------- | ----------|---------- | -------------- | ---------  | ------------------ | --------------- | -------------- | -----------------| -------- | ---------|------------|------------------|--------------------------- |
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_ORDERKEY          | NUMBER    |1500000    |1500000         |	0	  | 100.00     	       |0.00		 |1500000         |100.00	     |TRUE	|1         |6000000     |2999991.50        |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_CUSTKEY           | NUMBER	|1500000    |1500000         |	0         | 100.00     	       |0.00		 |99996		  |6.67		     |FALSE	|1    	   |149999      |75006.04          |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_ORDERSTATUS       | VARCHAR	|1500000    |1500000         |	0         | 100.00             |0.00		 |3               |0.00		     |FALSE	|null      |null        |null              |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_TOTALPRICE        | NUMBER	|1500000    |1500000	     |	0         | 100.00             |0.00		 |1464556	  |97.64 	     |FALSE	|857.71    |555285.16   |151219.54         |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_ORDERDATE         | DATE	|1500000    |1500000         |	0         | 100.00             |0.00		 |2406		  |0.16		     |FALSE	|1992-01-01|1998-08-02  |null              |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_ORDERPRIORITY     | VARCHAR	|1500000    |1500000         |	0         | 100.00	       |0.00		 |5     	  |0.00		     |FALSE	|null      |null        |null              |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_CLERK             | VARCHAR	|1500000    |1500000         |	0         | 100.00             |0.00		 |1000		  |0.07   	     |FALSE	|null      |null        |null              |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_SHIPPRIORITY      | NUMBER	|1500000    |1500000         |	0         | 100.00             |0.00		 |1		  |0.00		     |FALSE	|0         |0           |0.00              |2022-12-06T09:05:18.183Z	|
|SNOWFLAKE_SAMPLE_DATA  |TPCH_SF1| ORDERS     | O_COMMENT           | VARCHAR	|1500000    |1500000         |	0         | 100.00             |0.00		 |1482071         |98.80	     |FALSE	|null      |null        |null              |2022-12-06T09:05:18.183Z	|

```
