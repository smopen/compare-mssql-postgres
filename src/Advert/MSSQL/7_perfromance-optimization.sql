--Steven Rollo; CS299-03; Spring 2017
--
--7_performance-optimization.sql
--
--Final Paper Advert Schema - 5/12/2017

--Press ctrl+L to see the plan generate for each query
--Note that the query hint in the second query does force the behavior of the processor to change
--however, it is not an improvement
SELECT ar.ad_id, ar.issue_date, a.premium_place, a.color, a.edit
FROM AD_RUN ar
JOIN AD a ON ar.ad_id = a.ad_id
JOIN INVOICE i ON ar.ad_id = i.ad_id
WHERE i.fully_paid  = 1;

SELECT ar.ad_id, ar.issue_date, a.premium_place, a.color, a.edit
FROM AD_RUN ar
JOIN AD a ON ar.ad_id = a.ad_id
JOIN INVOICE i ON ar.ad_id = i.ad_id
WHERE i.fully_paid  = 1
OPTION(FORCE ORDER);
