import { Box, Container, Grid, Paper, Step, StepLabel, Stepper } from "@mui/material";
import React, { useContext, useEffect, useMemo, useState } from "react";

import CircularProgress from "@mui/material/CircularProgress";
import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { AnswerSheet, UserAnswer } from "../components/Collection/answerSheet";
import { Task } from "../components/Collection/task";
import { Header } from "../components/Header/collectionHeader";
import { EVQLTable } from "../components/VQL/EVQLTable";

import { QuerySheet } from "../components/Collection/querySheet";
import { RefContext } from "../pages/_app";

export const Collection = (props: any) => {
    // Ref
    const { targetRef } = useContext(RefContext);
    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", type: 0 });
    // Local state variables
    const [currentStep, setCurrentStep] = useState(0);
    const [receivedTasks, setReceivedTasks] = useState<Task[]>([]);
    const currentTask = useMemo(() => (receivedTasks && receivedTasks[currentStep] ? receivedTasks[currentStep] : null), [receivedTasks, currentStep]);
    // AMT informations
    const [hitId, setHitId] = useState("")
    const [assignmentId, setAssignmentId] = useState("")
    const [turkSubmitTo, setTurkSubmitTo] = useState("")
    const [workerId, setWorkerId] = useState("")


    const MyStepper: JSX.Element = (
        <React.Fragment>
            <br />
            {receivedTasks && currentTask ? (
                <Container maxWidth="xl">
                    <Stepper nonLinear activeStep={currentStep}>
                        {Array(receivedTasks.length)
                            .fill(0)
                            .map((_, idx) => (
                                <Step key={idx + 1}>
                                    <StepLabel>Step{idx + 1}</StepLabel>
                                </Step>
                            ))}
                    </Stepper>
                </Container>
            ) : null}
            <br />
        </React.Fragment>
    );

    <form action="https://workersandbox.mturk.com/mturk/externalSubmit">
    <input type='hidden' value={assignmentId} name='assignmentId' id='assignmentId'/>
    <input type='submit' id='submitButton' value='Submit'/>
  </form>

    const onSubmitHandler = () => {
        // Send current step's info to the server
        sendWorkerAnswer({ task: { ...currentTask, queryType: currentTask?.queryType, dbName: currentTask?.dbName }, answer: answer, userId: "dummyUser" });
        // Change state
        setCurrentStep(currentStep + 1);
        setAnswer({ ...answer, nl: "" });
    };

    const fetchTaskHandler = async () => {
        const fetchedTask = await fetchTask();
        console.log(`fecthed Task: ${JSON.stringify(fetchedTask)}`);
        setReceivedTasks(fetchedTask);
    };

    const getAMTInfo = () => {
        // Parse URL parameters
        const queryParams = new URLSearchParams(window.location.search)
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
        // Fetch task from the API server
        fetchTaskHandler();
    }, []);

    const collectionBody = (
        <div style={{ marginLeft: "1%", width: "98%" }}>
            {/* Show query information for the current task */}
            <AnswerSheet taskType={currentTask?.taskType} taskNL={currentTask?.nl} answer={answer} setAnswer={setAnswer} onSubmitHandler={onSubmitHandler} />
            <Paper elevation={2}>
                <QuerySheet currentTask={currentTask} />
            </Paper>
            {/* Show query information for the previous tasks (to complete the current task) */}
            {currentTask?.history.map((prevTask, idx) => {
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
                        {receivedTasks.length > 0 ? collectionBody : waitingBody}
                    </Grid>
                </Grid>
            </div>
        </React.Fragment>
    );
};

export default Collection;
