--Steven Rollo; CS299-03; Spring 2017
--
--5_opspgSQL.sql
--
--2017-Spring-CS299 Paper Advert Schema (pgSQL)- 10/5/2017

SELECT '5_opspgSQL.sql' "CS299 EXAMPLES";

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

INSERT INTO ad_t
VALUES      (1,'DONATIONPL2016000000',CURRENT_DATE - 1,CURRENT_DATE + 7,2,30,0,1,
            0,1,1);
INSERT INTO ad_t
VALUES      (2,'DONATIONPL2016000001',CURRENT_DATE - 30,CURRENT_DATE - 20,0,60,0,
            1,0,0,1);
INSERT INTO ad_t
VALUES      (0, 'RODISCFURN2016000000', CURRENT_DATE - 15, CURRENT_DATE + 31, 4, 90,
            1, 0, 0, 0, 0);
INSERT INTO ad_t
VALUES      (3,'UNIBOOKSTR2016111100',CURRENT_DATE, CURRENT_DATE + 7,3,14,1,
            1,1,1,2);

--Show the result of the user ops and dml trigger
SELECT * FROM ad_t;
SELECT * FROM invoice;
SELECT * FROM ad_run;

--show the results of the ddl trigger
SELECT * FROM ddl_event_log;

--show the results of the dml journaling trigger
SELECT * FROM new_ad_journal;
