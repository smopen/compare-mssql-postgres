--Steven Rollo; CS299-03; Spring 2017
--
--4_dml-trigger.sql
--
--2017-Spring-CS299 Paper Advert Schema (pgSQL)- 10/5/2017

SELECT '4_dml-trigger.sql' "CS299 EXAMPLES";

--When a new ad is inserted into the db, this function is executed by a trigger
CREATE OR REPLACE FUNCTION update_ad_runs()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO invoice_t VALUES(NEW.ad_id, CURRENT_DATE, NEW.advertiser_id); --Generate an invoice for the ad

	WITH RECURSIVE expanded AS ( --Postgres requires explicit recursive declaration
		SELECT NEW.ad_id, NEW.start_date, CAST(NEW.num_issues AS int) ni
		UNION ALL
		SELECT ad_id, start_date, ni - 1
		FROM expanded
		WHERE ni > 1)
	INSERT INTO ad_run(ad_id, issue_date, proof_sent)
	(SELECT ad_id, start_date + CAST(ROW_NUMBER() OVER (ORDER BY ad_id, ni) AS int) - 1, 0
	FROM expanded
	ORDER BY ad_id, ni);
	--If the ad is prepaid, create the payment that has already been paid automatically
	INSERT INTO payment VALUES(
		(SELECT COALESCE(MAX(payment_id), -1)
		FROM payment) + 1
		,NEW.advertiser_id, NEW.ad_id,
		(SELECT i.total_price
		FROM invoice i
		WHERE NEW.ad_id = i.ad_id));

		RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_ad_runs_trigger
AFTER INSERT
ON ad_t
FOR EACH ROW
EXECUTE PROCEDURE update_ad_runs();


DROP TABLE IF EXISTS new_ad_journal;

CREATE TABLE new_ad_journal (
   id SERIAL PRIMARY KEY,
   insert_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
   user_name TEXT,
   ip_address INET,
   ad_id NUMERIC(10,0) REFERENCES ad_t
);

--When a new ad is inserted into the db, this function is executed by a trigger
CREATE OR REPLACE FUNCTION updateNewAdJournal()
RETURNS trigger AS
$$
BEGIN
   INSERT INTO new_ad_journal(insert_timestamp, user_name, ip_address, ad_id)
   SELECT statement_timestamp(), session_user::TEXT, inet_client_addr(), NEW.ad_id;
   RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER updateAdJournalTrigger
AFTER INSERT
ON ad_t
FOR EACH ROW
EXECUTE PROCEDURE updateNewAdJournal();
