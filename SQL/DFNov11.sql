USE practicum2;
/********************************************************************************************************************************/

/*********** TITLE *************/
/* run python script to create and load data into tsv table where all values are strings. nulls are correctly inserted */
SELECT * FROM title_tsv;
DESCRIBE title_tsv;

/* create properly formatted table */
Create Table title (
	titleID varchar(40),
    titleType longtext,
    primaryTitle longtext,
    originalTitle longtext,
    isAdult bool,
    startYear int,
    endYear int,
    runtimeMinutes int,
    Constraint PK_titleID Primary Key (titleID)
);

/* Transfer data from title_tsv to title table. */
INSERT INTO title (titleID, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes)
SELECT tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes
FROM title_tsv;

SELECT * FROM title;
DESCRIBE title;
/********************************************************************************************************************************/

/*********** AKAS // TitleInfo *************/
/* run python script to create and load data into tsv table where all values are strings. nulls are correctly inserted */
SELECT * FROM akas_tsv;
DESCRIBE akas_tsv;

Create Table titleInfo (
	titleInfoID int AUTO_INCREMENT,
	titleID varchar(40),
    ordering int,
    title longtext,
    region varchar(40),
    language varchar(40),
    isOriginalTitle bool,
    Constraint PK_titleInfoID Primary Key (titleInfoID),
    Constraint FK_titleID_ti Foreign Key (titleID) REFERENCES title(titleID)
);

/*transfer data from tsv to newly corrected table */
INSERT INTO titleInfo (titleID, ordering, title, region, language, isOriginalTitle)
SELECT atsv.titleID, ordering, title, region, language, isOriginalTitle
FROM akas_tsv atsv INNER JOIN title t ON atsv.titleID = t.titleID;

SELECT * FROM titleInfo;
DESCRIBE titleInfo;
/********************************************************************************************************************************/

/*********** Name / Person *************/
SELECT * FROM name_tsv;

Create Table person (
	personID varchar(40),
    primaryName longtext,
    birthYear int,
    deathYear int,
    Constraint PK_personID Primary Key (personID)
);

INSERT INTO person (personID, primaryName, birthYear, deathYear)
SELECT nconst, primaryName, birthYear, deathYear
FROM name_tsv;
/********************************************************************************************************************************/

/*********** Rating *************/
SELECT * from ratings_tsv;

Create Table rating (
	ratingID int AUTO_INCREMENT,
    titleID varchar(40),
    averageRating int,
    numVotes int,
    Constraint PK_ratingID Primary Key (ratingID),
    Constraint FK_titleID_r Foreign Key (titleID) References title(titleID)
);

INSERT INTO rating (titleID, averageRating, numVotes)
SELECT tconst, averageRating, numVotes
FROM ratings_tsv rtsv INNER JOIN title t ON rtsv.tconst = t.titleID;

SELECT * FROM rating;

/********************************************************************************************************************************/

/*********** Episode *************/
SELECT * from episode_tsv;

Create Table episode (
	episodeID int AUTO_INCREMENT,
    titleID varchar(40),
    seasonNumber int,
    episodeNumber int,
    Constraint PK_episodeID Primary Key (episodeID),
    Constraint FK_titleID_e Foreign Key (titleID) References title(titleID)
);

INSERT INTO episode (titleID, seasonNumber, episodeNumber)
SELECT tconst, seasonNumber, episodeNumber
FROM episode_tsv etsv INNER JOIN title t ON etsv.tconst = t.titleID;

SELECT * FROM episode;
/********************************************************************************************************************************/


/********************************************************************************************************************************/

/*********** Principals *************/
SELECT * from principals_tsv;

Create Table principals (
	principalID int AUTO_INCREMENT,
    titleID varchar(40),
    ordering int,
    personID varchar(40),
    category longtext,
    job longtext,
    characters longtext,
    Constraint PK_principalID Primary Key (principalID),
	Constraint FK_titleID_p Foreign Key (titleID) References title(titleID),
	Constraint FK_personID_p Foreign Key (personID) References person(personID)
);

INSERT INTO principals (titleID, ordering, personID, category, job, characters)
SELECT tconst, ordering, nconst, category, job, characters
FROM principals_tsv ptsv INNER JOIN title t ON ptsv.tconst = t.titleID INNER JOIN person p ON ptsv.nconst = p.personId;

SELECT * FROM principals;
/********************************************************************************************************************************/

/*********** Crew - Crew/Director - Crew/Writer *************/
SELECT * FROM crew_tsv;

Create Table crew (
	crewID int AUTO_INCREMENT,
	titleID varchar(40),
	Constraint PK_crewID Primary Key (crewID),
	Constraint FK_titleID_c Foreign Key (titleID) References title(titleID)
);

INSERT INTO crew (titleID)
SELECT tconst FROM crew_tsv;

SELECT * FROM crew;

Create Table crewhelper (
	crewId varchar(40),
    director1 varchar(40),
	director2 varchar(40),
    director3 varchar(40),
    writer1 varchar(40),
	writer2 varchar(40),
    writer3 varchar(40)
);

INSERT INTO crewhelper(crewId, director1, director2, director3, writer1, writer2, writer3)
SELECT crewId, SUBSTRING_INDEX(directors, ',', 1) AS director1,
SUBSTRING_INDEX(SUBSTRING_INDEX(directors, ',', 2), ',', -1) AS director2,
SUBSTRING_INDEX(directors, ',', -1) AS director3,
SUBSTRING_INDEX(writers, ',', 1) AS writer1,
SUBSTRING_INDEX(SUBSTRING_INDEX(writers, ',', 2), ',', -1) AS writer2,
SUBSTRING_INDEX(writers, ',', -1) AS writer3
FROM crew_tsv JOIN title ON crew_tsv.tconst = title.titleId JOIN crew ON crew_tsv.tconst = crew.titleId;

SELECT * FROM crewhelper;

/* director */

Create Table directors (
	directorID varchar(40),
    Constraint directorID Primary Key (directorID)
);

INSERT INTO directors(directorID)
SELECT DISTINCT CH.director1
FROM crewhelper AS CH
WHERE CH.director1 IS NOT NULL AND
NOT EXISTS (SELECT * FROM directors AS D WHERE D.directorId = CH.director1);

INSERT INTO directors(directorID)
SELECT DISTINCT CH.director2
FROM crewhelper AS CH
WHERE CH.director2 IS NOT NULL AND
NOT EXISTS (SELECT * FROM directors AS D WHERE D.directorId = CH.director2);

INSERT INTO directors(directorID)
SELECT DISTINCT CH.director3
FROM crewhelper AS CH
WHERE CH.director3 IS NOT NULL AND
NOT EXISTS (SELECT * FROM directors AS D WHERE D.directorId = CH.director3);

SELECT * FROM directors;

Create Table crewDirector (
	crewDirectorID int AUTO_INCREMENT,
    crewID int,
    DirectorID varchar(40),
    Constraint PK_crewDirectorID Primary Key (crewDirectorID),
    Constraint FK_crewID_cd Foreign Key (crewID) References crew(crewID),
	Constraint FK_DirectorID_cd Foreign Key (DirectorID) References directors(DirectorID)
);

INSERT INTO crewDirector(crewId, directorID)
SELECT DISTINCT crewId, director1
FROM crewhelper
WHERE director1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, directorID FROM crewDirector WHERE directorID = crewhelper.director1);
SELECT * FROM crewDirector;

INSERT INTO crewDirector(crewId, directorID)
SELECT DISTINCT crewId, director2
FROM crewhelper
WHERE director1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, directorID FROM crewDirector WHERE directorID = crewhelper.director2);
SELECT * FROM crewDirector;

INSERT INTO crewDirector(crewId, directorID)
SELECT DISTINCT crewId, director3
FROM crewhelper
WHERE director1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, directorID FROM crewDirector WHERE directorID = crewhelper.director3);
SELECT * FROM crewDirector;

SELECT * from crewDirector;

/* writer */

Create Table writers (
	writerID varchar(40),
    Constraint writerID Primary Key (writerID)
);

INSERT INTO writers(writerID)
SELECT DISTINCT CH.writer1
FROM crewhelper AS CH
WHERE CH.writer1 IS NOT NULL AND
NOT EXISTS (SELECT * FROM writers AS W WHERE W.writerId = CH.writer1);

INSERT INTO writers(writerID)
SELECT DISTINCT CH.writer2
FROM crewhelper AS CH
WHERE CH.writer2 IS NOT NULL AND
NOT EXISTS (SELECT * FROM writers AS W WHERE W.writerId = CH.writer2);

INSERT INTO writers(writerID)
SELECT DISTINCT CH.writer3
FROM crewhelper AS CH
WHERE CH.writer3 IS NOT NULL AND
NOT EXISTS (SELECT * FROM writers AS W WHERE W.writerId = CH.writer3);

SELECT * FROM writers;

Create Table crewwriter (
	crewwriterID int AUTO_INCREMENT,
    crewID int,
    writerID varchar(40),
    Constraint PK_crewwriterID Primary Key (crewwriterID),
    Constraint FK_crewID_cw Foreign Key (crewID) References crew(crewID),
	Constraint FK_writerID_cw Foreign Key (writerID) References writers(writerID)
);

INSERT INTO crewwriter(crewId, writerID)
SELECT DISTINCT crewId, writer1
FROM crewhelper
WHERE writer1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, writerID FROM crewwriter WHERE writerID = crewhelper.writer1);
SELECT * FROM crewwriter;

INSERT INTO crewwriter(crewId, writerID)
SELECT DISTINCT crewId, writer2
FROM crewhelper
WHERE writer1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, writerID FROM crewwriter WHERE writerID = crewhelper.writer2);
SELECT * FROM crewwriter;

INSERT INTO crewwriter(crewId, writerID)
SELECT DISTINCT crewId, writer3
FROM crewhelper
WHERE writer1 IS NOT NULL AND
NOT EXISTS (SELECT crewId, writerID FROM crewwriter WHERE writerID = crewhelper.writer3);
SELECT * FROM crewwriter;

SELECT * from crewwriter;
/********************************************************************************************************************************/

/*********** Attribute, titleAttribute, AttributeHelper *************/
SELECT * FROM titleInfo;
SELECT * FROM akas_tsv;

Create Table attributehelper (
	titleInfoId varchar(40),
    attribute1 varchar(40),
    attribute2 varchar(40),
    attribute3 varchar(40)
);

INSERT INTO attributehelper(titleInfoId, attribute1, attribute2, attribute3)
SELECT titleInfoId, SUBSTRING_INDEX(attributes, ' ', 1) AS attribute1,
SUBSTRING_INDEX(SUBSTRING_INDEX(attributes, ' ', 2), ' ', -1) AS attribute2,
SUBSTRING_INDEX(attributes, ' ', -1) AS attribute3
FROM akas_tsv JOIN titleInfo ON akas_tsv.titleID = titleInfo.titleId;

SELECT * FROM attributehelper;

Create Table attributes (
	attributeID int AUTO_INCREMENT,
	attributeText varchar(40),
    Constraint PK_attributeID Primary Key (attributeID)
);

INSERT INTO attributes(attributeText)
SELECT DISTINCT AH.attribute1
FROM attributehelper AS AH
WHERE NOT EXISTS (SELECT * FROM attributes AS A WHERE A.attributeText = AH.attribute1);

INSERT INTO attributes(attributeText)
SELECT DISTINCT AH.attribute2
FROM attributehelper AS AH
WHERE NOT EXISTS (SELECT * FROM attributes AS A WHERE A.attributeText = AH.attribute2);

INSERT INTO attributes(attributeText)
SELECT DISTINCT AH.attribute3
FROM attributehelper AS AH
WHERE NOT EXISTS (SELECT * FROM attributes AS A WHERE A.attributeText = AH.attribute3);

SELECT * FROM attributes;

Create Table titleInfoAttribute (
	titleInfoAttributeID int AUTO_INCREMENT,
    titleInfoID int,
    attributeID int,
    Constraint PK_titleInfoAttributeID Primary Key (titleInfoAttributeID),
    Constraint FK_titleInfoID_tia Foreign Key (titleInfoID) References titleInfo(titleInfoID),
	Constraint FK_attributeID_tia Foreign Key (attributeID) References attributes(attributeID)
);

INSERT INTO titleInfoAttribute(titleInfoID, attributeID)
SELECT DISTINCT AH.titleInfoId, A.attributeID
FROM attributehelper AS AH, attributes AS A
WHERE NOT EXISTS (SELECT TIA.titleInfoID, TIA.attributeID FROM attributes AS A, titleInfoAttribute AS TIA
                  WHERE A.attributeID = TIA.attributeID AND  AH.titleInfoId = TIA.titleInfoId)
AND A.attributeText = AH.attribute1;

INSERT INTO titleInfoAttribute(titleInfoID, attributeID)
SELECT DISTINCT AH.titleInfoId, A.attributeID
FROM attributehelper AS AH, attributes AS A
WHERE NOT EXISTS (SELECT TIA.titleInfoID, TIA.attributeID FROM attributes AS A, titleInfoAttribute AS TIA
                  WHERE A.attributeID = TIA.attributeID AND  AH.titleInfoId = TIA.titleInfoId)
AND A.attributeText = AH.attribute2;

INSERT INTO titleInfoAttribute(titleInfoID, attributeID)
SELECT DISTINCT AH.titleInfoId, A.attributeID
FROM attributehelper AS AH, attributes AS A
WHERE NOT EXISTS (SELECT TIA.titleInfoID, TIA.attributeID FROM attributes AS A, titleInfoAttribute AS TIA
                  WHERE A.attributeID = TIA.attributeID AND  AH.titleInfoId = TIA.titleInfoId)
AND A.attributeText = AH.attribute3;

SELECT * from titleInfoAttribute;
/********************************************************************************************************************************/

/*********** attribute // titleAttribute *************/

-- SELECT * FROM akas_tsv;

-- Create Table attribute (
-- 	attributeID int AUTO_INCREMENT,
--     attributeText varchar(50),
--     Constraint PK_attributeID Primary Key (attributeID)
-- );

-- Create Table titleAttribute (
-- 	titleAttributeID int,
--     titleInfoID int,
--     attributeID int,
--     Constraint PK_titleAttributeID Primary Key (titleAttributeID),
--     Constraint FK_titleInfoID_ta Foreign Key (titleInfoID) REFERENCES titleInfo(titleInfoID),
-- 	Constraint FK_attributeID_ta Foreign Key (attributeID) REFERENCES attribute(attributeID)
-- );

-- /*transfer data from tsv to newly corrected table */
-- INSERT INTO attribute (attributeText)
-- SELECT DISTINCT Akas.attributes
-- FROM akas_tsv AS Akas
-- WHERE NOT EXISTS (SELECT * FROM attribute AS A WHERE A.attributeText = Akas.attributes);

-- INSERT INTO titleAttribute(titleInfoID, attributeID)
-- SELECT Ti.titleInfoID, A.attributeID
-- FROM attribute AS A, titleInfo AS Ti, akas_tsv AS Akas
-- WHERE Akas.titleID = Ti.titleID
-- AND Akas.ordering = Ti.ordering
-- AND A.attributeText = Akas.attributes;

/********************************************************************************************************************************/

SELECT * FROM akas_tsv;

/*********** mediaType // titleInfoMediaType *************/
Create Table mediaType (
	mediaTypeID int AUTO_INCREMENT,
    mediaTypeText varchar(50),
    Constraint PK_mediaTypeID Primary Key (mediaTypeID)
);

Create Table titleInfoMediaType (
	titleInfoMediaTypeID int AUTO_INCREMENT,
    titleInfoID int,
    mediaTypeID int,
    Constraint PK_titleInfoMediaTypeID Primary Key (titleInfoMediaTypeID),
    Constraint FK_titleInfoID_tit Foreign Key (titleInfoID) REFERENCES titleInfo(titleInfoID),
	Constraint FK_mediaTypeID_tit Foreign Key (mediaTypeID) REFERENCES mediaType(mediaTypeID)
);

Create Table mediaHelper(
	titleInfoID int,
    media1 varchar(40),
    media2 varchar(40)
);

INSERT INTO mediaHelper(titleInfoId, media1, media2)
SELECT titleInfoId, SUBSTRING_INDEX(types, ' ', 1) AS media1,
SUBSTRING_INDEX(types, ' ', -1) AS media2
FROM akas_tsv JOIN titleInfo ON akas_tsv.titleID = titleInfo.titleId;

SELECT * FROM mediaHelper;

/*transfer data from tsv to newly corrected table */
INSERT INTO mediaType(mediaTypeText)
SELECT DISTINCT MH.media1
FROM mediaHelper AS MH
WHERE NOT EXISTS (SELECT * FROM mediaTypes AS MT WHERE MT.mediaTypeText = MH.media1);

INSERT INTO mediaType(mediaTypeText)
SELECT DISTINCT MH.media2
FROM mediaHelper AS MH
WHERE NOT EXISTS (SELECT * FROM mediaTypes AS MT WHERE MT.mediaTypeText = MH.media2);

SELECT * FROM mediaType;

INSERT INTO titleInfoMediaType(titleInfoID, mediaTypeID)
SELECT DISTINCT MH.titleInfoId, MT.mediaTypeID
FROM mediaHelper AS MH, mediaType AS MT
WHERE NOT EXISTS (SELECT TMT.titleInfoID, TMT.mediaTypeID FROM mediaType AS MT, titleMediaType AS TMT
                  WHERE MT.mediaTypeID = TMT.mediaTypeID AND  MH.titleInfoId = TMT.titleInfoID)
AND MT.mediaTypeText = MH.media1;

INSERT INTO titleInfoMediaType(titleInfoID, mediaTypeID)
SELECT DISTINCT MH.titleInfoId, MT.mediaTypeID
FROM mediaHelper AS MH, mediaType AS MT
WHERE NOT EXISTS (SELECT TMT.titleInfoID, TMT.mediaTypeID FROM mediaType AS MT, titleMediaType AS TMT
                  WHERE MT.mediaTypeID = TMT.mediaTypeID AND  MH.titleInfoId = TMT.titleInfoID)
AND MT.mediaTypeText = MH.media2;

SELECT * FROM titleInfoMediaType;
/********************************************************************************************************************************/

/*********** KnownFor *************/
Create Table knownforhelper (
	nconst varchar(40),
    tconst1 varchar(40),
    tconst2 varchar(40),
    tconst3 varchar(40),
    tconst4 varchar(40)
);

INSERT INTO knownforhelper(nconst, tconst1, tconst2, tconst3, tconst4)
SELECT nconst, SUBSTRING_INDEX(knownForTitles, ',', 1) AS tconst1,
SUBSTRING_INDEX(SUBSTRING_INDEX(knownForTitles, ',', 2), ',', -1) AS tconst2,
SUBSTRING_INDEX(SUBSTRING_INDEX(knownForTitles, ',', 3), ',', -1) AS tconst3,
SUBSTRING_INDEX(knownForTitles, ',', -1) AS tconst4
FROM name_tsv;

SELECT * FROM knownforhelper;

Create Table knownFor (
	knownForID int AUTO_INCREMENT,
    personID varchar(40),
    titleID varchar(40),
    Constraint PK_knownForID Primary Key (knownForID),
    Constraint FK_personID_kf Foreign Key (personID) References person(personID),
	Constraint FK_titleID_kf Foreign Key (titleID) References title(titleID)
);

SELECT * FROM knownforhelper;

INSERT INTO knownFor(personID, titleID)
SELECT DISTINCT nconst, KFH.tconst1
FROM knownforhelper AS KFH INNER JOIN title t ON t.titleID = KFH.tconst1
WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.titleID = KFH.tconst1);

INSERT INTO knownFor(personID, titleID)
SELECT DISTINCT nconst, KFH.tconst2
FROM knownforhelper AS KFH INNER JOIN title t ON t.titleID = KFH.tconst2
WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.titleID = KFH.tconst2);

INSERT INTO knownFor(personID, titleID)
SELECT DISTINCT nconst, KFH.tconst3
FROM knownforhelper AS KFH INNER JOIN title t ON t.titleID = KFH.tconst3
WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.titleID = KFH.tconst3);

INSERT INTO knownFor(personID, titleID)
SELECT DISTINCT nconst, KFH.tconst4
FROM knownforhelper AS KFH INNER JOIN title t ON t.titleID = KFH.tconst4
WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.titleID = KFH.tconst4);

SELECT * FROM knownFor;

/********************************************************************************************************************************/


/*********** Genre, genreTitle, genrehelper *************/
Create Table genrehelper (
	tconst varchar(40),
    genre1 varchar(40),
    genre2 varchar(40),
    genre3 varchar(40)
);

INSERT INTO genrehelper(tconst, genre1, genre2, genre3)
SELECT tconst, SUBSTRING_INDEX(genres, ',', 1) AS genre1,
SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', 2), ',', -1) AS genre2,
SUBSTRING_INDEX(genres, ',', -1) AS genre3
FROM title_tsv;

SELECT * FROM genrehelper;

Create Table genres (
	genreID int AUTO_INCREMENT,
	genreText varchar(40),
    Constraint PK_genreID Primary Key (genreID)
);

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

Create Table titleGenre (
	titleGenreID int AUTO_INCREMENT,
    titleID varchar(40),
    genreID int,
    Constraint PK_titleGenreID Primary Key (titleGenreID),
    Constraint FK_titleID_tg Foreign Key (titleID) References title(titleID),
	Constraint FK_genreID_tg Foreign Key (genreID) References genres(genreID)
);

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
/********************************************************************************************************************************/

/*********** Profession, personProfession, professionhelper *************/
Create Table professionhelper (
	nconst varchar(40),
    profession1 varchar(40),
    profession2 varchar(40),
    profession3 varchar(40)
);

INSERT INTO professionhelper(nconst, profession1, profession2, profession3)
SELECT nconst, SUBSTRING_INDEX(primaryProfession, ',', 1) AS profession1,
SUBSTRING_INDEX(SUBSTRING_INDEX(primaryProfession, ',', 2), ',', -1) AS profession2,
SUBSTRING_INDEX(primaryProfession, ',', -1) AS profession3
FROM name_tsv;

SELECT * FROM professionhelper;

/* create professions table  and insert unique parsed professions*/

Create Table professions (
	professionsID int AUTO_INCREMENT,
    professionsText varchar(40),
    Constraint PK_personID Primary Key (professionsID)
);

INSERT INTO professions(professionsText)
SELECT DISTINCT PH.profession1
FROM professionhelper AS PH
WHERE NOT EXISTS (SELECT * FROM professions AS P WHERE P.professionsText = PH.profession1);

INSERT INTO professions(professionsText)
SELECT DISTINCT PH.profession2
FROM professionhelper AS PH
WHERE NOT EXISTS (SELECT * FROM professions AS P WHERE P.professionsText = PH.profession2);

INSERT INTO professions(professionsText)
SELECT DISTINCT PH.profession3
FROM professionhelper AS PH
WHERE NOT EXISTS (SELECT * FROM professions AS P WHERE P.professionsText = PH.profession3);

SELECT * FROM professions;


/* create personProfession associaive table that has 2 FKs - personID and professionsID */
Create Table personProfession (
	personProfessionID int AUTO_INCREMENT,
    personID varchar(40),
    professionsID int,
    Constraint PK_personProfessionID Primary Key (personProfessionID),
    Constraint FK_personID_pP Foreign Key (personID) References person(personID),
	Constraint FK_professionsID_pP Foreign Key (professionsID) References professions(professionsID)
);

/* load personProfession. choose the distinct nconst + profession (unique person + unique profession), from prof helper,
where there is NOT any existing (profession in both P and PP -AND-  person thats in both PH and PP),
AND profession text == professionhelper */


INSERT INTO personProfession(personID, professionsID)
SELECT DISTINCT PH.nconst, P.professionsID
FROM professionhelper AS PH, professions AS P
WHERE NOT EXISTS (SELECT PP.personID, PP.professionsID FROM professions AS P, personProfession AS PP
                  WHERE P.professionsID = PP.professionsID AND  PH.nconst = PP.personID)
AND P.professionsText = PH.profession1;

INSERT INTO personProfession(personID, professionsID)
SELECT DISTINCT PH.nconst, P.professionsID
FROM professionhelper AS PH, professions AS P
WHERE NOT EXISTS (SELECT PP.personID, PP.professionsID FROM professions AS P, personProfession AS PP
                  WHERE P.professionsID = PP.professionsID AND  PH.nconst = PP.personID)
AND P.professionsText = PH.profession2;

INSERT INTO personProfession(personID, professionsID)
SELECT DISTINCT PH.nconst, P.professionsID
FROM professionhelper AS PH, professions AS P
WHERE NOT EXISTS (SELECT PP.personID, PP.professionsID FROM professions AS P, personProfession AS PP
                  WHERE P.professionsID = PP.professionsID AND  PH.nconst = PP.personID)
AND P.professionsText = PH.profession3;


SELECT * FROM personProfession;



