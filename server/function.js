// Globally used variables
const { Client } = require("pg");
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
TaskDir = config.TaskSaveDirPath;

const spawnSync = require("child_process").spawnSync;

function logWithTime(msg) {
    console.log(messageWithTime(msg));
}

function messageWithTime(msg) {
    var currentdate = new Date();
    var datetime =
        "|" +
        currentdate.getFullYear() +
        "/" +
        (currentdate.getMonth() + 1) +
        "/" +
        currentdate.getDate() +
        "|" +
        currentdate.getHours() +
        ":" +
        currentdate.getMinutes() +
        ":" +
        currentdate.getSeconds() +
        "|";
    return `${datetime} ${msg}`;
}

/* Fetch configs */
function getConfig() {
    // const client = new pg();
    // client.connectSync(`user=${configDBUserID} password=${configDBUserPW} port=${DBPort} host=${DBIP} dbname=${configDBName}`);
    // const fetchedConfigs = client.querySync(`SELECT * FROM ${configDBTableName};`);
    // const fetchedQueryGoalNums = client.querySync(`SELECT * FROM ${configDBQueryGoalNumsTableName};`);
    // client.end();
    // // Parse configs into JSON
    // assert.equal(fetchedConfigs.length, 1);
    // const systemConfig = {
    //     originalBalance: fetchedConfigs[0].original_balance,
    //     pricePerDataPair: fetchedConfigs[0].price_per_data,
    //     remainingBalance: fetchedConfigs[0].remaining_balance,
    // };
    // const queryGoalNum = {};
    // fetchedQueryGoalNums.forEach((row) => {
    //     queryGoalNum[row.query_type] = row.goal_num;
    // });
    // return { ...systemConfig, goalNumOfQueries: queryGoalNum };
}

/* Fetch information */
function getEVQA(queryType) {
    const spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/utils/example_queries.py`, "--query_type", queryType]);
    const json_dumped_evqa = spawnedProcess.stdout.toString();
    var evqa = null;
    // Check if empty
    if (!json_dumped_evqa) {
        console.warn("No EVQA returned from Python script.");
    } else {
        // Try to parse string into JSON
        try {
            evqa = JSON.parse(json_dumped_evqa);
        } catch (err) {
            console.warn(`Error parsing JSON: ${err}`);
            console.warn(`JSON string: ${json_dumped_evqa}`);
        }
    }
    return evqa;
}

/* Fetch Task */
async function getTask(taskID, getHistory = true) {
    // Connect to DB and retrieve Task
    let sql_query = `SELECT * FROM ${collectionDBTaskTableName} WHERE id = ${taskID};`;
    let results = await queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query);
    let result = getOneQueryResult(results);
    if (result == null) {
        console.error(`Task ${taskID} not found in DB.`);
        return null;
    }
    // Get file paths
    const evqa_path = result.evqa_path;
    const result_table_path = result.result_table_path;
    const table_excerpt_path = result.table_excerpt_path;
    const nl_mapping_path = result.nl_mapping_path;
    // Retrieve data from Python script
    const evqa_object = readJsonFile(`${TaskDir}/evqa/${result.id}.json`);
    const result_table_object = readJsonFile(`${TaskDir}/result_table/${result.id}.json`);
    const table_excerpt_object = readJsonFile(`${TaskDir}/table_excerpt/${result.id}.json`);
    const nl_mapping_object = readJsonFile(`${TaskDir}/nl_mapping/${result.id}.json`);
    // Append history if there are any
    const sub_tasks = [];
    if (getHistory) {
        for (const task_id of result.sub_task_ids) {
            const sub_task = await getTask(task_id, false, false);
            sub_tasks.push(sub_task);
        }
    }
    return {
        nl: result.nl,
        nl_mapping: nl_mapping_object,
        sql: result.sql,
        evqa: evqa_object,
        queryType: result.query_type,
        taskType: result.task_type,
        dbName: result.db_name,
        tableExcerpt: table_excerpt_object,
        resultTable: result_table_object,
        subTasks: sub_tasks,
        taskID: result.id,
    };
}

async function checkTaskSetIDIsCollected(taskSetID) {
    // Connect to DB and retrieve Task
    let sql_query = `SELECT * FROM ${collectionDBCollectionTableName} WHERE task_set_id = ${taskSetID};`;
    let results = await queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query);
    return results.length > 0;
}

async function getTaskSet(workerID, taskSetID = null, isSkip = false) {
    // Connect to DB and retrieve Task
    console.log(`Fetching task set ${taskSetID}...`);
    if (taskSetID === null) {
        if (workerID === undefined || workerID === "" || workerID === null) {
            sql_query = `SELECT * FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName} GROUP BY task_set_id HAVING count(*) > 1) AND is_solving = false;`;
        } else {
            sql_query = `UPDATE ${collectionDBTaskSetTableName} SET is_solving = true WHERE id = (SELECT id FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName} GROUP BY task_set_id HAVING count(*) > 1) AND is_solving = false ORDER BY id LIMIT 1) RETURNING *;`;
        }
    } else if (isSkip) {
        // Update is_solving to false for the last taskSetID given to the workerID
        sql_query = `UPDATE ${collectionDBTaskSetTableName} SET is_solving = false WHERE id = ${taskSetID};`;
        await queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query);
        // Get the next taskSetID
        if (workerID === undefined || workerID === "" || workerID === null) {
            sql_query = `SELECT * FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName} GROUP BY task_set_id HAVING count(*) > 1) AND id > ${taskSetID} AND is_solving = false;`;
        } else {
            sql_query = `UPDATE ${collectionDBTaskSetTableName} SET is_solving = true WHERE id = (SELECT id FROM ${collectionDBTaskSetTableName} WHERE id NOT IN (SELECT task_set_id FROM ${collectionDBCollectionTableName} GROUP BY task_set_id HAVING count(*) > 1) AND id > ${taskSetID} AND is_solving = false ORDER BY id LIMIT 1) RETURNING *;`;
        }
    } else {
        sql_query = `SELECT * FROM ${collectionDBTaskSetTableName} WHERE id = ${taskSetID};`;
    }
    console.log(`sql_query: ${sql_query}`);
    let results = await queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query);
    let result = getOneQueryResult(results);
    if (result == null) {
        console.warn("No task returned from DB.");
        return null;
    }
    const task_ids = result.task_ids;
    const tasks = [];
    for (const task_id of task_ids) {
        const task = await getTask(task_id);
        tasks.push(task);
    }
    console.log(`TaskSet with ID:${result.id} containing ${tasks.length} number of tasks:(${tasks.map((t) => t.taskID).toString()}) is retrieved.`);
    return {
        taskSetID: result.id,
        tasks: tasks,
    };
}

/* Read in JSON object from file */
function readPickleFile(file_path) {
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

function readJsonFile(file_path) {
    return require(file_path);
}

/* Fetch Log data */
function getLogData() {
    // function psqlDateToyymmdd(postgresDate) {
    //     const months = {
    //         Jan: "01",
    //         Feb: "02",
    //         Mar: "03",
    //         Apr: "04",
    //         May: "05",
    //         Jun: "06",
    //         Jul: "07",
    //         Aug: "08",
    //         Sep: "09",
    //         Oct: "10",
    //         Nov: "11",
    //         Dec: "12",
    //     };
    //     const dateStringSplitted = String(postgresDate).split(" ");
    //     const year = dateStringSplitted[3];
    //     const month = months[dateStringSplitted[1]];
    //     const day = dateStringSplitted[2];
    //     return `${year}.${month}.${day}`;
    // }
    // const client = new pg();
    // client.connectSync(`user=${collectionDBUserID} password=${collectionDBUserPW} port=${DBPort} host=${DBIP} dbname=${collectionDBName}`);
    // // Insert new log
    // result = client.querySync(`SELECT * FROM ${collectionDBCollectionTableName};`);
    // client.end();
    // // Format Log Data for the client
    // const parsedResult = [];
    // for (var step = 0; step < result.length; step++) {
    //     parsedResult.push({
    //         id: result[step].id,
    //         given_nl: result[step].given_nl,
    //         given_sql: result[step].given_sql,
    //         given_evqa: JSON.parse(result[step].given_evqa),
    //         given_queryType: result[step].given_query_type,
    //         given_tableExcerpt: JSON.parse(result[step].given_table_excerpt),
    //         given_resultTable: JSON.parse(result[step].given_result_table),
    //         given_dbName: result[step].given_db_name,
    //         given_taskType: result[step].given_task_type,
    //         user_isCorrect: result[step].user_is_correct,
    //         user_nl: result[step].user_nl,
    //         user_id: result[step].user_id,
    //         date: psqlDateToyymmdd(result[step].date),
    //     });
    // }
    // return parsedResult;
}

/* Save info */
function setNewConfig(newConfig) {
    // const client = new pg();
    // client.connectSync(`user=${configDBUserID} password=${configDBUserPW} port=${DBPort} host=${DBIP} dbname=${configDBName}`);
    // // Update system config
    // client.querySync(`UPDATE ${configDBTableName} SET original_balance=${newConfig.originalBalance}, price_per_data=${newConfig.pricePerData};`);
    // // Update query goal nums
    // for (const queryType in newConfig.goalNumOfQueries) {
    //     client.querySync(`UPDATE ${configDBQueryGoalNumsTableName} SET goal_num=${newConfig.goalNumOfQueries[queryType]} WHERE query_type='${queryType}';`);
    // }
    // client.end();
}

/* Log worker answer */
function logWorkerAnswer(logData) {
    // Get values from answer
    const task_set_id = logData.taskSetID;
    const task_id = logData.taskID;
    const user_id = logData.workerID;
    const is_correct = logData.answer.isCorrect === undefined ? null : logData.answer.isCorrect;
    const nl = logData.answer.nl.replace(/'/g, "\\'");
    const sql_query1 = `INSERT INTO ${collectionDBCollectionTableName} VALUES(DEFAULT, ${task_set_id}, ${task_id}, E'${user_id}', ${is_correct}, E'${nl}', DEFAULT);`;
    // queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query1);
    // Change the is_solving column to false in the table task_set, where the column id is same as the variable task_set_id
    const sql_query2 = `UPDATE ${collectionDBTaskSetTableName} SET is_solving=false WHERE id=${task_set_id};`;
    queryDB(collectionDBName, collectionDBUserID, collectionDBUserPW, sql_query2);
}

/* Utils */
function EVQAToSQL(evqa) {
    var spawnedProcess = spawnSync("python3", [`${PathToPythonSrc}/VQA/EVQA_to_SQL.py`, "--evqa_in_json_str", JSON.stringify(evqa)]);
    var result = spawnedProcess.stdout.toString();
    return result;
}

function getOneQueryResult(results) {
    if (results.rowCount > 0) {
        return results.rows[0];
    }
    return null;
}

async function queryDB(database, user, password, sql) {
    const client = new Client({
        host: DBIP,
        port: DBPort,
        user: user,
        password: password,
        database: database,
    });
    client.connect();
    let result = await client.query({ text: sql });
    client.end();
    return result;
}

/* Used for query to demo*/
async function queryDemoDB(sql) {
    const client = new Client({
        host: DBIP,
        port: DBPort,
        user: demoDBUserID,
        password: demoDBUserPW,
        database: demoDBName,
    });
    client.connect();
    let result = await client.query({ text: sql, rowMode: "array" });
    client.end();
    return result;
}

module.exports = {
    logWithTime: logWithTime,
    messageWithTime: messageWithTime,
    readPickleFile: readPickleFile,
    readJsonFile: readJsonFile,
    checkTaskSetIDIsCollected: checkTaskSetIDIsCollected,
    getConfig: getConfig,
    getEVQA: getEVQA,
    getTask: getTask,
    getTaskSet: getTaskSet,
    getLogData: getLogData,
    setNewConfig: setNewConfig,
    logWorkerAnswer: logWorkerAnswer,
    EVQAToSQL: EVQAToSQL,
    queryDemoDB: queryDemoDB,
};
