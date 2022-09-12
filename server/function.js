const config = require("./config");

const PathToPythonSrc = "../src/";

// Add environment variable to Python path
process.env["PYTHONPATH"] = PathToPythonSrc;

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
    const user_id = logData.userID;

    const pg = require("pg-native");
    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(
        `INSERT INTO tasklog VALUES(DEFAULT, E'${given_nl}', E'${given_sql}', E'${given_evql}', '${given_query_type}', E'${given_table_excerpt}', E'${given_result_table}', '${given_db_name}', ${given_task_type}, ${answer_is_correct}, E'${answer_nl}', ${user_id});`
    );
    client.end();
    console.log(`result: ${result}`);
    return result;
}

module.exports = {
    EVQLToSQL: EVQLToSQL,
    getEVQL: getEVQL,
    queryDB: queryDB,
    getTask: getTask,
    logWorkerAnswer: logWorkerAnswer,
};
