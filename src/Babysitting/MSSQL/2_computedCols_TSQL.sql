--Andrew Figueroa; CS299-03; Spring 2017
--
--2_computedCols_TSQL.sql
--
--Final Paper Babysitting Schema (T-SQL) - 5/11/2017

--Creates a computed column natively. To match the implementation in Postgres, the column is not marked as PERSISTED, meaning that the expression is computed everytime, rather than being stored on disk.

--The original schema also had a similar computed column 

CREATE TABLE mssql_test (
  SID INTEGER PRIMARY KEY
  SStart DATETIME2,
  SFinish DATETIME2,
  SLength AS (ROUND(DATEDIFF(mi, SStart, SFinish)/ 60.0, 0)) 
);