import { Box, Container, Grid, Paper, Step, StepLabel, Stepper } from "@mui/material";
import React, { useEffect, useMemo, useState, useContext } from "react";

import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { AnswerSheet, UserAnswer } from "../components/Collection/answerSheet";
import { Task } from "../components/Collection/task";
import { Header } from "../components/Header/collectionHeader";
import { EVQLTable } from "../components/VQL/EVQLTable";

import { RefContext } from "../pages/_app";

export const Collection = (props: any) => {
    // Ref
    const { targetRef } = useContext(RefContext);

    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", type: 0 });

    // Local state variables
    const [currentStep, setCurrentStep] = useState(0);
    const [receivedTasks, setReceivedTasks] = useState<Task[]>([]);
    // const [currentTask, setCurrentTask] = useState<Task>();
    const currentTask = useMemo(() => (receivedTasks && receivedTasks[currentStep] ? receivedTasks[currentStep] : null), [receivedTasks, currentStep]);

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

    useEffect(() => {
        fetchTaskHandler();
    }, []);

    return (
        <React.Fragment>
            <div ref={targetRef}>
                <Grid container sx={{ background: "#f6efe8", color: "black" }}>
                    <Grid item xs={12}>
                        <Header />
                        <div style={{ marginLeft: "1%", width: "98%" }}>
                            {MyStepper}
                            <AnswerSheet
                                taskType={currentTask?.taskType}
                                taskNL={currentTask?.nl}
                                answer={answer}
                                setAnswer={setAnswer}
                                onSubmitHandler={onSubmitHandler}
                            />
                            <Paper elevation={2}>
                                {receivedTasks && currentTask ? (
                                    <Box style={{ marginLeft: "15px", marginRight: "15px" }}>
                                        <br />
                                        <b>Sentence</b>
                                        <br />
                                        <span>{currentTask?.nl}</span>
                                        <br />
                                        <Grid container spacing={2}>
                                            <Grid item xs={12} sm={12}>
                                                <br />
                                                <EVQLTable
                                                    evqlRoot={{ node: currentTask.evql.node, children: currentTask.evql.children }}
                                                    childListPath={[]}
                                                    editable={false}
                                                    isFirstNode={true}
                                                />
                                            </Grid>
                                        </Grid>
                                        <br />
                                    </Box>
                                ) : null}
                            </Paper>
                            <br />
                        </div>
                    </Grid>
                </Grid>
            </div>
        </React.Fragment>
    );
};

export default Collection;
