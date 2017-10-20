--Andrew Figueroa; CS299-03; Spring 2017
--
--2_filteredIndexpgSQL.sql
--
--Final Paper Shelter Schema (pgSQL) - 10/8/2017

--Creates a filtered index which only includes rows where arrival_date is after
-- 2010-01-01
-- (depending on the data stored in the table, this theoretically could result
-- in zero rows being indexed

CREATE INDEX IX_dog_RecentArrival
WHERE arrival_date > '2010-01-01';

--The index will only include rows where dogs have arrived after 2010 (depending
-- on the data stored in the table, this theoretically could result in zero rows
-- being indexed).