--Andrew Figueroa; CS299-03; Spring 2017
--
--1_classroom_pgSQL.sql
--
--Final Paper Classroom Scenario (pgSQL) - 10/8/2017

--create roles and users
CREATE ROLE Student;
CREATE ROLE Instructor;
CREATE ROLE ramsey033 LOGIN;

--associate a user with a role
GRANT Student TO ramsey003;

--create a schema object for illustration 
CREATE SCHEMA ramsey003;

--give a particular user CRUD access to schema
GRANT ALL PRIVILEGES ON SCHEMA ramsey003 TO ramsey003; 

--let any member of Instructor role read schema
GRANT USAGE ON SCHEMA ramsey003 TO Instructor;
