console.log("Begin server");

const fs = require("fs");
const config = require("./config");
const func = require("./function.js");
const https = require("https");
var express = require("express");
var cors = require("cors");

var app = express();
app.use(cors());
app.use(express.json());

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
    console.log(`app.post./fetchTask  with query: ${JSON.stringify(req.query)}`);
    const taskData = func.getTask();
    console.log(`task data1: ${taskData}`);
    res.send(taskData);
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
    const dbName = req.body.params.dbName;
    const queryResult = await func.queryDB(sql, dbName);
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

const use_https = true;
if (use_https) {
    https
        .createServer(
            {
                key: fs.readFileSync("../certificates/thawte_postech_key_nopass.pem"),
                cert: fs.readFileSync("../certificates/thawte_postech.pem"),
            },
            app
        )
        .listen(config.serverPort);
} else {
    app.listen(config.serverPort);
}

console.log(`Server is running on port ${config.serverPort}`);
