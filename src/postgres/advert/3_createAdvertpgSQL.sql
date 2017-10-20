--Steven Rollo; CS299-03; Spring 2017
--
--3_createAdvertpgSQL.sql
--
--2017-Spring-CS299 Paper Advert Schema (pgSQL)- 10/5/2017

SELECT '3_createAdvertpgSQL.sql' "CS299 EXAMPLES";

CREATE TABLE	advertiser_t
(
  advertiser_id NUMERIC(5,0) CHECK(advertiser_id > -1) PRIMARY KEY,
  university_org NUMERIC(1,0) CHECK(university_org = 0 OR university_org = 1),
  nonprofit_org NUMERIC(1,0) CHECK(nonprofit_org = 0 OR nonprofit_org = 1)
);
CREATE TABLE	contact_info
(
  advertiser_id NUMERIC(5,0)  NOT NULL
  PRIMARY KEY REFERENCES advertiser_t,
  name VARCHAR(50) NOT NULL,
  address VARCHAR(50) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state CHAR(2) CHECK(LENGTH(TRIM(state)) = 2),
  zip CHAR(5) CHECK(LENGTH(TRIM(zip)) = 5),
  email VARCHAR(50) NOT NULL,
  phone CHAR(10) CHECK(LENGTH(TRIM(phone)) = 10)
);
CREATE TABLE	rate_card
(
  rate_card_id NUMERIC(2,0) NOT NULL CHECK(rate_card_id > -1) PRIMARY KEY,
  ad_size CHAR(5) NOT NULL CHECK(LENGTH(TRIM(ad_size)) = 5),
  price_per_issue NUMERIC(8,2) NOT NULL
);
CREATE TABLE	price_request
(
  rate_card_id NUMERIC(2,0) NOT NULL REFERENCES rate_card,
  advertiser_id NUMERIC(5,0) NOT NULL REFERENCES advertiser_t,
  PRIMARY KEY(rate_card_id, advertiser_id)
);
CREATE TABLE	ad_t
(
  ad_id NUMERIC(10,0) CHECK(ad_id > -1) PRIMARY KEY,
  name CHAR(20) CHECK(LENGTH(TRIM(name)) = 20) UNIQUE,
  order_date DATE NOT NULL,
  start_date DATE NOT NULL,
  rate_card_id NUMERIC(2,0) NOT NULL REFERENCES RATE_CARD,
  num_issues 	NUMERIC(5,0) NOT NULL,
  prepaid NUMERIC(1,0)  CHECK(prepaid = 0 OR prepaid = 1),
  premium_place NUMERIC(1,0) CHECK(premium_place = 0 OR premium_place = 1),
  color NUMERIC(1,0) CHECK(color = 0 OR color = 1),
  edit NUMERIC(1,0) CHECK(edit = 0 OR edit = 1),
  advertiser_id NUMERIC(5,0) NOT NULL REFERENCES advertiser_t
);
CREATE VIEW ad AS
SELECT
  ad_id, name, order_date, start_date, rate_card_id, num_issues, prepaid,
  (CASE WHEN num_issues > 4 THEN 1 ELSE 0 END) AS consec_disc,
  premium_place, color, edit, advertiser_id
FROM ad_t;
CREATE TABLE 	invoice_t
(
  ad_id NUMERIC(10,0) NOT NULL PRIMARY KEY REFERENCES ad_t,
  invoice_date DATE NOT NULL,
  advertiser_id NUMERIC(5,0) NOT NULL REFERENCES advertiser_t
);
CREATE TABLE 	payment
(
  payment_id 	NUMERIC(16,0) CHECK(payment_id > -1) PRIMARY KEY,
  advertiser_id NUMERIC(5,0) NOT NULL REFERENCES advertiser_t,
  ad_id NUMERIC(10,0) NOT NULL REFERENCES invoice_t,
  amount NUMERIC(8,2)  NOT NULL
);
CREATE TABLE ad_run(
  ad_id NUMERIC(10,0) NOT NULL REFERENCES invoice_t,
  issue_date 	DATE NOT NULL,
  proof_sent 	NUMERIC(1,0) CHECK(proof_sent = 0
  OR proof_sent = 1
  OR proof_sent IS NULL),
  PRIMARY KEY(ad_id, issue_date)
);
CREATE VIEW ad_price AS
SELECT a.ad_id ad_id, a.advertiser_id advertiser_id,
  (a.num_issues * r.price_per_issue)
  base_price,
  (a.num_issues * r.price_per_issue
   + 100 * a.edit
   + a.num_issues * r.price_per_issue * 0.30 * a.color
   + a.num_issues * r.price_per_issue * 0.20 * a.premium_place
   - a.num_issues * r.price_per_issue * 0.10 * a.prepaid
   - a.num_issues * r.price_per_issue * 0.10 * a.consec_disc
   - a.num_issues * r.price_per_issue * 0.25 * av.university_org
   - a.num_issues * r.price_per_issue * 0.50 * av.nonprofit_org) total_price
FROM ad a
JOIN rate_card r ON r.rate_card_id = a.rate_card_id
JOIN advertiser_t av ON av.advertiser_id = a.advertiser_id;
CREATE VIEW advertiser AS
SELECT a.advertiser_id advertiser_id, a.university_org university_org, a.nonprofit_org nonprofit_org,
  (SELECT SUM(ar.total_price)
   FROM ad_price ar
   WHERE ar.advertiser_id = a.advertiser_id)
   - (SELECT 	SUM(p.amount)
   	FROM payment p
       WHERE 	p.advertiser_id = a.advertiser_id) outstanding_balance
FROM advertiser_t a;

CREATE VIEW INVOICE AS
SELECT i.ad_id ad_id, i.invoice_date invoice_date, ap.total_price total_price,
  CASE WHEN COALESCE(ap.total_price
    - (SELECT SUM(p.amount)
       FROM Payment p
       WHERE p.ad_id = i.ad_id), ap.total_price) > 0 THEN 0 ELSE 1 END fully_paid,
  CASE WHEN a.start_date + interval '1day' * a.num_issues < current_date THEN 1 ELSE 0
  END run_complete,
  CASE WHEN a.start_date + interval '1day' * a.num_issues > current_date OR
  (SELECT SUM(COALESCE(ar.proof_sent, 0))
    FROM ad_run ar
    WHERE ar.ad_id = i.ad_id) = a.num_issues THEN 0 ELSE 1 END run_failed
FROM invoice_t i
JOIN ad a ON a.ad_id = i.ad_id
JOIN ad_price ap ON ap.ad_id = i.ad_id;
INSERT INTO rate_card VALUES(0, '01x01', 5);
INSERT INTO rate_card VALUES(1, '02x02', 10);
INSERT INTO rate_card VALUES(2, '03x03', 15);
INSERT INTO rate_card VALUES(3, '10x10', 40);
INSERT INTO rate_card VALUES(4, 'fullp', 100);
