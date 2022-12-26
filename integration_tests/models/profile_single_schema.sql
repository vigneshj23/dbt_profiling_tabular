-- Pass many schema_name in the parameter

{{ dbt_profiling_tabular.data_profiling('profiling_test','profiling','data_profile_single_schema','profiling_test',['integration_tests_order_detail'])}}