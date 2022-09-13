// Globally used variables
const config = require("./config");
const pg = require("pg-native");
var assert = require("assert");

/* Add environment variable to Python path */
const PathToPythonSrc = "../src/";
process.env["PYTHONPATH"] = PathToPythonSrc;

/* Fetch configs */
function getConfig() {
    const client = new pg();
    client.connectSync(
        `user=${config.configDBUserID} password=${config.configDBUserPW} port=${config.configDBPort} host=${config.configDBIP} dbname=${config.configDBName}`
    );
    const fetchedConfigs = client.querySync(`SELECT * FROM ${config.configDBTableName};`);
    const fetchedQueryGoalNums = client.querySync(`SELECT * FROM ${config.configDBQueryGoalNumsTableName};`);

    // Parse configs into JSON
    assert.equal(fetchedConfigs.length, 1);
    const systemConfig = {
        originalBalance: fetchedConfigs[0].original_balance,
        pricePerDataPair: fetchedConfigs[0].price_per_data,
        remainingBalance: fetchedConfigs[0].remaining_balance,
    };
    const queryGoalNum = {};
    fetchedQueryGoalNums.forEach((row) => {
        queryGoalNum[row.query_type] = row.goal_num;
    });
    return { ...systemConfig, goalNumOfQueries: queryGoalNum };
}

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
    function psqlDateToyymmdd(postgresDate) {
        const months = {
            Jan: "01",
            Feb: "02",
            Mar: "03",
            Apr: "04",
            May: "05",
            Jun: "06",
            Jul: "07",
            Aug: "08",
            Sep: "09",
            Oct: "10",
            Nov: "11",
            Dec: "12",
        };
        const dateStringSplitted = String(postgresDate).split(" ");
        const year = dateStringSplitted[3];
        const month = months[dateStringSplitted[1]];
        const day = dateStringSplitted[2];
        return `${year}.${month}.${day}`;
    }
    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(`SELECT * FROM ${config.collectionDBTableName};`);
    client.end();

    // Format Log Data for the client
    const parsedResult = [];
    for (var step = 0; step < result.length; step++) {
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
            user_isCorrect: result[step].user_is_correct,
            user_nl: result[step].user_nl,
            user_id: result[step].user_id,
            date: psqlDateToyymmdd(result[step].date),
        });
    }
    return parsedResult;
}
/* Save info */
function setNewConfig(newConfig) {
    const client = new pg();
    client.connectSync(
        `user=${config.configDBUserID} password=${config.configDBUserPW} port=${config.configDBPort} host=${config.configDBIP} dbname=${config.configDBName}`
    );
    // Update system config
    client.querySync(`UPDATE ${config.configDBTableName} SET original_balance=${newConfig.originalBalance}, price_per_data=${newConfig.pricePerData};`);

    // Update query goal nums
    for (const queryType in newConfig.goalNumOfQueries) {
        client.querySync(
            `UPDATE ${config.configDBQueryGoalNumsTableName} SET goal_num=${newConfig.goalNumOfQueries[queryType]} WHERE query_type='${queryType}';`
        );
    }
    client.end();
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
    const user_is_correct = logData.answer.isCorrect ?? null;
    const user_nl = logData.answer.nl.replace(/'/g, "\\'");
    const user_id = logData.userId;

    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(
        `INSERT INTO ${config.collectionDBTableName} VALUES(DEFAULT, E'${given_nl}', E'${given_sql}', E'${given_evql}', '${given_query_type}', E'${given_table_excerpt}', E'${given_result_table}', '${given_db_name}', ${given_task_type}, ${user_is_correct}, E'${user_nl}', '${user_id}', DEFAULT);`
    );
    client.end();
    return result;
}

/* Utils */
function EVQLToSQL(evql) {
    var spawnSync = require("child_process").spawnSync;
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/VQL/EVQL_to_SQL.py`, "--evql_in_json_str", evql]);
    var result = spawnedProcess.stdout.toString();
    return result;
}

function queryDB(sql, dbName) {
    const client = new pg();
    client.connectSync(`user=${config.demoDBUserID} password=${config.demoDBUserPW} port=${config.demoDBPort} host=${config.demoDBIP} dbname=${dbName}`);
    result = client.querySync(sql);
    client.end();
    return result;
}

module.exports = {
    getConfig: getConfig,
    getEVQL: getEVQL,
    getTask: getTask,
    getLogData: getLogData,
    setNewConfig: setNewConfig,
    logWorkerAnswer: logWorkerAnswer,
    EVQLToSQL: EVQLToSQL,
    queryDB: queryDB,
};
