const func = require("./function.js");
const bodyParser = require("body-parser");
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
// const morgan = require("morgan");

// defining the Express app
const app = express();
// defining an array to work as the database (temporary solution)
// const ads = [{ title: "Hello, world (again)!" }];

// adding Helmet to enhance your Rest API's security
app.use(helmet());

// using bodyParser to parse JSON bodies into JS objects
app.use(bodyParser.json());

// enabling CORS for all requests
app.use(cors());
// app.use(express.json());

// adding morgan to log HTTP requests
// app.use(morgan("combined"));

const workerTaskMapping = {};

app.get("/", (req, res) => {
    console.log("hello");
    res.send("Hello World!");
});

// defining an endpoint to return all ads
app.post("/fetchTask", (req, res) => {
    console.log(`fetchTask: ${JSON.stringify(req.body)}`);
    // sleep 1 sec
    for (let i = 0; i < 1000000000; i++) {}
    const workerID = req.body.workerID;
    const taskSetID = req.body.taskSetID;
    const isSkip = req.body.isSkip;
    console.log(`/fetchTask: workerID:${workerID} taskSetID:${taskSetID}) has requested a task`);
    let taskSetData = null;
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
                // Assign worker to task mapping
                if (workerID !== undefined && workerID !== null) {
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
    console.log(`message sent!`);
});

// starting the server
app.listen(4001);
console.log("listening on port 4001");
// app.listen(4001, () => {
//     console.log("listening on port 4001");
// });
