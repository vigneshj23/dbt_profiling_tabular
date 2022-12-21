-- Pass one or many exclude_tables in the parameter.It will profile all the tables except the exclude tables.


{{ dbt_profiling_tabular.data_profiling('profiling_test',['customer_detail','order_detail'],['address'],[],[],'profiling_test','profiling','data_profile_table3')}}