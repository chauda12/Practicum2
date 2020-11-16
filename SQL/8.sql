SELECT T.titleID, MAX(E.seasonNumber)
FROM mediatype AS Mt, titleinfo AS Ti, title AS T, episode AS E, titlemediatype AS Tmt
WHERE Mt.mediaTypeText LIKE 'tv'
AND Tmt.mediaTypeID = Mt.mediaTypeID
AND Ti.titleInfoID = Tmt.titleInfoID
AND T.titleID = Ti.titleID
AND E.parentTconst = T.titleID;

/* above wasn't working for me , my implementation below*/

SELECT title.titleID, MAX(episode.seasonNumber) FROM title
JOIN titleInfo ON titleInfo.titleId = titleInfo.titleId
JOIN titleInfoMediaType ON titleInfoMediaType.titleInfoID = titleInfo.titleInfoID
JOIN mediaType ON mediaType.mediaTypeText = 'tv'
JOIN episode ON episode.titleId = title.titleId
GROUP BY titleID;
