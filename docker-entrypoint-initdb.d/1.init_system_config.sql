-- Create database
CREATE DATABASE proda_config;
\c proda_config;

-- Set time zone
SET TIME ZONE 'Asia/Seoul';


-- Create tables
BEGIN;
CREATE TABLE IF NOT EXISTS config (
    original_balance double precision NOT NULL,
    remaining_balance double precision NOT NULL,
    price_per_data double precision NOT NULL
);

CREATE TABLE IF NOT EXISTS query_goal (
    query_type VARCHAR(64) NOT NULL,
    goal_num integer NOT NULL
);

-- Add config
INSERT INTO config VALUES(2000.0, 500.0, 0.5);

-- Add query_goal
INSERT INTO query_goal VALUES('WHEREScalarComparison', 10);
INSERT INTO query_goal VALUES('WHEREQuantifiedScalarComparison', 10);
INSERT INTO query_goal VALUES('WHEREAttAggComparison', 10);
INSERT INTO query_goal VALUES('WHEREConstAggComparison', 10);
INSERT INTO query_goal VALUES('WHERESetMembershipCheckingWithIn', 10);
INSERT INTO query_goal VALUES('WHERESetMembershipCheckingWithNotIn', 10);
INSERT INTO query_goal VALUES('WHEREExistentialCheckingWithExists', 10);
INSERT INTO query_goal VALUES('WHEREExistentialCheckingWithNotExists', 10);
INSERT INTO query_goal VALUES('HAVINGAggScalarComparison', 10);
INSERT INTO query_goal VALUES('HAVINGAggQuantifiedScalarComparison', 10);
INSERT INTO query_goal VALUES('HAVINGAggAggComparison', 10);
INSERT INTO query_goal VALUES('HAVINGSetMembershipCheckingWithIn', 10);
INSERT INTO query_goal VALUES('HAVINGSetMembershipCheckingWithNotIn', 10);
INSERT INTO query_goal VALUES('HAVINGExistentialCheckingWithExists', 10);
INSERT INTO query_goal VALUES('HAVINGExistentialCheckingWithNotExists', 10);
INSERT INTO query_goal VALUES('FROMScalarSubQuery', 10);
INSERT INTO query_goal VALUES('FROMAggSubQuery', 10);
INSERT INTO query_goal VALUES('FROMNotScalarNotAggSubQuery', 10);
END;

-- Create user
DROP ROLE IF EXISTS config_user;
CREATE USER config_user WITH PASSWORD 'config_user_pw';

-- Grant privileges
GRANT CONNECT ON DATABASE proda_config TO config_user;
GRANT insert, delete, update, select on config to config_user;
GRANT insert, delete, update, select on query_goal to config_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO config_user;