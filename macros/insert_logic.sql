----------------------------------------------------------------------------------------------------------------------------------------------------------
-- This macro is used to do data profiling
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro do_data_profiling(information_schema_data, source_table_name, chunk_column, current_date_and_time) %}

    {% set null_count_query%}
        SELECT 
            SUM(CASE 
                    WHEN (CASE WHEN {{ chunk_column[0] }}::VARCHAR = '' THEN NULL ELSE {{ chunk_column[0] }} END ) IS NULL 
                        THEN 1
                    ELSE 0
                END )     AS null_count
        FROM {{ source_table_name }}
    {% endset%}

    {% if excute %}
        {% set null_count = run_query(null_count_query).columns[0].values()[0] %}
    {% endif %}
    SELECT

          '{{ information_schema_data[0] }}'                                                              AS database
        , '{{ information_schema_data[1] }}'                                                              AS schema
        , '{{ information_schema_data[2] }}'                                                              AS table_name
        , '{{ chunk_column[0].upper() }}'                                                                 AS column_name
        , '{{ chunk_column[1].upper() }}'                                                                 AS data_type

        , CAST(COUNT(*) AS NUMERIC)  	                                                                  AS row_count
        , CAST(COUNT(*) AS NUMERIC)-{{ null_count }}                                                      AS not_null_count
        , ROUND(((CAST(COUNT(*) AS NUMERIC)-{{ null_count }} ) / CAST(COUNT(*) AS NUMERIC)) * 100, 2)     AS not_null_percentage

        , {{ null_count }}                                                                                AS null_count
        , ROUND(({{ null_count }} / CAST(COUNT(*) AS NUMERIC)) * 100, 2)                                  AS null_percentage

        , COUNT(DISTINCT {{ chunk_column[0] }})	                                                          AS distinct_count
        , ROUND(COUNT(DISTINCT {{ chunk_column[0] }}) / CAST(COUNT(*) AS NUMERIC) * 100, 2)               AS distinct_percentage

        , COUNT(DISTINCT {{ chunk_column[0] }}) = CAST(COUNT(*) AS NUMERIC)                               AS IS_UNIQUE

        , {% if dbt_profiling_tabular.is_numeric_dtype((chunk_column[1]).lower()) or dbt_profiling_tabular.is_date_or_time_dtype((chunk_column[1]).lower()) %}
            CAST(MIN({{ adapter.quote(chunk_column[0]) }}) AS VARCHAR)
        {% else %}
            NULL
        {% endif %}      AS min

        , {% if dbt_profiling_tabular.is_numeric_dtype((chunk_column[1]).lower()) or dbt_profiling_tabular.is_date_or_time_dtype((chunk_column[1]).lower()) %}
            CAST(MAX({{ adapter.quote(chunk_column[0]) }}) AS VARCHAR)
        {% else %}
            NULL
        {% endif %}     AS max

        , {% if dbt_profiling_tabular.is_numeric_dtype((chunk_column[1]).lower()) %}
            ROUND(AVG(CAST({{ adapter.quote(chunk_column[0]) }} AS NUMERIC)), 2)
        {% else %}
            CAST(NULL AS NUMERIC)
        {% endif %}   AS avg

        , CAST('{{ current_date_and_time }}' AS TIMESTAMP)                                                AS profiled_at

    FROM {{ source_table_name }}

{% endmacro %}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- To check whether the column is numeric type or not
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro is_numeric_dtype(dtype) %}

    {% set is_numeric = dtype.startswith("int") or dtype.startswith("float") or "numeric" in dtype or "NUMERIC" in dtype or "double" in dtype %}
    {% do return(is_numeric) %}

{% endmacro %}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- To check the column is data/datetime
----------------------------------------------------------------------------------------------------------------------------------------------------------
{% macro is_date_or_time_dtype(dtype) %}

    {% set is_date_or_time = dtype.startswith("timestamp") or dtype.startswith("date") %}
    {% do return(is_date_or_time) %}

{% endmacro %}