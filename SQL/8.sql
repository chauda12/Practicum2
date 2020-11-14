SELECT T.titleID, MAX(E.seasonNumber)
FROM mediatype AS Mt, titleinfo AS Ti, title AS T, episode AS E, titlemediatype AS Tmt
WHERE Mt.mediaTypeText LIKE 'tv'
AND Tmt.mediaTypeID = Mt.mediaTypeID
AND Ti.titleInfoID = Tmt.titleInfoID
AND T.titleID = Ti.titleID
AND E.parentTconst = T.titleID;