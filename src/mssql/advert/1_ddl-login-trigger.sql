--Steven Rollo; CS299-03; Spring 2017
--
--1_ddl-login-trigger.sql
--
--2017-Spring-CS299 Paper Advert Schema (MSSQL) - 10/5/2017

SELECT '1_ddl-login-trigger.sql' "CS299 EXAMPLES";

--NOTE: this assumes the databaes for your Advert schema is called Advert, replace as necessary
-- This statement allows a statement executed at the database level to gain permissions at the server level
-- Without this, the user executing the ddl trigger in the Advert database will not have permission to
-- write to the log table in master.
-- Using this statement is not secure for a production enviroment,
-- however it is sufficient for demonstrating a ddl trigger
ALTER DATABASE Advert SET TRUSTWORTHY OFF;

USE master; --These triggers will be scoped to the server
GO

DROP TRIGGER IF EXISTS log_ddl_trigger ON ALL SERVER;
DROP TABLE IF EXISTS master.dbo.ddl_event_log;

--This table will record ddl events that happen in the server
CREATE TABLE master.dbo.ddl_event_log(
	id int IDENTITY(1,1) PRIMARY KEY,
	event_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	event_type NVARCHAR(64),
	event_ddl NVARCHAR(MAX),
	target_name NVARCHAR(1024),
	ip_address NVARCHAR(32),
	login_name NVARCHAR(255)
);
GO

--QUOTED_IDENTIFIER must be ON when creating a procedure that calls XML functions
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/set-quoted-identifier-transact-sql
SET QUOTED_IDENTIFIER ON;
GO

--When a ddl statement occurs, log it to ddl_event_log
CREATE TRIGGER log_ddl_trigger
ON ALL SERVER
WITH EXECUTE AS SELF
FOR DDL_TABLE_VIEW_EVENTS
AS
BEGIN
	DECLARE @event_data XML = EVENTDATA();
	DECLARE @ip NVARCHAR(32) =
	(SELECT client_net_address
	FROM sys.dm_exec_connections
	WHERE session_id = @@SPID);
	INSERT INTO master.dbo.ddl_event_log(event_type, event_ddl, target_name, ip_address, login_name)
	SELECT   @event_data.value('(/EVENT_INSTANCE/EventType)[1]',   'NVARCHAR(100)'),
				@event_data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)'),
				@event_data.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)'),
				@ip,
				ORIGINAL_LOGIN();
END
GO

SET QUOTED_IDENTIFIER OFF;
GO

USE master;
GO

DROP TRIGGER IF EXISTS log_logon_trigger ON ALL SERVER;
DROP TABLE IF EXISTS master.dbo.user_logon_log;

CREATE TABLE master.dbo.user_logon_log(
	id int IDENTITY(1,1) PRIMARY KEY,
	logon_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	logon_name NVARCHAR(255),
	ip_address NVARCHAR(32)
);
GO

CREATE TRIGGER log_logon_trigger
ON ALL SERVER
WITH EXECUTE AS SELF
FOR LOGON
AS
BEGIN
	DECLARE @ip NVARCHAR(32) =
	(SELECT client_net_address
	FROM sys.dm_exec_connections
	WHERE session_id = @@SPID);
	DECLARE @username NVARCHAR(255) = ORIGINAL_LOGIN();
	INSERT INTO master.dbo.user_logon_log(logon_name, ip_address)
	SELECT @username, @ip;
END
GO
