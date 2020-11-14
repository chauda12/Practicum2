DELIMITER $$
CREATE PROCEDURE addActor(personID varchar(40), primaryName varchar(40), birthYear int, deathYear int, primaryProfession varchar(50), knownForTitles varchar(100))
BEGIN
	DECLARE profession1 VARCHAR(40);
	DECLARE profession2 VARCHAR(40);
	DECLARE profession3 VARCHAR(40);
    
    DECLARE professionID1 int;
    DECLARE professionID2 int;
    DECLARE professionID3 int;
    
    DECLARE knownFor1 VARCHAR(40);
    DECLARE knownFor2 VARCHAR(40);
    DECLARE knownFor3 VARCHAR(40);
    DECLARE knownFor4 VARCHAR(40);
    
    SET profession1 = SUBSTRING_INDEX(primaryProfession, ',', 1);
    SET profession2 = SUBSTRING_INDEX(SUBSTRING_INDEX(primaryProfession, ',', 2), ',', -1);
    SET profession3 = SUBSTRING_INDEX(primaryProfession, ',', -1);
    
    INSERT INTO person(personID, primaryName, birthYear, deathYear)
	VALUES (personID, primaryName, birthYear, deathYear);
    
    INSERT INTO profession(professionText)
    SELECT profession1
    WHERE NOT EXISTS (SELECT 1 FROM professions AS P WHERE P.professionsText = profession1); 
    
    INSERT INTO profession(professionText)
    SELECT profession2
    WHERE NOT EXISTS (SELECT 1 FROM professions AS P WHERE P.professionsText = profession2); 
    
    INSERT INTO profession(professionText)
    SELECT profession3
    WHERE NOT EXISTS (SELECT 1 FROM professions AS P WHERE P.professionsText = profession3); 
    
    SELECT P.professionID FROM profession AS P WHERE P.professionText = profession1 INTO professionID1;
    SELECT P.professionID FROM profession AS P WHERE P.professionText = profession2 INTO professionID2;
    SELECT P.professionID FROM profession AS P WHERE P.professionText = profession3 INTO professionID3;
    
    INSERT INTO personprofession(personID, professionID)
    SELECT (personID, professionID1)
	WHERE NOT EXISTS (SELECT 1 FROM personprofession AS Pp WHERE Pp.personID = personID AND Pp.professionID = professionID1);
    
    INSERT INTO personprofession(personID, professionID)
    SELECT (personID, professionID2)
	WHERE NOT EXISTS (SELECT 1 FROM personprofession AS Pp WHERE Pp.personID = personID AND Pp.professionID = professionID2);
    
    INSERT INTO personprofession(personID, professionID)
    SELECT (personID, professionID3)
	WHERE NOT EXISTS (SELECT 1 FROM personprofession AS Pp WHERE Pp.personID = personID AND Pp.professionID = professionID3);
    
    SET knownFor1 = SUBSTRING_INDEX(knownForTitles, ',', 1);
	SET knownFor2 = SUBSTRING_INDEX(SUBSTRING_INDEX(knownForTitles, ',', 2), ',', -1);
	SET knownFor3 = SUBSTRING_INDEX(SUBSTRING_INDEX(knownForTitles, ',', 3), ',', -1);
	SET knownFOR4 = SUBSTRING_INDEX(knownForTitles, ',', -1);
    
    INSERT INTO knownFor(personID, titleID)
	SELECT (personID, knownFor1)
	WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.personID = personID AND KF.titleID = knownFor1);
    
    INSERT INTO knownFor(personID, titleID)
	SELECT (personID, knownFor2)
	WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.personID = personID AND KF.titleID = knownFor2);
    
    INSERT INTO knownFor(personID, titleID)
	SELECT (personID, knownFor3)
	WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.personID = personID AND KF.titleID = knownFor3);
    
    INSERT INTO knownFor(personID, titleID)
	SELECT (personID, knownFor4)
	WHERE NOT EXISTS (SELECT * FROM knownFor AS KF WHERE KF.personID = personID AND KF.titleID = knownFor4);
END$$