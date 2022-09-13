console.log("Begin server");

const config = require("./config");
const func = require("./function.js");
var express = require("express");
var cors = require("cors");

var app = express();
app.use(cors());
app.use(express.json());

app.get("/", function (req, res) {
    console.log("app.get./");
});

/* Handling Config Request */
app.post("/fetchConfig", function (req, res) {
    console.log("app.post./fetchConfig");
    const systemConfig = func.getConfig();
    res.send(systemConfig);
});

/* Handling Request */
app.post("/fetchEVQL", function (req, res) {
    console.log("app.post./fetchEVQL");
    const queryType = req.body.params.queryType;
    const evql = func.getEVQL(queryType);
    res.send(evql);
});

app.post("/runEVQL", function (req, res) {
    console.log("app.post./runEVQL");
    const evqlStr = req.body.params.evqlStr;
    const dbName = req.body.params.dbName;
    const sql = func.EVQLToSQL(evqlStr);
    const queryResult = func.queryDB(sql, dbName);
    console.log("evql:" + evqlStr);
    console.log("sql: " + sql);
    res.send({ sql: sql, result: queryResult });
});

app.post("/runSQL", function (req, res) {
    console.log("app.posts.runSQL");
    const sql = req.body.params.sql;
    const dbName = req.body.params.dbName;
    const queryResult = func.queryDB(sql, dbName);
    console.log(`SQL:${JSON.stringify(sql)} on ${dbName}`);
    res.send({ result: queryResult });
});

app.post("/fetchTask", function (req, res) {
    console.log("app.post./fetchask");
    const taskData = func.getTask();
    console.log(`task data: ${JSON.stringify(taskData)}`);
    res.send(taskData);
});

app.post("/fetchLogData", function (req, res) {
    console.log("app.post./fetchLogData");
    const logData = func.getLogData();
    console.log(`log data: ${JSON.stringify(logData)}`);
    res.send(logData);
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

app.listen(config.serverPort);

console.log(`Server is running on port ${config.serverPort}`);
