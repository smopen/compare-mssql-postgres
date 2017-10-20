--Steven Rollo; CS299-03; Spring 2017
--
--5_opsTSQL.sql
--
--Final Paper Advert Schema - 5/12/2017

--This script performs some operations on the tables in the Advert schema.
--These will demonstrate the triggers created in the previous script
INSERT INTO advertiser_t
VALUES      (0, 0, 0);
INSERT INTO contact_info
VALUES      (0, 'Robert''s Discount Furniture', '000 Example Street', 'Danbury',
            'CT', '00000', 'robert@rdiscountfurniture.net', '5555555555');

INSERT INTO advertiser_t
VALUES      (1, 0, 1);
INSERT INTO contact_info
VALUES      (1,'Donation Place','020 Other Street','Danbury','CT','00000',
            'joea@donationplc.org','5555555555');

INSERT INTO advertiser_t
VALUES      (2,1,0);
INSERT INTO contact_info
VALUES      (2,'Univeristy Bookstore','020 Street Street','Danbury','CT',
            '00000','contact-bookstore@univ.edu','5555555555');

INSERT INTO price_request
VALUES      (3, 0);
INSERT INTO price_request
VALUES      (4, 0);
INSERT INTO price_request
VALUES      (0,1);
INSERT INTO price_request
VALUES      (2,1);

INSERT INTO ad
VALUES      (1,'DONATIONPL2016000000',DATEADD(day,-1, CAST(GETDATE() AS DATE)), DATEADD(day, 7, CAST(GETDATE() AS DATE)),2,30,0,1,0,1,1);
INSERT INTO ad
VALUES      (2,'DONATIONPL2016000001',DATEADD(day, -30, CAST(GETDATE() AS DATE)), DATEADD(day, -20, CAST(GETDATE() AS DATE)),0,60,0,1,0,0,1);
INSERT INTO ad
VALUES      (0, 'RODISCFURN2016000000',DATEADD(day, -15, CAST(GETDATE() AS DATE)), DATEADD(day, 31, CAST(GETDATE() AS DATE)), 4, 90,1, 0, 0, 0, 0);
INSERT INTO ad
VALUES      (3,'UNIBOOKSTR2016111100',DATEADD(day, 0, CAST(GETDATE() AS DATE)), DATEADD(day, 7, CAST(GETDATE() AS DATE)),3,14,1,1,1,1,2);

--Show the result of the user ops and dml trigger
SELECT * FROM ad;
SELECT * FROM invoice;
SELECT * FROM ad_run;
SELECT * FROM payment;

DELETE FROM ad WHERE ad_id = 1;

--show the results of the delete dml trigger
SELECT * FROM ad;
SELECT * FROM invoice;
SELECT * FROM ad_run;

--show the results of the ddl and logon triggers
SELECT * FROM master.dbo.ddl_event_log;
SELECT * FROM master.dbo.user_logon_log;
