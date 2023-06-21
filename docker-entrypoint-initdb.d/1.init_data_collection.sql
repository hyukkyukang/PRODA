-- Create database
CREATE DATABASE proda_collection;
\c proda_collection;

-- Set time zone
SET TIME ZONE 'Asia/Seoul';

-- Create tables
BEGIN;
-- Table to collect user response
CREATE TABLE IF NOT EXISTS collection (
    id SERIAL PRIMARY KEY,
    task_set_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    user_id VARCHAR(64) NOT NULL,
    is_correct BOOLEAN NULL,
    nl VARCHAR(1024) DEFAULT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table to collect task data
CREATE TABLE IF NOT EXISTS task (
    id SERIAL PRIMARY KEY,
    nl VARCHAR(1024) NOT NULL,
    sql VARCHAR(1024) NOT NULL,
    query_type VARCHAR(64) NOT NULL,
    evqa_path VARCHAR(256) NOT NULL,
    table_excerpt_path VARCHAR(256) DEFAULT NULL,
    result_table_path VARCHAR(256) DEFAULT NULL,
    nl_mapping_path VARCHAR(256) DEFAULT NULL,
    db_name VARCHAR(128) NOT NULL,
    task_type INTEGER NOT NULL,
    sub_task_ids INTEGER[] NULL
);

-- Table to collect task data
CREATE TABLE IF NOT EXISTS task_set (
    id SERIAL PRIMARY KEY,
    task_ids INTEGER[] NOT NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
END;

-- Create user
DROP ROLE IF EXISTS collection_user;
CREATE USER collection_user WITH PASSWORD 'collection_user_pw';

-- Grant privileges
GRANT CONNECT ON DATABASE proda_collection TO collection_user;
GRANT insert, delete, update, select on collection to collection_user;
GRANT insert, delete, update, select on task to collection_user;
GRANT insert, delete, update, select on task_set to collection_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO collection_user;