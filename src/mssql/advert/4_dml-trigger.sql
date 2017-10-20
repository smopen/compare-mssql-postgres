--Steven Rollo; CS299-03; Spring 2017
--
--4_dml-trigger.sql
--
--Final Paper Advert Schema - 5/12/2017

--This script creates two example DML triggers for the Advert schema

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

--delete_ad_runs automatically removes other data that is uneeded after an ad instance is removed
--The results of this trigger can be seen after running 5_opsTSQL
CREATE OR ALTER TRIGGER delete_ad_runs
ON ad
INSTEAD OF DELETE --Approximate a BEFORE DELETE trigger
AS
BEGIN --t-sql doesn't support FOR EACH ROW triggers, so get all ad_id's deleted and use them
	DELETE FROM ad_run
	WHERE ad_id = ANY(SELECT ad_id FROM deleted);
	DELETE FROM payment
	WHERE ad_id = ANY(SELECT ad_id FROM deleted);
	DELETE FROM invoice_t
	WHERE ad_id = ANY(SELECT ad_id FROM deleted);
	DELETE FROM ad
	WHERE ad_id = ANY(SELECT ad_id FROM deleted);
END
GO