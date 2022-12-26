-- Pass one or many exclude_tables in the parameter.It will profile all the tables except the exclude tables.


{{ dbt_profiling_tabular.data_profiling('profiling_test','profiling','data_profile_exclude_table','profiling_test',['integration_tests_customer_detail','integration_tests_order_detail'],['address'])}}