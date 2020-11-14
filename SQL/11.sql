SELECT P.name, P.age 
FROM person AS P, rating AS R, principals AS Pr, title AS T
WHERE R.averageRating > 5
AND T.titleID = R.titleID
AND T.titleType LIKE "movie"
AND Pr.titleID = T.titleID
AND Pr.category LIKE "actor"