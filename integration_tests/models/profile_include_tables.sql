-- Pass one or many include_tables in the parameter.It will profile only the tables mentioned in the parameter.

{{ dbt_profiling_tabular.data_profiling('profiling_test','profiling','data_profile_include_table','profiling_test',['integration_tests_customer_detail','integration_tests_order_detail'],[],['customer','orders'])}}