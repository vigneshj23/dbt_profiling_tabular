-- Pass one or many include_tables in the parameter.It will profile only the tables mentioned in the parameter.

{{ dbt_profiling_tabular.data_profiling('profiling_test',['customer_detail','order_detail'],'profiling_test','profiling','data_profile_table4',[],['customer','orders'],[])}}