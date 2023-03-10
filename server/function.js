// Globally used variables
const config = require("./config");
const pg = require("pg-native");
var assert = require("assert");

/* Add environment variable to Python path */
const PathToPythonSrc = "../src/";
process.env["PYTHONPATH"] = "../";

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
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/utils/example_queries.py`, "--query_type", queryType]);
    var json_dumped_evql = spawnedProcess.stdout.toString();
    var evql = null;
    // Check if empty
    if (!json_dumped_evql) {
        console.warn("No EVQL returned from Python script.");
    } else {
        // Try to parse string into JSON
        try {
            evql = JSON.parse(json_dumped_evql);
        } catch (err) {
            console.warn(`Error parsing JSON: ${err}`);
            console.warn(`JSON string: ${json_dumped_evql}`);
        }
    }
    return evql;
}

function getTask(taskID = null) {
    // Connect to DB and retrieve Task
    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    var result = null;
    var results = null;
    if (taskID === null) {
        results = client.querySync(`SELECT * FROM ${config.collectionDBTaskTableName} WHERE id NOT IN (SELECT task_id FROM ${config.collectionDBTableName});`);
    } else {
        results = client.querySync(`SELECT * FROM ${config.collectionDBTaskTableName} WHERE id = ${taskID};`);
    }
    // Get one task
    if (results.length > 0) {
        result = results[0];
    }
    client.end();
    console.log(`Retrieved result: ${JSON.stringify(result)}`);
    // Handle empty result
    if (result == null) {
        console.warn("No task returned from DB.");
        return null;
    }
    // Get file paths
    const evql_path = result.evql_path;
    const result_table_path = result.result_table_path;
    const table_excerpt_path = result.table_excerpt_path;
    // Retrieve data from Python script
    const evql_object = getJsonDataFromFile(evql_path);
    const result_table_object = getJsonDataFromFile(result_table_path);
    const table_excerpt_object = getJsonDataFromFile(table_excerpt_path);
    // Replace path with the real data
    delete result.evql_path;
    delete result.result_table_path;
    delete result.table_excerpt_path;
    return {
        nl: result.nl,
        nl_mapping: null,
        sql: result.sql,
        evql: evql_object,
        queryType: result.query_type,
        taskType: result.task_type,
        dbName: result.db_name,
        tableExcerpt: table_excerpt_object,
        resultTable: result_table_object,
        history: null,
        blockId: null,
        taskId: result.id,
    };
}

function getJsonDataFromFile(file_path) {
    var spawnSync = require("child_process").spawnSync;
    // Retrieve data from Python script
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/utils/data_manager.py`, "--file_path", file_path]);
    var result = spawnedProcess.stdout.toString();
    var json_object = null;
    if (!result) {
        console.warn("No Data returned from Python script.");
    } else {
        try {
            json_object = JSON.parse(result);
        } catch (err) {
            console.warn(`Error parsing JSON: ${err}`);
            console.warn(`JSON string: ${result}`);
        }
    }
    return json_object;
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
    const task_id = logData.task.taskId;
    const user_id = logData.workerId;
    const is_correct = "isCorrect" in logData.answer ? logData.answer.isCorrect : null;
    const nl = logData.answer.nl.replace(/'/g, "\\'");

    const client = new pg();
    client.connectSync(
        `user=${config.collectionDBUserID} password=${config.collectionDBUserPW} port=${config.collectionDBPort} host=${config.collectionDBIP} dbname=${config.collectionDBName}`
    );
    // Insert new log
    result = client.querySync(`INSERT INTO ${config.collectionDBTableName} VALUES(DEFAULT, ${task_id}, E'${user_id}', ${is_correct}, E'${nl}', DEFAULT);`);
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

async function queryDB(sql, dbName) {
    const { Client } = require("pg");
    const client = new Client({
        host: config.demoDBIP,
        port: config.demoDBPort,
        user: config.demoDBUserID,
        password: config.demoDBUserPW,
        database: dbName,
    });
    client.connect();
    result = await client.query({ text: sql, rowMode: "array" });
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
