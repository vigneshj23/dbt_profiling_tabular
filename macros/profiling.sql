{% macro data_profiling(target_database, target_schema, exclude_tables, include_tables, destination_database, destination_schema, destination_table) %}
 
 {% if target_database == '' %}
        {{exceptions.raise_compiler_error("Config the valid `target_database`  ")}}
    {% elif target_schema == [] %}
        {{exceptions.raise_compiler_error("Config the valid `target_schema`  ")}}
    {% elif destination_database == '' %}
        {{exceptions.raise_compiler_error("Config the valid `destination_database`  " )}}
    {% elif destination_schema == '' %}
        {{exceptions.raise_compiler_error("Config the valid `destination_schema`  " )}}
    {% elif destination_table == '' %}
        {{exceptions.raise_compiler_error("Config the valid `destination_table`  ")}}
    {% else %}
    {% endif %}
    
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
            SELECT column_name,data_type FROM {{target_database}}.information_schema.columns WHERE table_name = '{{information_schema_data[2]}}' and table_schema = '{{information_schema_data[1]}}' and table_catalog = '{{information_schema_data[0]}}'
        {% endset %}
        {% if execute %}
            {% set source_columns = run_query(column_query)| list %}
        {% endif %}
        {% set chunk_columns     = [] %}
        {% for source_column in source_columns %}
                {% do chunk_columns.append(source_column) %}
                {% if (chunk_columns | length) == 100 %}
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
                    {% do chunk_columns.clear() %}
                {% endif %}
        {% endfor %}

        {% if (chunk_columns | length) != 0 %}
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
            {% do chunk_columns.clear() %}
        {% endif %}
    {% endfor %}


{% endif %}

SELECT  'TEMP_STORAGE' AS temp_column

{% endmacro %}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}