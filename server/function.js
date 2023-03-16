// Globally used variables
const pg = require("pg-native");
const assert = require("assert");

/* Add environment variable to Python path */
const PathToPythonSrc = "../src/";
process.env["PYTHONPATH"] = "../";

/* Load config */
const utils = require("./utils.js");
const config = utils.loadYamlFile("../config.yml");

// DB
DBIP = config.DB.IP;
DBPort = config.DB.Port;
// ConfigDB
configDBUserID = config.DB.config.UserID;
configDBUserPW = config.DB.config.UserPW;
configDBName = config.DB.config.DBName;
configDBTableName = config.DB.config.TableName;
configDBQueryGoalNumsTableName = config.DB.config.QueryGoalNumsTableName;
// CollectionDB
collectionDBUserID = config.DB.collection.UserID;
collectionDBUserPW = config.DB.collection.UserPW;
collectionDBName = config.DB.collection.DBName;
collectionDBCollectionTableName = config.DB.collection.CollectionTableName;
collectionDBTaskTableName = config.DB.collection.TaskTableName;
collectionDBTaskSetTableName = config.DB.collection.TaskSetTableName;
// DemoDB
demoDBUserID = config.DB.demo.UserID;
demoDBUserPW = config.DB.demo.UserPW;
demoDBName = config.DB.demo.DBName;
demoDBTableName = config.DB.demo.tableName;

/* Fetch configs */
function getConfig() {
    const client = new pg();
    client.connectSync(`user=${configDBUserID} password=${configDBUserPW} port=${DBPort} host=${DBIP} dbname=${configDBName}`);
    const fetchedConfigs = client.querySync(`SELECT * FROM ${configDBTableName};`);
    const fetchedQueryGoalNums = client.querySync(`SELECT * FROM ${configDBQueryGoalNumsTableName};`);

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

/* Fetch Task */
function getTask(taskID, getHistory = true) {
    // Connect to DB and retrieve Task
    const client = new pg();
    client.connectSync(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    results = client.querySync(`SELECT * FROM ${collectionDBTaskTableName} WHERE id = ${taskID};`);
    // Get one task
    if (results.length > 0) {
        result = results[0];
    }
    client.end();
    if (result == null) {
        console.warn(`Task ${taskID} not found in DB.`);
        return null;
    }
    // Get file paths
    const evql_path = result.evql_path;
    const result_table_path = result.result_table_path;
    const table_excerpt_path = result.table_excerpt_path;
    const nl_mapping_path = result.nl_mapping_path;
    // Retrieve data from Python script
    const evql_object = getJsonDataFromFile(evql_path);
    const result_table_object = getJsonDataFromFile(result_table_path);
    const table_excerpt_object = getJsonDataFromFile(table_excerpt_path);
    const nl_mapping_object = getJsonDataFromFile(nl_mapping_path);
    // Replace path with the real data
    delete result.evql_path;
    delete result.result_table_path;
    delete result.table_excerpt_path;
    // Append history if there are any
    const history = [];
    if (getHistory) {
        for (const task_id of result.history_task_ids) {
            const history_task = getTask(task_id, false, false);
            history.push(history_task);
        }
    }
    return {
        nl: result.nl,
        nl_mapping: nl_mapping_object,
        sql: result.sql,
        evql: evql_object,
        queryType: result.query_type,
        taskType: result.task_type,
        dbName: result.db_name,
        tableExcerpt: table_excerpt_object,
        resultTable: result_table_object,
        history: history,
        blockID: null,
        taskID: result.id,
    };
}

function getTaskSet(taskSetID = null, isSkip = false) {
    // Connect to DB and retrieve Task
    const client = new pg();
    // console.log(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    client.connectSync(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    // Insert new log
    var result = null;
    var results = null;
    if (taskSetID === null) {
        results = client.querySync(
            `SELECT * FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName});`
        );
    } else if (isSkip) {
        results = client.querySync(
            `SELECT * FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName}) AND id > ${taskSetID};`
        );
    } else {
        results = client.querySync(`SELECT * FROM ${collectionDBTaskSetTableName} WHERE id = ${taskSetID};`);
    }
    // Get one task
    if (results.length > 0) {
        result = results[0];
    }
    client.end();
    if (result == null) {
        console.warn("No task returned from DB.");
        return null;
    }
    const task_ids = result.task_ids;
    const tasks = [];
    for (const task_id of task_ids) {
        const task = getTask(task_id);
        tasks.push(task);
    }
    console.log(`Task set ${result.id} with ${tasks.length} number of tasks retrieved.`);
    return {
        taskSetID: result.id,
        tasks: tasks,
    };
}

/* Read in JSON object from file */
function getJsonDataFromFile(file_path) {
    var spawnSync = require("child_process").spawnSync;
    // Retrieve data from Python script
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/utils/data_manager.py`, "--file_path", file_path]);
    var result = spawnedProcess.stdout.toString();
    var json_object = null;
    if (!result) {
        console.warn(`No Data returned from Python script. Check following command: \npython3 ./src/utils/data_manager.py --file_path ${file_path}`);
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

/* Fetch Log data */
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
    client.connectSync(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    // Insert new log
    result = client.querySync(`SELECT * FROM ${collectionDBCollectionTableName};`);
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
    client.connectSync(`user=${configDBUserID} password=${configDBUserPW} port=${DBPort} host=${DBIP} dbname=${configDBName}`);
    // Update system config
    client.querySync(`UPDATE ${configDBTableName} SET original_balance=${newConfig.originalBalance}, price_per_data=${newConfig.pricePerData};`);

    // Update query goal nums
    for (const queryType in newConfig.goalNumOfQueries) {
        client.querySync(`UPDATE ${configDBQueryGoalNumsTableName} SET goal_num=${newConfig.goalNumOfQueries[queryType]} WHERE query_type='${queryType}';`);
    }
    client.end();
}

/* Log worker answer */
function logWorkerAnswer(logData) {
    // Get values from answer
    const task_set_id = logData.taskSetID;
    const task_id = logData.taskID;
    const user_id = logData.workerId;
    const is_correct = logData.answer.isCorrect === undefined ? null : logData.answer.isCorrect;
    const nl = logData.answer.nl.replace(/'/g, "\\'");

    const client = new pg();
    client.connectSync(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    // Insert new log
    result = client.querySync(
        `INSERT INTO ${collectionDBCollectionTableName} VALUES(DEFAULT, ${task_set_id}, ${task_id}, E'${user_id}', ${is_correct}, E'${nl}', DEFAULT);`
    );
    client.end();
    return result;
}

/* Utils */
function EVQLToSQL(evql) {
    var spawnSync = require("child_process").spawnSync;
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/VQL/EVQL_to_SQL.py`, "--evql_in_json_str", JSON.stringify(evql)]);
    var result = spawnedProcess.stdout.toString();
    return result;
}

/* Used for query to demo*/
async function queryDB(sql) {
    const { Client } = require("pg");
    const client = new Client({
        host: DBIP,
        port: DBPort,
        user: demoDBUserID,
        password: demoDBUserPW,
        database: demoDBName,
    });
    client.connect();
    result = await client.query({ text: sql, rowMode: "array" });
    return result;
}

module.exports = {
    getConfig: getConfig,
    getEVQL: getEVQL,
    getTask: getTask,
    getTaskSet: getTaskSet,
    getLogData: getLogData,
    setNewConfig: setNewConfig,
    logWorkerAnswer: logWorkerAnswer,
    EVQLToSQL: EVQLToSQL,
    queryDB: queryDB,
};
