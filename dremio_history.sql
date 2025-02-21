--------------- DON'T RUN ---------------
-- DROP TABLE mockaroo
-- CREATE TABLE mockaroo AS SELECT id, first_name,last_name, CAST(ts as DATE) ts FROM "@monofascia".mockaroo
-- SELECT YEAR(ts), * FROM mockaroo

-- ALTER TABLE mockaroo ADD PARTITION FIELD YEAR(ts);
---------------------------------------------------------

----- proviamo creando la tab gia partizionata;
--- select context!
CREATE TABLE mockaroo (
id INT,
first_name VARCHAR,
last_name VARCHAR,
ts DATE
) PARTITION BY (YEAR(ts));

INSERT INTO mockaroo SELECT CAST(id AS INT) id, first_name, last_name, CAST(ts AS DATE) ts FROM "@monofascia".mockaroo;

-- ora inseriamo la stessa senza partizionarla
CREATE TABLE mockaroo_noPartitioning (
id INT,
first_name VARCHAR,
last_name VARCHAR,
ts DATE
);

INSERT INTO mockaroo_noPartitioning SELECT CAST(id AS INT) id, first_name, last_name, CAST(ts AS DATE) ts FROM "@monofascia".mockaroo;

--- After those two queries, go to JOB and execution plan
SELECT * FROM "nessi".mockaroo_noPartitioning WHERE YEAR(ts) = 2000;
SELECT * FROM "nessi".mockaroo WHERE YEAR(ts) = 2000;