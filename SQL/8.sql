SELECT E.parentTconst, MAX(E.seasonNumber)
FROM title AS T, episode AS E
WHERE T.titleType = "tvSeries"
AND E.parentTconst = T.titleID
GROUP BY E.parentTconst;

/* above wasn't working for me , my implementation below*/

SELECT title.titleID, MAX(episode.seasonNumber) FROM title
JOIN titleInfo ON titleInfo.titleId = title.titleId
JOIN titlemediatype ON titleinfomediatype.titleInfoID = titleInfo.titleInfoID
JOIN mediaType ON mediaType.mediaTypeText = 'tv'
JOIN episode ON episode.titleId = title.titleId
GROUP BY titleID;
