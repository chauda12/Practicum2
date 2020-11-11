INSERT INTO title (titleID, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes)
SELECT tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes
FROM title_tsv;

INSERT INTO titleInfo (titleID, ordering, title, region, language, isOriginalTitle)
SELECT titleID, ordering, title, region, language, isOriginalTitle
FROM akas_tsv;

INSERT INTO person (personID, primaryName, birthYear, deathYear)
SELECT nconst, primaryName, birthYear, deathYear
FROM name_tsv;

INSERT INTO rating (titleID, averageRating, numVotes)
SELECT tconst, averageRating, numVotes
FROM ratings_tsv rtsv INNER JOIN title t ON rtsv.tconst = t.titleID;

INSERT INTO episode (titleID, seasonNumber, episodeNumber)
SELECT tconst, seasonNumber, episodeNumber
FROM episode_tsv etsv INNER JOIN title t ON etsv.tconst = t.titleID;

INSERT INTO principals (titleID, ordering, personID, category, job, characters)
SELECT tconst, ordering, nconst, category, job, characters
FROM principals_tsv ptsv INNER JOIN title t ON ptsv.tconst = t.titleID INNER JOIN person p ON ptsv.nconst = p.personId;


/* TO DO : INSERT INTO CREW TABLE from tsv
