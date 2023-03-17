const fs = require("fs");
const func = require("./function.js");
const https = require("https");
var express = require("express");
var cors = require("cors");

/* Load config */
console.log("Reading config file...");
const utils = require("./utils.js");
const config = utils.loadYamlFile("../config.yml");
const protocol = config.backend.Protocol;
const IP = config.backend.IP;
const port = config.backend.Port;
const SSLCertPath = config.SSLCertPath;
const SSLKeyPath = config.SSLKeyPath;

console.log("Begin server");

var app = express();
app.use(cors());
app.use(express.json());

const workerTaskMapping = {};

app.get("/", function (req, res) {
    console.log("app.get./");
    console.log(`query: ${JSON.stringify(req.query)}`);
    res.send("Hello World!\nThis is back-end Server responding!");
});

/* Handling Config Request */
app.post("/fetchConfig", function (req, res) {
    console.log("app.post./fetchConfig");
    const systemConfig = func.getConfig();
    res.send(systemConfig);
});

/* Handling Request */
app.post("/fetchEVQL", function (req, res) {
    console.log(`app.post./fetchEVQL  with queryType: ${JSON.stringify(req.body.queryType)}`);
    const queryType = req.body.queryType;
    const evql = func.getEVQL(queryType);
    console.log(`return evql of type: ${queryType}`);
    res.send(evql);
});

app.post("/fetchTask", function (req, res) {
    console.log(`fetchTask: ${JSON.stringify(req.body)}`);
    const workerID = req.body.workerID;
    const taskSetID = req.body.taskSetID;
    const isSkip = req.body.isSkip;
    console.log(`/fetchTask: workerID:${workerID} taskSetID:${taskSetID}) has requested a task`);
    var taskSetData = null;
    // If taskSetID is given, return the task
    if (taskSetID !== undefined && taskSetID !== null && taskSetID !== -1) {
        taskSetData = func.getTaskSet(taskSetID, isSkip);
    } else {
        // Check if worker has already been assigned a task
        if (workerID in workerTaskMapping) {
            // Return the same task
            const taskSetID = workerTaskMapping[workerID];
            console.log(`workerID:${workerID} has already been assigned to taskSetID:${taskSetID}`);
            taskSetData = func.getTaskSet(taskSetID);
        } else {
            // Allocate a new task
            console.log(`Getting a new task for workerID:${workerID}`);
            taskSetData = func.getTaskSet();
            if (taskSetData) {
                const taskSetID = taskSetData.taskSetID;
                if (workerID !== undefined) {
                    workerTaskMapping[workerID] = taskSetID;
                    console.log(`workerID:${workerID} has been assigned to taskSetID:${taskSetID}`);
                }
            }
        }
    }
    if (taskSetData === null) {
        console.log(`No task is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: false, taskSet: null });
    } else {
        console.log(`task ${taskSetData.taskSetID} is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: true, taskSet: taskSetData });
    }
});

app.post("/fetchLogData", function (req, res) {
    console.log("app.post./fetchLogData");
    const logData = func.getLogData();
    console.log(`log data: ${JSON.stringify(logData)}`);
    res.send(logData);
});

app.post("/runEVQL", async function (req, res) {
    console.log(`app.post./runEVQL`);
    const evqlStr = req.body.evql;
    const sql = func.EVQLToSQL(evqlStr);
    const queryResult = await func.queryDB(sql);
    console.log(`sending back result with SQL: ${sql}`);
    res.send({ sql: sql, result: queryResult });
});

app.post("/runSQL", async function (req, res) {
    console.log(`app.posts.runSQL with query: ${JSON.stringify(req.body.sql)}`);
    const sql = req.body.sql;
    console.log(`sql: ${sql}`);
    console.log(`This query causes error, need to fix this issue`);
    var queryResult = {};
    try {
        queryResult = await func.queryDB(sql);
    } catch (err) {
        console.warn(err);
    }
    console.log(`sending back result for SQL: ${sql}`);
    console.log(`result: ${queryResult}`);
    res.send(queryResult);
});

/* Handling Response */
app.post("/logWorkerAnswer", function (req, res) {
    console.log(`app.post./logWorkerAnswer`);
    // console.log(`Received answer: ${JSON.stringify(req.body.params)}`);
    func.logWorkerAnswer(req.body.params);
    res.send({ status: "success" });
});

app.post("/updateConfig", function (req, res) {
    console.log(`app.post./updateConfig`);
    console.log(`Received config: ${JSON.stringify(req.body.params)}`);
    const formattedConfig = {
        originalBalance: req.body.params.totalBudget,
        pricePerData: req.body.params.pricePerDataPair,
        goalNumOfQueries: req.body.params.goalNumOfQueries,
    };
    func.setNewConfig(formattedConfig);
    res.send({ status: "success" });
});

// Error handler
function errorHandler(err, req, res, next) {
    console.log("Handling error");
    console.error(err);
    // clear the task mapping
    for (var member in workerTaskMapping) delete workerTaskMapping[member];
    res.status(500).send({ error: err });
}
app.use(errorHandler);

if (protocol == "https") {
    console.log(`Using https protocol`);
    https
        .createServer(
            {
                key: fs.readFileSync(SSLKeyPath),
                cert: fs.readFileSync(SSLCertPath),
            },
            app
        )
        .listen(port);
} else {
    console.log(`Using http protocol`);
    app.listen(port);
}

console.log(`Server is running on ${protocol}:${IP}:${port}`);
