SELECT * FROM `data cleaning`.person;
SELECT id, name, gender, birth_date_earliest, birth_date_latest, birth_place FROM person WHERE gender IS NULL OR birth_date_earliest IS NULL OR birth_date_latest IS NULL OR
birth_place IS NULL; #2813 rows