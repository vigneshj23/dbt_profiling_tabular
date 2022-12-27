{% macro variable_validator(destination_database, destination_schema, destination_table, target_database, target_schema, exclude_tables, include_tables) %}
    
    -- target database validation
    {% if target_database == '' %}
        {{ exceptions.raise_compiler_error(" `target_database` should should not be empty  ") }}
    {% elif '[' in target_database | string %}
        {{ exceptions.raise_compiler_error(" `target_database` should not be a list ") }}
    {% endif %}

    -- target schema validation
    {% if target_schema | length == 0 %}
        {{ exceptions.raise_compiler_error(" `target_schema` should not be empty  ") }}
    {% elif '[' not in target_schema | string %}
        {{ exceptions.raise_compiler_error(" `target_schema` should not be a string ") }}
    {% endif %}

    -- destination database validation
    {% if destination_database == '' %}
        {{ exceptions.raise_compiler_error(" `destination_database` should not be empty  ") }}
    {% elif '[' in destination_database | string %}
        {{ exceptions.raise_compiler_error(" `destination_database` should not be a list ") }}
    {% endif %}

    -- destination schema validation
    {% if destination_schema == '' %}
        {{ exceptions.raise_compiler_error(" `destination_schema` should not be empty  ") }}
    {% elif '[' in destination_schema | string %}
        {{ exceptions.raise_compiler_error(" `destination_schema` should not be a list ") }}
    {% endif %}

    -- destination table validation
    {% if destination_table == '' %}
        {{ exceptions.raise_compiler_error(" `destination_table` should not be empty  ") }}
    {% elif '[' in destination_table | string %}
        {{ exceptions.raise_compiler_error(" `destination_table` should not be a list ") }}
    {% endif %}

    -- exclude table validation
    {% if '[' not in exclude_tables | string %}
        {{ exceptions.raise_compiler_error(" `exclude_tables` should not be a string ") }}
    {% endif %}

    -- include table validation
    {% if '[' not in include_tables | string %}
        {{ exceptions.raise_compiler_error(" `include_tables` should not be a string ") }}
    {% endif %}

{%- endmacro %}