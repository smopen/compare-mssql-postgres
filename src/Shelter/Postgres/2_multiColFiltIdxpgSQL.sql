--Andrew Figueroa; CS299-03; Spring 2017
--
--2_multiColFiltIdx.sql
--
--Final Paper Shelter Schema (pgSQL) - 5/11/2017

--Creates a filtered multi-column index

CREATE INDEX IX_dog_arrivalDate
ON dog (arrival_date, name, breed)
WHERE arrival_date > '2010-01-01';

--The name and breed column will be used for organizing the index. Although this increases the number of queries which may be covered by the index, it can slow down the organization of the index.
--The index will only include rows where dogs have arrived after 2010 (depending on the data stored in the table, this may result in the index having no rows).