DELIMITER $$
CREATE TRIGGER insert_age
BEFORE INSERT ON person FOR EACH ROW
BEGIN
    SET NEW.age = YEAR(CURDATE()) - NEW.birthYear;
END$$

CREATE TRIGGER insert_num_movies
BEFORE INSERT ON person FOR EACH ROW
BEGIN
	SELECT COUNT(*) FROM knownFor AS kF
    WHERE kF.personID = NEW.personID;
END$$


/* test works

INSERT INTO person (personID, primaryName, birthYear, deathYear)
VALUES ('atest', 'danf', '1994', '2020');

SELECT * FROM person;

 */

