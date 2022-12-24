SELECT 
	 CASE
		WHEN (SELECT COUNT(*) FROM profiling_test.profiling.data_profile_table1)>=20 THEN 1
		ELSE NULL
	END AS multiple_schema_row_count
    , CASE
		WHEN (SELECT COUNT(*) FROM profiling_test.profiling.data_profile_table2)>=10 THEN 1
		ELSE NULL
	END AS single_schema_row_count
    , CASE
		WHEN (SELECT COUNT(*) FROM profiling_test.profiling.data_profile_table3)>=16 THEN 1
		ELSE NULL
	END AS exclude_table_row_count
    , CASE
		WHEN (SELECT COUNT(*) FROM profiling_test.profiling.data_profile_table4)>=12 THEN 1
		ELSE NULL
	END AS include_table_row_count