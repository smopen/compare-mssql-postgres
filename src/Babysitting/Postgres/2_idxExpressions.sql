--Andrew Figueroa; CS299-03; Spring 2017
--
--2_idxExpressions.sql
--
--Final Paper Babysitting Schema (pgSQL) - 5/11/2017

--The following creates a view which uses an expression as one of its columns. This results in similar functionality to a non-PERSISTED computed column

CREATE VIEW pg_test_view AS 
(
  SELECT SID, SStart, SFinish, (SFinish - SStart) as SLength 
  FROM sitting 
);
