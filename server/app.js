console.log("Begin server")

const config = require("./config");
const func = require("./function.js");
var express = require("express");
var cors = require('cors');

var app = express();
app.use(cors());
app.use(express.json());

app.get("/", function(req, res){
    console.log("app.get./");
});

app.post("/fetchEVQL", function(req, res){
    console.log("app.post./fetchEVQL")
    const queryType = req.body.params.queryType;
    const evql = func.getEVQL(queryType);
    res.send({evql: evql});
});

app.post("/runEVQL", function(req, res){
    console.log("app.post./runEVQL")
    const evqlStr = req.body.params.evqlStr;
    const dbName = req.body.params.dbName;
    console.log(`params:${JSON.stringify(req.body.params)}`);
    const sql = func.EVQLToSQL(evqlStr);
    const queryResult = func.queryDB(sql, dbName);
    console.log("evql:" + evqlStr);
    console.log("sql: " + sql);
    res.send({sql: sql, result: queryResult});
});

app.post("/runSQL", function(req, res){
    console.log("app.posts.runSQL");
    const sql = req.body.params.sql;
    const dbName = req.body.params.dbName;
    const queryResult = func.queryDB(sql, dbName);
    console.log(`SQL:${JSON.stringify(sql)} on ${dbName}`);
    res.send({result: queryResult});
});

app.listen(config.serverPort);

console.log(`Server is running on port ${config.serverPort}`);
