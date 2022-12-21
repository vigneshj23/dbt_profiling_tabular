-- Pass many schema_name in the parameter

{{ dbt_profiling_tabular.data_profiling('GOVERNANCE',['order_detail'],[],[],'GOVERNANCE','profiling','data_profile_table2')}}