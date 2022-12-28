-- Pass one or many source_schema in the parameter.It will profile only all the tables in the mentioned schema in the parameter.

{{ dbt_profiling_tabular.data_profiling(target_database='profiling_test'
                                        , target_schema='profiling'
                                        , target_table='data_profile_multi_schema'
                                        , source_database='profiling_test'
                                        , source_schema=['integration_tests_order_detail']) }}