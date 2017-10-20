--Andrew Figueroa; CS299-03; Spring 2017
--
--2_computedColumns_pgSQL.sql
--
--Final Paper Shelter Schema (pgSQL) - 10/8/2017

--Creates a table, followed by a view with an expression as one of its columns

--This provides similar, but not identical, functionality to a computed column
-- in MSSQL

CREATE TABLE dog (
  dog_id INTEGER PRIMARY KEY,
  name VARCHAR(15),
  weight NUMERIC(4,1) );

CREATE VIEW dog_Kg AS (
  SELECT dog_id, name, weight,
    (weight * 0.45359) AS weightKG 
  FROM dog );
