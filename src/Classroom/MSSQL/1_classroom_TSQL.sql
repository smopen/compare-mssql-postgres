--Andrew Figueroa; CS299-03; Spring 2017
--
--1_classroom_TSQL.sql
--
--Final Paper Classroom Scenario (T-SQL) - 5/11/2017

--The following is specific example of creating a student
--Implementations with stored procedures will vary depending on the organization's
--  users and group structure.

CREATE ROLE CS205F17Student;
CREATE ROLE CS205F17Instructor;

CREATE USER [WCSU\Students\Ramsey033];
ALTER ROLE CS205F17Student ADD MEMBER [WCSU\Students\Ramsey033];

CREATE SCHEMA ramsey033 GRANT SELECT, INSERT, DELETE, UPDATE;
GRANT SELECT on SCHEMA ramsey033 to CS205F17Instructor;
