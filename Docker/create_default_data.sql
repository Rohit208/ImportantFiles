-- create_default_data.sql
-- Replace XXXXXXXX with your username before running: docker build
CREATE DATABASE test;
CREATE USER rohit WITH ENCRYPTED PASSWORD '12345';
------------------------------------------------------------
GRANT ALL PRIVILEGES ON DATABASE postgres TO rohit;
GRANT ALL PRIVILEGES ON database test TO rohit;
ALTER USER rohit CREATEDB;     -- Grant Create DB Access.
ALTER ROLE rohit CREATEROLE;   -- Create Role
ALTER ROLE rohit SUPERUSER;    -- Grant SuperUser Access to Create PG Extension.
ALTER ROLE rohit BYPASSRLS;    -- Bypass RLS
ALTER ROLE rohit REPLICATION;  -- REPLICATION
------------------------------------------------------------
CREATE DATABASE rohit_sys;
CREATE DATABASE rohit_auth;
CREATE DATABASE rohit_mdm0;
CREATE DATABASE rohit_mdm1;
CREATE DATABASE rohit_mdm2;
CREATE DATABASE rohit_mdm2_prod;
CREATE DATABASE rohit_alert0;
CREATE DATABASE rohit_alert1;
CREATE DATABASE rohit_alert2;
------------------------------------------------------------
CREATE DATABASE unit_test_rohit_sys;
CREATE DATABASE unit_test_rohit_auth;
CREATE DATABASE unit_test_rohit_mdm0;
CREATE DATABASE unit_test_rohit_mdm1;
CREATE DATABASE unit_test_rohit_mdm2;
CREATE DATABASE unit_test_rohit_alert0;
CREATE DATABASE unit_test_rohit_alert1;
CREATE DATABASE unit_test_rohit_alert2;
------------------------------------------------------------