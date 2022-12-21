-- Pass single schema_name in the parameter


{{
    config(
        materialized='ephemeral'
    )
}}


{{ dbt_profiling_tabular.data_profiling('transforming_data',['transforming_test'],[],[],'seed_data','seed','schema_name_one')}}