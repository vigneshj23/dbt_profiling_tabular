-- Pass one or many include_tables in the parameter.It will profile only the tables mentioned in the parameter.


{{ dbt_profiling_tabular.data_profiling(target_database='profiling_test'
                                        , target_schema='profiling'
                                        , target_table='data_profile_multi_schema'
                                        , source_database='profiling_test'
                                        , source_schema=['integration_tests_customer_detail', 'integration_tests_order_detail']
                                        , include_tables=['customer', 'orders']) }}