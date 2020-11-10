/* First create title tsv table. Run python script to load this data. Forcing variables to be strings */



-- Create Table title_tsv (
-- 	`index` bigint,
-- 	tconst varchar(40),
--     titleType longtext,
--     primaryTitle longtext,
--     originalTitle longtext,
--     isAdult varchar(40),
--     startYear varchar(40),
--     endYear varchar(40),
--     runtimeMinutes varchar(40),
--     genres varchar(40)
-- );

SELECT * FROM title_tsv;

/* create title table */

Create Table title (
	titleID varchar(40),
    titleType longtext,
    primaryTitle longtext,
    originalTitle longtext,
    isAdult varchar(40),
    startYear varchar(40),
    endYear varchar(40),
    runtimeMinutes varchar(40),
    Constraint PK_titleID Primary Key (titleID)
);

/* Transfer data from title_tsv to title table. */
INSERT INTO title (titleID, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes)
SELECT tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes
FROM title_tsv;

SELECT * FROM title;
SELECT * FROM title_tsv;


/* create name_tsv table. force strings. Run python script to load data into it*/

-- Create Table name_tsv (
-- 	`index` bigint,
-- 	nconst varchar(40),
--     primaryName longtext,
--     birthYear varchar(40),
--     deathYear varchar(40),
-- 	primaryProfession longtext,
--     knownForTitles longtext,
--     Constraint PK_personID Primary Key (nconst)
-- );

/* create person table*/

Create Table person (
	personID varchar(40),
    primaryName longtext,
    birthYear varchar(40),
    deathYear varchar(40),
    Constraint PK_personID Primary Key (personID)
);

/* transfer data from name_tsv table to person table */

INSERT INTO person (personID, primaryName, birthYear, deathYear)
SELECT nconst, primaryName, birthYear, deathYear
FROM name_tsv;

SELECT * FROM person;


/* create professionhelper to parse PrimaryProfession col from names_tsv table */

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




















/*   ~~~~~~  some errors below when transfering from principals_tsv to principals ~~~~~~~ */

/* run python script to load principals_tsv table. no need to make tsv table here because no vartype conflicts */
SELECT * FROM principals_tsv;

/* create principals table */

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

/* BELOW NOT WORKING -- child/fk error --  i thought it was because I needed to upload person table first. not sure why still its not working.
/* transfer data from principals_tsv to principals */

INSERT INTO principals(titleId, ordering, personId, category, job, characters)
SELECT tconst, ordering, nconst, category, job, characters
FROM principals_tsv;
