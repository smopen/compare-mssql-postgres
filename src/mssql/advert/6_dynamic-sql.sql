--Steven Rollo; CS299-03; Spring 2017
--
--6_dynamic-sql.sql
--
--2017-Spring-CS299 Paper Advert Schema - 10/5/2017

--This demonstrates two dynamic sql statements.  The first executes a simple SELECT statement
SELECT '6_dynamic-sql.sql' "CS299 EXAMPLES";

EXEC('SELECT table_name FROM INFORMATION_SCHEMA.TABLES');
GO
--This second query demonstrates using dynamic SQL to parameterize a statement
-- that will normally only accept literals. For example, CREATE LOGIN can't
-- be parameterized, so you must use dynamic SQL if you want to create a FUNCTION
-- that takes a user name and creates a users
CREATE OR ALTER PROCEDURE createUser(@userName NVARCHAR(128), @password NVARCHAR(128))
AS
BEGIN
   DECLARE @query NVARCHAR(64), @uname NVARCHAR(258), @passwd NVARCHAR(258);

   SET @uname = QUOTENAME(@userName);
   SET @passwd = QUOTENAME(@password, '''');
   SET @query = N'CREATE LOGIN ' + @uname + ' WITH PASSWORD = ' + @passwd;

   EXEC(@query)
END;
GO

EXEC createUser 'testuser', 'TestuS3r12@3';

SELECT *
FROM master.sys.server_principals
WHERE name = 'testuser';
GO
