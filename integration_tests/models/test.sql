{{
    config(
        materialized='ephemeral'
    )
}}


  {{ dbt_profiling_tabular.data_profiling('transforming_data',['transforming_test','transforming_demo'],[],[],'seed_data','seed','test')}}



