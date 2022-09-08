const config = require("./config");

const PathToPythonSrc = "../src/";

function getEVQL(queryType) {
    var spawnSync = require("child_process").spawnSync;
    var process = spawnSync("python3", [`${PathToPythonSrc}/VQL/example_queries.py`, "--query_type", queryType]);
    var json_dumped_evql = process.stdout.toString();

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
    var process = spawnSync("python3", [`${PathToPythonSrc}/VQL/EVQL_to_SQL.py`, "--evql_in_json_str", evql]);
    var result = process.stdout.toString();
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

function getCollectionTask() {
    var spawnSync = require("child_process").spawnSync;
    var process = spawnSync("python3", [`${PathToPythonSrc}/create_task.py`]);
    var result = process.stdout.toString();
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

module.exports = {
    EVQLToSQL: EVQLToSQL,
    getEVQL: getEVQL,
    queryDB: queryDB,
    getCollectionTask: getCollectionTask,
};
