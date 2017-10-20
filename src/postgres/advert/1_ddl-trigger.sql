--Steven Rollo; CS299-03; Spring 2017
--
--1_ddl-trigger.sql
--
--Final Paper Advert Schema (pgSQL) - 5/12/2017
DROP EVENT TRIGGER IF EXISTS log_ddl_trigger;
DROP EVENT TRIGGER IF EXISTS log_ddl_drop_trigger;
DROP FUNCTION IF EXISTS log_ddl();
DROP FUNCTION IF EXISTS log_ddl_drop();
DROP TABLE IF EXISTS ddl_event_log;

CREATE TABLE ddl_event_log(
  id SERIAL PRIMARY KEY,
  event_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
  user_name TEXT,
  event TEXT,
  tag TEXT,
  object_name TEXT,
  object_identity TEXT,
  ip_address INET
);

--Check user permissions on execute trigger / triggering statement
CREATE OR REPLACE FUNCTION log_ddl()
RETURNS event_trigger AS
$BODY$
BEGIN
  INSERT INTO "NewspaperAds".public.ddl_event_log(event_timestamp, user_name, event, tag, object_name, object_identity, ip_address)
  SELECT statement_timestamp(), session_user::text, tg_event, tg_tag, pg.object_type, pg.object_identity, inet_client_addr()
  FROM pg_event_trigger_ddl_commands() pg;
END;
$BODY$
LANGUAGE plpgsql
SECURITY DEFINER;

CREATE OR REPLACE FUNCTION log_ddl_drop()
RETURNS event_trigger AS
$BODY$
BEGIN
  INSERT INTO "NewspaperAds".public.ddl_event_log(event_timestamp, user_name, event, tag, object_name, object_identity, ip_address)
  SELECT statement_timestamp(), session_user::text, tg_event, tg_tag, pg.object_type, pg.object_identity, inet_client_addr()
  FROM pg_event_trigger_dropped_objects() pg;
END;
$BODY$
LANGUAGE plpgsql
SECURITY DEFINER;

CREATE EVENT TRIGGER log_ddl_trigger
ON ddl_command_end
EXECUTE PROCEDURE log_ddl();

CREATE EVENT TRIGGER log_ddl_drop_trigger
ON sql_drop
EXECUTE PROCEDURE log_ddl_drop();
