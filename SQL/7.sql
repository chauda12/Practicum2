-- CREATE VIEW actorView AS
-- SELECT P.PrimaryName, P.age, P.deathYear = '\n' AS 'whether dead',
-- (SELECT COUNT(*) FROM knownFor AS KF, person AS P WHERE P.personID = KF.personID) AS 'movies known for'
-- FROM person AS P

CREATE VIEW actorView AS
SELECT P.PrimaryName, P.age,
CASE
	WHEN deathYear IS NOT NULL THEN 'dead'
    ELSE 'alive'
END
AS 'whether dead',
numMovies AS 'movies known for'
FROM person AS P;
