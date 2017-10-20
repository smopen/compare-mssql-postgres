--Andrew Figueroa; CS299-03; Spring 2017
--
--3_multiColumnIndex_pgSQL.sql
--
--Final Paper Shelter Schema (pgSQL) - 10/8/2017

--Creates a multi-column index

CREATE INDEX IX_dog_ArrivalDate
ON dog (arrival_date, name, breed);

--The name and breed column will be used for organizing the index. Although this
-- increases the number of queries which may be covered by the index, it can 
-- slow down the organization of the index.
--This makes the functionalty different from an included column in MSSQL