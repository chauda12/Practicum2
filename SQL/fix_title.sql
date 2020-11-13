INSERT INTO title (titleID, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes)
SELECT tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes
FROM title_tsv;

INSERT INTO genrehelper(tconst, genre1, genre2, genre3)
SELECT tconst, SUBSTRING_INDEX(genres, ',', 1) AS genre1,
SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 2), ',', -1) AS genre2,
SUBSTRING_INDEX(genres, ',', -1) AS genre3
FROM title_tsv;

INSERT INTO genres(genreText)
SELECT DISTINCT GH.genre1
FROM genrehelper AS GH
WHERE NOT EXISTS (SELECT * FROM genres AS G WHERE G.genreText = GH.genre1);

INSERT INTO genres(genreText)
SELECT DISTINCT GH.genre2
FROM genrehelper AS GH
WHERE NOT EXISTS (SELECT * FROM genres AS G WHERE G.genreText = GH.genre2);

INSERT INTO genres(genreText)
SELECT DISTINCT GH.genre3
FROM genrehelper AS GH
WHERE NOT EXISTS (SELECT * FROM genres AS G WHERE G.genreText = GH.genre3);

INSERT INTO titlegenre(titleID, genreID)
SELECT DISTINCT GH.tconst, G.genreID
FROM genrehelper AS GH, genres AS G
WHERE NOT EXISTS (SELECT TG.titleID, TG.genreID FROM genres AS G, titlegenre AS TG
                  WHERE G.genreID = TG.genreID AND  GH.tconst = TG.titleID)
AND G.genreText = GH.genre1;

INSERT INTO titlegenre(titleID, genreID)
SELECT DISTINCT GH.tconst, G.genreID
FROM genrehelper AS GH, genres AS G
WHERE NOT EXISTS (SELECT TG.titleID, TG.genreID FROM genres AS G, titlegenre AS TG
                  WHERE G.genreID = TG.genreID AND  GH.tconst = TG.titleID)
AND G.genreText = GH.genre2;

INSERT INTO titlegenre(titleID, genreID)
SELECT DISTINCT GH.tconst, G.genreID
FROM genrehelper AS GH, genres AS G
WHERE NOT EXISTS (SELECT TG.titleID, TG.genreID FROM genres AS G, titlegenre AS TG
                  WHERE G.genreID = TG.genreID AND  GH.tconst = TG.titleID)
AND G.genreText = GH.genre3;
