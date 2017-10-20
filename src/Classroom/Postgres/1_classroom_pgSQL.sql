--Andrew Figueroa; CS299-03; Spring 2017
--
--1_classroom_pgSQL.sql
--
--Final Paper Classroom Scenario (pgSQL) - 5/11/2017

--This script creates roles for students and instructors, and defines stores procedures for creating students 
-- and instructors, given a username and password for each. Finally, a sample student and instructor are
-- created for testing.

--Group equivalent for managing permissions for students
CREATE ROLE CS205F17Student;

 --Group equivalent for managing permissions for instructors
CREATE ROLE CS205F17Instructor;

--Removes the ability for users to modify the "public" schema for the current database
REVOKE CREATE ON SCHEMA public FROM PUBLIC; 


--Creates a role for a student given a username and password. This procedure also creates 
-- a schema for each user and gives both the student and instructor appropriate 
-- privilages.
CREATE OR REPLACE FUNCTION createCS205F17Student(userName VARCHAR(25), pw VARCHAR(25)) RETURNS VOID AS
$$
BEGIN
  userName := lower(userName);
  EXECUTE format('CREATE USER %I PASSWORD %L', userName, pw);
  EXECUTE format('GRANT CS205F17Student TO %I', userName);
  EXECUTE format('CREATE SCHEMA %I', userName);
  EXECUTE format('GRANT ALL PRIVILEGES ON SCHEMA %I TO %I', userName, userName);
  EXECUTE format('GRANT USAGE ON SCHEMA %I TO cs205F17Instructor', userName);
  EXECUTE format('ALTER USER %I SET search_path = %I', userName, userName);
END
$$ LANGUAGE plpgsql;

--Creates a role for an instructor given a username and password. The procedure also 
-- adds this new instuctor to the appropriate group, but does not create any schemas.
CREATE OR REPLACE FUNCTION createCS205F17Instructor(userName VARCHAR(25), pw VARCHAR(25)) RETURNS VOID AS
$$
BEGIN
  userName := lower(userName);
  EXECUTE format('CREATE USER %I PASSWORD %L', userName, pw);
  EXECUTE format('GRANT CS205F17Instructor TO %I', userName);
END
$$ LANGUAGE plpgsql;

--Creates a sample student and instructor
SELECT createCS205F17Student('Ramsey033', '50045123');
SELECT createCS205F17Instructor('WestP', '123999888');

--Note that in order to drop the roles, all objects beloging to the role must also be 
-- dropped before doing so.
