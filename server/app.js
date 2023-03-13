const fs = require("fs");
const func = require("./function.js");
const https = require("https");
var express = require("express");
var cors = require("cors");

/* Load config */
console.log("Reading config file...");
const utils = require("./utils.js");
const config = utils.loadYamlFile("../config.yml");

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
    console.log(`app.post./fetchEVQL  with query: ${JSON.stringify(req.query)}`);
    const queryType = req.body.params.queryType;
    console.log(`queryType: ${queryType}`);
    const evql = func.getEVQL(queryType);
    res.send(evql);
});

app.post("/fetchTask", function (req, res) {
    const workerID = req.body.workerId;
    console.log(`/fetchTask; workerID:${workerID}) has requested a task`);
    var taskData = null;
    // Check if worker has already been assigned a task
    if (workerID in workerTaskMapping) {
        // Return the same task
        const taskID = workerTaskMapping[workerID];
        console.log(`workerID:${workerID} has already been assigned to taskID:${taskID}`);
        taskData = func.getTask(taskID);
    } else {
        // Allocate a new task
        taskData = func.getTask();
        if (taskData) {
            const taskID = taskData["taskId"];
            workerTaskMapping[workerID] = taskID;
            console.log(`workerID:${workerID} has been assigned to taskID:${taskID}`);
        }
    }
    if (taskData === null) {
        console.log(`No task is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: false, task: null });
    } else {
        console.log(`task is retrieved and sent to workerID:${workerID}\n`);
        res.send({ isTaskReturned: true, task: taskData });
    }
});

app.post("/fetchLogData", function (req, res) {
    console.log("app.post./fetchLogData");
    const logData = func.getLogData();
    console.log(`log data: ${JSON.stringify(logData)}`);
    res.send(logData);
});

app.post("/runEVQL", async function (req, res) {
    console.log(`app.post./runEVQL with query: ${JSON.stringify(req.query)}`);
    const evqlStr = req.body.params.evqlStr;
    const dbName = req.body.params.dbName;
    const sql = func.EVQLToSQL(evqlStr);
    const queryResult = await func.queryDB(sql, dbName);
    console.log("evql:" + evqlStr);
    console.log("sql: " + sql);
    res.send({ sql: sql, result: queryResult });
});

app.post("/runSQL", async function (req, res) {
    console.log(`app.posts.runSQL  with query: ${JSON.stringify(req.query)}`);
    const sql = req.body.params.sql;
    const queryResult = await func.queryDB(sql);
    res.send(queryResult);
});

/* Handling Response */
app.post("/logWorkerAnswer", function (req, res) {
    console.log(`app.post./logWorkerAnswer`);
    console.log(`Received answer: ${JSON.stringify(req.body.params)}`);
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

if (config.backend.Protocol == "https") {
    console.log(`Using https protocol`);
    https
        .createServer(
            {
                key: fs.readFileSync("../certificates/thawte_postech_key_nopass.pem"),
                cert: fs.readFileSync("../certificates/thawte_postech.pem"),
            },
            app
        )
        .listen(config.backend.Port);
} else {
    console.log(`Using http protocol`);
    app.listen(config.backend.Port);
}

console.log(`Server is running on ${config.backend.Protocol}:${config.backend.IP}:${config.backend.Port}`);
