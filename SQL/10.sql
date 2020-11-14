DELIMITER $$
CREATE PROCEDURE deleteActor(primaryName varchar(50))
BEGIN
	DECLARE personID varchar(40);
    
    SELECT P.personID FROM person AS P WHERE P.primaryName = primaryName;
    
    DELETE FROM knownFor AS KF
    WHERE KF.personID = personID;
    
    DELETE FROM personprofession AS PP
    WHERE PP.personID = personID;
    
    DELETE FROM principals AS PR
    WHERE PR.personID = personID;
    
    DELETE FROM directors AS D
    WHERE D.personID = personID;
    
    DELETE FROM writers AS W
    WHERE W.personID = personID;
    
    DELETE FROM person AS P
    WHERE P.personID = personID;
    
END$$
    