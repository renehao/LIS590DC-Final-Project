# TASK1: interity check: session('producer','engineer') not in person_session_skill
# skill & id: producer:26, engineer:33
SELECT * FROM `data cleaning`.session; #2711
SELECT COUNT(*) FROM session WHERE producer IS NOT NULL; #158
SELECT COUNT(*) FROM session WHERE engineer IS NOT NULL; #83
SELECT * FROM skill WHERE name = 'producer'; #26
SELECT * FROM skill WHERE name = 'engineer'; #33


### producer
# STEP1: check if (producer, session) pair already exists in person_session_skill
SELECT id, producer FROM session WHERE producer IS NOT NULL AND (id, producer) NOT IN 
	(SELECT session, person FROM person_session_skill WHERE skill = 26);
SELECT person, session, order_key FROM person_session_skill
	WHERE (session, person) NOT IN 
		(SELECT id, producer FROM session WHERE producer IS NOT NULL) 
	AND skill = 26;
# STEP2: insert into person_session_skill with (producer, session, 26, max(session_order_key)+1)
# STEP2.1: find max(session_order_key)
CREATE OR REPLACE VIEW session_max_order_key (session, max_order_key) as
	SELECT session, MAX(order_key) FROM person_session_skill
		WHERE session IN (SELECT id FROM session WHERE producer IS NOT NULL)
		GROUP BY session;
# STEP2.2: insert
INSERT INTO person_session_skill (person, session, skill, order_key)
	SELECT producer, id, 26, max_order_key+1 FROM session s 
	JOIN session_max_order_key s1 ON s.id = s1.session
	WHERE s.producer IS NOT NULL;

SELECT * FROM person_session_skill WHERE session = 9;



### engineer
# STEP1: check if (engineer, session, skill=33) pair already exists in person_session_skill
SELECT id, engineer FROM session WHERE engineer IS NOT NULL AND (id, engineer) NOT IN 
	(SELECT session, person FROM person_session_skill WHERE skill = 33);
SELECT person, session, order_key FROM person_session_skill
	WHERE (session, person) NOT IN 
		(SELECT id, engineer FROM session WHERE engineer IS NOT NULL)
		AND skill = 33;
# STEP2: insert into person_session_skill with (engineer, session, 33, max(session_order_key)+1)
# STEP2.1: find max(session_order_key)
CREATE OR REPLACE VIEW session_max_order_key (session, max_order_key) as
	SELECT session, MAX(order_key) FROM person_session_skill
		WHERE session IN (SELECT id FROM session WHERE engineer IS NOT NULL)
		GROUP BY session;
# STEP2.2: insert
INSERT INTO person_session_skill (person, session, skill, order_key)
	SELECT engineer, id, 33, max_order_key+1 FROM session s 
	JOIN session_max_order_key s1 ON s.id = s1.session
	WHERE s.engineer IS NOT NULL;

SELECT * FROM person_session_skill WHERE session = 9;




# TASK2: person_session_skill() not in person_skill
# Discard person id = 646 (unknown)
CREATE OR REPLACE VIEW temp_person_skill (person, skill) AS
	SELECT person, skill FROM person_session_skill WHERE (person, skill) NOT IN 
		(SELECT person, skill FROM person_skill) AND person <> 646
		GROUP BY person, skill; #1335 rows need to be inserted

# Note: There are duplicates since a person can have multiple skills not recorded
# That's why this view only has 798 rows but actually 1335 rows need to be inserted
# Also note: there're people whose skill is not recorded in person_skill at all; 
CREATE OR REPLACE VIEW person_skill_max (person, max) AS 
	SELECT person, MAX(order_key) FROM person_skill WHERE person IN 
		(SELECT person FROM temp_person_skill)
	GROUP BY person; #798 rows


CREATE TABLE person_max
	SELECT person, MAX(order_key) as max FROM person_skill WHERE person IN 
		(SELECT person FROM temp_person_skill)
	GROUP BY person; #798 rows

INSERT INTO person_max (person, max)
SELECT DISTINCT person, -1 FROM temp_person_skill WHERE person NOT IN (SELECT person FROM person_max);
# 68 rows added

SELECT * FROM temp_person_skill WHERE person = 12;
SELECT * FROM person_max WHERE person = 12;

SELECT person, count(*) FROM temp_person_skill GROUP BY person HAVING count(*) >1 ORDER BY count(*); 
#246 rows


SELECT t1.person, t1.skill, max+1 FROM temp_person_skill t1 
	LEFT JOIN person_max t2 ON t1.person = t2.person
	ORDER BY t1.person;


LOAD DATA LOCAL INFILE '/Users/ReneeHao/Documents/Data Cleaning Final Project/out_person_skill.txt' 
	INTO TABLE person_skill
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n';
# 1333 rows added


# TASK3: issue('producer','master_engineer','reissue_producer','reissue_engineer',
# 'remix_engineer','remaster_engineer','photographer','design_supervisor') not in person_skill
SELECT COUNT(*) FROM issue WHERE producer IS NOT NULL; #109
SELECT DISTINCT producer FROM issue WHERE producer IS NOT NULL AND producer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 26); #3 rows, 109, 261, 912

SELECT * FROM person_skill WHERE person = 109;
INSERT INTO person_skill (person, skill, order_key) VALUES (109, 26, 0);

SELECT * FROM person_skill WHERE person = 261;
INSERT INTO person_skill (person, skill, order_key) VALUES (261, 26, 0);

SELECT * FROM person_skill WHERE person = 912;
INSERT INTO person_skill (person, skill, order_key) VALUES (912, 26, 26);



# master_engineer: 113
SELECT DISTINCT master_engineer FROM issue WHERE master_engineer IS NOT NULL AND master_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113); #9 rows

INSERT INTO person_skill (person, skill, order_key)
SELECT person, 113, MAX(order_key)+1 FROM person_skill WHERE person in
(SELECT DISTINCT master_engineer FROM issue WHERE master_engineer IS NOT NULL AND master_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113))
GROUP BY person;

### recheck
SELECT DISTINCT master_engineer FROM issue WHERE master_engineer IS NOT NULL AND master_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113); #1, 16

INSERT INTO person_skill (person, skill, order_key) VALUES (16, 113, 0);


#############
SELECT DISTINCT reissue_producer FROM issue WHERE reissue_producer IS NOT NULL AND reissue_producer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 26); #0

SELECT DISTINCT reissue_engineer FROM issue WHERE reissue_engineer IS NOT NULL AND reissue_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 33); #1, 2529
SELECT * FROM person_skill WHERE person = 2529;
INSERT INTO person_skill (person, skill, order_key) VALUES (2529, 33, 1);

#############
SELECT DISTINCT remix_engineer FROM issue WHERE remix_engineer IS NOT NULL AND remix_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 33); #0

#############
SELECT DISTINCT remaster_engineer FROM issue WHERE remaster_engineer IS NOT NULL AND remaster_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113); #7

INSERT INTO person_skill (person, skill, order_key)
SELECT person, 113, MAX(order_key)+1 FROM person_skill WHERE person in
(SELECT DISTINCT remaster_engineer FROM issue WHERE remaster_engineer IS NOT NULL AND remaster_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113))
GROUP BY person;

### recheck
SELECT DISTINCT remaster_engineer FROM issue WHERE remaster_engineer IS NOT NULL AND remaster_engineer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 113); #1, 126

INSERT INTO person_skill (person, skill, order_key) VALUES (126, 113, 0);

#############
SELECT * FROM skill WHERE name = 'photographer'; #34
SELECT DISTINCT photographer FROM issue WHERE photographer IS NOT NULL AND photographer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 34); #7

INSERT INTO person_skill (person, skill, order_key)
SELECT person, 34, MAX(order_key)+1 FROM person_skill WHERE person in
(SELECT DISTINCT photographer FROM issue WHERE photographer IS NOT NULL AND photographer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 34))
GROUP BY person;

### recheck
SELECT DISTINCT photographer FROM issue WHERE photographer IS NOT NULL AND photographer NOT IN 
	(SELECT person FROM person_skill WHERE skill = 34); #3, 8, 223, 1623

INSERT INTO person_skill (person, skill, order_key) values
	(8, 34, 0), (223, 34, 0), (1623, 34, 0);
