--Steven Rollo; CS299-03; Spring 2017
--
--4_dml-trigger.sql
--
--Final Paper Advert Schema (pgSQL)- 5/12/2017

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

--When an existing ad is removed from the db, this function is executed by a trigger
CREATE OR REPLACE FUNCTION delete_ad_runs()
RETURNS trigger AS
$BODY$
BEGIN --Remove all ad_runs, invoices and payments associated with the ad being removed
	DELETE FROM ad_run WHERE ad_id = OLD.ad_id;
	DELETE FROM payment WHERE ad_id = OLD.ad_id;
	DELETE FROM invoice_t WHERE ad_id = OLD.ad_id;
	RETURN OLD;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_ad_runs_trigger ON ad_t;
DROP TRIGGER IF EXISTS delete_ad_runs_trigger ON ad_t;

CREATE TRIGGER update_ad_runs_trigger
AFTER INSERT
ON ad_t
FOR EACH ROW
EXECUTE PROCEDURE update_ad_runs();

CREATE TRIGGER delete_ad_runs_trigger
BEFORE DELETE
ON ad_t
FOR EACH ROW
EXECUTE PROCEDURE delete_ad_runs();
