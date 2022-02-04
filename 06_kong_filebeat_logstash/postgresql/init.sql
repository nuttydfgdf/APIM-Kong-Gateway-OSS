--This script is run the first time only when the volume is created.
--If you modify the init.sql after creating the volume, it has no effect.
SELECT NOW();

CREATE DATABASE db_konga WITH OWNER = postgres_adm ENCODING = 'UTF8' CONNECTION LIMIT = -1;

CREATE USER konga_adm WITH ENCRYPTED PASSWORD 'konga_adm';

GRANT ALL PRIVILEGES ON DATABASE db_konga TO konga_adm;

SELECT datname FROM pg_database;


-- DECLARE
--     V_DB_NAME VARCHAR(50) := 'db_konga';
--     V_DDL_SCRIPT VARCHAR(500);
-- BEGIN
--     SELECT datname FROM pg_database;

--     IF NOT EXISTS (SELECT FROM pg_database WHERE datname = V_DB_NAME) THEN
--         --RAISE NOTICE 'Database already exists';  -- optional
--         V_DDL_SCRIPT := 'CREATE DATABASE db_konga WITH OWNER = postgres_adm ENCODING = \'UTF8\' CONNECTION LIMIT = -1;';

--         EXECUTE( V_DDL_SCRIPT );
--     END IF;
-- END 
