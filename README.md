# FreeCodeCamp - Relational Database

## Certification Project - Build a Periodic Table Database

This is one of the required projects to earn your certification. For this project, you will create Bash a script to get information about chemical elements from a periodic table database.

## Commands

```sh
psql --username=freecodecamp --dbname=periodic_table
```

```sh
pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql
```

```sh
psql -U postgres < periodic_table.sql
```

## Part 1: Fix the database

- [x] There are some mistakes in the database that need to be fixed or changed. See the user stories below for what to change.
  - [x] You should rename the weight column to atomic_mass
  - [x] You should rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
  - [x] Your melting_point_celsius and boiling_point_celsius columns should not accept null values
  - [x] You should add the UNIQUE constraint to the symbol and name columns from the elements table
  - [x] Your symbol and name columns should have the NOT NULL constraint
  - [x] You should set the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table

  - [x] You should create a types table that will store the three types of elements
  - [x] Your types table should have a type_id column that is an integer and the primary key
  - [x] Your types table should have a type column that's a VARCHAR and cannot be null. It will store the different types from the type column in the properties table
  - [x] You should add three rows to your types table whose values are the three different types from the properties table
  - [x] Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
  - [x] Each row in your properties table should have a type_id value that links to the correct type from the types table
  - [x] You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
  - [x] You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
  - [x] You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
  - [x] You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal

  - [x] You should create a periodic_table folder in the project folder and turn it into a git repository with git init
  - [x] Your repository should have a main branch with all your commits
  - [x] Your periodic_table repo should have at least five commits
  - [x] You should create an element.sh file in your repo folder for the program I want you to make
  - [x] Your script (.sh) file should have executable permissions
  - [x] If you run `./element.sh`, it should output only Please provide an element as an argument. and finish running.
  - [x] If you run `./element.sh 1`, `./element.sh H`, or `./element.sh Hydrogen`, it should output only The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
  - [x] If you run `./element.sh` script with another element as input, you should get the same output but with information associated with the given element.
  - [x] If the argument input to your element.sh script doesn't exist as an atomic_number, symbol, or name in the database, the only output should be I could not find that element in the database.
  - [x] The message for the first commit in your repo should be Initial commit
  - [x] The rest of the commit messages should start with fix:, feat:, refactor:, chore:, or test:
  - [x] You should delete the non existent element, whose atomic_number is 1000, from the two tables
  - [x] Your properties table should not have a type column
  - [x] You should finish your project while on the main branch. Your working tree should be clean and you should not have any uncommitted changes

```sql
ALTER TABLE properties 
RENAME COLUMN weight TO atomic_mass;

ALTER TABLE properties
RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties
RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties
ALTER COLUMN melting_point_celsius
SET NOT NULL;
ALTER TABLE properties
ALTER COLUMN boiling_point_celsius
SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT unique_symbol_name UNIQUE (symbol, name);

ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE properties
ADD CONSTRAINT fk_atomic_number FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number);

CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(20) NOT NULL
);

---

INSERT INTO types (type)
VALUES
  ('metal'),
  ('nonmetal'),
  ('metalloid');

-- ALTER TABLE properties ADD COLUMN type_id INT NOT NULL REFERENCES types(type_id);

UPDATE properties
SET type_id = 1
WHERE type = 'metal';
UPDATE properties
SET type_id = 2
WHERE type = 'nonmetal';
UPDATE properties
SET type_id = 3
WHERE type = 'metalloid';

UPDATE elements
SET symbol = CONCAT(UPPER(LEFT(symbol, 1)), LOWER(SUBSTRING(symbol FROM 2)));


ALTER TABLE properties ALTER COLUMN weight TYPE DECIMAL;
UPDATE properties SET weight = TRIM(TRAILING '0' FROM weight::text)::DECIMAL;

INSERT INTO elements (atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine');

INSERT INTO elements (atomic_number, symbol, name) VALUES (10, 'Ne', 'Neon');

--- FIXs -------------------------------------------

-- periodic_table=> ALTER TABLE properties ADD COLUMN type_id INT NOT NULL REFERENCES types(type_id);
-- ERROR:  column "type_id" contains null values

ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id);

-- periodic_table=> UPDATE properties SET type_id = 1 WHERE type = 'nonmetal';
-- ERROR:  column "type_id" of relation "properties" does not exist

-- rerun

-- periodic_table=> UPDATE properties SET type_id = 2 WHERE type = 'metal';
-- ERROR:  column "type_id" of relation "properties" does not exist

-- rerun

-- periodic_table=> UPDATE properties SET type_id = 3 WHERE type = 'metalloid';
-- ERROR:  column "type_id" of relation "properties" does not exist

-- rerun

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;
UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::text)::DECIMAL;

-- FIXs PART II ---------------------------------

-- You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
-- You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal

-- adiciona em elements
INSERT INTO elements (atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');

-- adiciona em properties: mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
-- adiciona em properties: mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
INSERT INTO properties (
  atomic_number,
  type,
  atomic_mass,
  melting_point_celsius,
  boiling_point_celsius,
  type_id
)
VALUES
  (9,'nonmetal',18.998,-220,-188.1,2),
  (10,'nonmetal',20.18,-248.6,-246.1,2);

-- adiciona em types: tá errado os types, tem que trocar 1 com o 2
-- UPDATE types SET type = 'nonmetal' WHERE type_id = 1;
-- UPDATE types SET type = 'metal' WHERE type_id = 2;

```

## Part 2: Create your git repository

- [x] You need to make a small bash program.
- [x] The code needs to be version controlled with git, so you will need to turn the suggested folder into a git repository.

## Part 3: Create the script

- [x] Lastly, you need to make a script that accepts an argument in the form of an atomic number, symbol, or name of an element and outputs some information about the given element.
- [x] In your script, you can create a PSQL variable for querying the database like this: `PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"` add more flags if you need to.

