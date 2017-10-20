--Steven Rollo; CS299-03; Spring 2017
--
--6_dynamic-sql.sql
--
--Final Paper Advert Schema - 5/12/2017

--This demonstrates two dynamic sql statements.  The first executes a simple SELECT statement
EXEC('SELECT table_name FROM INFORMATION_SCHEMA.TABLES');

--The second constructs a larger query, and then executes it.
--This will SELECT * from every table in the database
DECLARE @query_text NVARCHAR(MAX);
SET @query_text = '';

SELECT @query_text += 'SELECT * FROM ' + table_name + ';' 
FROM INFORMATION_SCHEMA.TABLES;

EXEC(@query_text);