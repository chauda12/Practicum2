SELECT * FROM person WHERE primaryName = 'Frank Sinatra';
/* 0.040 sec / 0.000011 sec */

CREATE INDEX primaryName_index
ON person(primaryName(40));

SELECT * FROM person WHERE primaryName = 'Frank Sinatra';
/* # 0.00056 sec / 0.000028 sec  */
