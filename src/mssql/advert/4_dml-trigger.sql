--Steven Rollo; CS299-03; Spring 2017
--
--4_dml-trigger.sql
--
--2017-Spring-CS299 Paper Advert Schema (MSSQL) - 10/5/2017

--This script creates two example DML triggers for the Advert schema

--updateAdJournal records whenever a new row is inserted into ad
-- This shows an example of a trigger journaling user activity
-- The results of this trigger can be seen after running 5_opsTSQL
SELECT '4_dml-trigger.sql' "CS299 EXAMPLES";
GO
--update_ad_runs automatically creates ad_run instances when a new ad instance is created
--This shows an example of a trigger enforcing buisiness requirements
--The results of this trigger can be seen after running 5_opsTSQL
CREATE OR ALTER TRIGGER update_ad_runs
ON ad
AFTER INSERT AS
BEGIN
	DECLARE @cDate DATE = CAST(GETDATE() AS DATE);

	INSERT INTO invoice_t
	SELECT ad_id, @cDAte, advertiser_id
	FROM inserted;

	WITH expanded AS (
		SELECT ad_id, start_date, CAST(num_issues AS int) ni
		FROM inserted
		UNION ALL
		SELECT ad_id, start_date, ni - 1
		FROM expanded
		WHERE ni > 1)
	INSERT INTO ad_run
	SELECT ad_id, DATEADD(day, ROW_NUMBER() OVER (ORDER BY ad_id, ni) - 1, start_date), 0
	FROM expanded
	ORDER BY ad_id, ni;

	INSERT INTO payment
	SELECT (SELECT COALESCE(MAX(payment_id), -1)
			FROM payment) + 1,
			advertiser_id, ad_id,
			(SELECT i.total_price
			FROM invoice i
			WHERE inserted.ad_id = i.ad_id)
	FROM inserted
	WHERE prepaid = 1;
END
GO

DROP TABLE IF EXISTS new_ad_journal;
DROP TRIGGER IF EXISTS updateAdJournal;

CREATE TABLE new_ad_journal (
   id INT IDENTITY(1,1) PRIMARY KEY,
   insert_timestamp DATETIME NOT NULL,
   user_name NVARCHAR(255),
   ip_address NVARCHAR(32),
   ad_id NUMERIC(10,0) REFERENCES AD
);
GO

CREATE TRIGGER updateAdJournal
ON AD
AFTER INSERT AS
BEGIN
   DECLARE @ip NVARCHAR(32) =
   (SELECT client_net_address
   FROM sys.dm_exec_connections
   WHERE session_id = @@SPID);
   INSERT INTO new_ad_journal(insert_timestamp, user_name, ip_address, ad_id)
   SELECT CURRENT_TIMESTAMP, ORIGINAL_LOGIN(), @ip, ad_id
   FROM inserted;
END
GO
