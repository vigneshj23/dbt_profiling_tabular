-- Pass one or many exclude_tables in the parameter.It will profile all the tables except the exclude tables.



{{
    config(
        materialized='ephemeral'
    )
}}


{{ dbt_profiling_tabular.data_profiling('transforming_data',['transforming_test','transforming_demo'],['demo_data'],[],'seed_data','seed','exclude_tables')}}