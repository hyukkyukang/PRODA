const config = require("./config");

/* Add environment variable to Python path */
const PathToPythonSrc = "../src/";
process.env["PYTHONPATH"] = PathToPythonSrc;

/* Fetch information */
function getEVQL(queryType) {
    var spawnSync = require("child_process").spawnSync;
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/VQL/example_queries.py`, "--query_type", queryType]);
    var json_dumped_evql = spawnedProcess.stdout.toString();

    // Try to parse string into JSON
    var evql = null;
    try {
        evql = JSON.parse(json_dumped_evql);
    } catch (err) {
        console.warn(`Error parsing JSON: ${err}`);
        console.warn(`JSON string: ${json_dumped_evql}`);
    }
    return evql;
}

function getTask() {
    var spawnSync = require("child_process").spawnSync;
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/task/task.py`]);
    var result = spawnedProcess.stdout.toString();
    // Parse JSON string
    var taskData = null;
    try {
        taskData = JSON.parse(result);
    } catch (err) {
        console.warn(`Error parsing JSON: ${err}`);
        console.warn(`JSON string: ${result}`);
    }
    return taskData;
}

function getLogData() {
    const pg = require("pg-native");
    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(`SELECT * FROM ${config.collectionDBTableName};`);
    client.end();

    // TODO: for each row, parse stringified data into JSON
    var step;
    const parsedResult = [];
    for (step = 0; step < result.length; step++) {
        parsedResult.push({
            id: result[step].id,
            given_nl: result[step].given_nl,
            given_sql: result[step].given_sql,
            given_evql: JSON.parse(result[step].given_evql),
            given_queryType: result[step].given_query_type,
            given_tableExcerpt: JSON.parse(result[step].given_table_excerpt),
            given_resultTable: JSON.parse(result[step].given_result_table),
            given_dbName: result[step].given_db_name,
            given_taskType: result[step].given_task_type,
            answer_isCorrect: result[step].answer_is_correct,
            answer_nl: result[step].answer_nl,
            user_id: result[step].user_id,
        });
    }
    return parsedResult;
}

/* Utils */
function EVQLToSQL(evql) {
    var spawnSync = require("child_process").spawnSync;
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/VQL/EVQL_to_SQL.py`, "--evql_in_json_str", evql]);
    var result = spawnedProcess.stdout.toString();
    return result;
}

function queryDB(sql, dbName) {
    const pg = require("pg-native");
    const client = new pg();
    client.connectSync(`user=${config.demoDBUserID} password=${config.demoDBUserPW} port=${config.demoDBPort} host=${config.demoDBIP} dbname=${dbName}`);
    result = client.querySync(sql);
    client.end();
    return result;
}

function logWorkerAnswer(logData) {
    // Get values from answer
    const given_nl = logData.task.nl.replace(/'/g, "\\'");
    const given_sql = logData.task.sql.replace(/'/g, "\\'");
    const given_evql = JSON.stringify(logData.task.evql).replace(/'/g, "\\'");
    const given_table_excerpt = JSON.stringify(logData.task.tableExcerpt).replace(/'/g, "\\'");
    const given_result_table = JSON.stringify(logData.task.resultTable).replace(/'/g, "\\'");
    const given_db_name = logData.task.dbName;
    const given_task_type = logData.answer.type;
    const given_query_type = logData.answer.queryType;
    const answer_is_correct = logData.answer.isCorrect;
    const answer_nl = logData.answer.nl.replace(/'/g, "\\'");
    const user_id = logData.userId;

    const pg = require("pg-native");
    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(
        `INSERT INTO ${config.collectionDBTableName} VALUES(DEFAULT, E'${given_nl}', E'${given_sql}', E'${given_evql}', '${given_query_type}', E'${given_table_excerpt}', E'${given_result_table}', '${given_db_name}', ${given_task_type}, ${answer_is_correct}, E'${answer_nl}', '${user_id}');`
    );
    client.end();
    return result;
}

module.exports = {
    EVQLToSQL: EVQLToSQL,
    getEVQL: getEVQL,
    queryDB: queryDB,
    getTask: getTask,
    logWorkerAnswer: logWorkerAnswer,
    getLogData: getLogData,
};
