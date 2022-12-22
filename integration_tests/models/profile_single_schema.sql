-- Pass many schema_name in the parameter

{{ dbt_profiling_tabular.data_profiling('profiling_test',['integration_tests_order_detail'],'profiling_test','profiling','data_profile_table2')}}