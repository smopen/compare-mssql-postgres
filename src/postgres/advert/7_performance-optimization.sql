--Steven Rollo; CS299-03; Spring 2017
--
--7_performance-optimization.sql
--
--2017-Spring-CS299 Paper Advert Schema (pgSQL)- 10/5/2017

--This script shows how turing on or off enable_hashjoin affects the query plan
-- genrated by the query processor
--Note that this script must be run as a superuser
SELECT '7_performance-optimization.sql' "CS299 EXAMPLES";

EXPLAIN
SELECT ar.ad_id, ar.issue_date, a.premium_place, a.color, a.edit
FROM AD_RUN ar
JOIN AD a ON ar.ad_id = a.ad_id
JOIN INVOICE i ON ar.ad_id = i.ad_id
WHERE i.fully_paid  = 1;

ALTER SYSTEM SET enable_hashjoin TO 'off';
SELECT pg_reload_conf();

EXPLAIN
SELECT ar.ad_id, ar.issue_date, a.premium_place, a.color, a.edit
FROM AD_RUN ar
JOIN AD a ON ar.ad_id = a.ad_id
JOIN INVOICE i ON ar.ad_id = i.ad_id
WHERE i.fully_paid  = 1;

ALTER SYSTEM SET enable_hashjoin TO 'on';
SELECT pg_reload_conf();
