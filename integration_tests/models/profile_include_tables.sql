-- Pass one or many include_tables in the parameter.It will profile only the tables mentioned in the parameter.

{{ dbt_profiling_tabular.data_profiling('GOVERNANCE',['customer_detail','order_detail'],[],['customer','orders'],'GOVERNANCE','profiling','data_profile_table4')}}