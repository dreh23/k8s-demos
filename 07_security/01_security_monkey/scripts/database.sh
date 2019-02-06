#!/usr/bin/env bash

#Install Postgres Client
sudo apt-get update
sudo apt-get -y install postgresql-client


#Install SQL Proxy

sudo wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
sudo chmod +x /usr/local/bin/cloud_sql_proxy

#Start GCP CloudSQL Proxy
cloud_sql_proxy -instances=$1=tcp:5432 &

PGPASSWORD=$3 psql -h 127.0.0.1 -p 5432 -U $2 << EOF
CREATE DATABASE "secmonkey";
CREATE SCHEMA secmonkey;
GRANT Usage, Create ON SCHEMA "secmonkey" TO "$2";
set timezone TO 'GMT';
select now();
\q
EOF