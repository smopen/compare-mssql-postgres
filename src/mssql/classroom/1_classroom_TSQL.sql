--Andrew Figueroa; CS299-03; Spring 2017
--
--1_classroom_TSQL.sql
--
--Final Paper Classroom Scenario (T-SQL) - 10/8/2017

--The following is specific example of creating a student
--Implementations with stored procedures will vary depending on an organization's
--  users and group structure.


--create roles and users
CREATE ROLE Student;
CREATE ROLE Instructor;
CREATE LOGIN Ramsey033;
CREATE USER Ramsey033;

--associate a user with a role
ALTER ROLE Student ADD MEMBER Ramsey033;

--create a schema object for illustration 
CREATE SCHEMA ramsey033;

--give a particular user CRUD access to schema
GRANT SELECT, INSERT, DELETE, UPDATE 
 ON SCHEMA ramsey033 TO Ramsey033

--let any member of Instructor role read schema
GRANT SELECT ON SCHEMA ramsey033 TO Instructor;
