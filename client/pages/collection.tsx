import React, { useState, useEffect, useMemo } from "react";
import { Container, Box, Paper, Button, Step, Stepper, StepLabel, Grid } from "@mui/material";

import { Instruction } from "../components/Collection/instruction";
import { Task } from "../components/Collection/task";
import { ResultTable } from "../components/TableExcerpt/resultTable";
import { EVQLTable } from "../components/VQL/EVQLTable";
import { UserAnswer, AnswerSheet } from "../components/Collection/answerSheet";
import { fetchTask, sendWorkerAnswer } from "../api/connect";

export const Collection = (props: any) => {
    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", type: 0 });

    // Local state variables
    const [currentStep, setCurrentStep] = useState(0);
    const [currentTask, setCurrentTask] = useState<Task>();
    const currentSubTask = useMemo(() => (currentTask && currentTask.subTasks ? currentTask.subTasks[currentStep] : null), [currentTask, currentStep]);

    const MyStepper: JSX.Element = (
        <React.Fragment>
            <br />
            {currentTask && currentTask.subTasks ? (
                <Container maxWidth="xl">
                    <Stepper nonLinear activeStep={currentStep}>
                        {Array(currentTask.subTasks.length)
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

    const onSubmitHandler = () => {
        // Send current step's info to the server
        sendWorkerAnswer({ task: { ...currentSubTask, queryType: currentTask?.queryType, dbName: currentTask?.dbName }, answer: answer, userId: "dummyUser" });
        // Change state
        setCurrentStep(currentStep + 1);
        setAnswer({ ...answer, nl: "" });
    };

    const fetchTaskHandler = async () => {
        const fetchedTask = await fetchTask();
        setCurrentTask(fetchedTask);
    };

    useEffect(() => {
        fetchTaskHandler();
    }, []);

    return (
        <React.Fragment>
            <Grid container sx={{ background: "white", color: "black" }}>
                <Grid item xs={12}>
                    <h1 style={{ marginLeft: "10px" }}>Data Collection</h1>
                    {MyStepper}
                    <div style={{ marginLeft: "1%", width: "98%" }}>
                        <Instruction taskType={currentTask?.taskType} />
                        <br />
                        <Paper elevation={2}>
                            {currentTask && currentSubTask ? (
                                <Box style={{ marginLeft: "15px" }}>
                                    <br />
                                    <b>Natural Language Query</b>
                                    <br />
                                    <span>{currentSubTask?.nl}</span>
                                    <br />
                                    <br />
                                    <Grid container spacing={2}>
                                        <Grid item xs={12} sm={6}>
                                            <b>EVQL</b>
                                            <br />
                                            <EVQLTable evqlRoot={{ node: currentSubTask.evql, child: null }} childListPath={[]} editable={false} />
                                        </Grid>
                                        <Grid item xs={12} sm={6}>
                                            <b>Table Excerpt</b>
                                            <ResultTable queryResult={currentSubTask.tableExcerpt} />
                                            <br />
                                            <b>Query Result</b>
                                            <ResultTable queryResult={currentSubTask.resultTable} />
                                        </Grid>
                                    </Grid>
                                    <br />
                                </Box>
                            ) : null}
                        </Paper>
                        <br />
                        <AnswerSheet taskType={currentTask?.taskType} answer={answer} setAnswer={setAnswer} />
                        <br />
                        <Button variant="contained" color="success" onClick={onSubmitHandler}>
                            Submit
                        </Button>
                        <br />
                        <br />
                    </div>
                </Grid>
            </Grid>
        </React.Fragment>
    );
};

export default Collection;
