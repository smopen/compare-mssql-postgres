--Steven Rollo; CS299-03; Spring 2017
--
--6_dynamic-sql.sql
--
--2017-Spring-CS299 Paper Advert Schema (pgSQL)- 10/5/2017

--This demonstrates two dynamic sql statements.  The first executes a simple SELECT statement
SELECT '6_dynamic-sql.sql' "CS299 EXAMPLES";

-- EXECUTE can only be used inside a plpgsql function
CREATE OR REPLACE FUNCTION getTableNames()
RETURNS TABLE(table_name INFORMATION_SCHEMA.sql_identifier) AS
$$
BEGIN
   --The output of a SELECT statement can't be seen by a client in a plpgsql function,
   -- so we will return the query result and select that
   RETURN QUERY EXECUTE 'SELECT table_name FROM INFORMATION_SCHEMA.TABLES';
END
$$
LANGUAGE plpgsql;

SELECT *
FROM getTableNames();

--This second query demonstrates using dynamic SQL to parameterize a statement
-- that will normally only accept literals. For example, CREATE USER can't
-- be parameterized, so you must use dynamic SQL if you want to create a FUNCTION
-- that takes a user name and creates a users
CREATE OR REPLACE FUNCTION createUser(userName VARCHAR(63))
RETURNS VOID AS
$$
BEGIN
   --format inserts escaped versions of the input parameter into the dynamic query
   EXECUTE format('CREATE USER %s ENCRYPTED PASSWORD %L', $1, $1);
END
$$
LANGUAGE plpgsql;

--Execute the function
SELECT createUser('testuser');

--We should see the new user
SELECT * FROM pg_catalog.pg_roles
WHERE rolname = 'testuser';
