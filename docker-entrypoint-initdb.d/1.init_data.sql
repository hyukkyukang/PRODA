-- Create database
CREATE DATABASE proda_data;
\c proda_data;

-- Set time zone
SET TIME ZONE 'Asia/Seoul';

-- Create tables
-- TODO: Add tables

-- Create user
DROP ROLE IF EXISTS data_user;
CREATE USER data_user WITH PASSWORD 'data_user_pw';

-- Grant privileges
GRANT CONNECT ON DATABASE proda_collection TO data_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO data_user;