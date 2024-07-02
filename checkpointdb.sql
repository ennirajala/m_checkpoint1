-- Database: checkpointdb

--1.2 Create the database definitions described in the ER-diagram below on the next page.
--1.3 Assign appropriate data types to each column. Bonus points are given if you show different constraints as well.

DROP DATABASE IF EXISTS checkpointdb;

CREATE DATABASE checkpointdb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Finland.1252'
    LC_CTYPE = 'English_Finland.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE IF NOT EXISTS CONTACT_CATEGORIES(
	id SERIAL PRIMARY KEY,
	contact_category TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS CONTACT_TYPES(
	id SERIAL PRIMARY KEY,
	contact_type TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS CONTACTS(
	id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	title TEXT,
	organization TEXT
);

CREATE TABLE IF NOT EXISTS ITEMS(
	contact TEXT NOT NULL,
	contact_id INT NOT NULL REFERENCES CONTACTS(id),
	contact_type_id INT NOT NULL REFERENCES CONTACT_TYPES(id),
	contact_category_id INT NOT NULL REFERENCES CONTACT_CATEGORIES(id)
);


--1.4 Add data from the four sample tables below.
INSERT INTO CONTACT_CATEGORIES (contact_category)
VALUES ('Home'), ('Work'), ('Fax');

INSERT INTO CONTACT_TYPES (contact_type)
VALUES ('Email'), ('Phone'), ('Skype'), ('Instagram');

INSERT INTO CONTACTS (first_name, last_name, title, organization)
VALUES
('Erik', 'Eriksson', 'Teacher', 'Utbildning AB'),
('Anna', 'Sundh', NULL, NULL),
('Goran', 'Bregovic', 'Coach', 'Dalens IK'),
('Ann-Marie', 'Bergqvist', 'Cousin', NULL),
('Herman', 'Appelkvist', NULL, NULL);

INSERT INTO ITEMS (contact, contact_id, contact_type_id, contact_category_id)
VALUES
('011-12 33 45', 3, 2, 1),
('goran@infoab.se', 3, 1, 2),
('010-88 55 44', 4, 2, 2),
('erik57@hotmail.com', 1, 1, 1),
('@annapanna99', 2, 4, 1),
('077-563578', 2, 2, 1),
('070-156 22 78', 3, 2, 2);


--1.5 Add one more row into the CONTACTS table, which should contain your own name. Add yourself with a (fake) contact in the ITEMS table as well.

INSERT INTO CONTACTS (first_name, last_name, title, organization)
VALUES
('Enni', 'Rajala', 'Learner', 'Brights');

INSERT INTO ITEMS (contact, contact_id, contact_type_id, contact_category_id)
VALUES
('enni.rajala@brightstraining.com', 6, 1, 1);


--1.6 Create a query that lists if there are unused contact_types.
SELECT id, contact_type FROM CONTACT_TYPES
LEFT JOIN ITEMS ON (CONTACT_TYPES.id = ITEMS.contact_type_id)
WHERE ITEMS.CONTACT IS NULL;


-- 1.7 Create a VIEW and name it view_contacts that lists the columns: first_name, last_name, contact, contact_type, contact_category.

CREATE VIEW view_contacts AS
	SELECT c.first_name, c.last_name, i.contact, ct.contact_type, cc.contact_category
	FROM CONTACTS c, ITEMS i, CONTACT_TYPES ct, CONTACT_CATEGORIES cc
	WHERE i.contact_id = c.id 
		AND i.contact_type_id = ct.id
		AND i.contact_category_id = cc.id
	ORDER BY c.first_name, c.last_name;


--1.8 Create a query that lists all information from the database in one big resulting table. The id columns should be invisible in the result.

SELECT c.*, i.*, ct.contact_type, cc.contact_category
FROM CONTACTS c, ITEMS i, CONTACT_TYPES ct, CONTACT_CATEGORIES cc
WHERE i.contact_id = c.id 
	AND i.contact_type_id = ct.id
	AND i.contact_category_id = cc.id
ORDER BY c.first_name, c.last_name;


--1.9 Make a comment in the script file about how an alternative solution to the design of the ITEMS table would look like in terms of SQL definition code.

-- Not sure if i understand the question. But I would make a separate junction table that have only foreign keys.
-- Then the ITEMS table should have columns id, contact and foreighn key column contact_id.


