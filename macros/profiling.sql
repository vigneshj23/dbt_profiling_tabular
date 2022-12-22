{% macro data_profiling(target_database, target_schema, destination_database, destination_schema, destination_table, exclude_tables=[], include_tables=[], exclude_columns=[]) %}
 
{{ dbt_profiling_tabular.variable_validator(target_database, target_schema, destination_database, destination_schema, destination_table, exclude_tables, include_tables, exclude_columns) }}
    
{% if (flags.WHICH).upper() == 'RUN' %}

    {% set profiled_at = dbt_profiling_tabular.create_query(destination_database, destination_schema, destination_table) %}

    -- Read the table names from information schema for that particular layer
    {% set read_information_schema_datas %}
        SELECT
            table_catalog           AS table_database
            , table_schema
            , table_name
        FROM {{target_database}}.INFORMATION_SCHEMA.TABLES
        WHERE
            lower(table_schema) IN ( {%- for profiling_schema in target_schema -%}
                                    '{{ profiling_schema.lower()}}'
                                    {%- if not loop.last -%} , {% endif -%}
                                {%- endfor -%} )
            {% if exclude_tables | length != 0 %}
                AND lower(table_name) NOT IN ( {%- for exclude_table in exclude_tables -%}
                                        '{{ exclude_table.lower() }}'
                                        {%- if not loop.last -%} , {% endif -%}
                                    {%- endfor -%} )
            
            {% elif include_tables | length != 0 %}
                AND lower(table_name) IN ( {%- for include_table in include_tables -%}
                                        '{{ include_table.lower() }}'
                                        {%- if not loop.last -%} , {% endif -%}
                                    {%- endfor -%} )
            {% else %}

                AND 1 = 1
            
            {% endif %}
    {% endset %}

    {% if execute %}
        {% set information_schema_datas = run_query(read_information_schema_datas) %}
    {% endif %}


    {% for information_schema_data in information_schema_datas %}
        {% set source_table_name = information_schema_data[0] + '.' + information_schema_data[1] + '.' + information_schema_data[2] %}
        {% set column_query %}
            SELECT 
                column_name
                , data_type 
            FROM {{target_database}}.information_schema.columns 
            WHERE table_name = '{{information_schema_data[2]}}' 
                and table_schema = '{{information_schema_data[1]}}' 
                and table_catalog = '{{information_schema_data[0]}}'
            {% if exclude_columns | length != 0 %}
                AND lower(column_name) NOT IN ( {%- for exclude_column in exclude_columns -%}
                                        '{{ exclude_column.lower() }}'
                                        {%- if not loop.last -%} , {% endif -%}
                                    {%- endfor -%} )
            {% endif %}
        {% endset %}
        {% if execute %}
            {% set source_columns = run_query(column_query)| list %}
        {% endif %}
        {% set chunk_columns     = [] %}
        {% for source_column in source_columns %}
                {% do chunk_columns.append(source_column) %}
                {% if (chunk_columns | length) == 100 %}
                    {{ dbt_profiling_tabular.insert_statement(destination_database,destination_schema,destination_table,information_schema_data,source_table_name,chunk_column,profiled_at) }}
                    {% do chunk_columns.clear() %}
                {% endif %}
        {% endfor %}

        {% if (chunk_columns | length) != 0 %}
            {{ dbt_profiling_tabular.insert_statement(destination_database,destination_schema,destination_table,information_schema_data,source_table_name,chunk_column,profiled_at) }}
            {% do chunk_columns.clear() %}
        {% endif %}
    {% endfor %}


{% endif %}

SELECT  'TEMP_STORAGE' AS temp_column

{% endmacro %}

{% macro insert_statement(destination_database,destination_schema,destination_table,information_schema_data,source_table_name,chunk_column,profiled_at) %}
    {% set insert_rows %}
        INSERT INTO {{ destination_database }}.{{ destination_schema }}.{{ destination_table }} 
        (
        {% for chunk_column in chunk_columns %}
            {{ dbt_profiling_tabular.do_data_profiling(information_schema_data,source_table_name,chunk_column,profiled_at) }}
            {% if not loop.last %} UNION ALL {% endif %}
        {% endfor %}
        )
    {% endset %}
    {% do run_query(insert_rows) %}
{% endmacro %}