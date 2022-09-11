BEGIN;

CREATE TABLE IF NOT EXISTS tasklog (
    id SERIAL PRIMARY KEY,
    given_nl VARCHAR(512) NOT NULL,
    given_sql VARCHAR(512) NOT NULL,
    given_evql VARCHAR(4096) NOT NULL,
    given_table_excerpt VARCHAR(4096) DEFAULT NULL,
    given_result_table VARCHAR(4096) DEFAULT NULL,
    given_db_name VARCHAR(32) NOT NULL,
    given_task_type INTEGER NOT NULL,
    answer_is_correct BOOLEAN NOT NULL,
    answer_nl VARCHAR(512) DEFAULT NULL
);

INSERT INTO tasklog (given_nl, given_sql, given_evql, given_table_excerpt, given_result_table, given_db_name, given_task_type, answer_is_correct, answer_nl) VALUES
('Show average max speed of each model whose production year is greater than 2010.', 'SELECT model, avg(max_speed) FROM cars WHERE year > 2010 GROUP BY model', '{
            "header_names": [
                "cars",
                "id",
                "model",
                "horsepower",
                "max_speed",
                "year",
                "price"
            ],
            "header_aliases": [
                "cars",
                "id",
                "model",
                "horsepower",
                "max_speed",
                "year",
                "price"
            ],
            "foreach": null,
            "projection": {
                "headers": [
                    {
                        "id": 2,
                        "agg_type": null
                    },
                    {
                        "id": 4,
                        "agg_type": 3
                    }
                ]
            },
            "predicate": {
                "clauses": [
                    {
                        "conditions": [
                            {
                                "header_id": 5,
                                "func_type": "Selecting",
                                "op_type": 1,
                                "r_operand": "2010"
                            },
                            {
                                "header_id": 2,
                                "func_type": "Grouping"
                            }
                        ]
                    }
                ]
            }
        }', '[
            {
                "id": 1,
                "model": "A",
                "horsepower": 100,
                "max_speed": 200,
                "year": 2000,
                "price": 10000
            },
            {
                "id": 2,
                "model": "B",
                "horsepower": 200,
                "max_speed": 300,
                "year": 2000,
                "price": 70000
            },
            {
                "id": 3,
                "model": "C",
                "horsepower": 300,
                "max_speed": 400,
                "year": 2000,
                "price": 60000
            },
            {
                "id": 4,
                "model": "D",
                "horsepower": 400,
                "max_speed": 500,
                "year": 2000,
                "price": 50000
            },
            {
                "id": 5,
                "model": "E",
                "horsepower": 500,
                "max_speed": 600,
                "year": 2000,
                "price": 40000
            },
            {
                "id": 6,
                "model": "A",
                "horsepower": 300,
                "max_speed": 300,
                "year": 2012,
                "price": 30000
            },
            {
                "id": 7,
                "model": "A",
                "horsepower": 200,
                "max_speed": 200,
                "year": 2010,
                "price": 20000
            },
            {
                "id": 8,
                "model": "B",
                "horsepower": 100,
                "max_speed": 200,
                "year": 2000,
                "price": 10000
            }
        ]','[
            {
                "model": "A",
                "max_speed_avg": 233
            },
            {
                "model": "B",
                "max_speed_avg": 250
            },
            {
                "model": "C",
                "max_speed_avg": 400
            },
            {
                "model": "D",
                "max_speed_avg": 500
            },
            {
                "model": "E",
                "max_speed_avg": 600
            }
        ]', 'cars', 1, true, 'For each model produced after 2010, show average max speed');


COMMIT;
END;
