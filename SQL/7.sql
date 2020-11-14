CREATE VIEW actorView AS 
SELECT P.name, P.age, P.deathYear = '\n' AS 'whether dead', 
(SELECT COUNT(*) FROM principals AS PR, person AS P WHERE P.personID = PR.personID)
FROM person AS P