
CREATE TABLE yahoo_result_tmp AS
SELECT *
FROM yahoo_result;

Truncate table yahoo_result;

INSERT INTO yahoo_result
SELECT ticker,_date,close,"open",high,low,volume FROM (
SELECT *,  ROW_NUMBER() OVER (PARTITION BY ticker, _date ORDER BY _date DESC) rn
 FROM yahoo_result_tmp

)
WHERE rn = 1
;


DROP TABLE IF EXISTS    yahoo_result_tmp;