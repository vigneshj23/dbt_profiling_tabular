----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Macro for identifying the data platforms and based on that it will redirect to specific macro
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro create_query(destination_database, destination_schema, destination_table) %}

    {{ return(adapter.dispatch('create_query','dbt_profiling_tabular')(destination_database, destination_schema, destination_table)) }}

{% endmacro %}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- This macro is used to creating the schema and table in snowflake
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro snowflake__create_query(destination_database, destination_schema, destination_table) %}
    
    {% set get_current_timestamp %}
        SELECT CAST(CONVERT_TIMEZONE('UTC', CURRENT_TIMESTAMP()) AS TIMESTAMP_NTZ) AS utc_time_zone
    {% endset %}

    {% if excute %}
        {% set profiled_at = run_query(get_current_timestamp).columns[0].values()[0] %}
    {% endif %}

    {% set create_schema %}
        CREATE SCHEMA IF NOT EXISTS {{ destination_database }}.{{ destination_schema }}
    {% endset %}
    
    {% if excute %}
        {% do run_query(create_schema) %}
    {% endif %}
    {% set create_table %}
        CREATE TABLE IF NOT EXISTS {{ destination_database }}.{{ destination_schema }}.{{ destination_table }} (

            database                    VARCHAR(100)
            , schema                    VARCHAR(100)
            , table_name                VARCHAR(100)
            , column_name               VARCHAR(500)
            , data_type                 VARCHAR(100)
            , row_count                 NUMBER(38,0)
            , not_null_count            NUMBER(38,0)
            , not_null_percentage       NUMBER(38,2)
            , null_count                NUMBER(38,0)
            , null_percentage           NUMBER(38,2)
            , distinct_count            NUMBER(38,0)
            , distinct_percent          NUMBER(38,2)
            , is_unique                 BOOLEAN
            , min                       VARCHAR(250)
            , max                       VARCHAR(250)
            , avg                       NUMBER(38,2)
            , profiled_at               TIMESTAMP_NTZ(9)

        )
    {% endset %}

    {% if excute %}
        {% do run_query(create_table) %}
    {% endif %}
    {{ return(profiled_at) }}

{% endmacro %}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- This macro is used to creating the table for snowflake
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro postgres__create_query(destination_database, destination_schema, destination_table) %}

    /* get current timestamp of UTC timezone */
    {% set get_current_timestamp %}
        SELECT CAST(NOW() AT TIME ZONE 'UTC'AS TIMESTAMPTZ) AS UTC_TIME_ZONE
    {% endset %}
    
    {% if excute %}
        {% set profiled_at = run_query(get_current_timestamp).columns[0].values()[0] %}
    {% endif %}

    {% set create_schema %}
        CREATE SCHEMA IF NOT EXISTS {{ destination_schema }}
    {% endset %}

    {% if excute %}
        {% do run_query(create_schema) %}
    {% endif %}

    {% set create_table %}
        CREATE TABLE IF NOT EXISTS {{ destination_database }}.{{ destination_schema }}.{{ destination_table }} (

            database                    VARCHAR(100)
            , schema                    VARCHAR(100)
            , table_name                VARCHAR(100)
            , column_name               VARCHAR(500)
            , data_type                 VARCHAR(100)
            , row_count                 NUMERIC(38,0)
            , not_null_count            NUMERIC(38,0)
            , not_null_percentage       NUMERIC(38,2)
            , null_count                NUMERIC(38,0)
            , null_percentage           NUMERIC(38,2)
            , distinct_count            NUMERIC(38,0)
            , distinct_percent          NUMERIC(38,2)
            , is_unique                 BOOLEAN
            , min                       VARCHAR(250)
            , max                       VARCHAR(250)
            , avg                       NUMERIC(38,2)
            , profiled_at               TIMESTAMPTZ(9)

        )
    {% endset %}

    {% if excute %}
        {% do run_query(create_table) %}
    {% endif %}
    {{ return(profiled_at) }}

{% endmacro %}