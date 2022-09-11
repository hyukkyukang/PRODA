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

module.exports = {
    EVQLToSQL: EVQLToSQL,
    getEVQL: getEVQL,
    queryDB: queryDB,
    getTask: getTask,
};
