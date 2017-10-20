--Andrew Figueroa; CS299-03; Spring 2017
--
--5_indexOnExpressionsTSQL.sql
--
--Final Paper Shelter Schema (T-SQL) - 10/8/2017

--Creates a table with a computed column and then creates an index on that 
-- column. This results in similar functionality to an index on an expression.

CREATE TABLE Volunteer
(
   vol_id INTEGER PRIMARY KEY,
   fullName VARCHAR(50)
   fullNameCaps AS UPPER(fullName)
);

CREATE INDEX IX_Volunteer
ON Volunteer(fullNameCaps);
