--Andrew Figueroa; CS299-03; Spring 2017
--
--2_computedColumns_TSQL.sql
--
--Final Paper Shelter Schema (T-SQL) - 10/8/2017

--Creates a table with a computed column

CREATE TABLE dog
(
   dog_id INTEGER PRIMARY KEY,
   name VARCHAR(15),
   weight NUMERIC(4,1),
   weightKg AS weight * 0.45359
);

--The computed columns created above (weightKG) is not physically stored, since
-- it is not marked as PERSISTED.