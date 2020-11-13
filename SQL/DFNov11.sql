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
SELECT titleID, ordering, title, region, language, isOriginalTitle
FROM akas_tsv;

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

/**TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO**/
/**TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO**/
/**TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO****TO*DO**/
/* TO DO: insert data into crew table. i'm confused by the job field */
/*********** Crew *************/
SELECT * FROM crew_tsv;

Create Table crew (
	crewID int AUTO_INCREMENT,
    personID varchar(40),
    titleID varchar(40),
    job boolean,
	Constraint PK_crewID Primary Key (crewID),
    Constraint FK_personID_c Foreign Key (personID) References person(personID),
	Constraint FK_titleID_c Foreign Key (titleID) References title(titleID)
);
/********************************************************************************************************************************/

/*********** attribute // titleAttribute *************/
Create Table attribute (
	attributeID int,
    attributeText varchar(50),
    Constraint PK_attributeID Primary Key (attributeID)
);

Create Table titleAttribute (
	titleAttributeID int,
    titleInfoID int,
    attributeID int,
    Constraint PK_titleAttributeID Primary Key (titleAttributeID),
    Constraint FK_titleInfoID_ta Foreign Key (titleInfoID) REFERENCES titleInfo(titleInfoID),
	Constraint FK_attributeID_ta Foreign Key (attributeID) REFERENCES attribute(attributeID)
);

/*transfer data from tsv to newly corrected table */
INSERT INTO attribute (attributeText)
SELECT DISTINCT Akas.attributes
FROM akas_tsv AS Akas
WHERE NOT EXISTS (SELECT * FROM attribute AS A WHERE A.attributeText = Akas.attributes);

INSERT INTO titleAttribute(titleInfoID, attributeID)
SELECT Ti.titleInfoID, A.attributeID
FROM attribute AS A, titleInfo AS Ti, akas_tsv AS Akas
WHERE Akas.titleID = Ti.titleID
AND Akas.ordering = Ti.ordering
AND A.attributeText = Akas.attributes;
/********************************************************************************************************************************/

/*********** mediaType // titleMediaType *************/
Create Table mediaType (
	mediaTypeID int,
    mediaTypeText varchar(50),
    Constraint PK_mediaTypeID Primary Key (mediaTypeID)
);

Create Table titleMediaType (
	titleMediaTypeID int,
    titleInfoID int,
    mediaTypeID int,
    Constraint PK_titleMediaTypeID Primary Key (titleMediaTypeID),
    Constraint FK_titleInfoID_tit Foreign Key (titleInfoID) REFERENCES titleInfo(titleInfoID),
	Constraint FK_mediaTypeID_tit Foreign Key (mediaTypeID) REFERENCES mediaType(mediaTypeID)
);

/*transfer data from tsv to newly corrected table */
INSERT INTO mediaType (mediaTypeText)
SELECT DISTINCT Akas.types
FROM akas_tsv AS Akas
WHERE NOT EXISTS (SELECT * FROM mediaType AS Mt WHERE A.mediaTypeText = Akas.types);

INSERT INTO titleMediaType(titleInfoID, mediaTypeID)
SELECT Ti.titleInfoID, Mt.mediaTypeID
FROM mediaType AS Mt, titleInfo AS Ti, akas_tsv AS Akas
WHERE Akas.titleID = Ti.titleID
AND Akas.ordering = Ti.ordering
AND Mt.mediaTypeText = Akas.types;
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



