const fs = require("fs");
const func = require("./function.js");
const https = require("https");
var express = require("express");
var cors = require("cors");
var path = require("path");

/* Load config */
func.logWithTime("Reading config file...");
const utils = require("./utils.js");
const config = utils.loadYamlFile("../config.yml");
const protocol = config.backend.Protocol;
const IP = config.backend.IP;
const port = config.backend.Port;
const projectPath = config.ProjectPath;
const SSLCertPath = path.join(projectPath, config.SSLCertPath);
const SSLKeyPath = path.join(projectPath, config.SSLKeyPath);

func.logWithTime(`Begin server`);

var app = express();
app.use(cors());
app.use(express.json());

const workerTaskMapping = {};

app.get("/", function (req, res) {
    func.logWithTime("app.get./");
    func.logWithTime(`query: ${JSON.stringify(req.query)}`);
    res.send("Hello World!\nThis is back-end Server responding!");
});

/* Handling Config Request */
app.post("/fetchConfig", function (req, res) {
    func.logWithTime("app.post./fetchConfig");
    const systemConfig = func.getConfig();
    res.send(systemConfig);
});

/* Handling Request */
app.post("/fetchEVQL", function (req, res) {
    func.logWithTime(`app.post./fetchEVQL  with queryType: ${JSON.stringify(req.body.queryType)}`);
    const queryType = req.body.queryType;
    const evql = func.getEVQL(queryType);
    func.logWithTime(`return evql of type: ${queryType}`);
    res.send(evql);
});

app.post("/fetchTask", async function (req, res) {
    func.logWithTime(`fetchTask: ${JSON.stringify(req.body)}`);
    const workerID = req.body.workerID;
    const taskSetID = req.body.taskSetID;
    const isSkip = req.body.isSkip;
    func.logWithTime(`/fetchTask: workerID:${workerID} taskSetID:${taskSetID}) has requested a task`);
    func.logWithTime(`workerTaskMapping: ${JSON.stringify(workerTaskMapping)} workerID:${workerID}`);
    var taskSetData = null;
    // If taskSetID is given, return the task
    if (taskSetID !== undefined && taskSetID !== null && taskSetID !== -1) {
        taskSetData = await func.getTaskSet(workerID, taskSetID, isSkip);
    } else {
        // Check if worker has already been assigned a task
        if (workerID !== "" && workerID in workerTaskMapping && false) {
            // TODO: Need to check if the task is still available
            // Return the same task
            const taskSetID = workerTaskMapping[workerID];
            const isCollected = await func.checkTaskSetIDIsCollected(taskSetID);
            func.logWithTime(`isCollected: ${JSON.stringify(isCollected)}`);
            if (!isCollected) {
                func.logWithTime(`workerID:${workerID} has already been assigned to taskSetID:${taskSetID}`);
                taskSetData = await func.getTaskSet(workerID, taskSetID);
            } else {
                // TODO: Need to refactor the same code block in the below condition
                // Allocate a new task
                func.logWithTime(`Getting a new task for workerID:${workerID}`);
                taskSetData = await func.getTaskSet(workerID);
                if (taskSetData) {
                    const taskSetID = taskSetData.taskSetID;
                    if (workerID !== undefined && workerID !== "" && workerID !== null) {
                        workerTaskMapping[workerID] = taskSetID;
                        func.logWithTime(`workerID:${workerID} has been assigned to taskSetID:${taskSetID}`);
                    }
                }
            }
        } else {
            // Allocate a new task
            func.logWithTime(`Getting a new task for workerID:${workerID}`);
            taskSetData = await func.getTaskSet(workerID);
            if (taskSetData) {
                const taskSetID = taskSetData.taskSetID;
                if (workerID !== undefined && workerID !== "" && workerID !== null) {
                    workerTaskMapping[workerID] = taskSetID;
                    func.logWithTime(`workerID:${workerID} has been assigned to taskSetID:${taskSetID}`);
                }
            }
        }
    }
    if (taskSetData === null) {
        func.logWithTime(`No task is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: false, taskSet: null });
    } else {
        func.logWithTime(`task ${taskSetData.taskSetID} is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: true, taskSet: taskSetData });
    }
});

// app.post("/fetchLogData", function (req, res) {
//     func.logWithTime("app.post./fetchLogData");
//     const logData = func.getLogData();
//     func.logWithTime(`log data: ${JSON.stringify(logData)}`);
//     res.send(logData);
// });

app.post("/runEVQL", async function (req, res) {
    func.logWithTime(`app.post./runEVQL`);
    const evqlStr = req.body.evql;
    const sql = func.EVQLToSQL(evqlStr);
    const queryResult = await func.queryDemoDB(sql);
    func.logWithTime(`sending back result with SQL: ${sql}`);
    res.send({ sql: sql, result: queryResult });
});

app.post("/runSQL", async function (req, res) {
    func.logWithTime(`app.posts.runSQL with query: ${JSON.stringify(req.body.sql)}`);
    const sql = req.body.sql;
    func.logWithTime(`sql: ${sql}`);
    func.logWithTime(`This query causes error, need to fix this issue`);
    var queryResult = {};
    try {
        queryResult = await func.queryDemoDB(sql);
    } catch (err) {
        console.warn(err);
    }
    func.logWithTime(`sending back result for SQL: ${sql}`);
    func.logWithTime(`result: ${queryResult}`);
    res.send(queryResult);
});

/* Handling Response */
app.post("/logWorkerAnswer", function (req, res) {
    func.logWithTime(`app.post./logWorkerAnswer`);
    func.logWorkerAnswer(req.body.params);
    delete workerTaskMapping[req.body.params.workerID];
    res.send({ status: "success" });
});

app.post("/updateConfig", function (req, res) {
    func.logWithTime(`app.post./updateConfig`);
    func.logWithTime(`Received config: ${JSON.stringify(req.body.params)}`);
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
    func.logWithTime("Handling error");
    console.error(err);
    // clear the task mapping
    for (var member in workerTaskMapping) delete workerTaskMapping[member];
    res.status(500).send({ error: err });
}
app.use(errorHandler);

if (protocol == "https") {
    func.logWithTime(`Using https protocol`);
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
    func.logWithTime(`Using http protocol`);
    app.listen(port);
}

func.logWithTime(`Server is running on ${protocol}:${IP}:${port}`);
