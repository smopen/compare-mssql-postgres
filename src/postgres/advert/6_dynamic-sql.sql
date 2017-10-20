--Steven Rollo; CS299-03; Spring 2017
--
--6_dynamic-sql.sql
--
--Final Paper Advert Schema (pgSQL)- 5/12/2017

--This is a little bit different than the MSSQL example
--Since EXECUTE has to be called from a PL/pgSQL block, there is no easy way
--to display SELECT output from a query.  So, to demonstrate this query,
--I am actually printing the query to the window, and then executing it,
--event though the execution output will not be visible
DO $$
DECLARE
  query TEXT;
BEGIN
  SELECT string_agg('
    SELECT * FROM ' || table_name, ';')
  INTO query
  FROM INFORMATION_SCHEMA.TABLES
  WHERE table_schema='public'
  AND NOT table_name ='';

  EXECUTE(query);

  RAISE NOTICE 'Query to select from all tables in database: %I', query;
END$$;
