-- Read the table names from information schema for that particular layer









    SELECT
        table_catalog           AS table_database
        , table_schema
        , table_name
    FROM profiling_test.INFORMATION_SCHEMA.TABLES
    WHERE
        lower(table_schema) IN ('customer_detail', 'order_detail')
        

            AND 1 = 1
        
        


    



