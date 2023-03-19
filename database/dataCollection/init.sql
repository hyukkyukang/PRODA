BEGIN;

-- Table to collect user response
CREATE TABLE IF NOT EXISTS collection (
    id SERIAL PRIMARY KEY,
    task_set_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    user_id VARCHAR(64) NOT NULL,
    is_correct BOOLEAN NULL,
    nl VARCHAR(512) DEFAULT NULL,
    date DATE DEFAULT CURRENT_DATE
);

-- Table to collect task data
CREATE TABLE IF NOT EXISTS task (
    id SERIAL PRIMARY KEY,
    nl VARCHAR(512) NOT NULL,
    sql VARCHAR(1024) NOT NULL,
    query_type VARCHAR(64) NOT NULL,
    evqa_path VARCHAR(256) NOT NULL,
    table_excerpt_path VARCHAR(256) DEFAULT NULL,
    result_table_path VARCHAR(256) DEFAULT NULL,
    nl_mapping_path VARCHAR(256) DEFAULT NULL,
    db_name VARCHAR(128) NOT NULL,
    task_type INTEGER NOT NULL,
    history_task_ids INTEGER[] NULL
);

-- Table to collect task data
CREATE TABLE IF NOT EXISTS task_set (
    id SERIAL PRIMARY KEY,
    task_ids INTEGER[] NOT NULL,
    date DATE DEFAULT CURRENT_DATE
);

END;
