#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL

    CREATE USER rohit WITH SUPERUSER PASSWORD '12345';

    ALTER USER rohit WITH Superuser CREATEROLE CREATEDB Replication;

    CREATE DATABASE "rohit_pams_system";
    CREATE DATABASE "rohit_pams_authentication";
    CREATE DATABASE "rohit_mdm_common";
    CREATE DATABASE "rohit_mdm_prod";
    CREATE DATABASE "rohit_alt_prod";

    GRANT ALL PRIVILEGES ON DATABASE "rohit_pams_system"         TO rohit;
    GRANT ALL PRIVILEGES ON DATABASE "rohit_pams_authentication" TO rohit;
    GRANT ALL PRIVILEGES ON DATABASE "rohit_mdm_common"          TO rohit;
    GRANT ALL PRIVILEGES ON DATABASE "rohit_mdm_prod"            TO rohit;
    GRANT ALL PRIVILEGES ON DATABASE "rohit_alt_prod"            TO rohit;
EOSQL