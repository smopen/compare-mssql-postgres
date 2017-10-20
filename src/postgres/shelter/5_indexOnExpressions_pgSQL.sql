--Andrew Figueroa; CS299-03; Spring 2017
--
--5_indexOnExpressions_pgSQL.sql
--
--Final Paper Shelter Schema (pgSQL) - 10/8/2017

--Creates a table, followed by creating a sinlge-column index using an 
-- expression as its column

CREATE TABLE Volunteer
(
   vol_id INTEGER PRIMARY KEY,
   fullName VARCHAR(50)
);

CREATE INDEX IX_Volunteer
ON Volunteer(UPPER(fullName));
