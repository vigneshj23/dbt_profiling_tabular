{{
 config(materialized='ephemeral')

}}

{{ dbt_profiling_tabular.data_profiling('RAW',['SALES','CUSTOMER'],[],[],'GOVERNANCE','profiling','data_profile_table')}}