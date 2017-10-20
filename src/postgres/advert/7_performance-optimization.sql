--Steven Rollo; CS299-03; Spring 2017
--
--7_performance-optimization.sql
--
--Final Paper Advert Schema (pgSQL)- 5/12/2017

--Unfortunately, there is no way to set the planner method configurations in
--a script file.  In demonstrate, first run this file once and observe then plan
--it generates.  Then, find the configuration file it displays, and set
--enable_hashjoin = off.  Then, restart the server and rerun this query to
--see the different plan generated
SHOW config_file;

EXPLAIN
SELECT ar.ad_id, ar.issue_date, a.premium_place, a.color, a.edit
FROM AD_RUN ar
JOIN AD a ON ar.ad_id = a.ad_id
JOIN INVOICE i ON ar.ad_id = i.ad_id
WHERE i.fully_paid  = 1;
