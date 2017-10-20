--Steven Rollo; CS299-03; Spring 2017
--
--3_createAdvertTSQL.sql
--
--2017-Spring-CS299 Paper Advert Schema - 10/5/2017

SELECT '3_createAdvertTSQL.sql' "CS299 EXAMPLES";

--The ADVERTISER entity is fully represented by the view ADVERTISER below
CREATE TABLE ADVERTISER_T
(
  advertiser_id NUMERIC(5, 0) CHECK(advertiser_id > -1) PRIMARY KEY,
  university_org NUMERIC(1, 0) CHECK(university_org = 0 OR university_org = 1),
  nonprofit_org NUMERIC(1, 0) CHECK(nonprofit_org = 0 OR nonprofit_org = 1)
  --outstanding_balance is in view ADVERTISER
);
CREATE TABLE CONTACT_INFO
(
  advertiser_id NUMERIC(5, 0) NOT NULL PRIMARY KEY REFERENCES ADVERTISER_T,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state CHAR(2) CHECK(LEN(LTRIM(RTRIM(state))) = 2),
  zip CHAR(5) CHECK(LEN(LTRIM(RTRIM(zip))) = 5),
  email VARCHAR(50) NOT NULL,
  phone CHAR(10) CHECK(LEN(LTRIM(RTRIM(phone))) = 10)
);
CREATE TABLE RATE_CARD
(
  rate_card_id NUMERIC(2, 0) NOT NULL CHECK(rate_card_id > -1) PRIMARY KEY,
  ad_size CHAR(5) NOT NULL CHECK(LEN(LTRIM(RTRIM(ad_size))) = 5),
  price_per_issue NUMERIC(8, 2) NOT NULL
);
CREATE TABLE PRICE_REQUEST
(
  rate_card_id  NUMERIC(2, 0) NOT NULL REFERENCES RATE_CARD,
  advertiser_id NUMERIC(5, 0) NOT NULL REFERENCES ADVERTISER_T,
  PRIMARY KEY(rate_card_id, advertiser_id)
);
CREATE TABLE AD
(
  ad_id NUMERIC(10, 0) CHECK(ad_id > -1) PRIMARY KEY,
  name CHAR(20) CHECK(LEN(LTRIM(RTRIM(name))) = 20) UNIQUE,
  order_date DATE NOT NULL,
  start_date DATE NOT NULL,
  rate_card_id NUMERIC(2, 0) NOT NULL REFERENCES RATE_CARD,
  num_issues NUMERIC(5, 0) NOT NULL,
  prepaid NUMERIC(1, 0) CHECK(prepaid = 0 OR prepaid = 1),
  consec_disc AS (CASE WHEN num_issues > 4 THEN 1 ELSE 0 END),
  premium_place NUMERIC(1, 0) CHECK(premium_place = 0 OR premium_place = 1),
  color NUMERIC(1, 0) CHECK(color = 0 OR color = 1),
  edit NUMERIC(1, 0) CHECK(edit = 0 OR edit = 1),
  advertiser_id NUMERIC(5, 0) NOT NULL REFERENCES ADVERTISER_T
);

CREATE TABLE INVOICE_T
(
  ad_id NUMERIC(10, 0) NOT NULL PRIMARY KEY REFERENCES AD,
  invoice_date DATE NOT NULL,
  advertiser_id NUMERIC(5, 0) NOT NULL REFERENCES ADVERTISER_T
  --total_charge is in view INVOICE
  --fully_paid is in view INVOICE
  --run_complete is in view INVOICE
  --run_failed is in view INVOICE
);
CREATE TABLE PAYMENT
(
  payment_id NUMERIC(16, 0) CHECK(payment_id > -1) PRIMARY KEY,
  advertiser_id NUMERIC(5, 0) NOT NULL REFERENCES ADVERTISER_T,
  ad_id NUMERIC(10, 0) NOT NULL REFERENCES INVOICE_T,
  amount NUMERIC(8, 2) NOT NULL
);
CREATE TABLE AD_RUN
(
  ad_id NUMERIC(10, 0) NOT NULL REFERENCES INVOICE_T,
  issue_date DATE NOT NULL,
  proof_sent NUMERIC(1, 0) CHECK(proof_sent = 0 OR proof_sent = 1 OR proof_sent IS NULL),
  PRIMARY KEY(ad_id, issue_date)
);
GO
CREATE VIEW AD_PRICE AS
SELECT a.ad_id ad_id, a.advertiser_id advertiser_id,
  (a.num_issues * r.price_per_issue) base_price,
  (a.num_issues * r.price_per_issue + 100 * a.edit + a.num_issues
  * r.price_per_issue * 0.30 * a.color + a.num_issues
  * r.price_per_issue * 0.20 * a.premium_place - a.num_issues
  * r.price_per_issue * 0.10 * a.prepaid - a.num_issues
  * r.price_per_issue * 0.10 * a.consec_disc - a.num_issues
  * r.price_per_issue * 0.25 * av.university_org - a.num_issues
  * r.price_per_issue * 0.50 * av.nonprofit_org) total_price
FROM AD a
JOIN RATE_CARD r ON r.rate_card_id = a.rate_card_id
JOIN ADVERTISER_T av ON av.advertiser_id = a.advertiser_id;
GO
CREATE VIEW ADVERTISER AS
SELECT a.advertiser_id advertiser_id, a.university_org university_org, a.nonprofit_org    nonprofit_org,
(
  SELECT SUM(ar.total_price)
  FROM AD_PRICE ar
  WHERE ar.advertiser_id = a.advertiser_id
) -
(
  SELECT SUM(p.amount)
  FROM PAYMENT p
  WHERE p.advertiser_id = a.advertiser_id
) outstanding_balance
FROM ADVERTISER_T a;
GO
CREATE VIEW INVOICE AS
SELECT i.ad_id ad_id, i.invoice_date invoice_date, ap.total_price total_price,
  CASE WHEN COALESCE(ap.total_price -
  (
    SELECT SUM(p.amount)
    FROM Payment p
    WHERE p.ad_id = i.ad_id
   ), ap.total_price) > 0 THEN 0 ELSE 1 END fully_paid,
  CASE WHEN DATEADD(day, a.num_issues, a.start_date) < GETDATE() THEN 1 ELSE 0 END run_complete,
  CASE WHEN DATEADD(day, a.num_issues, a.start_date) > GETDATE() OR
  (
    SELECT SUM(COALESCE(ar.proof_sent, 0))
    FROM AD_RUN ar
    WHERE ar.ad_id = i.ad_id
  ) = a.num_issues THEN 0 ELSE 1 END run_failed
FROM INVOICE_T i
JOIN AD a ON a.ad_id = i.ad_id
JOIN AD_PRICE ap ON ap.ad_id = i.ad_id;
GO
INSERT INTO RATE_CARD
VALUES(0, '01x01', 5);
INSERT INTO RATE_CARD
VALUES(1, '02x02', 10);
INSERT INTO RATE_CARD
VALUES(2, '03x03', 15);
INSERT INTO RATE_CARD
VALUES(3, '10x10', 40);
INSERT INTO RATE_CARD
VALUES(4, 'fullp', 100);
SELECT 'Price List' BASE_DATA;
SELECT *
FROM RATE_CARD;
