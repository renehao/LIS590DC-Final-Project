# arranger (id=28->65), percussion (id=35<-59), tympani (id=45->63->105), sopranino saxophone (23->159)
# male voice -> male vocal (60->166), voice->vocal (58->20), songwriter->composer(116->29)
# master engineer-> engineer (113->33)
SELECT * FROM person_session_skill WHERE skill = 131;
UPDATE person_session_skill SET skill = 20 WHERE skill = 58;

SELECT * FROM person_skill WHERE skill = 131;
SELECT * FROM person_skill WHERE skill = 116 AND person = 2097;
UPDATE person_skill SET skill = 33 WHERE skill = 113 AND person <> 4774;
UPDATE person_skill SET skill = 20 
WHERE skill = 58 
AND person <> 4774 AND person <> 1681 AND person <> 1937 AND person <> 2064 
AND person <> 2082 AND person <> 2170;
DELETE FROM person_skill WHERE skill = 113
AND person = 4774;

SELECT * FROM person_track_skill WHERE skill = 131;
SELECT * FROM person_track_skill WHERE skill = 84;
UPDATE person_track_skill SET skill = 159 WHERE skill = 23;

SELECT * FROM skill WHERE id = 113;
DELETE FROM skill WHERE id = 116;






SELECT * FROM person_skill WHERE skill = 63 AND person = 4774;
SELECT * FROM person_skill WHERE person = 1681;
SELECT * FROM person_session_skill WHERE person = 3294 AND session = 1318;
SELECT * FROM person_track_skill WHERE skill = 45;
SELECT * FROM person WHERE id = 1204;
SELECT * FROM person WHERE id = 305;
SELECT * FROM skill where id = 63;
SELECT * FROM track WHERE id = 7742;
SELECT * FROM session WHERE id = 2409;
