--Andrew Figueroa; CS299-03; Spring 2017
--
--3_includedColumns_TSQL.sql
--
--Final Paper Shelter Schema (T-SQL) - 10/8/2017

--Creates an index with included columns

CREATE INDEX IX_dog_ArrivalDate
ON dog (arrival_date)
INCLUDE (name, breed);


--The name and breed column will not be used for organizing the index, but will
-- be included (stored) with the index, which can speed up queries without
-- slowing down organization of the index.
