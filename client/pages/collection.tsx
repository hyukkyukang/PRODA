import { Grid, Paper } from "@mui/material";
import React, { useContext, useEffect, useRef, useState } from "react";
import { useQuery } from "react-query";

import CircularProgress from "@mui/material/CircularProgress";
import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { AnswerSheet, UserAnswer } from "../components/Collection/answerSheet";
import { Task } from "../components/Collection/task";
import { Header } from "../components/Header/collectionHeader";

import { QuerySheet } from "../components/Collection/querySheet";
import { RefContext } from "../pages/_app";

export const Collection = (props: any) => {
    // Ref
    const { targetRef } = useContext(RefContext);
    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", type: 0 });
    // Local state variables
    // AMT informations
    const [hitId, setHitId] = useState("");
    const [assignmentId, setAssignmentId] = useState("");
    const [turkSubmitTo, setTurkSubmitTo] = useState("");
    const [workerId, setWorkerId] = useState("");

    // To handle submission
    const formRef = useRef<HTMLFormElement>(null);

    // Fetching Data
    const { isLoading, isError, data, error } = useQuery<Task>("fetchTask", fetchTask);

    const onSubmitHandler = () => {
        // Send current step's info to the server
        sendWorkerAnswer({ task: { ...data, queryType: data?.queryType, dbName: data?.dbName }, answer: answer, userId: "dummyUser" });

        // Submit assignment
        if (formRef.current) {
            formRef.current.submit();
        }
    };

    const getAMTInfo = () => {
        // Parse URL parameters
        const queryParams = new URLSearchParams(window.location.search);
        const hitId = queryParams.get("hitId") ? queryParams.get("hitId") : "";
        const assignmentId = queryParams.get("assignmentId") ? queryParams.get("assignmentId") : "";
        const turkSubmitTo = queryParams.get("turkSubmitTo") ? queryParams.get("turkSubmitTo") : "";
        const workerId = queryParams.get("workerId") ? queryParams.get("workerId") : "";

        // Debugging
        console.log(`hitId: ${hitId}`);
        console.log(`assignmentId: ${assignmentId}`);
        console.log(`turkSubmitTo: ${turkSubmitTo}`);
        console.log(`workerId: ${workerId}`);

        // Set AMT information
        setHitId(hitId === null ? "" : hitId);
        setAssignmentId(assignmentId === null ? "" : assignmentId);
        setTurkSubmitTo(turkSubmitTo === null ? "" : turkSubmitTo);
        setWorkerId(workerId === null ? "" : workerId);
    };

    useEffect(() => {
        getAMTInfo();
    }, []);

    const AMTSubmissionForm = (
        <React.Fragment>
            <form action="https://workersandbox.mturk.com/mturk/externalSubmit" ref={formRef}>
                <input type="hidden" value={assignmentId} name="assignmentId" id="assignmentId" />
                <input type="hidden" value={answer.type} name="taskType" id="taskType" />
                <input type="hidden" value={answer.nl} name="answerNL" id="answerNL" />
                <input type="hidden" value={answer.isCorrect === undefined ? "true" : answer.isCorrect.toString()} name="isCorrect" id="isCorrect" />
            </form>
        </React.Fragment>
    );

    console.log(`data: ${JSON.stringify(data)}`);

    const collectionBody = (
        <div style={{ marginLeft: "1%", width: "98%" }}>
            {/* Show saquery information for the current task */}
            <AnswerSheet taskType={data?.taskType} taskNL={data?.nl} answer={answer} setAnswer={setAnswer} onSubmitHandler={onSubmitHandler} />
            <Paper elevation={2}>
                <QuerySheet currentTask={data} />
            </Paper>
            {/* Show query information for the previous tasks (to complete the current task) */}
            {data?.history.map((prevTask, idx) => {
                return (
                    <React.Fragment>
                        <br />
                        <Paper elevation={2}>
                            <QuerySheet currentTask={prevTask} />
                        </Paper>
                    </React.Fragment>
                );
            })}
            <br />
            {AMTSubmissionForm}
        </div>
    );

    const waitingBody = (
        <div style={{ height: "100px", display: "flex", textAlign: "center", justifyContent: "center", alignItems: "center" }}>
            <div style={{ display: "inline-block" }}>
                <p> Loading data... </p>
            </div>
            <div style={{ display: "inline-block", paddingLeft: "3px", paddingBottom: "10px" }}>
                <CircularProgress color="inherit" size="20px" />
            </div>
        </div>
    );

    return (
        <React.Fragment>
            <div ref={targetRef}>
                <Grid container sx={{ background: "#f6efe8", color: "black" }}>
                    <Grid item xs={12}>
                        <Header />
                        {data === undefined || data === null ? waitingBody : collectionBody}
                    </Grid>
                </Grid>
            </div>
        </React.Fragment>
    );
};

export default Collection;
